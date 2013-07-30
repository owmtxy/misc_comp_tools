// network SLAVE CLOCK
// owmtxy, 2013

// a simple clock that listens for a master broadcast

// listens to socket "239.0.0.1" on port 8472 for the time
// the master clock can start/reset and broadcastst the time
// uses multicasting from sojamo's oscP5: http://www.sojamo.de/libraries/oscP5/

import oscP5.*;
import netP5.*;

OscP5 oscP5;

PFont font;

String secs, mins, hours;
String time = "-:--:--"; // initialise the time

void setup(){
  size(700,200);
  smooth();
  
  /* create a new instance of oscP5 using a multicast socket. */
  oscP5 = new OscP5(this,"239.0.0.1",8472);
  
  font = createFont("Helvetica",140);
  textFont(font);
  textAlign(CENTER,CENTER);
  fill(255);
}


void draw(){
  background(0);
  
  text(time,width/2,height/2);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  time = theOscMessage.addrPattern(); // get time from the master_clock
}

