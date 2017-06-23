//imports
#include "SoftwareSerial.h"
#include "Adafruit_Thermal.h"
#include <Time.h>
#include <avr/pgmspace.h>
//end imports

const float pi = 3.14159;

int printer_RX_Pin = 7;  // This is the yellow wire
int printer_TX_Pin = 6;  // This is the green wire
Adafruit_Thermal printer(printer_RX_Pin, printer_TX_Pin); //setup printer
int print_interval = 10631; //10631, number of seconds between each printing, seconds-in-moon-cycle/240
double phase_interval = 1.0/240.0; //240 moons, 240 phases in cycle
int start_time = 0;


void setup(){
  Serial.begin(9600);
  pinMode(7, OUTPUT); digitalWrite(7, LOW); // To also work w/IoTP printer
  start_time = now();
  printer.begin(); 
}
  
void loop()
{
  
  Serial.print("Second" + (String) (now()-start_time));
  Serial.println();
  double phase = (((double)now()-start_time)*phase_interval)/((double) print_interval);
  Serial.println(phase);
  if(((int)now()-start_time) % print_interval == 0 && printer.hasPaper() && phase <= 1) //9889
  {
    //Serial.println(now());
    print_moon(phase); 
    print_spacer();
  }
  
}

void print_moon(double phase)
{
  Serial.println(phase);
  int width = 288;
   for (int y = 0; y < width; y++)
  {
  uint8_t row_data[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
  int radius = width/2;
  
  int curve_start = -1*sqrt(square(radius)-square(y-radius)) + 1 + radius + (384-width)/2;
  int curve_end = -1*(sqrt(square(radius)-square(y-radius))*cos(2*pi*phase))/1 + radius + (384-width)/2;
  if (phase > 0.5) 
  {
    Serial.println("PHASE STATE REACHED");
    curve_start = (sqrt(square(radius)-square(y-radius))*cos(2*pi*phase))/1 + radius + (384-width)/2;
    curve_end = sqrt(square(radius)-square(y-radius)) - 1 + radius + (384-width)/2;
  }
  
  int pixel = 0;
  if (y % 2 == 0) pixel = 1; //make pattern checkered
  
  for (; pixel < 384; pixel+=2) //generate the pixels by heating every other pixel
       if (pixel >= curve_start && pixel<=curve_end)
         row_data[pixel/8] += (1 << ((pixel+8)/8)*8-pixel-1);
         
    //for (int i=0; i < 48; i++) Serial.println(row_data[i], BIN);
    
    //print one row of the moon
    printer.printBitmap(384,1,row_data,false);
  }
}

void print_spacer()
{
  uint8_t blank_data[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
                            0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
                        0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
                  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
              0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x00, 0x00};
  printer.printBitmap(0, 96, blank_data, false); //should be 96?
}
