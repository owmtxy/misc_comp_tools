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

public class master_clock extends PApplet {

// network MASTER CLOCK
// owmtxy, 2013

// a simple stopwatch that sends over a network to listening clock

// 'slave clocks' listen to socket "239.0.0.1" on port 8472 for the time
// the master clock can start/reset and broadcastst the time
// uses multicasting from sojamo's oscP5: http://www.sojamo.de/libraries/oscP5/

// hit a key to start / stop(reset) the clock




OscP5 oscP5;

PFont font;

int startingTime;

int sec, min, hour;

String secs, mins, hours;
String time;

boolean count = false;

public void setup(){
  size(700,200);
  smooth();
  
  oscP5 = new OscP5(this,"239.0.0.1",8472);
  
  font = createFont("Helvetica",140);
  textFont(font);
  textAlign(CENTER,CENTER);
  fill(255,0,0);
  
  startingTime = millis();
}


public void draw(){
  background(0);
  
   if(count){ //if supposed to be counting
    fill(0,255,0);
     sec = (millis() - startingTime) / 1000;
     min = sec / 60;
     hour = min / 60;
   }
   
   sec -= min * 60;
   min -= hour * 60;
 
   secs = nf(sec,2);
   mins = nf(min,2);
   hours = nf(hour,2);
   time = (hours+":"+mins+":"+secs);
    
   text(time,width/2,height/2);
    
   OscMessage oscTime = new OscMessage(time);
   oscP5.send(oscTime); // send time to multicast group
}

public void keyPressed(){
  
    if(count){ // if its counting: stop
      count = false;
      startingTime = millis();
      fill(255,0,0);
    } else { // if it isn't counting: reset and start counting
      count = true;
      startingTime = millis();
    }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "master_clock" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
