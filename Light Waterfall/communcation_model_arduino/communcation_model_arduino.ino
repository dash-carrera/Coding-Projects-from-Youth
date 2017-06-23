#include <Adafruit_NeoPixel.h>


int incomingByte = 1;  
int receivedByte;
boolean unreadByte = false;

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

//Adafruit_NeoPixel strips = Adafruit_NeoPixel(60, 6, NEO_GRB + NEO_KHZ800);

int byte_counter = 0;
int pixel_color[3] = {0, 0, 0}; 



void setup() {
  // initialize serial communication:
  Serial.begin(115200);
  //initialize the NeoPixel strips
  for (int i=0; i < num_strips; i++)
   strips[i].begin();
  updateStrips(); //start the strips off blank
  
  establishContact();
  
  //SETUP RGB LED FOR DEBUGGING
  
  pinMode(7, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(5, OUTPUT);
  
  
}

void loop() {
  // see if there's incoming serial data:
   
  if (Serial.available() > 0) {
    // read the oldest byte in the serial buffer:
    receivedByte = Serial.read(); //Serial is read byte by byte
    incomingByte = receivedByte + 128; //account for weird Processing storage - use this variable 
    unreadByte = true;
    }
    
      
  if (unreadByte)
   { 
     
    pixel_color[byte_counter % 3] = incomingByte;
    byte_counter++;
    
    if ((byte_counter % 3) == 0) // if a full color ready
    {
      uint32_t c = strips[0].Color(pixel_color[0], pixel_color[1], pixel_color[2]); //generate the color
      strips[byte_counter/3/strip_length].setPixelColor(byte_counter/3 % strip_length, c);
    }      
    
    if (byte_counter == 3*num_strips*strip_length)
    {
      byte_counter = 0;
      updateStripsDebug();
    }
    unreadByte = false;
    Serial.write(receivedByte);   
  }
}


void establishContact()
{
  while (Serial.available() <= 0)
  {
    Serial.write(8); //send ping to establish connection
    delay(300);
  }
}


void updateStrips() 
//This refreshes all the strips
{
  for (int i=0; i < num_strips; i++)
   strips[i].show();
}



void updateStripsDebug()
{
 for (int i = 0; i < strip_length; i++)
  {
    analogWrite(7,(strips[0].getPixelColor(i) >> 16) & 0xFF); //red
    analogWrite(5,(strips[0].getPixelColor(i) >> 8) & 0xFF); //green
    analogWrite(6,strips[0].getPixelColor(i) & 0xFF); //blue
  }
// delay(200);
  
} 
  
  

  
  
  
 
 
