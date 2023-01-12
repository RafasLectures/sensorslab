#include "Nicla_System.h"
#include "Arduino_BHY2.h"
#include <thread>

SensorXYZ magnetometer(SENSOR_ID_MAG_PASS);

SensorXYZ& sensorXYZ = magnetometer;

void setup() {
  Serial.begin(115200);

  nicla::begin();
  nicla::leds.begin();
  
  BHY2.begin();

  sensorXYZ.begin();
}

void loop() {
  static bool toggle = false;
  static uint16_t measurementCount = 0;
  constexpr uint16_t MAX_MEASUREMENTS = 1000;
  static auto lastCheck = millis();

  // Update function should be continuously polled
  BHY2.update();

if(measurementCount < MAX_MEASUREMENTS) {
  // Check sensor values every 100 ms
  if (millis() - lastCheck >= 100) {
    lastCheck = millis();
  
    if(toggle) {
      nicla::leds.setColor(green);
    } else {
      nicla::leds.setColor(blue);
    }
  
    Serial.println(lastCheck + String(", ") + sensorXYZ.x()+ String(", ") + sensorXYZ.y() + String(", ") + sensorXYZ.z());
    toggle ^= 1;
    measurementCount++;
  }
}
  
  
}
