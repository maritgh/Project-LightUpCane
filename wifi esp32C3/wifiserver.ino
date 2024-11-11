#include <WiFi.h>
#include <WebServer.h>

const char *ssid = "tesla iot";
const char *password = "fsL6HgjN";

WebServer server(80);

constexpr uint8_t LED_PIN_BLUE = 8;
constexpr uint8_t LED_PIN_YELLOW = 9;
constexpr uint8_t LED_PIN_RED = 10;

String currentColor = "Off";

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN_BLUE, OUTPUT);
  pinMode(LED_PIN_YELLOW, OUTPUT);
  pinMode(LED_PIN_RED, OUTPUT);
  delay(10);

  // We start by connecting to a WiFi network

  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  currentColor = "Off";
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/B", HTTP_POST, []() {
    digitalWrite(LED_PIN_BLUE, HIGH);
    digitalWrite(LED_PIN_YELLOW, LOW);
    digitalWrite(LED_PIN_RED, LOW);

    currentColor = "Blue";
    server.send(200, "text/plain", "LED Blue");
  });

  server.on("/Y", HTTP_POST, []() {
        digitalWrite(LED_PIN_BLUE, LOW);
    digitalWrite(LED_PIN_YELLOW, HIGH);
    digitalWrite(LED_PIN_RED, LOW);
    currentColor = "Yellow";
    server.send(200, "text/plain", "LED Yellow");
  });
  server.on("/R", HTTP_POST, []() {
        digitalWrite(LED_PIN_BLUE, LOW);
    digitalWrite(LED_PIN_YELLOW, LOW);
    digitalWrite(LED_PIN_RED, HIGH);
    currentColor = "Red";
    server.send(200, "text/plain", "LED Red");
  });

  server.on("/status", HTTP_GET, []() {
    server.send(200, "text/plain", currentColor);
  });

  server.begin();
  Serial.println("HTTP server started");
}


void loop() {
  server.handleClient();
}