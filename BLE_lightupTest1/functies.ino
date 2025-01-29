// initialize all the hardware
void init_hardware() {
  Serial.begin(9600);
  pinMode(SW_ON_BOOT, INPUT_PULLUP);
  pinMode(LED_LIGHTS, OUTPUT);
  pinMode(BATT_SENS, INPUT);
  ledcAttachChannel(HAPTIC, 100000, 8, 0);
  ledcAttachChannel(BUZZER, profiles.frequency, 8, 1);
}

// calculations to covert the percenteges input to workable numbers for buzzer, haptic and led
int calc_intensity(float intensity) {
  intensity = ((intensity / 100.0) * 256.0) + 0.5;
  return intensity;
}

// convert the work numbers to percentages
int revers_calc_intensity(float intens) {
  intens = ((intens / 256) * 100) + 0.5;
  return intens;
}

// function to turn the led on and off
void toggle_power() {
  power = !power;
  if (power == 1) {
    analogWrite(LED_LIGHTS, profiles.intensity_led);
  } else {
    analogWrite(LED_LIGHTS, 0);
  }
#ifdef Debug
  Serial.print("Power = ");
  Serial.println(power);
#endif
  delay(200);
  if (power) {
    trig_feedback(power_filter);

  } else if (!power) {
    trig_feedback(power_filter);
  }
}

// haptic and buzzer feedback and how many times
void trig_feedback(int feedback) {
  int haptic_on = 0;
  int haptic_off = 0;
  int buzzer_on = 0;
  int buzzer_off = 0;
  int haptic_battery = 0;
  int buzzer_battery = 0;
  // if battery status has to be checked
  if (feedback == 1) {
    if (bat_status() < 25) {  // 0%-25%
      battery_status = 1;
    } else if (bat_status() >= 25 && bat_status() < 50) {  // 25%-50%
      battery_status = 2;
    } else if (bat_status() >= 50 && bat_status() < 75) {  // 50%-75%
      battery_status = 3;
    } else if (bat_status() >= 75) {  // 75%-100%
      battery_status = 4;
    }
    haptic_battery = battery_status;
    buzzer_battery = battery_status;
    if (check_battery_status) {
      while ((haptic_battery > 0) || (buzzer_battery > 0)) {
        if (buzzer_battery > 0) {
          ledcWrite(BUZZER, profiles.intensity_buzzer);
          buzzer_battery--;
        }
        if (haptic_battery > 0) {
          ledcWrite(HAPTIC, profiles.intensity_haptic);
          haptic_battery--;
        }
        delay(200);
        ledcWrite(HAPTIC, 0);  // turn off haptic feedback
        ledcWrite(BUZZER, 0);  // turn off buzzer
        delay(100);
      }
    }
    check_battery_status = false;
  }
  if (feedback == 2) {
    haptic_on = haptic_on_times;
    haptic_off = haptic_off_times;
    buzzer_on = buzzer_on_times;
    buzzer_off = buzzer_off_times;
    //when led is turned on
    if (power) {
      while ((buzzer_on > 0) || (haptic_on > 0)) {

        if (buzzer_on > 0) {
          ledcWrite(BUZZER, profiles.intensity_buzzer);
          buzzer_on--;
        }
        if (haptic_on > 0) {
          ledcWrite(HAPTIC, profiles.intensity_haptic);
          haptic_on--;
        }

        delay(200);
        ledcWrite(HAPTIC, 0);  // turn off haptic feedback
        ledcWrite(BUZZER, 0);  // turn off buzzer
        delay(100);
      }
      //when led is turned off
    } else if (!power) {
      while (buzzer_off > 0 || haptic_off > 0) {

        if (buzzer_off > 0) {
          ledcWrite(BUZZER, profiles.intensity_buzzer);
          buzzer_off--;
        }
        if (haptic_off > 0) {
          ledcWrite(HAPTIC, profiles.intensity_haptic);
          haptic_off--;
        }

        delay(200);
        ledcWrite(HAPTIC, 0);  // turn off haptic feedback
        ledcWrite(BUZZER, 0);  // turn off buzzer
        delay(100);
      }
    }
  }
}

// calculate the battery percentage
int bat_status() {
  //for 9 volt battery
  float sum = 0.0;

  for (int i = 0; i < 20; i++) {
    sum += analogReadMilliVolts(BATT_SENS);
  }
  float v_out = (sum / 20);
  //voltage divider formula
  float source_Voltage = (v_out * (resistor1 + resistor2) / resistor2) / 1000;
  if (source_Voltage < 6.5) {
    return 0;
  } else {
    return ((source_Voltage - 6.5) / 2.5 * 100);
  }
}

// to convert the incomming data from the app to workable executables
void saveProfileSettings() {
  preferences.begin("profile", false);  // Open the preferences with namespace "profile"
  preferences.clear();
  // Save profile settings to flash memory
  preferences.putInt("hap", profiles.intensity_haptic);
  preferences.putInt("buzz", profiles.intensity_buzzer);
  preferences.putInt("led", profiles.intensity_led);
  preferences.putInt("time", profiles.time_battery_status);
  preferences.putInt("hapOn", haptic_on_times);
  preferences.putInt("hapOff", haptic_off_times);
  preferences.putInt("buzzOn", buzzer_on_times);
  preferences.putInt("buzzOff", buzzer_off_times);
  // Add more lines to save additional settings as needed...
  // Serial.println("dit is een test");
  // Serial.println(profiles.intensity_haptic);

  preferences.end();  // Close the preferences
}

// to save profile settings in the preferences library
void loadProfileSettings() {
  preferences.begin("profile", false);  // Open the preferences with namespace "profile"

  // Load profile settings from flash memory
  profiles.intensity_haptic = preferences.getInt("hap", profiles.intensity_haptic);
  profiles.intensity_buzzer = preferences.getInt("buzz", profiles.intensity_buzzer);
  profiles.intensity_led = preferences.getInt("led", profiles.intensity_led);
  profiles.time_battery_status = preferences.getInt("time", profiles.time_battery_status);
  haptic_on_times = preferences.getInt("hapOn", haptic_on_times);     // Update haptic_on_times
  haptic_off_times = preferences.getInt("hapOff", haptic_off_times);  // Update haptic_off_times
  buzzer_on_times = preferences.getInt("buzzOn", buzzer_on_times);
  buzzer_off_times = preferences.getInt("buzzOff", buzzer_off_times);
  // Add more lines to load additional settings as needed...

  // Serial.println(haptic_on_times);
  // Serial.println(haptic_off_times);

  preferences.end();  // Close the preferences
}
