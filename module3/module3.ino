#include "Nicla_System.h"
#include "Arduino_BHY2.h"
#include <thread>

Sensor gas(SENSOR_ID_GAS);
SensorBSEC bsec(SENSOR_ID_BSEC);

void setup() {
  Serial.begin(115200);

  nicla::begin();
  nicla::leds.begin();
  
  BHY2.begin();

  gas.begin();
  bsec.begin();
}

void loop() {
  static bool toggle = false;
  static uint16_t measurementCount = 0;
//  constexpr uint16_t MAX_MEASUREMENTS = 1000;
  static auto lastCheck = millis();

  // Update function should be continuously polled
  BHY2.update();

//if(measurementCount < MAX_MEASUREMENTS) {
  // Check sensor values every 10 s
  if (millis() - lastCheck >= 10000) {
    lastCheck = millis();
  
    if(toggle) {
      nicla::leds.setColor(green);
    } else {
      nicla::leds.setColor(blue);
    }
  
    Serial.println(lastCheck + String(", ") + gas.value() + String(", ") + bsec.iaq() + String(", ") + bsec.b_voc_eq() + String(", ") + bsec.co2_eq() + String(", ") + bsec.comp_t() + String(", ") + bsec.comp_h() + String(", ") + bsec.accuracy());
    toggle ^= 1;
    measurementCount++;
  }
//}
  
  
}
