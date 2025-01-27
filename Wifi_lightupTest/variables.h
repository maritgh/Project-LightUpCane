/* DEFINES PINS*/
#define BUZZER 8
#define HAPTIC 10
#define LED_LIGHTS 3
#define SW_ON_BOOT 9
#define BATT_SENS 2

/* DEBUG DEFINES */
#define Debug

// WiFi access point credentials
const char* ssid = "light_up_cane";
const char* password = "12345678";


/* VARIABLES */
bool power = false;           // the current state of LED
bool short_press = false;
bool check_battery_status = false;

// which resistors are used for the voltage divider
int resistor1 = 200;
int resistor2 = 100;

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









