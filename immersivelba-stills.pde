import oscP5.*;
import netP5.*;
//import codeanticode.syphon.*;
import spout.*;

OscP5 oscCom;
PGraphics canvas;

// Configuration
String sketchName = "IL_basic_example";
int oscReceivePort = 12000;
int trackingMode = 0; // 0: touch points, 1: clusters
//String audioFilePath = "/Users/dbisig/Projects/ImmersiveLab/Agora_2017-2019/teaching/Mapping_2019/Software/ExampleCode/Processing/IL_basic_complete_audio/audio";
String audioFilePath = "C:/Users/il/Desktop/ImmersiveLab/Mapping_2019/Example_Code/Processing/IL_basic_example/audio";

// Processing Standard Functions
void settings() 
{
  size(1280,180,P3D);
  PJOGL.profile=1;
}

void setup()
{
  frameRate(60);

  setupCommunication();
  setupTracking();
  setupVideoMapping();
  setupAudio();
  
  setupContent();
}

void draw()
{ 
  canvas.beginDraw();
  canvas.noStroke();
  canvas.background(255);
  
  udpateContent();
  drawContent();

  canvas.endDraw();
  mappingControl.update(canvas);
  image(canvas,0,0, width, height);
}

// OSC Communication
void 
setupCommunication()
{
  oscCom = new OscP5(this, oscReceivePort);
}

void oscEvent(OscMessage oscMessage) 
{ 
  String oscAddress = oscMessage.addrPattern();
 
  if( oscAddress.equals("/tuio/2Dcur") )
  {
     trackingControl.update(oscMessage);
     
     if(trackingControl.updated == true)
     {
       updateContent(trackingControl.touchPoints);
     }
   }
}