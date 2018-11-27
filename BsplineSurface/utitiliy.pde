import java.util.*;
float edgeDistTole = 0.2, nodeDistTole = 0.5;

Node getClosestNode(){
  if(surfaces.size()<1) return null;
  int tempCurve = -1;
  Node firstNode = surfaces.get(0).head;
  Node theNode = null;
  float dist = getDist(mouseX, mouseY, 
               drawingScale(firstNode.x, false), drawingScale(firstNode.y, true));;
  for (int j = 0 ; j < surfaces.size(); j++) {
     Node temp = surfaces.get(j).head;
     while(temp != null){
       float tempDist = getDist(localPos(mouseX, false), localPos(mouseY, true), temp.x, temp.y);
       if(tempDist < dist){
         dist = tempDist;
         theNode = temp;
         tempCurve = j;
       }
       temp = temp.next;
     }
  }
  //println(mouseX, mouseY, drawingScale(theNode.x, false), drawingScale(theNode.y, true));
  if(dist < nodeDistTole){
    currentCurve = tempCurve;
    return theNode;
  }
  
  currentCurve = -1;
  return null;
}

Node getClosestEdgeNode(){
  if(surfaces.size()<1) return null;
  int tempCurve = -1;
  Node firstNode = surfaces.get(0).head;
  Node theNode = null;
  float dist = lineDistance( 
               drawingScale(firstNode.x, false), drawingScale(firstNode.y, true),
               drawingScale(firstNode.next.x, false), drawingScale(firstNode.next.y, true),
               mouseX, mouseY);
               
  for (int j = 0 ; j < surfaces.size(); j++) {
     Node temp = surfaces.get(j).head;
     while(temp.next != null){
       float tempDist = lineDistance(
        temp.x, temp.y, temp.next.x, temp.next.y,
        localPos(mouseX, false), localPos(mouseY, true));
        
       if(tempDist < dist){
         dist = tempDist;
         theNode = temp.next;
         tempCurve = j;
       }
       temp = temp.next;
     }
  }
  //println(mouseX, mouseY, drawingScale(theNode.x, false), drawingScale(theNode.y, true));
  if(dist < edgeDistTole){
    currentCurve = tempCurve;
    return theNode;
  }
  
  currentCurve = -1;
  return null;
}
float getDist(float x, float y, float x1, float y1){
  return ((x-x1)*(x-x1)+(y-y1)*(y-y1));
}


float lineDistance(float x1, float y1, float x2, float y2, float mX, float mY) {
  PVector lineStart, lineEnd, mouse, projection, temp;

  lineStart = new PVector(x1, y1);
  lineEnd = new PVector(x2, y2);
  mouse = new PVector(mX, mY);
  
  temp = PVector.sub(lineEnd, lineStart);
  float lineLength = temp.x * temp.x + temp.y * temp.y; //lineStart.dist(lineEnd);

  if (lineLength == 0F)
    return mouse.dist(lineStart);

  float t = PVector.dot(PVector.sub(mouse, lineStart), temp) / lineLength;

  projection = PVector.add(lineStart, PVector.mult(temp, t));
  
  if(projection.dist(lineEnd) > lineEnd.dist(lineStart)) return mouse.dist(lineStart);
  if(projection.dist(lineStart) > lineEnd.dist(lineStart)) return mouse.dist(lineEnd);
  
  return mouse.dist(projection);
}
