import java.io.File;

boolean addingNewCurve = false;

void dropdown(int n) {
  /* request the selected item based on index n */
  String name  = cp5.get(ScrollableList.class, "dropdown").getItem(n).get("name").toString();

  String folderName = split(name, '/')[0];
  println(n,"folder=", folderName, name);
  
  if(folderName.equals("BsplineSurfaceInterpoData"))
    readFileInterpo("BsplineData/"+name);
  else if(folderName.equals("BsplineSurfaceData"))
    readFile("BsplineData/"+name);
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
  if (key == TAB){
      if(currentMode == 2)
        currentMode = 0;
      else currentMode = 2;
  }
  
  
}

boolean mouseAroundMenu(){
  if(mouseX > width-230){
    if(mouseY < 320)
    return true;
  }
  return false;
}
