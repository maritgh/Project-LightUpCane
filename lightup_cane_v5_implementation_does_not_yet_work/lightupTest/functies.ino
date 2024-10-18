void init_hardware(){
  Serial.begin(9600);
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
  intensity = (intensity / 100.0)*256.0;   
  return intensity;
}
