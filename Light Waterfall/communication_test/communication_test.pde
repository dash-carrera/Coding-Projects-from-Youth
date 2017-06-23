import processing.serial.*; 
 
 Serial port; 
 String port_name;
 boolean firstContact = false;
 byte val;
 color[][] red_waterfall = new color[120][10];
 color[][] blue_waterfall = new color[120][10]; 
 
 //Send Waterfall Variables
 int which_color = 0;
 int which_strip = 0; //10 total strips
 int which_row = 0; //120 total rows
 color[][] current_waterfall = new color[120][10];
 
 
 //*******************
 
 
 void setup()  
 {
 // List all the available serial ports in the output pane. 
 // You will need to choose the port that the Arduino board is 
 // connected to from this list. The first port in the list is 
 // port #0 and the third port in the list is port #2. 
 println("Serial List");
 println(Serial.list());
 port_name = Serial.list()[5];
 println("Selected port:");
 println(port_name); 
 port = new Serial(this, port_name, 115200); //Open the port at same speed as Arduino
  
   //Make some test waterfalls
 for (int i = 0; i < 120; i++)
    for (int j = 0; j < 10; j++)
    {
      red_waterfall[i][j] = color(255,0,0);
      blue_waterfall[i][j] = color(0,0,255);
    }
  current_waterfall = red_waterfall; 
 }

 
 void draw() 
 { 
  //Must be called by reDraw() - all loop running is based around serialEvents
 }
 
 void serialEvent(Serial port)
 {
   byte[] bytes = port.readBytes();
   if (bytes.length > 1)
     println("BYTE ARRAY LARGER THAN 1");
     
   val = bytes[0];
   
   //print(val);
      
  if (firstContact == false) 
  {
    if (val == 8) {
      port.clear();
      firstContact = true;
      port.write(getRGB(current_waterfall[0][0]));
      print(getRGB(current_waterfall[0][0]));
      println("contact");
    }
  }
  
  else
  {
   // print(".");
        
    if (val == (getRGB(current_waterfall[which_row][which_strip]))) //if returned value what expected
    {
      //print(val);
      
      which_color++;
      if (which_color == 3)
      {
        which_color = 0;
        which_row++;
        if (which_row == 120)
        {
          which_row = 0;
          which_strip++;
          if (which_strip == 10)
          {
            println("Reached end of waterfall_state");
            if (current_waterfall == blue_waterfall) //switch waterfalls
              current_waterfall = red_waterfall;
            else
              current_waterfall = blue_waterfall;
            which_strip = 0;
          }
        }
      }
      port.write(getRGB(current_waterfall[which_row][which_strip]));
    }
    else
    {
      println("Error! " + val  + " Returned Instead of " + getRGB(current_waterfall[which_row][which_strip]));
    }  
  }
 }
 
byte getRGB(color the_color)
//return the needed r,g, or b component of a color
{
  if (which_color == 0) //if after red component
    return byte(((the_color >> 16) & 0xFF)-128);
  else if (which_color == 1)
    return byte(((the_color >> 8) & 0xFF) - 128);
  else
    return byte((the_color & 0xFF)-128);
}
