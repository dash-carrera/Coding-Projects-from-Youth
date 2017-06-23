
byte val = 1; //Data received from the serial port
byte altered_val = 1;

void setup()
{
  Serial.begin(115200);
  establishContact();
}

void loop()
{
  if (Serial.available() > 0)
  {
    val = Serial.read(); //read it and store it
    altered_val = val + 128;
  }
  
  if (altered_val == 127)
  {
        analogWrite(7,255); //red
  }
  
    
  Serial.write(val);
    
  
}


void establishContact()
{
  while (Serial.available() <= 0)
  {
    Serial.write(5); //send ping to establish connection
     //analogWrite(6,255); //blue
    delay(300);
  }
}

