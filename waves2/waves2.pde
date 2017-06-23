float y = 100;
float time = PI;
int index = 0;
int subindex = 0;
String[] data;
int last_tide; //the tide you just came from
int tide; //the tide you are trying to reach in the cycle

void setup() {
  size(1000, 1000);
  stroke(255); 
  frameRate(12);
  data = loadStrings("tideswellingtonedit.txt");
  tide = parse();
  y = float(last_tide);
}

int parse()
{  
  if (subindex > 3)
  {
    index++;
    subindex = 0;
  }
  if (index >= data.length)
    index = 0;
  String[] pieces = split(data[index], '\t');
  int number = int(pieces[subindex]);
  subindex++;
  return number;
}


void draw()
{ 
  background(0);
  time = time + QUARTER_PI/16;
  //print(time +", ");
  if (time >= PI)
  {
    time = 0;
    last_tide = tide;
    tide = parse();
  }
  y = (sin(time-HALF_PI)+1)*(tide-last_tide)/2 + last_tide;
  y *= 10;
  rect(0, 0, width, y);
  print("(" + tide + ", " + round(y)+") ");
}
