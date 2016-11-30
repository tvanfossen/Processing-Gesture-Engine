import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;

boolean firstContact=false; 
boolean firstTouch=false;

int touchX;
int touchY;
int initialX;
int initialY;
int curVector;
char vectorDir;
char dir;
int calcX;
int calcY;
String vectorString;
float vectorDrawX;
float vectorDrawY;
int i=0;


long initMillis=millis();
long prevMillis=initMillis;


void setup() 
{
  fullScreen();
  val=new String ();
  myPort = new Serial(this, "COM3", 9600);
  stroke (255);
  background(0);
 
}

void draw ()
{ 
  initMillis=millis();
 if (firstTouch==true&&initMillis>prevMillis+5000)
 {
   firstTouch=false;
   i=0;
   vectorString=null;
 }
 myPort.write ("DONULL");
  
}

void mouseDragged()
{
  
  if (firstTouch==false)
  {
    initialX=mouseX;
    initialY=mouseY;
    vectorDrawX=initialX;
    vectorDrawY=initialY;
    firstTouch=true;
    prevMillis=millis();
  }
  
  touchX=mouseX;
  touchY=mouseY;
  delay(10);
  
  println(touchX);
  println(touchY);
  
  vectorDrawX=vectorDrawX+calcX;
  vectorDrawY=vectorDrawY+calcY;
  
  line(vectorDrawX, vectorDrawY, touchX, touchY);
  
  curVector=CalculateVector();
  vectorDir=CalculateDirectional();
  
  println (curVector);
  println (vectorDir);
  
  append (vectorString, vectorDir);
  println (vectorString);
  
  if (vectorString=="ABCD"||vectorString=="BCDE"||vectorString=="CDEF"||vectorString=="DEFG"||
      vectorString=="EFGH"||vectorString=="FGHA"||vectorString=="GHAB"||vectorString=="HABC")
  {
    myPort.write ("BRR");
    myPort.write (curVector);
    myPort.write ('\n');
    vectorString=null;
  }
  else if (vectorString=="AHGF"||vectorString=="HGFE"||vectorString=="GFED"||vectorString=="FEDC"||
           vectorString=="EDCB"||vectorString=="DCBA"||vectorString=="CBAH"||vectorString=="BAHG")
  {
    myPort.write ("BRF");
    myPort.write (curVector);
    myPort.write ('\n');
    vectorString=null;
  }
  else
  {
    if (vectorDir!='B'||vectorDir!='D'||vectorDir!='F'||vectorDir!='H')
    {
      myPort.write (vectorDir);
      myPort.write (curVector);
      myPort.write ('\n');
      vectorString=null;
    }
  }
  delay(23);
  
  
  
}

int CalculateVector()
{
  
  int mag;
  
  calcX=initialX-touchX;
  calcY=initialY-touchY;
  
  mag=int(sqrt((sq(calcX)+ sq(calcY))));
  
  
  return mag;
}

char CalculateDirectional()
{
  
  
  calcX=initialX-touchX;
  calcY=initialY-touchY;
  
  if (calcX>20)
  {
    dir='A';
  }
  
  else if (calcX<-20)
  {
    dir='E';
  }
  
  if (calcY>20)
  {
    dir='C';
  }
  
  else if (calcY<-20)
  {
   dir='G';

  }
  if (calcX>20&&calcY>20)
  {
    dir='B';
  }
  else if (calcX<-20&&calcY>20)
  {
    dir='D';
  }
  else if (calcX<-20&&calcY<-20)
  {
    dir='F';
  }
  else if (calcX>20&&calcY<-20)
  {
    dir='H';
  }
  
  i=i+1;
  return dir;
}