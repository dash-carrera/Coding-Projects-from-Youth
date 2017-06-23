import processing.serial.*; 
 
 
 int waterfall_counter = 0;
 
 Serial port; 
 String port_name;
 boolean firstContact = false;
 byte val;
 color[][] red_waterfall = new color[120][10];
 color[][] blue_waterfall = new color[120][10]; 
 
 //Send Waterfall Variables
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
      red_waterfall[i][j] = color(80,40,0);
      blue_waterfall[i][j] = color(80,0,40);
    }
  current_waterfall = red_waterfall; 
 }

 
 void draw() 
 { 
  //Must be called by reDraw() - all loop running is based around serialEvents
 }
 
 void serialEvent(Serial port)
 {
   print(".");
   print(val);
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
      port.write(getBytes(0)); //contact confirmation
      println("contact");
    }
  }
  
  else
  {     
    if (val == 20) //confirm data received
    {
      //print(val);
        which_row+=20;
        if (which_row == 120)
        {
          which_row = 0;
          which_strip++;
          if (which_strip == 10)
          {
            println("Reached end of waterfall_state " + waterfall_counter);
            waterfall_counter++;
            if (current_waterfall == blue_waterfall) //switch waterfalls
              current_waterfall = red_waterfall;
            else
              current_waterfall = blue_waterfall;
            which_strip = 0;
          }
      }
      port.write(getBytes(which_row));
    }
    else
    {
      println("Error! " + val  + " Returned Instead of Confirmation");
    }  
  }
 }
 
byte getRGB(color the_color, int which_color)
//return the needed r,g, or b component of a color
{
  if (which_color == 0) //if after red component
    return byte(((the_color >> 16) & 0xFF)-128);
  else if (which_color == 1)
    return byte(((the_color >> 8) & 0xFF) - 128);
  else
    return byte((the_color & 0xFF)-128);
}

byte[] getBytes(int start_row)
//get the next needed partition of bytes, length 20 pixels
{
  byte[] bytes = new byte[60];  
  for (int i=start_row; i < start_row+20; i++)
    for (int which_color =0; which_color < 3; which_color++)
      bytes[(i-start_row)*3+which_color] = getRGB(current_waterfall[i][which_strip], which_color);
  return bytes;
}


