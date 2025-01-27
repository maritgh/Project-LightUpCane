/* DEFINES */
#define BUZZER 8
#define HAPTIC 10
#define LED_LIGHTS 2
#define SW_ON_BOOT 9
#define BATT_SENS 3

/* DEBUG DEFINES */
#define Debug

/* VARIABLES */
bool led_state = false;    // the current state of LED
bool power = false;
bool short_press = false;
bool check_battery_status = false;


int resistor1 = 200;
int resistor2 = 100;


int lastState = HIGH;  // the previous state from the input pin
int currentState;     // the current reading from the input pin
int battery_status = 4;
int haptic_on_times = 1;
int haptic_off_times = 2;
int buzzer_on_times = 1;
int buzzer_off_times = 2;
int battery_filter = 1;
int power_filter = 2;

long pressDuration = 0;
unsigned long pressedTime  = 0;
unsigned long releasedTime = 0;

// Flags for BLE connection
bool deviceConnected = false;








