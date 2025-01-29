#include <stdio.h>
#include <iostream>
#include "variables.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "user_settings.h"
#include <Preferences.h>

Preferences preferences;

// BLE service and characteristic UUIDs
#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define SET_CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define GET_CHARACTERISTIC_UUID "6d140001-bcb0-4c43-a293-b21a53dbf9f5"

BLEServer* pServer = NULL;
BLECharacteristic* setCharacteristic;
BLECharacteristic* getCharacteristic;

// fuction to convert the incomming data from the app to workable executables
void splitStringBySpace(String data) {
  // Log the received command for debugging
  Serial.print("Received command: ");
  Serial.println(data);

  // Find the first space in the command
  int spaceIndex = data.indexOf(' ');

  String command = data.substring(0, spaceIndex);
  Serial.println(command);
  command.trim();
  Serial.println(command);

  String valueString = data.substring(spaceIndex + 1);
  valueString.trim();  // Remove any leading or trailing spaces
  int value = valueString.toInt();

  // Process the command with a value
  if (command == "Battery") {
    profiles.time_battery_status = value;
    saveProfileSettings();
    Serial.print("Battery status interval changed to: ");
    Serial.println(profiles.time_battery_status);

  } else if (command == "Haptic") {
    profiles.intensity_haptic = int(calc_intensity(value));
    saveProfileSettings();
    Serial.print("Haptic intensity changed to: ");
    Serial.println(profiles.intensity_haptic);

  } else if (command == "Light") {
    profiles.intensity_led = int(calc_intensity(value));
    saveProfileSettings();
    if (power == 1) {
      analogWrite(LED_LIGHTS, profiles.intensity_led);
    }
    Serial.print("LED intensity changed to: ");
    Serial.println(profiles.intensity_led);

  } else if (command == "Buzzer") {
    profiles.intensity_buzzer = int(calc_intensity(value));
    saveProfileSettings();
    Serial.print("Buzzer intensity changed to: ");
    Serial.println(profiles.intensity_buzzer);

  } else if (command == "LightSwitch"){
    toggle_power();
    Serial.println("Light toggled");

   } else if (strcmp(command.c_str(), "Find") == 0) {  // Use 'command' instead of 'part1'
      profiles.intensity_buzzer = int(calc_intensity(value));
      saveProfileSettings();
     for (int i = 0; i <= 10; i++) {
      ledcWrite(BUZZER, 250.0);
      delay(200);
      ledcWrite(BUZZER, 0);  // turn off buzzer
      delay(100);
     }
     Serial.println("Find my cane.");
  } else {
    Serial.println("Unknown command type. Please use Battery, Haptic, Light, Buzzer, or LightSwitch.");
  }
}

// Callback for BLE Server connection events
class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("Device connected");
  }

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("Device disconnected");
    BLEDevice::startAdvertising();  // Restart advertising after client disconnects
  }
};

// Callback for when data is written to the "set" characteristic
class SetCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pCharacteristic) {
    // Get the value and convert it to an Arduino String
    String value = pCharacteristic->getValue().c_str();

    // Process the command if it starts with "set"
    if (value.length() > 0) {
      splitStringBySpace(value);
    } else {
      Serial.println("Invalid command received: empty value");
    }
  }
};

// Initialize BLE
void setup() {
  init_hardware();
  loadProfileSettings();
  Serial.println("\nESP32 Initialized"); // print al the start values
  // profiles.intensity_haptic = int(calc_intensity(profiles.intensity_haptic));
  // profiles.intensity_buzzer = int(calc_intensity(profiles.intensity_buzzer));
  // profiles.intensity_led = int(calc_intensity(profiles.intensity_led));

  // Setup BLE server
  BLEDevice::init("light_up_cane");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  // Create the BLE Service
  BLEService* pService = pServer->createService(SERVICE_UUID);

  // Set up the writable characteristic for "set" commands
  setCharacteristic = pService->createCharacteristic(
    SET_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_WRITE);
  setCharacteristic->setCallbacks(new SetCallbacks());

  // Set up the readable characteristic for status updates
  getCharacteristic = pService->createCharacteristic(
    GET_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
  getCharacteristic->addDescriptor(new BLE2902());

  // Start the service and begin advertising
  pService->start();
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // Set advertising interval
  BLEDevice::startAdvertising();
  Serial.println("BLE server started and advertising");

#ifdef Debug
  Serial.print("Intensity haptic: ");
  Serial.println(profiles.intensity_haptic);
  Serial.print("Intensity buzzer: ");
  Serial.println(profiles.intensity_buzzer);
  Serial.print("Intensity led: " );
  Serial.println(profiles.intensity_led);
#endif
}


void loop() {
  if (deviceConnected) {
    // Send battery and profile data periodically
    String data = String(bat_status()) + " " + String((String)revers_calc_intensity(profiles.intensity_led)) + " " + String(revers_calc_intensity(profiles.intensity_buzzer)) + " " + String(profiles.frequency) + " " + String(revers_calc_intensity(profiles.intensity_haptic)) + " " + String(power);
    getCharacteristic->setValue(data.c_str());
    getCharacteristic->notify();
  }

  // check if the button is pressed and for how long
  currentState = digitalRead(SW_ON_BOOT);
  if (lastState == HIGH && currentState == LOW) {
    pressedTime = millis();
    delay(100);
  } else if (lastState == LOW && currentState == HIGH) {
    releasedTime = millis();
    pressDuration = releasedTime - pressedTime;
    if ((pressDuration > profiles.time_battery_status) && power) {
      check_battery_status = true;
    } else if (pressDuration > 0) {
      short_press = true;
    }
    delay(100);
  }

  lastState = currentState;
  // if the button is pressed what to do
  if (short_press) {
    short_press = false;
    toggle_power();
  } else if (check_battery_status && power) {
#ifdef Debug
    Serial.println("Check battery status");
    Serial.print("Battery is: ");
    Serial.print(bat_status());
    Serial.println("%");
#endif
    trig_feedback(battery_filter);
  }
}
