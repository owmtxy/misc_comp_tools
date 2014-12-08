/////////////////
// string harmonics / multiphonics map
/////////////////
//  this map is useful for calculating and location harmonic partials
//  for n-partials on a string of any tuning.
//  all pitches are given in 12-TET, with deviation in cents.
//////////
// processing, v.3.0a4+
// oliver thurley, 2014
// questions: ollie[dot]thurley[at]gmail

// based on the work by cellomap.com
// http://www.cellomap.com/index/the-string/multiphonics-and-other-multiple-sounds.html


/// BEFORE YOU BEGIN...
// set number of partials to calculate
int partialLength = 15; 

// set fundamental tuning of string in Hz
float root = 41.203; // i.e. 41.203 = E1
//   E1      A1      D2      G2
//  41.203  55.00   73.416  97.999
/////////////////////////////////

PFont font;
int stng = 1100;
int off = stng/12;
int ptl = 3;
int branch = 320;
float vScale = 1.3;

String[] noteName = {"C", "C#", "D", "D#", "E", "F","F#", "G", "G#", "A", "Bb", "B"};

void setup(){
  size(1300,700);
    
  background(255);
  stroke(0,127);
  strokeWeight(0.25);
  smooth();
  font = createFont("Courier", 10);
  textFont(font);
  
  textAlign(CENTER, CENTER);
  
  fill(0);
  // title
  text("harmonic nodes: "+pitchName(root)+" string ["+str(root)+"Hz]", width/2, 20);
  fill(0,127);
  pushStyle();
    textSize(8);
    text("~thurley", width-100, 20);
  popStyle();

  pushMatrix();
  translate(off,height/2);
  line(0,0,stng,0);
  text("nut", -25, 0);
  text("bridge", stng+25, 0);
  
  fill(0);
  text(pitchName(root), 30, -30);
  text(str(root)+"Hz", 30, -15);
  fill(0,127);

  // partials
  for(int i=2; i<=partialLength; i++){
    branch(i);
  }
  popMatrix();
  
  frets();
}



void branch(int part){

  ptl = part;
  float freq = root*part;
  
  // every partial
  for(int i=1; i<part; i++){
    // draw partial branch on string
        line((stng/ptl)*i, 0,(stng/ptl)*i, branch+(15*-ptl)*vScale);
        text(i+"/"+ptl, (stng/ptl)*i, branch+((15*-ptl)*vScale)+10); // show ratio/partial

        // horizontal line // bezier curves
        float x1, y1, x2, y2, x3, y3, x4, y4;
        // start-point
        x1 = (stng/ptl)*i;
        y1 = -(15*ptl)*vScale;
        // end-point
        x4 = (stng/ptl)*(i+1);
        y4 = y1;
        //mid 1
        x2 = x1 + ((x4 - x1)/2);
        y2 = branch+(15*-ptl)*vScale;
        // mid 2
        x3 = x2;//x1 + ((x4 - x1)/2);
        y3 = y2;//(height/3)- (i*5);
    
        pushStyle();
        stroke(0,75);
        noFill();
        strokeWeight(0.25);
        if(i < part-1){
          bezier(x1,0, x2,-y2,x3,-y3,x4,0);
        }
        popStyle();
        
        pushStyle();
          fill(255,0,0,127);
          noStroke();
          float mass = (10*ptl)*0.05;
          ellipse((stng/ptl)*i,0,mass, mass);
        popStyle();
  }
  
  // first instance (draw above)
  pushStyle();
    stroke(255,0,0,127);
    strokeWeight(1);
    line((stng/ptl), -(15*ptl)*vScale, (stng/ptl), 0);
    fill(255,0,0,75);
    noStroke();
    ellipse((stng/ptl), 0, 10, 10);
    fill(0,127);
    
    // pitch info above
    float pVert = -((15*ptl)*vScale); 
    textAlign(LEFT,BOTTOM);
    text("1/"+str(ptl) + " : "+pitchName(freq), (stng/ptl), pVert); // write pitch-class    
    
    if (ptl == partialLength){
      String partext = "partial : ";
      text(partext, (stng/ptl)-textWidth(partext), pVert);
    }
  popStyle();
}

// calculate and return cent deviation from frequency
String cents(float frq){
    float microPitch = (1200 * log(frq/440) / log(2));
    println(microPitch, 1);
    microPitch = round(microPitch % 1200) % 100;
    println(microPitch, 2);

    int micro;
    
    if(microPitch >= 50.){
        micro = round(microPitch-100);
    } else if (microPitch < -50.){
        micro = round(100+microPitch);
    } else{
        micro = round(microPitch);
    }
    /////
    if(micro == 0.){
        return "";
    } else if (micro > 0){
        return " [+"+str(micro)+"c]";
    } else {
        return " ["+str(micro)+"c]";
    }
}

// translate frequency (Hz) into note name and octave
String pitchName(float frq){

  float pitch = 69+(12 * (log(frq/440.) / log(2.))); // calc relative to middle c4
  String note = noteName[round(pitch) % 12];//[int(round(pitch)) % 12]; // get name
  int oct = (round(pitch) / 12) -1; //get octave, offset from C(+4)

  return note+str(oct)+cents(frq);
}
  
  // draw the 'normal' note positions under string, useful for orienting nodes
void frets(){
  translate(off,(height/2)+10);
  float sLen = stng/2;
  
  for(int f=1; f<=43; f++){
    float tmp = pow(2,f/12.);
    float pfreq = tmp * root;
    println(tmp,3);
    
    float fret = (sLen-(stng / tmp))+sLen;
    
    stroke(0,0,255,127);
    line(fret,0,fret,-10);
    stroke(0,127);
    
    fill(0,0,255,127);
    ellipse(fret,0,5,5);
    fill(0,127);
    
    if(f==1){
      text("position:", fret-40, 10);
    }
    
    if(f<=24){
      text(pitchName(pfreq), fret, 10);
    } else if((f%2==0) && (f>24) && (f<36)) {
      text(pitchName(pfreq), fret, 10); // offset odd frets to avoid overlap
    } else if((f%3==0) && (f>=36)) {
      text(pitchName(pfreq), fret, 10); // offset odd frets to avoid overlap
    }
  }
}
