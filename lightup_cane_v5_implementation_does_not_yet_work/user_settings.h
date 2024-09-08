/* USER SETTINGS */

struct profiles {  
  int number = 1;                 // number of the (standard) profile [see 'profiles.ino']
  int frequency = 1000;         // frequency of the buzzer
  int angle = 2000;               // angle threshold of the IMU
  int time_change_profile = 1500; // [LONG press threshold] - time (in milliseconds) to press button to change profile
  int time_battery_status = 500;  // [MEDIUM press threshold] - time (in milliseconds) to press button the get battery status
  float intensity_haptic = 50.0;  // intensity of the haptic feedback
  float intensity_buzzer = 90.0;  // intensity of the buzzer
  float intensity_led = 50.0;     // intensity of the led
} profiles;

int haptic_on_times = 1;
int haptic_off_times = 2;
int buzzer_on_times = 1;
int buzzer_off_times = 2;
int haptic_profiles_times = 3;
int buzzer_profiles_times = 3;

// #define DEFAULT_INTENSITY_HAPTIC 50
// #define DEFAULT_INTENSITY_BUZZER 50
// #define DEFAULT_INTENSITY_LED 50
// #define DEFAULT_TIME_CHANGE_PROFILE 1000
// #define DEFAULT_TIME_BATTERY_STATUS 500
// #define DEFAULT_HAPTIC_ON_TIMES 1
// #define DEFAULT_HAPTIC_OFF_TIMES 1
// #define DEFAULT_BUZZER_ON_TIMES 1
// #define DEFAULT_BUZZER_OFF_TIMES 1


// Number of profiles in use (see profiles.ino how many profiles you're actually using)
const int MAX_NUMBER_OF_PROFILES = 2; //profiles.number = 0 -> disable profile use
