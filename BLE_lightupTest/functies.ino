void init_hardware(){
  Serial.begin(9600);
  // init LEDS
  pinMode(SW_ON_BOOT, INPUT_PULLUP); 
  pinMode(LED_LIGHTS, OUTPUT);        
  // init HAPTIC
  ledcAttachChannel(HAPTIC, 100000, 8, 0);
  // init BUZZER
  ledcAttachChannel(BUZZER ,profiles.frequency, 8 ,1);
}

void init_imu(){
  Wire.begin(SDA_PIN, SCL_PIN); // Gebruik GPIO8 als SDA en GPIO6 als SCL
  mpu.initialize();
  // init IMU timer
  imu_timer = timerBegin(1000000); // (timer ch, divider, countup)
  timerAttachInterrupt(imu_timer, &onTimer);
  timerAlarm(imu_timer, 100000, true, 1);
}

int calc_intensity(float intensity){
  intensity = ((intensity / 100.0)*256.0)+0.5;   
  return intensity;
}

int revers_calc_intensity(float intens){
  intens = ((intens/256)*100)+ 0.5;
  return intens; 
}

void toggle_power() {
  power = !power;
  if(power == 1){
    analogWrite(LED_LIGHTS, profiles.intensity_led);
  }else{
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

void trig_feedback(int feedback) {
  int haptic_on = 0;
  int haptic_off = 0;
  int buzzer_on = 0;
  int buzzer_off = 0;
  int haptic_battery = 0;
  int buzzer_battery = 0;
 if (feedback == 1) {
    if (bat_voltage < 3.3) {  // 0%-25%
      battery_status = 1;
    } else if (bat_voltage >= 3.3 && bat_voltage < 3.6) {  // 25%-50%
      battery_status = 2;
    } else if (bat_voltage >= 3.6 && bat_voltage < 3.9) {  // 50%-75%
      battery_status = 3;
    } else if (bat_voltage > 3.9) {  // 75%-100%
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


float bat_status() {
  float sum = 0.0;
  float avg = 0.0;
  float bat = analogRead(BATT_SENS) / 226.0;
  for (int i = 0; i < 19; i++) {
    bat_voltages[i + 1] = bat_voltages[i];
  }
  bat_voltages[0] = bat;
  for (int i = 0; i < 20; i++) {
    sum += bat_voltages[i];
  }
  avg = sum / 20.0;
  return (avg/9)*100;
}