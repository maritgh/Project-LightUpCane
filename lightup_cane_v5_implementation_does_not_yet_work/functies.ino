void init_hardware(){
  // init LEDS
  pinMode(SW_ON_BOOT, INPUT_PULLUP); 
  pinMode(LED_LIGHTS, OUTPUT);          
  // init HAPTIC
  ledcSetup(0, 100000, 8);
  ledcAttachPin(HAPTIC, 0);
  // init BUZZER
  ledcSetup(1, profiles.frequency, 8);
  ledcAttachPin(BUZZER, 1);
  adcAttachPin(BATT_SENS);
}

void IRAM_ATTR onTimer(){
  //++ctr;
  //Serial << "timer called " << ctr << " times\n";
  bat_voltage = bat_status();
  imu = true;
}

void init_imu(){
  Wire.begin(SDA_PIN, SCL_PIN); // Gebruik GPIO8 als SDA en GPIO6 als SCL
  mpu.initialize();
  // init IMU timer
  imu_timer = timerBegin(0, 80, true); // (timer ch, divider, countup)
  timerAttachInterrupt(imu_timer, &onTimer, true);
  timerAlarmWrite(imu_timer, 100000, true);
  timerAlarmEnable(imu_timer);
}

int calc_intensity(float intensity){
  intensity = (intensity / 100.0)*255.0;   
  return intensity;
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

  /* Return feedback about POWER
  /* Sends the user haptic and buzzer feedback
   * after a short button press, to indicate    
   * whether the lights are turned on or off
   */
  if (feedback == power_filter){
    haptic_on = haptic_on_times; //How many vibrations when power is turned on
    haptic_off = haptic_off_times; //How many vibrations when power is turned off
    buzzer_on = buzzer_on_times; //How many beeps when power is turned on
    buzzer_off = buzzer_off_times; //How many beeps when power is turned off
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

  /* Return feedback about PROFILES
  /* Sends the user haptic and buzzer feedback
   * to indicate the number of the selected profile    
   */
  if (feedback == profiles_filter){
    haptic_profiles = haptic_profiles_times;
    buzzer_profiles = buzzer_profiles_times;
    if (change_profile_flag){
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

  /* Return feedback about BATTERY
  /* Sends the user haptic and buzzer feedback
   * to indicate battery percentage:
   *    100%-75%: 4 vibrations and beeps
   *     75%-50%: 3 vibrations and beeps
   *     50%-25%: 2 vibrations and beeps
   *     25%-0%:  1 vibrations and beeps
   *    
   */
  if (feedback == battery_filter){ 
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
    if(check_battery_status_flag){
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
    check_battery_status_flag = false;
  }
    // if(buzzer > 0){
    //   ledcWrite(1, profiles.intensity_buzzer);
    //   buzzer--;
    // }
    // if(haptic > 0){
    //   ledcWrite(0, profiles.intensity_haptic);
    //   haptic--;
    // }
    // delay(100);
    // ledcWrite(0, 0);  // turn off haptic feedback
    // ledcWrite(1, 0);  // turn off buzzer
    // delay(100);  
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
    // Serial << "Avg: " << avg << "\n";
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

void calc_imu(){
  int16_t ax, ay, az;
  int16_t gx, gy, gz;
  imu = false;  

  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

// Serial.println(ay);


  if(ay < -profiles.angle-3000){                 // holding the stick up
    led_state = !led_state;
    digitalWrite(LED_LIGHTS, led_state);
  }
  else if (ay > profiles.angle){            // holding the stick down
    led_state = true;
    digitalWrite(LED_LIGHTS, led_state);
  }
  // if((gx > 25000) || (gx < -25000)){     // droppin the stick
  //   digitalWrite(BUZZER, HIGH);
  //   delay(500);
  //   digitalWrite(BUZZER, LOW);
  // }
}
