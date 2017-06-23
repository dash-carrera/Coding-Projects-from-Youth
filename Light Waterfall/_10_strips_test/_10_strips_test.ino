#include <Adafruit_NeoPixel.h>

int incomingByte;      // a variable to read incoming serial data into
int strip_length = 120;
const int num_strips = 10;

Adafruit_NeoPixel strips[num_strips] = {Adafruit_NeoPixel(strip_length, 1, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 2, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 3, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 4, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 5, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 6, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 7, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 8, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 9, NEO_GRB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 10, NEO_GRB + NEO_KHZ800)};

void setup() {
  // initialize serial communication:
  Serial.begin(115200);
  //initialize the NeoPixel strips
  for (int i=0; i < num_strips; i++)
   strips[i].begin();
  updateStrips(); //start the strips off blank
}

void loop()
{
  for (int i=0; i < 10; i++)
    strips[i].setPixelColor(strips[0].Color(100,100,100));
  updateStrips();
}

void updateStrips() 
//This refreshes all the strips
{
  for (int i=0; i < num_strips; i++)
   strips[i].show();
}
