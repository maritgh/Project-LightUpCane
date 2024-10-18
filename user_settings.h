/* USER SETTINGS */

struct profiles {  
  int number = 6;                 // number of the profile
  int frequency = 1000;         // frequency of the buzzer
  int angle = 2000;               // angle of the IMU
  int time_change_profile = 4000; // time (in milliseconds) to press button to change profile 
  int time_battery_status = 500;  // time (in milliseconds) to press button the get battery status
  float intensity_haptic = 50.0;  // intensity of the haptic feedback
  float intensity_buzzer = 90.0;  // intensity of the buzzer
  float intensity_led = 50.0;     // intensity of the led
} profiles;
