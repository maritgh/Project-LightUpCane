#include <stdio.h>
#include <iostream>
#include <MPU6050.h>
#include "variables.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "user_settings.h"

// BLE service and characteristic UUIDs
#define SERVICE_UUID           "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define SET_CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define GET_CHARACTERISTIC_UUID "6d140001-bcb0-4c43-a293-b21a53dbf9f5"

BLEServer* pServer = NULL;
BLECharacteristic* setCharacteristic;
BLECharacteristic* getCharacteristic;

// Flags for BLE connection
bool deviceConnected = false;

template<typename T>
Print& operator<<(Print& printer, T value) {
  printer.print(value);
  return printer;
}

void IRAM_ATTR onTimer() {
  bat_voltage = bat_status();
  imu = true;
}

// Callback for BLE Server events
class ServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("Device connected");
    }

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("Device disconnected");
    }
};

// Callback for when data is written to the "set" characteristic
class SetCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      // Haal de waarde op en zet om naar een Arduino String
      String value = String(pCharacteristic->getValue().c_str());
      
      // Controleer of er gegevens zijn ontvangen
      if (value.length() > 0) {
        if (value.startsWith("set")) {
          splitStringBySpace(value.substring(4));
        } else {
          Serial.println("Invalid command received");
        }
      }
    }
};



void setup() {
  init_hardware();
  init_imu();
  Serial << "\nESP32 Initialized\n";
  profiles.intensity_haptic = int(calc_intensity(profiles.intensity_haptic));
  profiles.intensity_buzzer = int(calc_intensity(profiles.intensity_buzzer));
  profiles.intensity_led = int(calc_intensity(profiles.intensity_led));

  // Initialize BLE
  BLEDevice::init("light_up_cane");  // BLE device name
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create BLE characteristics for setting and getting data
  setCharacteristic = pService->createCharacteristic(
                      SET_CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_WRITE
                    );
  setCharacteristic->setCallbacks(new SetCallbacks());

  getCharacteristic = pService->createCharacteristic(
                      GET_CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_NOTIFY
                    );
  getCharacteristic->addDescriptor(new BLE2902());

  pService->start();
  pServer->getAdvertising()->start();
  Serial.println("BLE server started and advertising");

#ifdef Debug
  Serial << "Intensity haptic: " << profiles.intensity_haptic << "\n";
  Serial << "Intensity buzzer: " << profiles.intensity_buzzer << "\n";
  Serial << "Intensity led: " << profiles.intensity_led << "\n";
#endif
}

// Function to process and split incoming set commands
void splitStringBySpace(String data) {
  int firstSpaceIndex = data.indexOf('$');
  int secondSpaceIndex = data.indexOf('$', firstSpaceIndex + 1);

  if (firstSpaceIndex != -1 && secondSpaceIndex != -1) {
    String part1 = data.substring(0, firstSpaceIndex);
    String part2 = data.substring(firstSpaceIndex + 1, secondSpaceIndex);
    int part = part2.toInt();

    if (strcmp(part1.c_str(), "Battery") == 0) {
      profiles.time_battery_status = part;
      Serial.println("Battery status interval changed to:");
      Serial.println(profiles.time_battery_status);

    } else if (strcmp(part1.c_str(), "Haptic") == 0) {
      profiles.intensity_haptic = int(calc_intensity(part));
      Serial.println("Haptic intensity changed to:");
      Serial.println(profiles.intensity_haptic);

    } else if (strcmp(part1.c_str(), "Light") == 0) {
      profiles.intensity_led = int(calc_intensity(part));
      Serial.println("Light intensity changed to:");
      Serial.println(profiles.intensity_led);

    } else if (strcmp(part1.c_str(), "Buzzer") == 0) {
      profiles.intensity_buzzer = int(calc_intensity(part));
      Serial.println("Buzzer intensity changed to:");
      Serial.println(profiles.intensity_buzzer);
      
    } else if (strcmp(part1.c_str(), "LightSwitch") == 0) {
      toggle_power();
      Serial.println("Light toggled");
    } else {
      Serial.println("Unknown setting type. Please use Battery, Haptic, Light, or Buzzer.");
    }
  }
}

void loop() {
  if (deviceConnected) {
    // Check and send battery and profile data on read request
    float bat = bat_status();
    String data = String(bat_status()) + " " + String(revers_calc_intensity(profiles.intensity_led)) + " " + 
                  String(revers_calc_intensity(profiles.intensity_buzzer)) + " " + String(profiles.frequency) + 
                  " " + String(revers_calc_intensity(profiles.intensity_haptic)) + " " + String(power);
    getCharacteristic->setValue(data.c_str());
    getCharacteristic->notify();
  }

  // Handle other button and state changes as in the original loop
  currentState = digitalRead(SW_ON_BOOT);
  if (lastState == HIGH && currentState == LOW) {
    pressedTime = millis();
    delay(100);
  } else if (lastState == LOW && currentState == HIGH) {
    releasedTime = millis();
    pressDuration = releasedTime - pressedTime;
    if ((pressDuration > profiles.time_change_profile) && power && !change_profile) {
      change_profile = true;
    } else if ((pressDuration > profiles.time_battery_status) && power && !change_profile) {
      check_battery_status = true;
    } else if (pressDuration > 0) {
      short_press = true;
    }
    delay(100);
  }

  lastState = currentState;
  if (short_press) {
    short_press = false;
    toggle_power();
  } else if (check_battery_status && power) {
#ifdef Debug
    Serial << "Check battery status\n";
    Serial << "Battery is: " << bat_voltage << "V\n";
#endif
    trig_feedback(battery_filter);
  } else if (change_profile && power) {
#ifdef Debug
    Serial << "Changing profile\n";
#endif
    change_profiles();
    toggle_profiles();
    change_profile = false;
#ifdef Debug
    Serial << "Profile " << profiles.number << "\n";
#endif
  }
}