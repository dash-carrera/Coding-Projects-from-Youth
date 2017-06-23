float max_distance;
color blackout = 255; 
int totalPts = 10;
float steps = totalPts + 1;
int demo = 2;
int demos = 4;
float[] xpos = new float[150];
float[] ypos = new float[150];
float[] yspeed = new float[150];
   
int x;
int y;
int h;
int w;
color chrome;
color chrome2;


void setup() {
  size(240, 240);
   max_distance = dist(0, 0, width, height);
   noStroke();
   frameRate(30);
   
  for (int i=0; i<xpos.length; i++) {
    xpos[i] = random(width);
    ypos[i] = -30;
    yspeed[i] = random(1., 3.);
  }


}

void draw() {
  pushMatrix();
  noStroke();

  if (demo == 0) {
  circles();
  } else if (demo == 1) {
    noise();
  } else if (demo == 2) {
  rain();
  } else if (demo == 3) {
    prettycolors();
  } 
  
  
 


  overlay();
  }

void overlay() {
popMatrix();
strokeWeight(1);
  
    for (int i = 0; i<11; i++) {
      stroke(#aaaaaa);
  blendMode(DIFFERENCE);

  line((24*i+10),0,(24*i+10),(240));
  line((24*i+13),0,(24*i+13),(240));
  noStroke();
  fill(#000000,blackout);
  blendMode(BLEND);
  rect((24*(i)-11),0,22,height);
  fill(255,255,255);
  }
  blendMode(BLEND);
  noStroke();

}
void keyPressed() {
 
if (key == 'b') {
  
  if (blackout == 255) {
    blackout = 0;
  } else {blackout=255;
}
}
if ( key == 't') {
  background(0);
  demo = (demo + 1)%demos;
}
}
void noise() {
background(0);
  float rand = 0;
  for  (int i = 11; i < 240; i+=24) {
    stroke(#ffffff);
    rect( i, (height/2) + random(-rand, rand) , 1 , 2);
    rand += random(-20, 20);
  }
}

void circles() {
 background(0);


  for(int i = 12; i <= width; i += 24) {
    for(int j = 12; j <= height; j += 24) {
      float size = dist(mouseX, mouseY, i, j);
      size = size/max_distance * 66;
      ellipse(i, j, size, size);
    }
  }
}

void rain() {
  fill(0, 5);
  rect(0, 0, 240, 240);
 
  for (int i=0; i<ypos.length; i++) {
    ypos[i] += yspeed[i];
     
    strokeWeight(random(1., 2.));
    float r = map(xpos[i], 0, 240, 0, 255);
    float g = map(ypos[i], 0, 240, 0, 255);
    float b = random(50, 150);
    stroke(r, g, b);
    line(xpos[i]+random(0.1, 2.5), ypos[i], xpos[i]+random(0.1, 2.5), ypos[i]-20);
    if (ypos[i] > height+20/2) {
      ypos[i] = -30;
    }
  }

}

void prettycolors() {
    // TODO: assign each variable a random value here. For example:
  //    x = int(random(0,100));
  x = round( random(5,240) );
  y = round( random(30,240) );
  h = round( random(100,240) );
  w = round( random(40,240) );
  chrome = color(x*4,255/x+y,y/2,10);
  chrome2 = color(x*2,255/y,255, 15);
  // Do this for each variable.
  // see http://processing.org/reference/random_.html for more details
  
  // TODO: paste all your draw code here (ie, the code that uses those variables)
fill(chrome);
noStroke();
rect(x,y,h,w);
ellipse(x+330,y+30,w,w);
beginShape();
vertex(x+310, y*2);
vertex(x+600, y+340);
vertex(x+310, y+340);
vertex(x+400, y*5);
endShape();
 
fill(chrome2);
translate(width/4, height/4);
rotate(PI/x*y/2);
rect(x, y, x*0.8, y*3);
  
  // TODO: If you are using background(), remove it for now.
  
  // TODO: Add transparency to all your colors. For example, if you have:
  //   fill(255,0,0);
  // in your code, replace it with:
  //   fill(255,0,0,10);
  
  // TODO: run your sketch and see what happens!
    
  // The idea here is that if you do the above, you should hopefully
  // get something that looks like the Idris Khan image compositions.
  // Do you?

}
