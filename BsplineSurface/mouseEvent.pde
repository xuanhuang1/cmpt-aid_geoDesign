import java.io.File;

boolean addingNewCurve = false;

void dropdown(int n) {
  /* request the selected item based on index n */
  String name  = cp5.get(ScrollableList.class, "dropdown").getItem(n).get("name").toString();
  println(n, name);

  if(name.toLowerCase().endsWith(".dat") || name.toLowerCase().endsWith(".txt"))
    readFile("BsplineData/"+name);
  /* here an item is stored as a Map  with the following key-value pairs:
   * name, the given name of the item
   * text, the given text of the item by default the same as name
   * value, the given value of the item, can be changed by using .getItem(n).put("value", "abc"); a value here is of type Object therefore can be anything
   * color, the given color of the item, how to change, see below
   * view, a customizable view, is of type CDrawable 
   */
   //for(int i=0; i<surfaces.size(); i++)
   //  surfaces.get(i).printList();
}

void modeOption(int n) {
  String name  = cp5.get(ScrollableList.class, "modeOption").getItem(n).get("name").toString();
  for(int i=0; i<modes.length; i++){
    if(name == modes[i]){
       currentMode = i;
    }
  }
}

void mouseDragged() {
  if(mouseAroundMenu()== true) return;
  if(currentMode == 0){ // add
    if(surfaces.size()>0){
      Node theNode = getClosestNode();
      if(theNode != null){
        theNode.x = localPos(mouseX, false);
        theNode.y = localPos(mouseY, true);
      }
    }
    
  }
}

void mouseClicked() {
  if(mouseAroundMenu()== true) return;
}

void keyPressed() {
  if (key == 'r') {
    background(255);
    surfaces.clear();
  } 
  if (key == 'p') 
    polyOn = 1-polyOn;
  if (key == 'b') 
    bCurveOn = 1-bCurveOn;
  if (key == 'c') 
    ctrlOn = 1-ctrlOn;
  if (key == 'a'){
    ctrlOn = 1;
    bCurveOn = 1;
    polyOn = 1;
  }
  if (key == 'n'){
    ctrlOn = 0;
    bCurveOn = 0;
    polyOn = 0;
  }
  if (key == 'i'){
    if(currentMode == 2){
      cameraAttr[2] -= 10;
      if(cameraAttr[2] < 10) cameraAttr[0] = 10;
    }
  }
  if (key == 'o'){
    if(currentMode == 2)
      cameraAttr[2] += 10;
  }
  
  
  
  if(key == 'w'){
    writeFile();
  }
  
  if (key == CODED) {
    if (keyCode == SHIFT){
      if(currentMode == 2)
        currentMode = 0;
      else currentMode = 2;
      return;
    }
    if(currentMode != 2) return;
    if (keyCode == LEFT) {
      cameraAttr[0] = (cameraAttr[0] + PI/10.0)%TWO_PI;
    } else if (keyCode == RIGHT) {
      cameraAttr[0] = (cameraAttr[0] - PI/10.0+TWO_PI)%TWO_PI;
    } else if (keyCode == DOWN) {
      cameraAttr[1] += cameraAttr[2]/30.0;
      cameraAttr[4] += cameraAttr[2]/30.0;
    } else if (keyCode == UP) {
      cameraAttr[1] -= cameraAttr[2]/30.0;
      cameraAttr[4] -= cameraAttr[2]/30.0;
    }
  } else {
    //fillVal = 126;
  }
  
}

boolean mouseAroundMenu(){
  if(mouseX > width-230){
    if(mouseY < 320)
    return true;
  }
  return false;
}
