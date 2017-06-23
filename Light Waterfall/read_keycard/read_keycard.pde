String lastInput = new String();
String currentInput = new String();
void setup()
{
}
void draw()
{
}
void keyPressed()
{
  boolean flag = true;
  if(key == ENTER || key == ';')
  {
    lastInput = currentInput = currentInput;
    currentInput = "";
    String a = "600955";
    if(lastInput.length() > 5 && flag){
      if(lastInput.substring(0, 6).equals(a) == true){
        println(lastInput.substring(6,16));
      }
    }
  }
  /*
  else if(key == BACKSPACE && currentInput.length() > 0)
  {
    currentInput = currentInput.substring(0, currentInput.length() - 1);
  }*/
  
  else
  {
    if(key>='0' && key <='9'){
      currentInput = currentInput + key;
    }
    else if(currentInput.length() > 1){
      flag = false;
    }
  }
}
