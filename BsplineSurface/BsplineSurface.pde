import controlP5.*;
import java.util.*;
import java.io.File;
import java.io.FilenameFilter;
import peasy.*;

ArrayList<LL> surfaces = new ArrayList<LL>();
String modes[] = {"move", "delete", "3D view"}; 
int currentMode = 0;
int currentCurve = -1;
ControlP5 cp5; // you always need the main class
int gridNum = 50;
int gridResolution = 5;
int ctrlOn=1, polyOn=1, bCurveOn=1;
float[] cameraAttr = {PI/4.0, width/30.0, width*2,  0,0,0, 0,1,0};
PeasyCam cam;

void setup(){
  size(1200, 800, P3D);
  background(255);
  stroke(100);
  noFill();
  
  File[] folders = {new File(sketchPath()+"/BsplineData/BsplineSurfaceData"),
                    new File(sketchPath()+"/BsplineData/BsplineSurfaceInterpoData"),
                    new File(sketchPath()+"/BsplineData/fitting_result")};
                    
  File[][] files= new File[folders.length][];
  int filesLen = 0;
  for (int i = 0; i < folders.length; i++) {
    files[i] = folders[i].listFiles(new FilenameFilter() {
      public boolean accept(File dir, String name) {
          return (name.toLowerCase().endsWith(".dat") ||  name.toLowerCase().endsWith(".txt"));
      }
    });
    filesLen += files[i].length;
  }
     
  String listOfFiles[] = new String[filesLen];
  
  int count=0;
  for (int i = 0; i < files.length; i++) {
    for (int j = 0; j < files[i].length; j++) {
      listOfFiles[count] = files[i][j].getParentFile().getName()+"/"+files[i][j].getName();
      count ++;
    }
  }
  

  /* add a ScrollableList, by default it behaves like a DropdownList */
  
  cp5 = new ControlP5(this);
  cp5.addScrollableList("dropdown")
     .setPosition(width-220, 20)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(listOfFiles)
     .setType(ScrollableList.LIST);
     
     
     
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(500);
}
void draw(){  
  background(255);
  // move origin to center
  if(currentMode != 2)
    camera();
  
  pushMatrix();
  if(currentMode != 2)
    translate(width/2, height/2);
  stroke(200,0,0);
  line(-width/2,0, width/2, 0);
  stroke(0,200,0);
  line(0,-height/2,0, height/2);
  stroke(0,0,200);
  line(0,0,-400,0, 0,30);
  stroke(100);
  displaySurface();
  //println();
  popMatrix();
  
  
  
}




void displaySurface(){
  if(surfaces.size() > 0){
    drawControlPoly();
    drawSurfacePoints();
  }
}

void drawSurfacePoints(){
  if(bCurveOn == 0) return;
  for (int i = 0 ; i < surfaces.size(); i++) {
    if(surfaces.get(i).size > 0){
      stroke(0);
      if(i == currentCurve) stroke(0,0,255);
      int stepCounts = gridNum*gridResolution;
      float maxU = surfaces.get(i).u[surfaces.get(i).u.length-surfaces.get(i).degreeU-1];
      float maxV = surfaces.get(i).v[surfaces.get(i).v.length-surfaces.get(i).degreeV-1];
      float minU = surfaces.get(i).u[surfaces.get(i).degreeU];
      float minV = surfaces.get(i).v[surfaces.get(i).degreeV];
      for (int j = 0 ; j < stepCounts; j++) {
        float tu1 = j/(stepCounts+0.0)*(maxU-minU)+minU;
        float tu2 = (j+1)/(stepCounts+0.0)*(maxU-minU)+minU;
        for (int k = 0 ; k < stepCounts; k++) {
          float tv1 = k/(stepCounts+0.0)*(maxV-minV)+minV;
          float tv2 = (k+1)/(stepCounts+0.0)*(maxV-minV)+minV;
          xyzPair thePoint1 = pointOnCurve(tu1,tv1, i);
          xyzPair thePoint2 = pointOnCurve(tu2,tv1, i);
          xyzPair thePoint3 = pointOnCurve(tu1,tv2, i);
          if(k % gridResolution == 0)
            drawLinePiece(thePoint1, thePoint2);
          if(j % gridResolution == 0)
            drawLinePiece(thePoint1, thePoint3);
          if(k == stepCounts -1){
            xyzPair thePoint4 = pointOnCurve(tu2,tv2, i);
            drawLinePiece(thePoint3, thePoint4);
          }
          if(j == stepCounts -1){
            xyzPair thePoint4 = pointOnCurve(tu2,tv2, i);
            drawLinePiece(thePoint2, thePoint4);
          }
            
        }
      }
      stroke(0);
    }
  }
}

void drawLinePiece(xyzPair a, xyzPair b){
  line(drawingScale(a.x, false), drawingScale(a.y, true), drawingScale(a.z,true),
           drawingScale(b.x, false), drawingScale(b.y, true), drawingScale(b.z, true));
}


void drawControlPoly(){
  if((currentMode == 0) || (currentMode == 1))
    displayActionNode();
  
  if(currentMode == 0)
    displayActionEdgeNode();
    
  //println(surfaces.size());
    
  for (int j = 0 ; j < surfaces.size(); j++) {
     Node temp = surfaces.get(j).head;
     Node tempRightEdgeTail = surfaces.get(j).head;
     stroke(200);
     if(j == currentCurve) stroke(0,255,0);
     //println("in curve "+j);
     int countOnCurve = 0;
     while(temp != null){
       //if(temp == surfaces.get(j).head) {fill(255,0,0);} else
       //if(temp == surfaces.get(j).tail) {fill(0,255,0);} else {noFill();}
       if(ctrlOn == 1){
         if(currentMode != 2)  
           ellipse(drawingScale(temp.x, false), drawingScale(temp.y, true),10, 10);
         else{
           pushMatrix();
           translate(drawingScale(temp.x, false), drawingScale(temp.y, true), drawingScale(temp.z, true));
           sphere(1);
           popMatrix();
         }
       }
       //println("poly: "+temp.x +" "+ temp.y);
       if((temp.next != null) && (polyOn == 1) && (countOnCurve%(surfaces.get(j).sizeU)!=surfaces.get(j).sizeU-1)){
         line(drawingScale(temp.x, false), drawingScale(temp.y, true),drawingScale(temp.z,true), 
         drawingScale(temp.next.x, false), drawingScale(temp.next.y,true),drawingScale(temp.next.z,true));
       }
       if(countOnCurve > surfaces.get(j).sizeU-1){
         line(drawingScale(temp.x, false), drawingScale(temp.y, true),drawingScale(temp.z,true), 
         drawingScale(tempRightEdgeTail.x, false), drawingScale(tempRightEdgeTail.y,true),drawingScale(tempRightEdgeTail.z,true));
         tempRightEdgeTail = tempRightEdgeTail.next;
       }
       temp = temp.next;
       countOnCurve++;
     }
     stroke(200);
  }
}

void displayActionNode(){
  if(surfaces.size()>0){
      Node theNode = getClosestNode();
      if(theNode != null){  
        fill(0,255,0);
        ellipse(drawingScale(theNode.x, false), drawingScale(theNode.y, true), 10, 10);
        noFill();
      }
    }
}

void displayActionEdgeNode(){
  if(surfaces.size()>0){
      Node theNode = getClosestEdgeNode();
      if(theNode != null){  
        fill(0,255,255);
        ellipse(drawingScale(localPos(mouseX, false), false), drawingScale(localPos(mouseY, true), true), 10, 10);
        noFill();
      }
    }
}
