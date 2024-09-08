#include <Arduino.h>
#include <Preferences.h>
#include <string.h>

// LUC = LightUpCane

// Initialize the Preferences library
Preferences preferences;

int frequency;            // frequency of the buzzer
int angle;                // angle threshold of the IMU
int time_change_profile;  // [LONG press threshold] - time (in milliseconds) to press button to change profile
int time_battery_status;  // [MEDIUM press threshold] - time (in milliseconds) to press button to get battery status
int time_led_status;      // [SHORT press threshold] - time (in milliseconds) to press button to get battery status
int intensity_haptic;     // intensity of the haptic feedback
int intensity_buzzer;     // intensity of the buzzer
int intensity_led;        // intensity of the led
int batteryFull;          // Battery status 100-75%
int batteryThird;         // Battery status 75-50%
int batteryHalve;         // Battery status 50-25%
int batteryLow;           // Battery status 25-0%

int haptic_on_times;      // Vibrations when LUC is turned on
int haptic_off_times;     // Vibrations when LUC is turned on
int buzzer_on_times;      // Buzzes when LUC is turned on
int buzzer_off_times;     // Buzzes when LUC is turned on

bool led_status = true;   // LUC LED status

// Function to split the string recieved by the GUI
// To devide the important information
void splitStringBySpace(String data) {
  int firstSpaceIndex = data.indexOf('$');
  int secondSpaceIndex = data.indexOf('$', firstSpaceIndex + 1);

  if (firstSpaceIndex != -1 && secondSpaceIndex != -1) {
    // Split the string into three parts
    String part1 = data.substring(0, firstSpaceIndex);
    String part2 = data.substring(firstSpaceIndex + 1, secondSpaceIndex);
    String part3 = data.substring(secondSpaceIndex + 1);

    // Print the three parts
    Serial.print("Part 1: ");
    Serial.println(part1);
    Serial.print("Part 2: ");
    Serial.println(part2);
    Serial.print("Part 3: ");
    Serial.println(part3);

    // If the string has 3 parts it will be checked on the first part of the string to determine the setting
    if (strcmp(part1.c_str(), "Battery") == 0) {
      changeBattery(part2, part3);
    } else if (strcmp(part1.c_str(), "Button") == 0) {
      changeButton(part2, part3);
    } else if (strcmp(part1.c_str(), "Light") == 0) {
      changeLight(part2, part3);
    } else if (strcmp(part1.c_str(), "Properties") == 0) {
      changeProperties(part2, part3);
    } else {
      Serial.println("Unknown setting type. Please use Battery, Button, Light, or Properties.");
    }

    
  } else if (firstSpaceIndex != -1) {
    // If there is only one space
    String part1 = data.substring(0, firstSpaceIndex);
    String part2 = data.substring(firstSpaceIndex + 1);

    // Print the two parts
    Serial.print("Part 1: ");
    Serial.println(part1);
    Serial.print("Part 2: ");
    Serial.println(part2);
    Serial.println("Part 3: (empty)");
  } else {
    // If there are no spaces, print the whole string as part 1 and leave parts 2 and 3 empty
    Serial.print("Part 1: ");
    Serial.println(data);
    Serial.println("Part 2: (empty)");
    Serial.println("Part 3: (empty)");
  }
}

// This function keeps track of the battery status and save its value on the flash memory throught the prefrence library
void changeBattery(String data, String value) {
  if (strcmp(value.c_str(), "100-75%") == 0) {
    const char* cData = data.c_str();
    batteryFull = cData[0] - '0';
    preferences.putInt("batteryFull", batteryFull);
  } else if (strcmp(value.c_str(), "75-50%") == 0) {
    const char* cData = data.c_str();
    batteryThird = cData[0] - '0';
    preferences.putInt("batteryThird", batteryThird);
  } else if (strcmp(value.c_str(), "50-25%") == 0) {
    const char* cData = data.c_str();
    batteryHalve = cData[0] - '0';
    preferences.putInt("batteryHalve", batteryHalve);
  } else if (strcmp(value.c_str(), "25-0%") == 0) {
    const char* cData = data.c_str();
    batteryLow = cData[0] - '0';
    preferences.putInt("batteryLow", batteryLow);
  }
}

// This function keeps track of the button status and save its value on the flash memory throught the prefrence library
void changeButton(String setting, String value) {
  size_t pos = setting.indexOf('>');
  if (pos != -1) {
    String numberStr = setting.substring(pos + 1);
    float time = numberStr.toFloat();
    float result = time * 100;

    if (strcmp(value.c_str(), "Battery status indication") == 0) {
      time_battery_status = result;
      preferences.putInt("time_battery_status", time_battery_status);
      Serial.print("Battery status indication result after multiplying by 100: ");
      Serial.println(time_battery_status);
    } else if (strcmp(value.c_str(), "Change settings") == 0) {
      time_change_profile = result;
      preferences.putInt("time_change_profile", time_change_profile);
      Serial.print("Change settings result after multiplying by 100: ");
      Serial.println(time_change_profile);
    } else if (strcmp(value.c_str(), "Toggle light") == 0) {
      time_led_status = result;
      preferences.putInt("time_led_status", time_led_status);
      Serial.print("Toggle light result after multiplying by 100: ");
      Serial.println(time_led_status);
    }
  }
}

// This function keeps track of the light status and save its value on the flash memory throught the prefrence library
void changeLight(String setting, String value) {
  if (strcmp(setting.c_str(), "On") == 0) {
    const char* cValue = value.c_str();
    haptic_on_times = cValue[0] - '0';
    buzzer_on_times = cValue[0] - '0';
    preferences.putInt("haptic_on_times", haptic_on_times);
    preferences.putInt("buzzer_on_times", buzzer_on_times);
  } else if (strcmp(setting.c_str(), "Off") == 0) {
    const char* cValue = value.c_str();
    haptic_off_times = cValue[0] - '0';
    buzzer_off_times = cValue[0] - '0';
    preferences.putInt("haptic_off_times", haptic_off_times);
    preferences.putInt("buzzer_off_times", buzzer_off_times);
  } else if (strcmp(setting.c_str(), "Light Intensity:") == 0) {
    Serial.println("change" + value);
  } else if (strcmp(setting.c_str(), "Light On/Off") == 0) {
    Serial.println("change" + value);
  }
}

// This function keeps track of the properties status and save its value on the flash memory throught the prefrence library
void changeProperties(String setting, String value) {
  if (strcmp(setting.c_str(), "Haptic intensity") == 0) {
    value.replace("%", "");
    intensity_haptic = value.toInt();
    preferences.putInt("haptic", intensity_haptic);
    Serial.println("change Haptic intensity to " + String(intensity_haptic));
  } else if (strcmp(setting.c_str(), "Buzzer intensity") == 0) {
    value.replace("%", "");
    intensity_buzzer = value.toInt();
    preferences.putInt("buzzer", intensity_buzzer);
    Serial.println("change Buzzer intensity to " + String(intensity_buzzer));
  } else if (strcmp(setting.c_str(), "Buzzer frequency") == 0) {
    value.replace("Hz", "");
    frequency = value.toInt();
    preferences.putInt("frequency", frequency);
    Serial.println("change Buzzer frequency to " + String(frequency));
  }
}

void setup() {
  // Start the serial communication at 9600 baud rate
  Serial.begin(9600);

  // Initialize Preferences library
  preferences.begin("settings", false);

  // Load stored values from flash memory
  frequency = preferences.getInt("frequency", frequency);
  time_change_profile = preferences.getInt("time_change_profile", time_change_profile);
  time_battery_status = preferences.getInt("time_battery_status", time_battery_status);
  time_led_status = preferences.getInt("time_led_status", time_led_status);
  intensity_haptic = preferences.getInt("haptic", intensity_haptic);
  intensity_buzzer = preferences.getInt("buzzer", intensity_buzzer);
  intensity_led = preferences.getInt("intensity_led", intensity_led);
  batteryFull = preferences.getInt("batteryFull", batteryFull);
  batteryThird = preferences.getInt("batteryThird", batteryThird);
  batteryHalve = preferences.getInt("batteryHalve", batteryHalve);
  batteryLow = preferences.getInt("batteryLow", batteryLow);
  haptic_on_times = preferences.getInt("haptic_on_times", haptic_on_times);
  haptic_off_times = preferences.getInt("haptic_off_times", haptic_off_times);
  buzzer_on_times = preferences.getInt("buzzer_on_times", buzzer_on_times);
  buzzer_off_times = preferences.getInt("buzzer_off_times", buzzer_off_times);

  // When connecting to the GUI this message will be send immediately to set the display values of the LUC
  String message = "display$_$" + String(intensity_led) + "$" + String(intensity_buzzer) + "$" + String(frequency) + "$" + String(intensity_haptic) + "$" + String(led_status);
  Serial.println(message);
}

void loop() {
  // Check if data is available to read
  while (Serial.available() > 0){
    // Read the incoming byte
    String receivedData = Serial.readStringUntil('\n');
    
    // Print the received data
    Serial.print("Received: ");
    Serial.println(receivedData);
    splitStringBySpace(receivedData);
    // Send a response back to the GUI
    String message = "display$_$" + String(intensity_led) + "$" + String(intensity_buzzer) + "$" + String(frequency) + "$" + String(intensity_haptic) + "$" + String(led_status);
    Serial.println(message);
  }
}