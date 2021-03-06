import controlP5.*;
import java.util.*;
import java.io.File;
import java.io.FilenameFilter;

ArrayList<LL> curves = new ArrayList<LL>();
LL tempNewCurve;
int newCurveType = 0;
String modes[] = {"move", "delete", "3D view"}; 
int currentMode = 0;
int currentCurve = -1;
ControlP5 cp5; // you always need the main class
int stepsCount = 200;
int ctrlOn=1, polyOn=1, bCurveOn=1;
float[] cameraAttr = {PI/4.0, width/30.0, width*2,  0,0,0, 0,1,0};

void setup(){
  size(1200, 800, P3D);
  background(255);
  stroke(100);
  noFill();
  
  File[] folders = {new File(sketchPath()+"/BsplineData/Bspline2DData"),
                    new File(sketchPath()+"/BsplineData/Bspline3DdispData"),
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
  
  tempNewCurve = null;
  /* add a ScrollableList, by default it behaves like a DropdownList */
  
  cp5 = new ControlP5(this);
  cp5.addScrollableList("dropdown")
     .setPosition(width-220, 20)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(listOfFiles)
     .setType(ScrollableList.LIST);
     
 cp5.addScrollableList("modeOption")
     .setPosition(width-220, 160)
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(modes)
     .setType(ScrollableList.LIST);
     
     
 /*float l1 = getBasis(0.3, 0, 3, new float[] {0,0,0,0,1,1,1,1});
 float l2 = getBasis(0.3, 1, 3, new float[] {0,0,0,0,1,1,1,1});
 float l3 = getBasis(0.3, 2, 3, new float[] {0,0,0,0,1,1,1,1});
 float l4 = getBasis(0.3, 3, 3, new float[] {0,0,0,0,1,1,1,1});
 println(l1,l2,l3,l4);*/
}
void draw(){  
  background(255);
  // move origin to center
  if(currentMode == 2){
  camera(cos(cameraAttr[0])*cameraAttr[2],cameraAttr[1], sin(cameraAttr[0])*cameraAttr[2], 
      cameraAttr[3],cameraAttr[4],cameraAttr[5],
      cameraAttr[6],cameraAttr[7],cameraAttr[8]);
  }
  else camera();
  pushMatrix();
  if(currentMode != 2)
    translate(width/2, height/2);
  //rotateX(PI/8);
  //rotateY(PI/8);
  //box(100);
  stroke(200,0,0);
  line(-width/2,0, width/2, 0);
  stroke(0,200,0);
  line(0,-height/2,0, height/2);
  stroke(0,0,200);
  line(0,0,-400,0, 0,30);
  stroke(100);
  displayCurve();
  //println();
  popMatrix();
  
  
  
}




void displayCurve(){
  if(curves.size() > 0){
    drawControlPoly();
    drawCurvePoints();
  }
  if(tempNewCurve != null){
    drawTempNewCurve();
  }
}

void drawCurvePoints(){
  if(bCurveOn == 0) return;
  for (int i = 0 ; i < curves.size(); i++) {
    if(curves.get(i).size > 0){
      stroke(0);
      if(i == currentCurve) stroke(0,0,255);
      for (int j = 0 ; j < stepsCount; j++) {
        float t1 = j/(stepsCount+0.0);
        float t2 = (j+1)/(stepsCount+0.0);
        xyzPair thePoint1 = pointOnCurve(t1, i);
        xyzPair thePoint2 = pointOnCurve(t2, i);
        line(drawingScale(thePoint1.x, false), drawingScale(thePoint1.y, true), drawingScale(thePoint1.z,true),
         drawingScale(thePoint2.x, false), drawingScale(thePoint2.y, true), drawingScale(thePoint2.z, true));
      }
      stroke(0);
    }
  }
}

void drawTempNewCurve(){
  Node temp = tempNewCurve.head;
  stroke(200);
  while(temp != null){
    if(ctrlOn == 1)
       ellipse(drawingScale(temp.x, false), drawingScale(temp.y, true), 10, 10);
    if((temp.next != null) && (polyOn == 1)){
       line(drawingScale(temp.x, false), drawingScale(temp.y, true), 
       drawingScale(temp.next.x, false), drawingScale(temp.next.y, true));
    }
    temp = temp.next;
  }
  stroke(200);
  if(tempNewCurve.degree < 1) return;
  if(tempNewCurve.size < tempNewCurve.degree+1) return;
  
  stroke(0);
  for (int j = 0 ; j < stepsCount; j++) {
    float t1 = j/(stepsCount+0.0);
    float t2 = (j+1)/(stepsCount+0.0);
    xyzPair thePoint1 = ctAlgo(t1, tempNewCurve);
    xyzPair thePoint2 = ctAlgo(t2, tempNewCurve);
    line(drawingScale(thePoint1.x, false), drawingScale(thePoint1.y, true),
         drawingScale(thePoint2.x, false), drawingScale(thePoint2.y, true));
  }
  stroke(0);
}

void drawControlPoly(){
  if((currentMode == 0) || (currentMode == 1))
    displayActionNode();
  
  if(currentMode == 0)
    displayActionEdgeNode();
    
  //println(curves.size());
    
  for (int j = 0 ; j < curves.size(); j++) {
     Node temp = curves.get(j).head;
     stroke(200);
     if(j == currentCurve) stroke(0,255,0);
     //println("in curve "+j);
     while(temp != null){
       //if(temp == curves.get(j).head) {fill(255,0,0);} else
       //if(temp == curves.get(j).tail) {fill(0,255,0);} else {noFill();}
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
       if((temp.next != null) && (polyOn == 1)){
         line(drawingScale(temp.x, false), drawingScale(temp.y, true),drawingScale(temp.z,true), 
         drawingScale(temp.next.x, false), drawingScale(temp.next.y,true),drawingScale(temp.next.z,true));
       }
       temp = temp.next;
     }
     stroke(200);
  }
}

void displayActionNode(){
  if(curves.size()>0){
      Node theNode = getClosestNode();
      if(theNode != null){  
        fill(0,255,0);
        ellipse(drawingScale(theNode.x, false), drawingScale(theNode.y, true), 10, 10);
        noFill();
      }
    }
}

void displayActionEdgeNode(){
  if(curves.size()>0){
      Node theNode = getClosestEdgeNode();
      if(theNode != null){  
        fill(0,255,255);
        ellipse(drawingScale(localPos(mouseX, false), false), drawingScale(localPos(mouseY, true), true), 10, 10);
        noFill();
      }
    }
}
