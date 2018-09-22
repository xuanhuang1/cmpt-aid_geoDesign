import controlP5.*;
import java.util.*;
import java.io.File;
import java.io.FilenameFilter;

ArrayList<LL> curves = new ArrayList<LL>();
String modes[] = {"move", "add", "delete", "new"}; 
int currentMode = 0;
int currentCurve = -1;
ControlP5 cp5; // you always need the main class
int stepsCount = 100;
int ctrlOn=1, polyOn=1, bCurveOn=1;

void setup(){
  size(1200, 800);
  background(255);
  stroke(100);
  noFill();
  
  File folder = new File(sketchPath()+"/bezier_data");
  File folder2 = new File(sketchPath()+"/approx_data");
  File[] files = folder.listFiles(new FilenameFilter() {
    public boolean accept(File dir, String name) {
        return (name.toLowerCase().endsWith(".dat"));
    }
  });
  File[] files2 = folder2.listFiles(new FilenameFilter() {
    public boolean accept(File dir, String name) {
        return (name.toLowerCase().endsWith(".crv"));
    }
  });
  String listOfFiles[] = new String[files.length+files2.length];
  
  for (int i = 0; i < files.length; i++) 
    listOfFiles[i] = files[i].getName();
  for (int i = 0; i < files2.length; i++) 
    listOfFiles[i+files.length] = files2[i].getName();
  
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
}
void draw(){  
  background(255);
  // move origin to center
  pushMatrix();
  translate(width/2, height/2);
  
  stroke(0);
  line(-width/2,0, width/2, 0);
  line(0,-height/2,0, height/2);
  stroke(100);
  
  displayCurve();
  popMatrix();
  
  //line(width/2-10, height/2+10, width/2+10, height/2+10);
  
  
}


void displayCurve(){
  if(curves.size() > 0){
    drawControlPoly();
    drawCurvePoints();
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
        xyPair thePoint1 = pointOnCurve(t1, i);
        xyPair thePoint2 = pointOnCurve(t2, i);
        line(drawingScale(thePoint1.x, false), drawingScale(thePoint1.y, true), 
         drawingScale(thePoint2.x, false), drawingScale(thePoint2.y, true));
      }
      stroke(0);
    }
  }
}

void drawControlPoly(){
  if((currentMode == 0) || (currentMode == 2))
    displayActionNode();
  
  if(currentMode == 1)
    displayActionEdgeNode();
    
  for (int j = 0 ; j < curves.size(); j++) {
     Node temp = curves.get(j).head;
     stroke(200);
     if(j == currentCurve) stroke(0,255,0);
     while(temp != null){
       //if(temp == curves.get(j).head) {fill(255,0,0);} else
       //if(temp == curves.get(j).tail) {fill(0,255,0);} else {noFill();}
       if(ctrlOn == 1)
         ellipse(drawingScale(temp.x, false), drawingScale(temp.y, true), 10, 10);
       //println(temp.x +" "+ temp.y);
       if((temp.next != null) && (polyOn == 1)){
         line(drawingScale(temp.x, false), drawingScale(temp.y, true), 
         drawingScale(temp.next.x, false), drawingScale(temp.next.y, true));
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
