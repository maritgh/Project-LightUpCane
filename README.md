**ESP32 C3 code for the light up cane with app**

**DartCode_V2**

  this code is for an app to install the light up cane through wifi or bluetooth the code can be run in multiple ways one way is to run it     in VS-code with a simulator for ios or android. For this u need to open a flutter project in vs code and copy this map as the lib map.       After that u need to edit the pubspec.yaml file to add these dependencies:
  
    dependencies: 
      flutter:  
        sdk: flutter
      english_words: ^4.0.0
      provider: ^6.0.0
      flutter_blue_plus: ^1.34.4
      http: ^1.2.2
      flutter_tts: ^4.1.0
  
  
  For ios the wifi version is needed and for android u can use both.

**lightupTest**

  this is the code for the light up cane to work with the app through Wifi.
  (the battery status is not yet correct in this code)

**BLE_lightupTest**

  this code is for the light up cane to work with the app throug BLE.
  (this code does not yet fully work)

