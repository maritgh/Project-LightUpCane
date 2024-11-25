This code is to use the light up cane through Wifi
The battery status is not fully correct yet

To use this code download the next libraries:
stdio.h
MPU6050.h
WiFi.h
WebServer.h

and the next board:
esp32 by Espressif Systems (it works with version 3.0.7 all other versions might not work because of changes in the API)

To upload the code follow the next steps:
1. go to Tools > Board > esp32 > ESP32C2 DEV MODULE
2. go to Tools > port and choose the port the esp32 is connected to
3. go to USB CDC On Boot: and choose enabled

To connect to the cane connect your wifi to light_up_cane with the password "12345678"

