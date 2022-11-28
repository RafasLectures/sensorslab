#include "Nicla_System.h"
#include "Arduino_BHY2.h"
#include <thread>

SensorXYZ accelerometer(SENSOR_ID_ACC_PASS);
//SensorXYZ gyro(SENSOR_ID_GYRO);
Sensor pressureSensor(SENSOR_ID_BARO);
//Sensor temperatureSensor(SENSOR_ID_TEMP);

SensorXYZ& sensorXYZ = accelerometer;
Sensor& sensor = pressureSensor;
// configureSensorRange in BoschSensortec
void setup() {
  Serial.begin(115200);

  nicla::begin();
  nicla::leds.begin();
  
  BHY2.begin();

  sensorXYZ.begin();
  sensor.begin();
  sensorXYZ.setRange(2);
}

void loop() {
  static bool toggle = false;
  static uint16_t measurementCount = 0;
  constexpr uint16_t MAX_MEASUREMENTS = 1000;
  static auto lastCheck = millis();

  // Update function should be continuously polled
  BHY2.update();

if(measurementCount < MAX_MEASUREMENTS) {
  // Check sensor values every second  
  if (millis() - lastCheck >= 100) {
    lastCheck = millis();
  
    if(toggle) {
      nicla::leds.setColor(green);
    } else {
      nicla::leds.setColor(blue);
    }
  
    Serial.println(lastCheck + String(", ")  + sensor.value() + String(", ") + sensorXYZ.x()+ String(", ") + sensorXYZ.y() + String(", ") + sensorXYZ.z());
    toggle ^= 1;
    measurementCount++;
    //delay(100);
  }
}
  
  
}
