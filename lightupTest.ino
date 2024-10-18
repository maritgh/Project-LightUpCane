#include <stdio.h>
#include <iostream>
#include <MPU6050.h>
#include "variables.h"
#include "user_settings.h"

template <typename T>
Print& operator<<(Print& printer, T value)
{
    printer.print(value);
    return printer;
}

void IRAM_ATTR onTimer(){
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

  #ifdef Debug
    Serial << "\nESP32 Initialized\n";
    Serial << "Intensity haptic: " << profiles.intensity_haptic << "\n";
    Serial << "Intensity buzzer: " << profiles.intensity_buzzer << "\n";
    Serial << "Intensity led: " << profiles.intensity_led << "\n"; 
  #endif    
}

void toggle_power(){
  power = !power;
  led_state = power;
  digitalWrite(LED_LIGHTS, led_state);
  #ifdef Debug
    Serial << "Power = " << power << "\n";
  #endif
  delay(200);
  if(power){
    trig_feedback(power_filter);
    
  } else if (!power) {
    trig_feedback(power_filter);
  }
}

void trig_feedback(int feedback){  
  int haptic_on = 0;
  int haptic_off = 0;
  int buzzer_on = 0;
  int buzzer_off = 0;
  int haptic_profiles = 0;
  int buzzer_profiles = 0;
  int haptic_battery = 0;
  int buzzer_battery = 0;

  if (feedback == 2){
    haptic_on = haptic_on_times;
    haptic_off = haptic_off_times;
    buzzer_on = buzzer_on_times;
    buzzer_off = buzzer_off_times;
    if (power){
      while((buzzer_on > 0) || (haptic_on > 0)){
        // Serial << "POWER\n";
        
        if (buzzer_on > 0){
          ledcWrite(1, profiles.intensity_buzzer);
          buzzer_on--;
        }
        if (haptic_on > 0){
          ledcWrite(0, profiles.intensity_haptic);
          haptic_on--;
        }
        
        delay(100);
        ledcWrite(0, 0);  // turn off haptic feedback
        ledcWrite(1, 0);  // turn off buzzer
        delay(100);
      }
    } else if (!power){
      while(buzzer_off > 0 || haptic_off > 0){
           
        if (buzzer_off > 0){
          ledcWrite(1, profiles.intensity_buzzer);
          buzzer_off--;
        }
        if (haptic_off > 0){
          ledcWrite(0, profiles.intensity_haptic);
          haptic_off--;
        }
        
        delay(100);
        ledcWrite(0, 0);  // turn off haptic feedback
        ledcWrite(1, 0);  // turn off buzzer
        delay(100);
      }
    }
  } 
  if (feedback == 3){
    haptic_profiles = haptic_profiles_times;
    buzzer_profiles = buzzer_profiles_times;
    if (change_profile){
      while(buzzer_profiles > 0 || haptic_profiles > 0){
               
        if (buzzer_profiles > 0){
          ledcWrite(1, profiles.intensity_buzzer);
          buzzer_profiles--;
        }
        if (haptic_profiles > 0){
          ledcWrite(0, profiles.intensity_haptic);
          haptic_profiles--;
        }
        
        delay(100);
        ledcWrite(0, 0);  // turn off haptic feedback
        ledcWrite(1, 0);  // turn off buzzer
        delay(100);
      }
    }
  } 
  if (feedback == 1){
if (bat_voltage < 3.3){ // 0%-25%
      battery_status = 1;
    } else if (bat_voltage >= 3.3 && bat_voltage < 3.6){ // 25%-50%
      battery_status = 2;
    } else if (bat_voltage >= 3.6 && bat_voltage < 3.9){ // 50%-75%
      battery_status = 3;
    } else if (bat_voltage > 3.9){ // 75%-100%
      battery_status = 4;
    }
    haptic_battery = battery_status;
    buzzer_battery = battery_status;
    if(check_battery_status){
      while ((haptic_battery > 0) || (buzzer_battery > 0)){
        // Serial << "BATTERY\n";
        if (buzzer_battery > 0){
          ledcWrite(1, profiles.intensity_buzzer);
          buzzer_battery--;
        }
        if (haptic_battery > 0){
          ledcWrite(0, profiles.intensity_haptic);
          haptic_battery--;
        }
        delay(100);
        ledcWrite(0, 0);  // turn off haptic feedback
        ledcWrite(1, 0);  // turn off buzzer
        delay(100);
      }
    }
    check_battery_status = false;
  }
}


float bat_status() {
  float sum = 0.0;
  float avg = 0.0;
  float bat = analogRead(BATT_SENS)/226.0;
  for(int i = 0; i < 19; i++){
    bat_voltages[i+1] = bat_voltages[i];
  }
  bat_voltages[0] = bat;
  for(int i = 0; i < 20; i++){
    sum += bat_voltages[i];
  }
  avg = sum/20.0;
  #ifdef Debug
  //  Serial << "Avg: " << avg << "\n";
  #endif
  return avg;
}


void change_profiles() {
  if(Serial.available() != -1){
    profiles.number = 0;
    do{
      #ifdef Debug
        Serial.println("Enter the number of the profile: ");
      #endif
      while(Serial.available() == 0){}
      profiles.number = Serial.parseInt();
      #ifdef Debug
        if((profiles.number < 1) || (profiles.number > 16)){
          #ifdef Debug
            Serial.println("ERROR! Profile not found.");
          #endif
        }
      #endif
    } while((profiles.number < 1) || (profiles.number > 16));
  }
}

void loop() {
  currentState = digitalRead(SW_ON_BOOT);
  if (lastState == HIGH && currentState == LOW) {
    pressedTime = millis();
    delay(100);
  } else if (lastState == LOW && currentState == HIGH) { // button is released
    releasedTime = millis();
    pressDuration = releasedTime - pressedTime;
    if((pressDuration > profiles.time_change_profile) && power && !change_profile){
      change_profile = true;
    } else if((pressDuration > profiles.time_battery_status) && power && !change_profile){
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