GUI-codes:

1. **taalVertaling**:
This GUI application is designed to control and monitor a light-up cane device. It provides functionalities to authenticate users, display information, manage profiles, and adjust settings.
This GUI has an optional feature that allows you to translate the interface from English to Dutch.
This facilitates usage for elderly caregivers who do not speak English.

2. **tts**:
Another optional feature is the text-to-speech function.
This enables you to hear all written text, improving accessibility for visually impaired users and facilitating future interface usage.


Requirements:
- Python 3.x
- Tkinter (usually comes pre-installed with Python)
  
If not, Install the required dependencies by running:

pip install tkinter  

for text-to-speech function: 
pyttsx3 (usually comes pre-installed with Python)
If not, Install the required dependencies by running:

pip install pyttsx3

Installation:
Clone or download the repository to your local machine.
Make sure you have Python installed.


Run the application by executing the file.


Usage:
- Start Screen: The application begins with a start screen prompting the user to connect the Light-up Cane.

- Login Screen: After clicking the "Next" button, the login screen appears where the user needs to enter the correct cane number and click the "Login" button.

- Main Screen: Upon successful login, the main screen is displayed. It contains three buttons: "Profile", "Display", and "Settings". Clicking on each button navigates to the corresponding screen.

- Profile Screen: Here, users can select a profile from the dropdown menu and view/edit the profile name.

- Display Screen: This screen displays information such as battery status, light intensity, buzzer intensity, buzzer frequency, haptic intensity, and light on/off status.

- Settings Screen: Users can adjust various settings including button settings, battery status indication, toggle light settings, and properties settings.

Features:
- User authentication.
- Multilingual support (English and Dutch).
- Profile management.
- Dynamic updating of display values.
- Settings customization.
- Text-to-speech options. 

Supported Languages:
- English
- Dutch


