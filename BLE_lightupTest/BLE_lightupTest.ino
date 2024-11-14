#include <stdio.h>
#include <MPU6050.h>
#include "variables.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "user_settings.h"

// BLE UUIDs
constexpr char SERVICE_UUID[] = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
constexpr char SET_CHARACTERISTIC_UUID[] = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
constexpr char GET_CHARACTERISTIC_UUID[] = "6d140001-bcb0-4c43-a293-b21a53dbf9f5";

BLEServer* pServer = nullptr;
BLECharacteristic* setCharacteristic;
BLECharacteristic* getCharacteristic;
bool deviceConnected = false;

void IRAM_ATTR onTimer() {
  bat_voltage = bat_status();
  imu = true;
}

// BLE Server Callbacks
class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) override {
    deviceConnected = true;
    #ifdef Debug
      Serial.println("Device connected");
    #endif
  }

  void onDisconnect(BLEServer* pServer) override {
    deviceConnected = false;
    BLEDevice::startAdvertising();
    #ifdef Debug
      Serial.println("Device disconnected");
    #endif
  }
};

// BLE Characteristic Callbacks
class SetCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pCharacteristic) override {
    const char* value = pCharacteristic->getValue().c_str();
    if (strlen(value) > 0) splitStringBySpace(value);
  }
};

// Setup BLE
void setup() {
  init_hardware();
  init_imu();
  #ifdef Debug
    Serial.println("ESP32 Initialized");
  #endif

  BLEDevice::init("light_up_cane");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService* pService = pServer->createService(SERVICE_UUID);

  setCharacteristic = pService->createCharacteristic(SET_CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_WRITE);
  setCharacteristic->setCallbacks(new SetCallbacks());

  getCharacteristic = pService->createCharacteristic(GET_CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);
  getCharacteristic->addDescriptor(new BLE2902());

  pService->start();
  BLEDevice::startAdvertising();

  #ifdef Debug
    Serial.println("BLE server started and advertising");
  #endif
}

// Command Processing Function
void splitStringBySpace(const char* data) {
  const char* spacePtr = strchr(data, ' ');
  String command(data, spacePtr ? spacePtr - data : strlen(data));

  if (command == "LightSwitch") {
    toggle_power();
    return;
  }

  if (!spacePtr) return;
  int value = atoi(spacePtr + 1);

  if (command == "Battery") profiles.time_battery_status = value;
  else if (command == "Haptic") profiles.intensity_haptic = calc_intensity(value);
  else if (command == "Light") profiles.intensity_led = calc_intensity(value);
  else if (command == "Buzzer") profiles.intensity_buzzer = calc_intensity(value);
}

void loop() {
  if (deviceConnected) {
    String data = String(bat_status()) + " " + String(revers_calc_intensity(profiles.intensity_led)) + " " + String(revers_calc_intensity(profiles.intensity_buzzer)) + " " + String(profiles.frequency) + " " + String(revers_calc_intensity(profiles.intensity_haptic)) + " " + String(power);
    getCharacteristic->setValue(data.c_str());
    getCharacteristic->notify();
  }

  // Additional button press handling
  currentState = digitalRead(SW_ON_BOOT);
  if (lastState == HIGH && currentState == LOW) {
    pressedTime = millis();
    delay(100);
  } else if (lastState == LOW && currentState == HIGH) {
    releasedTime = millis();
    pressDuration = releasedTime - pressedTime;
    if ((pressDuration > profiles.time_battery_status) && power) check_battery_status = true;
    else if (pressDuration > 0) short_press = true;
    delay(100);
  }

  lastState = currentState;
  if (short_press) {
    short_press = false;
    toggle_power();
  } else if (check_battery_status && power) trig_feedback(battery_filter);
}

