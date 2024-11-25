/* DEFINES PINS*/
#define SCL_PIN 1
#define SDA_PIN 0
#define BUZZER 8
#define HAPTIC 10
#define LED_LIGHTS 3
#define SW_ON_BOOT 9
#define BATT_SENS 3

/* DEBUG DEFINES */
#define Debug

// WiFi access point credentials
const char* ssid = "light_up_cane";
const char* password = "12345678";


/* VARIABLES */
bool power = false;           // the current state of LED
bool imu = false;
bool short_press = false;
bool check_battery_status = false;

float bat_voltage = 0.0; // ADC batt sens
float bat_voltages[20];  // array for battery voltages

int check = 0;
int ctr = 0;
int lastState = HIGH;  // the previous state from the input pin
int currentState;     // the current reading from the input pin
int battery_status = 4;

int haptic_on_times = 1;  //how many times haptic when light is turned on
int haptic_off_times = 2; //how many times haptic when light is turned off

int buzzer_on_times = 1; //how many times buzzer when light is turned on
int buzzer_off_times = 2;  //how many times buzzer when light is turned off

int battery_filter = 1;
int power_filter = 2;

long pressDuration = 0;
unsigned long pressedTime  = 0;
unsigned long releasedTime = 0;

hw_timer_t *imu_timer = NULL;
hw_timer_t *imu_blink_timer = NULL;

MPU6050 mpu;








