This code is to use the light up cane through Bluetooth low energie

To use this code download the next libraries:
stdio.h
BLEDevice.h
BLEServer.h
BLEUtils.h
BLE2902.h
Preferences.h

and the next board:
esp32 by Espressif Systems (it was tested with version 3.1.1 all other versions might not work because of changes in the API)

to upload the code follow the next steps:
1. go to Tools > Board > esp32 > XIAO_ESP32C3
2. go to Tools > port and choose the port the esp32 is connected to
3. go to USB CDC On Boot: and choose enabled

To work with the cane connect the app in the connection page to light_up_cane

