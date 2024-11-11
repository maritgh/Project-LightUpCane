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
  imu_timer = timerBegin(1000000); // (timer ch, divider, countup)
  timerAttachInterrupt(imu_timer, &onTimer);
  timerAlarm(imu_timer, 100000, true, 1);
}

int calc_intensity(float intensity){
  intensity = (intensity / 100.0)*256.0;   
  return intensity;
}
