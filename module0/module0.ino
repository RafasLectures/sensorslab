#include "Nicla_System.h"
#include "Arduino_BHY2.h"
#include <thread>

SensorXYZ accelerometer(SENSOR_ID_ACC);
//SensorXYZ gyro(SENSOR_ID_GYRO);
Sensor pressureSensor(SENSOR_ID_BARO);

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
}

void loop() {
  static bool toggle = false;
  static uint16_t measurementCount = 0;
  constexpr uint16_t MAX_MEASUREMENTS = 1000;

  //if(measurementCount < MAX_MEASUREMENTS) {
    BHY2.update();
    if(toggle) {
      nicla::leds.setColor(green);
    } else {
      nicla::leds.setColor(blue);
    }
    sensorXYZ.setRange(uint16_t range)
    Serial.println(millis() + String(", ")  + sensor.value() + String(", ") + sensorXYZ.x()+ String(", ") + sensorXYZ.y() + String(", ") + sensorXYZ.z());
    toggle ^= 1;
    measurementCount++;
    delay(100);
  //}
  
  
}
