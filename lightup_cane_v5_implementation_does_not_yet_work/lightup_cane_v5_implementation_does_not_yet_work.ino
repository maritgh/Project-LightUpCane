#include <stdio.h>
#include <iostream>
#include <MPU6050.h>
#include <Preferences.h>
#include "variables.h"
#include "user_settings.h"
#define Debug 1



Preferences preferences;

unsigned long lastSaveTime = 0; // Variable to store the last time settings were saved
const unsigned long saveInterval = 50000; // Interval between saving settings (milliseconds), adjust as needed

template <typename T> Print& operator<<(Print& printer, T value)
{
    printer.print(value);
    return printer;
}

//has been tested
void saveProfileSettings() {
  preferences.begin("profile", false); // Open the preferences with namespace "profile"
  preferences.clear();
  // Save profile settings to flash memory
  preferences.putInt("intensity_haptic", profiles.intensity_haptic);
  preferences.putInt("intensity_buzzer", profiles.intensity_buzzer);
  preferences.putInt("intensity_led", profiles.intensity_led);
  preferences.putInt("time_change_profile", profiles.time_change_profile);
  preferences.putInt("time_battery_status", profiles.time_battery_status);
  preferences.putInt("haptic_on_times", haptic_on_times);
  preferences.putInt("haptic_off_times", haptic_off_times);
  preferences.putInt("buzzer_on_times", buzzer_on_times);
  preferences.putInt("buzzer_off_times", buzzer_off_times);
  // Add more lines to save additional settings as needed...

  preferences.end(); // Close the preferences
}

//has been tested
void loadProfileSettings() {
  preferences.begin("profile", false); // Open the preferences with namespace "profile"
  
  // Load profile settings from flash memory
  profiles.intensity_haptic = preferences.getInt("intensity_haptic", profiles.intensity_haptic);
  profiles.intensity_buzzer = preferences.getInt("intensity_buzzer", profiles.intensity_buzzer);
  profiles.intensity_led = preferences.getInt("intensity_led", profiles.intensity_led);
  profiles.time_change_profile = preferences.getInt("time_change_profile", profiles.time_change_profile);
  profiles.time_battery_status = preferences.getInt("time_battery_status", profiles.time_battery_status);
  haptic_on_times = preferences.getInt("haptic_on_times", haptic_on_times); // Update haptic_on_times
  haptic_off_times = preferences.getInt("haptic_off_times", haptic_off_times); // Update haptic_off_times
  buzzer_on_times = preferences.getInt("buzzer_on_times", buzzer_on_times);
  buzzer_off_times = preferences.getInt("buzzer_off_times", buzzer_off_times);
  // Add more lines to load additional settings as needed...

  Serial.println(haptic_on_times) ;
  Serial.println(haptic_off_times) ;

  preferences.end(); // Close the preferences
}

//couldnt be tested

// void updateSettingsFromSerial() {
//   if (Serial.available() > 0) {
//     Serial.println("updating settings");    
//     String inputString = Serial.readStringUntil('\n'); // Read serial input until newline character
//     String firstWord, secondWord;
//     Serial.println(inputString);
//     splitStringBySpace(inputString, firstWord, secondWord); // Split input string into two words
//     Serial.println(inputString);

//     if (firstWord.equals("intensity_haptic")) {
//       int newValue = secondWord.toInt();
//       if (newValue != profiles.intensity_haptic) {
//         profiles.intensity_haptic = newValue;
//         Serial.println("Intensity Haptic updated");
//       }
//     } else if (firstWord.equals("intensity_buzzer")) {
//       int newValue = secondWord.toInt();
//       if (newValue != profiles.intensity_buzzer) {
//         profiles.intensity_buzzer = newValue;
//         Serial.println("Intensity Buzzer updated");
//       }
//     } else if (firstWord.equals("intensity_led")) {
//       int newValue = secondWord.toInt();
//       if (newValue != profiles.intensity_led) {
//         profiles.intensity_led = newValue;
//         Serial.println("Intensity LED updated");
//       }
//     } else if (firstWord.equals("time_change_profile")) {
//       int newValue = secondWord.toInt();
//       if (newValue != profiles.time_change_profile) {
//         profiles.time_change_profile = newValue;
//         Serial.println("Time Change Profile updated");
//       }
//     } else if (firstWord.equals("time_battery_status")) {
//       int newValue = secondWord.toInt();
//       if (newValue != profiles.time_battery_status) {
//         profiles.time_battery_status = newValue;
//         Serial.println("Time Battery Status updated");
//       }
//     }
//     else if (firstWord.equals("100-75%")) {
//       Serial.println("battery status updated");
//       // int newValue = secondWord.toInt();      
//       // if(newValue != )
//     }
// //     // Add more conditions to update additional settings as needed...
//   }
// }

//couldnt be tested

// void splitStringBySpace(String inputString, String& firstWord, String& secondWord) {
//   int spaceIndex = inputString.indexOf(' '); // Find the index of the space character
//   if (spaceIndex != -1) { // If space character found
//     firstWord = inputString.substring(0, spaceIndex); // Extract the first word
//     secondWord = inputString.substring(spaceIndex + 1); // Extract the second word
//   } else { // If space character not found
//     firstWord = inputString; // Assign the entire string to the first word
//     secondWord = ""; // Set second word as empty string
//   }
// }

void setup() {
  Serial.begin(9600);
  loadProfileSettings(); // Load profile settings from flash memory during setup
    
  init_hardware();
  init_imu();
  

  profiles.intensity_haptic = int(calc_intensity(profiles.intensity_haptic));
  profiles.intensity_buzzer = int(calc_intensity(profiles.intensity_buzzer));
  profiles.intensity_led = int(calc_intensity(profiles.intensity_led));

  // Set the last save time to the current time
  lastSaveTime = millis();
  
  #ifdef Debug
    Serial.println("ESP32 Initialized");
    Serial.print("Intensity haptic: ");
    Serial.println(profiles.intensity_haptic);
    Serial.print("Intensity buzzer: ");
    Serial.println(profiles.intensity_buzzer);
    Serial.print("Intensity led: ");
    Serial.println(profiles.intensity_led);
  #endif
}
 
void loop() {
  currentState = digitalRead(SW_ON_BOOT);

  // Call function to update settings from Serial monitor
  //updateSettingsFromSerial();

  //Determine the duration of button press (whenever button is being pressed)
  if (lastState == HIGH && currentState == LOW) {
    pressedTime = millis();
    delay(100);
  } else if (lastState == LOW && currentState == HIGH) { // button is released
    releasedTime = millis();

    //Calculate button press duration
    pressDuration = releasedTime - pressedTime;

    //Determine function according to button press duration
    if((pressDuration > profiles.time_change_profile) && power && !change_profile_flag){
      change_profile_flag = true;
    } else if((pressDuration > profiles.time_battery_status) && power && !change_profile_flag){
      check_battery_status_flag = true;
    } else if (pressDuration > 0) {
      short_press_flag = true;
    }
    delay(100);
  }

  lastState = currentState;

  //Short press - Toggle power: turn Lightupcane on or off
	if (short_press_flag) {                          
    short_press_flag = false;
    toggle_power();
  }

  //Medium press - check battery status
  else if (check_battery_status_flag && power) { 
#ifdef Debug
      Serial << "Check battery status\n";
      Serial << "Battery is: " << bat_voltage << "V\n";
#endif
    // bat_status();    //TODO verify why this is commented
    trig_feedback(battery_filter);

  }
  
  //Long press - change current profile
  else if (change_profile_flag && power) {      
  // [VVV - COMMENT THIS OUT TO CHANGE LONG-PRESS FUNCTION - VVV]  

#ifdef Debug
      Serial << "Changing profile\n";
      change_profiles();
      toggle_profiles();
      change_profile_flag = false;
      Serial << "Profile " << profiles.number << "\n";
#else
      //Move to next profile
      if (profiles.number != 0){ //profiles.number = 0 -> disable profile use

        if (profiles.number == MAX_NUMBER_OF_PROFILES){
          profiles.number = 1;
        }
        else{
          profiles.number++;
        }

        toggle_profiles();
      }
#endif

  // [^^^ - COMMENT THIS OUT TO CHANGE LONG-PRESS FUNCTION - ^^^]

  // [VVV - NEW LONG-PRESS FUNCTION - VVV]



  // [^^^ - NEW LONG-PRESS FUNCTION - ^^^]  
  }

  // Perform IMU-angle calculation
  if(imu && power){
    calc_imu();   
  }  

  // Check if it's time to save settings
  unsigned long currentTime = millis();
  if (currentTime - lastSaveTime >= saveInterval) {
    saveProfileSettings(); // Save profile settings to flash memory
    loadProfileSettings();
    lastSaveTime = currentTime; // Update the last save time  
    Serial.println("saved"); 
  }
}
