#include "Nicla_System.h"
#include "Arduino_BHY2.h"

//SensorXYZ accelerometer(SENSOR_ID_ACC);
SensorXYZ gyro(SENSOR_ID_GYRO);


SensorXYZ& sensor = gyro;

template <typename ...TYPES>
class CsvLogger {
  
};

void setup() {
  Serial.begin(115200);

  nicla::begin();
  nicla::leds.begin();

  BHY2.begin();
  //accelerometer.begin();
  sensor.begin();

  Serial.println(String("X, Y, Z"));
}

void loop() {
  static bool toggle = false;
  static uint16_t measurementCount = 0;
  constexpr uint16_t MAX_MEASUREMENTS = 1000;

  if(measurementCount < MAX_MEASUREMENTS) {
    BHY2.update();
    if(toggle) {
      nicla::leds.setColor(green);
    } else {
      nicla::leds.setColor(blue);
    }
    //Serial.println(String("Acceleration: ") + sensor.toString());
    Serial.println(sensor.x()+ String(", ") + sensor.y() + String(", ") + sensor.z());
    toggle ^= 1;
    measurementCount++;
    delay(100);
  }
  
  
}
