import oscP5.*;
import netP5.*;
//import codeanticode.syphon.*;
import spout.*;

OscP5 oscCom;
PGraphics canvas;

// Configuration
String sketchName = "immersivelab_stills";
int oscReceivePort = 12000;
int trackingMode = 0; // 0: touch points, 1: clusters

// video mapping
int canvasW = 7680;
int canvasH = 1080;

ArrayList<String> images = new ArrayList<String>();
int imageIndex = 0;
PImage current = null;
// Processing Standard Functions
void settings() 
{
  size(1280, 180, P3D);
  PJOGL.profile=1;
}

void setup()
{
  frameRate(60);

  //load images
  String path = sketchPath();
  String imagePath = path + "/img";
  println(imagePath);

  println("Listing all filenames in a directory: ");
  String[] filenames = listFileNames(imagePath);
  printArray(filenames);

  for (int i=0; i<filenames.length; i++) {

    if ( filenames[i].equals(".DS_Store")) {
      continue;
    }
    String filePath = imagePath + "/" + filenames[i];
    println("adding  " + filePath);
    images.add(filePath);
  }
  
  loadPath(imageIndex);

  canvas = createGraphics(canvasW, canvasH, P3D);
  //setupCommunication();
  //setupTracking();
  //setupVideoMapping();

  noLoop();
}

void draw()
{ 

  println("draw");
  canvas.beginDraw();
  canvas.noStroke();
  canvas.background(255);

  println("getting index " + imageIndex + ", images.length " + images.size());



  canvas.image(current, 0, 0);


  canvas.endDraw();
  // mappingControl.update(canvas);
  image(canvas, 0, 0, width, height);
}

void keyTyped() {
  imageIndex = constrain(++imageIndex, 0, images.size()-1);
  if (imageIndex>=images.size()-1) {
    imageIndex = 0;
  }
  println("imageIndex: " + imageIndex + " / " + images.size());

  loadPath(imageIndex);
  redraw();
}

void loadPath(int index) {
  String path = images.get(imageIndex);
  println("loading "  + path);
  current = loadImage(path);
  println("done");
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

  if ( oscAddress.equals("/tuio/2Dcur") )
  {
    trackingControl.update(oscMessage);

    if (trackingControl.updated == true)
    {
      // updateContent(trackingControl.touchPoints);
    }
  }
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
