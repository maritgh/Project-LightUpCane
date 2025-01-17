#include <stdio.h>
#include <MPU6050.h>
#include "variables.h"
#include <WiFi.h>
#include "user_settings.h"
#include <WebServer.h>
#include <Preferences.h>

Preferences preferences;

WebServer server(80);

void setup() {
  init_hardware();
  init_imu();
  loadProfileSettings();
  Serial.println("\nESP32 Initialized"); // print al the start values

#ifdef Debug
  Serial.print("Intensity haptic: ");
  Serial.println(profiles.intensity_haptic);
  Serial.print("Intensity buzzer: ");
  Serial.println(profiles.intensity_buzzer);
  Serial.print("Intensity led: " );
  Serial.println(profiles.intensity_led);
#endif

  Serial.println("\n\nConfiguring access point..."); //starting the hotspot 
  WiFi.softAP(ssid, password);
  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
  

  server.on("/set", HTTP_POST, []() { // to put the data send in the right spot
    if (server.hasArg("data")) {
      String data = server.arg("data");
      splitStringBySpace(data);
    } else {
      server.send(400, "text/plain", "Invalid data");
    }
  });

  server.on("/get", HTTP_GET, []() { // to send data to the app
    String data = String(bat_status()) + " " + String(revers_calc_intensity(profiles.intensity_led)) + " " + String(revers_calc_intensity(profiles.intensity_buzzer)) + " " + String(profiles.frequency) + " " + String(revers_calc_intensity(profiles.intensity_haptic)) + " " + String(power);
    server.send(200, "text/plain", data);
  });
  
  server.begin();
  Serial.println("HTTP server started");
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

    if ((pressDuration > profiles.time_battery_status) && power ) {
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
    Serial.println("Check battery status");
    Serial.print("Battery is: ");
    Serial.print(bat_voltage);
    Serial.println("V");
#endif
    trig_feedback(battery_filter);
  }
}