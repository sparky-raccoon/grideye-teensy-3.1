#include <Wire.h>
byte pixeltemp;
char address = 0x68;
int celsius;

void setup()
{
  Wire.begin(); // Begin using Wire in master mode.
  Serial.begin(9600); // Sets the data rate in bits per second (baud) for serial data transmission.
}

void loop()
{
  // Serial.print("Grid-EYE:\r\n");
  pixeltemp = 0x80;
  for (int pixel = 0; pixel < 64 ; pixel ++) {
    
    Wire.beginTransmission(address); // Start a new transmission to a device at "address". Master mode is used.
    Wire.write(pixeltemp); // Writes data from a slave device in response to a request from a master, or queues bytes for transmission from a master to slave device. 
    Wire.endTransmission(); // In master mode, this ends the transmission and causes all buffered data to be sent.
    Wire.requestFrom(address, 1); // Used by the master to request bytes from a slave device.
    byte lowerLevel = Wire.read();
    
    pixeltemp ++;
    
    Wire.beginTransmission(address); 
    Wire.write(pixeltemp); 
    Wire.endTransmission(); 
    Wire.requestFrom(address, 1);
    byte upperLevel = Wire.read();
    
    pixeltemp ++;
    
    int temperature = ((upperLevel << 8) | lowerLevel);
    if (temperature > 2047){ temperature = temperature - 4096; }
    
    celsius = temperature * 0.25;
    
    // Select 1 or 2.
    
    // 1. Displaying data for Arduino serial monitoring.
    /* if (pixel==0) { Serial.print(500); }
    else { Serial.print(celsius); }
    if((pixel+1)%8 == 0){ Serial.print("\r\n"); } */
    
    // 2. Transmitting data to Processing.
    if (pixel==0) { Serial.println(500); }
    else { Serial.println(celsius); }
  }
  // (1.) Serial.println();
  delay(100);
 }
