//Communication Related

import processing.serial.*; 
Serial port; 
String port_name;
boolean firstContact = false;
byte val;
 int which_strip = 0; //10 total strips
 int which_row = 0; //120 total rows
  int waterfall_counter = 0;
color[][] current_waterfall = new color[120][10];
//End of communication related

//Keycard reading constants
String lastInput = new String();
String currentInput = new String();

int offset = 0;

//Constants
int rect_width = 24;
float rect_height = 100;
int num_circles = 5000;
float rate_increaser = 1;

//Circle variables
float[] circle_rates = new float[num_circles];
float[] circle_y = new float[num_circles];
float[] rect_heights = new float[num_circles];
int[] colors = new int[num_circles];

//Speed transition variable
boolean speed_transitions = false;
boolean[] circle_changed = new boolean[num_circles];

//Other initializations
char mode = 'n'; 
color saturated1;
color saturated2;

//Start mario
PImage mario;


void setup()
{
  size(240, 240);
  noStroke();

  for (int i = 0; i < num_circles; i++) //Setup the variables
  {
    circle_rates[i] =  random(1, 5);
    circle_y[i] = random(0, height);
    colors[i] = color(0, 0, 0);
    circle_changed[i] = true;
  }

  //Communcation stuff 

  println("Serial List");
  println(Serial.list());
  port_name = Serial.list()[5];
  println("Selected port:");
  println(port_name); 
  port = new Serial(this, port_name, 115200); //Open the port at same speed as Arduino
  
  //Setup very first waterfall state
  for (int i = 0; i < 120; i++)
    for (int j = 0; j < 10; j++)   
      current_waterfall[i][j] = color(80,40,0); //waterfall starts off as arbitrary color
  
  
noLoop();
}


void draw()
{
//  background(0);
//
//
//  //Draw all the circles
//  for (int i = 0; i < circle_y.length; i++)
//  {  
//    int slot = 24*(i%10); //go in one of ten slots
//    fill(colors[i]);
//    rect(slot, circle_y[i], rect_width, rect_heights[i]);
//  }
//
//
//
//  for (int i=0; i < num_circles; i++)
//  {
//    if (circle_y[i] - rect_height > height)
//    {
//      rect_heights[i] = rect_height;
//      circle_y[i] = -rect_heights[i];
//
//      if (speed_transitions)
//        //Toggle speed transitions mode
//        //Change circles after they've made one change of color
//      {
//        if (circle_changed[i])
//        {
//          circle_rates[i] = random(1+rate_increaser, 2+rate_increaser);
//        }
//        else
//          circle_changed[i] = true;
//      }
//
//
//      int first_color = (int) random(0, 255);
//
//      if (mode == 'n') 
//      {
//        colors[i] = color(random(0, 255), random(0, 255), random(0, 255));
//      }
//      else if (mode == 'r')
//      {
//        colors[i] = color(0, first_color, 255-first_color);
//      }
//      else if (mode == 'g')
//      {
//        colors[i] = color(first_color, 0, 255-first_color);
//      }
//      else if (mode == 'b')
//      {
//        colors[i] = color(first_color, 255-first_color, 0);
//      }
//      else if (mode =='q')
//      {
//        float red = random(min(red(saturated1), red(saturated2)), max(red(saturated1), red(saturated2)));
//        float blue = random(min(blue(saturated1), blue(saturated2)), max(blue(saturated1), blue(saturated2)));
//        float green = random(min(green(saturated1), green(saturated2)), max(green(saturated1), green(saturated2)));
//        colors[i] = color(red, green, blue);
//      }
//      else if (mode =='w') //when w is pressed
//      {
//        float frac = random(0, 1);
//        float red = red(saturated1)*frac+red(saturated2)*(1-frac);
//        float blue = blue(saturated1)*frac+blue(saturated2)*(1-frac);
//        float green = green(saturated1)*frac+green(saturated2)*(1-frac);
//
//        colors[i] = color(red, green, blue);
//      }
//      else if (mode =='e') //when e is pressed
//      {
//        float frac = random(0, 1);
//        float red = red(saturated1)*frac+red(saturated2)*(1-frac);
//        float blue = blue(saturated1)*frac+blue(saturated2)*(1-frac);
//        float green = green(saturated1)*frac+green(saturated2)*(1-frac);
//
//        float scalar = random(0, 1);
//
//        colors[i] = color(scalar*red, scalar*green, scalar*blue);
//      }
//    }
//    else
//      circle_y[i]+=circle_rates[i];
//  }
  flag();
  //image(mario,0,0);
  current_waterfall=sample();
/*  for (int i=0; i<60; i++) {
  serialSend(port);
  delay(3);
}*/
}
void serialSend(Serial port) {
  which_row+=20;
        if (which_row == 120)
        {
          which_row = 0;
          which_strip++;
          if (which_strip == 10)
          {
            println("Reached end of waterfall_state " + waterfall_counter);
            waterfall_counter++;
            //redraw();
            current_waterfall = sample();
            which_strip = 0;
          }
      }
      port.write(getBytes(which_row));
      
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
            redraw();
            //current_waterfall = sample();
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
 //ACTUALLY RBG
//return the needed r,g, or b component of a color
{
  if (which_color == 0) //if after red component
    return byte(((the_color >> 16) & 0xFF)-128);
  else if (which_color == 1)
  return byte((the_color & 0xFF)-128);
  else
    return byte(((the_color >> 8) & 0xFF) - 128);
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



void keyPressed()
{
  /*
  //Keycard reading
  boolean flag = true;
  if(key == ENTER || key == ';')
  {
    lastInput = currentInput;
    currentInput = "";
    String a = "600955";
    if(lastInput.length() > 5 && flag){
      if(lastInput.substring(0, 6).equals(a) == true){
        {
    randomSeed(int(lastInput.substring(7,16))); //chop off one digit so not to large
    //randomSeed(472981459);
    mode = 'q'; //uses same as q
    rect_height = random(5, 100);
    int random_num = (int) random(0, 765);
    saturated1 = saturated_color(random_num);
    saturated2 = saturated_color((int) (random_num+383+random(-200, 200))%765);
        }
      }
    }
  } 
  else
  {
    if(key>='0' && key <='9'){
      currentInput = currentInput + key;
    }
    else if(currentInput.length() > 1){
      flag = false;
    }
  }
  */
  
  //End of keycard reading
  
  

  if (speed_transitions)
    rate_increaser = random(0, 10);



  //Alter the mode
  if (key != '1' && key != '2' && key != '3') //if not one of the setting changes
    mode = key;

  //Mode changes

  if (key == 'q' || key == 'w' || key == 'e')
  {
    rect_height = random(5, 100);
    saturated1 = saturated_color((int) random(0, 765));
    saturated2 = saturated_color((int) random(0, 765));
  }
 

  if (key == 's') //complementary colors
  {
    mode = 'q'; //uses same as q
    rect_height = random(5, 100);
    int random_num = (int) random(0, 765);
    saturated1 = saturated_color(random_num);
    saturated2 = saturated_color((int) (random_num+383+random(-200, 200))%765);
  }

  //Settings toggle



  if (key == '1')
    //Toggle width
  {
    if (rect_width == 24)
      rect_width = 1;
    else
      rect_width = 24;
  }

  if (key == '2')
    //Increase speed
  {
    for (int i = 0; i < num_circles; i++) //Setup the variables
      circle_rates[i] =  random(1+rate_increaser, 5+rate_increaser);
    rate_increaser++;
  }

  if (key == '3')
  {   
    //Variable, shifting speed

    if (!speed_transitions)
    {
      for (int i = 0; i < num_circles; i++)
        circle_changed[i] = false;
      rate_increaser = random(0, 10);
      speed_transitions = true;
    }
    else
    {
      speed_transitions = false;
      for (int i =0; i < num_circles; i++)
        circle_rates[i] =  random(1, 5);
    }
  }

  //Print shit out

  //saturated 1
  /*
    print("red1: ");
   println(red(saturated1));
   print("green1: ");
   println(green(saturated1));
   print("blue1: ");
   println(blue(saturated1));
   //saturated 2
   print("red2: ");
   println(red(saturated2));
   print("green2: ");
   println(green(saturated2));
   print("blue2: ");
   println(blue(saturated2));
   println("---------------");
   */
}

color saturated_color(int permutation)
{
  int blue;
  int green;
  int red;
  if (permutation < 255)
  {
    red = 255 - permutation;
    green = permutation;
    blue = 0;
  }
  else if (permutation < 510)
  {
    red = 0;
    green = 510 - permutation; 
    blue = permutation - 255;
  }
  else
  {
    red = permutation - 510;
    green = 0; 
    blue = 765 - permutation;
  }
  return color(red, green, blue);
}

color saturated_color(int permutation, float scalar)
//Input: Permutation is a number 0-765, scalar is 0-1
{
  scalar = pow(scalar, .3333);
  int blue;
  int green;
  int red;
  if (permutation < 255)
  {
    blue = 255 - permutation;
    green = permutation;
    red = 0;
  }
  else if (permutation < 510)
  {
    red = 510 - permutation;
    blue = permutation - 255;
    green = 0;
  }
  else
  {
    green = 765 - permutation; 
    red = permutation - 510;
    blue = 0;
  }
  return color(red*scalar, green*scalar, blue*scalar);
}

color[][] sample() {
  color[][] sampled = new color[120][10];
  loadPixels(); 
 /*for (int i = 0; i<10; i++) {
    int xpos = 24*i+11;
    for (int j = 0; j<120; j++) {
      sampled[i][j]=pixels[480*j+xpos];
    }
  }*/
  
  for (int i = 0; i < 10; i++)
    for (int j =0; j < 120; j++)
      sampled[j][i] = pixels[j*120*4+i*24];
  
  
 
  /*for (int y = 0; y < 120; y ++) {
   for (int x = 0; x < 10; x ++) {
   stroke(sampled[y][x]);
   point(x, y);
   }
   
   }*/
 
   
  return sampled;
}
void flag() {
background(255,0,0);
fill(255);
for (int i=0; i<5; i++){
rect(48*i+24,0,24,240);
}
fill(0,0,255);
rect(120,0,120,120);
fill(255,255,255);
for(int i = 0; i<9; i++){
  for (int j=0;j<6;j++) {
  if((j+offset)%2==0) {
  rect(24*j+120,14*i,24,4);
 
  }
  if((j+offset)%2==1) {
  rect(24*j+120,14*i-7,24,4);
 
  }
  }
//rect(0,14*i-offset,120,4);
}
offset = (offset+1)%2;
}
