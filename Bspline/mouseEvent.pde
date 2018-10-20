import java.io.File;

void dropdown(int n) {
  /* request the selected item based on index n */
  String name  = cp5.get(ScrollableList.class, "dropdown").getItem(n).get("name").toString();
  //println(n, name);

  if(name.toLowerCase().endsWith(".dat") || name.toLowerCase().endsWith(".txt"))
    readFile("BsplineData/"+name);
  /* here an item is stored as a Map  with the following key-value pairs:
   * name, the given name of the item
   * text, the given text of the item by default the same as name
   * value, the given value of the item, can be changed by using .getItem(n).put("value", "abc"); a value here is of type Object therefore can be anything
   * color, the given color of the item, how to change, see below
   * view, a customizable view, is of type CDrawable 
   */
   //for(int i=0; i<curves.size(); i++)
   //  curves.get(i).printList();
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
  if(currentMode == 0){
    if(curves.size()>0){
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
  // delete
  if(currentMode == 1){ //delete
    if(curves.size()>0){
      Node theNode = getClosestNode();
      if(theNode != null)
        curves.get(currentCurve).delete(theNode);
    }  
  }
  else if(currentMode == 0){ //add 
    if(curves.size()>0){
      Node theNode = getClosestEdgeNode();
      if(theNode != null)
        curves.get(currentCurve).insertBefore(theNode, localPos(mouseX, false), localPos(mouseY, true),0);
    }
  }
  /*else if(currentMode == 2){ //new
    curves.add(new LL());
    curves.get(curves.size()-1).add(localPos(mouseX-5, false), localPos(mouseY, true),0);
    curves.get(curves.size()-1).add(localPos(mouseX+5, false), localPos(mouseY, true),0);
  }*/
}

void keyPressed() {
  if (key == 'r') {
    background(255);
    curves.clear();
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
  
  if(key == 'w'){
    writeFile();
  }
}

boolean mouseAroundMenu(){
  if(mouseX > width-200){
    if(mouseY < 300)
    return true;
  }
  return false;
}
