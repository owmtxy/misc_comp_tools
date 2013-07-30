import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class slave_clock extends PApplet {

// network SLAVE CLOCK
// owmtxy, 2013

// a simple clock that listens for a master broadcast

// listens to socket "239.0.0.1" on port 8472 for the time
// the master clock can start/reset and broadcastst the time
// uses multicasting from sojamo's oscP5: http://www.sojamo.de/libraries/oscP5/




OscP5 oscP5;

PFont font;

String secs, mins, hours;
String time = "-:--:--"; // initialise the time

public void setup(){
  size(700,200);
  smooth();
  
  /* create a new instance of oscP5 using a multicast socket. */
  oscP5 = new OscP5(this,"239.0.0.1",8472);
  
  font = createFont("Helvetica",140);
  textFont(font);
  textAlign(CENTER,CENTER);
  fill(255);
}


public void draw(){
  background(0);
  
  text(time,width/2,height/2);
}

/* incoming osc message are forwarded to the oscEvent method. */
public void oscEvent(OscMessage theOscMessage) {
  time = theOscMessage.addrPattern(); // get time from the master_clock
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "slave_clock" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
