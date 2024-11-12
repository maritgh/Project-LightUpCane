#include <stdio.h>
#include <iostream>
#include <MPU6050.h>
#include "variables.h"
#include <WiFi.h>
#include "user_settings.h"
#include <WebServer.h>

// WiFi access point credentials
const char* ssid = "light_up_cane";
const char* password = "12345678";

WebServer server(80);

template<typename T>
Print& operator<<(Print& printer, T value) {
  printer.print(value);
  return printer;
}

void IRAM_ATTR onTimer() {
  //++ctr;
  //Serial << "timer called " << ctr << " times\n";
  bat_voltage = bat_status();
  imu = true;
}

void setup() {
  init_hardware();
  init_imu();
  // Serial.println("test");
  Serial << "\nESP32 Initialized\n";
  profiles.intensity_haptic = int(calc_intensity(profiles.intensity_haptic));
  profiles.intensity_buzzer = int(calc_intensity(profiles.intensity_buzzer));
  profiles.intensity_led = int(calc_intensity(profiles.intensity_led));
  Serial.println("\n\nConfiguring access point...");
  WiFi.softAP(ssid, password);
  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
#ifdef Debug
  Serial << "\nESP32 Initialized\n";
  Serial << "Intensity haptic: " << profiles.intensity_haptic << "\n";
  Serial << "Intensity buzzer: " << profiles.intensity_buzzer << "\n";
  Serial << "Intensity led: " << profiles.intensity_led << "\n";
#endif
  server.on("/set", HTTP_POST, []() {
    if (server.hasArg("data")) {
      String data = server.arg("data");
      splitStringBySpace(data);
      server.send(200, "text/plain", "Setting updated");
    } else {
      server.send(400, "text/plain", "Invalid data");
    }
  });

  server.on("/get", HTTP_GET, []() {
    float bat = bat_status();
    String data = String(bat_status()) + " " + String(revers_calc_intensity(profiles.intensity_led)) + " " + String(revers_calc_intensity(profiles.intensity_buzzer)) + " " + String(profiles.frequency) + " " + String(revers_calc_intensity(profiles.intensity_haptic)) + " " + String(power);
    server.send(200, "text/plain", data);
  });

  server.begin();
  Serial.println("HTTP server started");
}

void splitStringBySpace(String data) {
  int firstSpaceIndex = data.indexOf('$');
  int secondSpaceIndex = data.indexOf('$', firstSpaceIndex + 1);

  if (firstSpaceIndex != -1 && secondSpaceIndex != -1) {
    String part1 = data.substring(0, firstSpaceIndex);
    String part2 = data.substring(firstSpaceIndex + 1, secondSpaceIndex);
    String part3 = data.substring(secondSpaceIndex + 1);

    if (strcmp(part1.c_str(), "Battery") == 0) {
     // profiles.time_battery_status = int(part2);
      //Serial.println("time battery status changed to:");
     // Serial.println(profiles.time_battery_status);
    } else if (strcmp(part1.c_str(), "Button") == 0) {
      //changeButton(part2, part3);
    } else if (strcmp(part1.c_str(), "Light") == 0) {
      //changeLight(part2, part3);
    } else if (strcmp(part1.c_str(), "Properties") == 0) {
     // changeProperties(part2, part3);
    } else {
      Serial.println("Unknown setting type. Please use Battery, Button, Light, or Properties.");
    }
  }
}

void loop() {
  server.handleClient();
  currentState = digitalRead(SW_ON_BOOT);
  if (lastState == HIGH && currentState == LOW) {
    pressedTime = millis();
    delay(100);
  } else if (lastState == LOW && currentState == HIGH) {  // button is released
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
// check_battery_status = false;
#ifdef Debug
    Serial << "Check battery status\n";
    Serial << "Battery is: " << bat_voltage << "V\n";
#endif
    // bat_status();
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