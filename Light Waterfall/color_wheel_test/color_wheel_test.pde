



int i =0 ;


void setup()
{  
}

void draw()
{
  background(saturated_color(i));
  println(i);
  i=i+10;
  if (i > 765)
    i = 0;
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
  return color(red,green,blue);
}
