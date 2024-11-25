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
#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define SET_CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define GET_CHARACTERISTIC_UUID "6d140001-bcb0-4c43-a293-b21a53dbf9f5"

BLEServer* pServer = NULL;
BLECharacteristic* setCharacteristic;
BLECharacteristic* getCharacteristic;

// Flags for BLE connection
bool deviceConnected = false;

// Operator overload to use << with Serial for convenience
template<typename T>
Print& operator<<(Print& printer, T value) {
  printer.print(value);
  return printer;
}

void IRAM_ATTR onTimer() {
  bat_voltage = bat_status();
  imu = true;
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
  init_imu();
  Serial << "\nESP32 Initialized\n";
  profiles.intensity_haptic = int(calc_intensity(profiles.intensity_haptic));
  profiles.intensity_buzzer = int(calc_intensity(profiles.intensity_buzzer));
  profiles.intensity_led = int(calc_intensity(profiles.intensity_led));

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
  Serial << "Intensity haptic: " << profiles.intensity_haptic << "\n";
  Serial << "Intensity buzzer: " << profiles.intensity_buzzer << "\n";
  Serial << "Intensity led: " << profiles.intensity_led << "\n";
#endif
}

// Function to process and handle "set" commands
void splitStringBySpace(String data) {
  // Log the received command for debugging
  Serial.print("Received command: ");
  Serial.println(data);

  // Find the first space in the command
  int spaceIndex = data.indexOf(' ');

  if (spaceIndex == 0) {
    String command = data;
    command.trim();  // Remove any leading or trailing spaces

    if (command == "LightSwitch") {
      toggle_power();
      Serial.println("Light toggled");
    } else {
      Serial.println("Invalid command format or unknown command.");
    }
    return;
  }

  String command = data.substring(0, spaceIndex);
  command.trim();

  String valueString = data.substring(spaceIndex + 1);
  valueString.trim();  // Remove any leading or trailing spaces
  int value = valueString.toInt();

  // Process the command with a value
  if (command == "Battery") {
    profiles.time_battery_status = value;
    Serial.print("Battery status interval changed to: ");
    Serial.println(profiles.time_battery_status);

  } else if (command == "Haptic") {
    profiles.intensity_haptic = int(calc_intensity(value));
    Serial.print("Haptic intensity changed to: ");
    Serial.println(profiles.intensity_haptic);

  } else if (command == "Light") {
    profiles.intensity_led = int(calc_intensity(value));
    Serial.print("LED intensity changed to: ");
    Serial.println(profiles.intensity_led);

  } else if (command == "Buzzer") {
    profiles.intensity_buzzer = int(calc_intensity(value));
    Serial.print("Buzzer intensity changed to: ");
    Serial.println(profiles.intensity_buzzer);

  } else {
    Serial.println("Unknown command type. Please use Battery, Haptic, Light, Buzzer, or LightSwitch.");
  }
}

void loop() {
  if (deviceConnected) {
    // Send battery and profile data periodically
    float batteryLevel = bat_status();
    String data = String(batteryLevel) + " " + String(revers_calc_intensity(profiles.intensity_led)) + " " + String(revers_calc_intensity(profiles.intensity_buzzer)) + " " + String(profiles.frequency) + " " + String(revers_calc_intensity(profiles.intensity_haptic)) + " " + String(power);
    getCharacteristic->setValue(data.c_str());
    getCharacteristic->notify();
  }

  // Additional handling for button presses or other state changes
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
  if (short_press) {
    short_press = false;
    toggle_power();
  } else if (check_battery_status && power) {
#ifdef Debug
    Serial << "Check battery status\n";
    Serial << "Battery is: " << bat_voltage << "V\n";
#endif
    trig_feedback(battery_filter);
  }
}
