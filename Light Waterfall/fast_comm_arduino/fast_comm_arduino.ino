#include <Adafruit_NeoPixel.h>


int incomingByte = 1;  
int receivedByte;

int strip_length = 120;
const int num_strips = 10;




Adafruit_NeoPixel strips[num_strips] = {Adafruit_NeoPixel(strip_length, 5, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 10, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 6, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 3, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 4, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 8, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 7, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 12, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 9, NEO_RGB + NEO_KHZ800),
Adafruit_NeoPixel(strip_length, 11, NEO_RGB + NEO_KHZ800)};

//Adafruit_NeoPixel strips = Adafruit_NeoPixel(60, 6, NEO_GRB + NEO_KHZ800);

int byte_counter = 0;
int pixel_color[3] = {0, 0, 0}; 


//TRY PLAYING AROUND WITH DISABLING INTERRUPTS AND SEE HOW THAT EFFECTS COMMUNCATION SPEED

//WRITE FUNCTION SO THAT SUM OF RGB NEVER GOES ABOVE 360


void setup() {
  // initialize serial communication:
  //Serial.begin(9600);
  Serial.begin(115200);
  //initialize the NeoPixel strips
  for (int i=0; i < num_strips; i++)
   strips[i].begin();
  updateStrips(); //start the strips off blank
  
  establishContact();
  
  //SETUP RGB LED FOR DEBUGGING
  /*
  pinMode(7, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(5, OUTPUT);
  */
  
  
}

void loop() {
  // see if there's incoming serial data:
   
  if (Serial.available() > 0) {
    // read the oldest byte in the serial buffer:
    receivedByte = Serial.read(); //Serial is read byte by byte
    incomingByte = receivedByte + 128; //account for weird Processing storage - use this variable 
    byte_counter++;    
    pixel_color[byte_counter % 3] = incomingByte;   
    if ((byte_counter % 3) == 0) // if a full color ready
    {
      uint32_t c = strips[0].Color(pixel_color[0], pixel_color[1], pixel_color[2]); //generate the color
      strips[(byte_counter-1)/3/strip_length].setPixelColor(byte_counter/3 % strip_length, c); //set appropiate pixel with color
    }      
    
    if (byte_counter == 3*num_strips*strip_length) //if we have finished a full waterfall state
    {
      byte_counter = 0;
      //updateStripsDebug();
      updateStrips();
    }
    
   if (byte_counter % 60 == 0)
    {
      Serial.write(20);  
    }
    }
}


void establishContact()
{
  while (Serial.available() <= 0)
  {
    Serial.write(8); //send ping to establish connection
    delay(100);
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
    analogWrite(7,(strips[0].getPixelColor(0) >> 16) & 0xFF); //red //8
    analogWrite(5,(strips[0].getPixelColor(0) >> 8) & 0xFF); //green // 0
    analogWrite(6,strips[0].getPixelColor(0) & 0xFF); //blue //16  
} 


  
  

  
  
  
 
 
