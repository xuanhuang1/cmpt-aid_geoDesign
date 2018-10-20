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
  if(currentMode == 0){ // add
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
    if(addingNewCurve){
      if(tempNewCurve.degree <1) return;
      //println("size",tempNewCurve.size);
      if(tempNewCurve.size+1 < tempNewCurve.degree+1 +1) 
        tempNewCurve.add(localPos(mouseX, false), localPos(mouseY, true),0); 
      if((tempNewCurve.size == tempNewCurve.degree+1) && (tempNewCurve.t == null)){
        tempNewCurve.t = new float[tempNewCurve.degree*2+2];
        //println(tempNewCurve.t, tempNewCurve.degree, tempNewCurve.size);
        fillInModifiedOpenKnotV(tempNewCurve.t, tempNewCurve.degree, tempNewCurve.size);
        return;
      }
      if(tempNewCurve.size > tempNewCurve.degree){
        tempNewCurve.insert(localPos(mouseX, false), localPos(mouseY, true),0);
        //tempNewCurve.printList(); tempNewCurve.printT();
      }
    }else if(curves.size()>0){
      Node theNode = getClosestEdgeNode();
      if(theNode != null) 
        curves.get(currentCurve).insertBefore(theNode, localPos(mouseX, false), localPos(mouseY, true),0);
      else{ // check if add to head/tail
        Node closestNode = curves.get(0).head;
        float endNodeDistClosets = getDist(closestNode.x, closestNode.y, localPos(mouseX, false), localPos(mouseY, true));
        for (int i=0;i<curves.size();i++){
          float distTemp = getDist(curves.get(i).head.x, curves.get(i).head.y, localPos(mouseX, false), localPos(mouseY, true));
          if(!(distTemp > endNodeDistClosets)) {endNodeDistClosets = distTemp; currentCurve = i; closestNode = curves.get(i).head;}
          distTemp = getDist(curves.get(i).tail.x, curves.get(i).tail.y, localPos(mouseX, false), localPos(mouseY, true));
          if(!(distTemp > endNodeDistClosets)) {endNodeDistClosets = distTemp; currentCurve = i; closestNode = curves.get(i).tail;}
        }
        println("add to one end of curve:", currentCurve);
        if((endNodeDistClosets < nodeDistTole) && (currentCurve > -1)){ // add at head/tail
          if(closestNode.next == null) curves.get(currentCurve).insert(localPos(mouseX, false), localPos(mouseY, true),0);
          if(closestNode.prev == null) curves.get(currentCurve).insertBefore(closestNode, localPos(mouseX, false), localPos(mouseY, true),0);
        }
        
        else if(!(endNodeDistClosets < nodeDistTole)){ // too far to move/append existing, add new curve
          addingNewCurve = true;
          tempNewCurve = new LL();
          println("add new curve d="+tempNewCurve.degree);
        }
      }
    }else{// there is no curve, create new
      addingNewCurve = true;
      tempNewCurve = new LL();
      println("add new curve d="+tempNewCurve.degree);
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
  if (key == 'i'){
    cameraAttr[2] -= 10;
    if(cameraAttr[2] < 10) cameraAttr[0] = 10;
  }
  if (key == 'o'){
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
  
  if((key == ENTER) || (key == RETURN)){ // end adding point
    if(addingNewCurve == false) return;
    if(tempNewCurve.size < tempNewCurve.degree+1)
      println(tempNewCurve.degree+1, "points needed for degree", tempNewCurve.degree);
    else{
      curves.add(tempNewCurve);
      tempNewCurve = null;
      addingNewCurve = false;
    }
  }
  
  if(key == BACKSPACE){
    println("delete temp curve");
    tempNewCurve = null;
    addingNewCurve = false;
  }
  
  
  if (keyPressed == true){
    if(addingNewCurve){
      if((tempNewCurve.degree < 0)&& (Character.digit(key, 10)>0)){
        tempNewCurve.degree = Character.digit(key, 10);
        println(" add curve d",tempNewCurve.degree);
      }
    }
  }
}

boolean mouseAroundMenu(){
  if(mouseX > width-230){
    if(mouseY < 320)
    return true;
  }
  return false;
}
