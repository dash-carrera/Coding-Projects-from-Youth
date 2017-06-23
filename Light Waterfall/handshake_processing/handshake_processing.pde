import processing.serial.*; //import the Serial library
 Serial myPort;  //the Serial port object
 byte val;
 
 int which_color = 0;
 
// since we're doing serial handshaking, 
// we need to check if we've heard from the microcontroller
boolean firstContact = false;
//String[] alph = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"};
//byte[] alph = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26};
//int alphIndex = 0;

void setup() {
  myPort = new Serial(this, Serial.list()[5], 115200);
  noLoop(); //no draw loop
}

void draw()
{
}


void serialEvent(Serial myPort) 
{

val = myPort.readBytes()[0];

println(val);


  if (firstContact == false) 
  {
    if (val == 5) {
      myPort.clear();
      firstContact = true;
      myPort.write(getRGB(color(127,200,300)));
      println("contact");
    }
  }
  else 
  { //if we've already established contact, keep getting and parsing data
  print(".");
  
  
  
  if (val == getRGB(color(127,200,300)))
   println("Success!"); 
    
    /*
    if (alphIndex <= 25)
      if (val == alph[alphIndex])
      {
      print(val);
      alphIndex++;
      if (alphIndex <= 25)
        myPort.write(alph[alphIndex]);
      }
      */
    
    
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


