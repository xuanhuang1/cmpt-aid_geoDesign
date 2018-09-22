import java.util.*;

boolean linetoskip(String s){
  if(s.isEmpty()) return true;
  if(s.charAt(0) == '#') return true;
  return false;
}

int readFile(String fileName){
  String[] lines = loadStrings(fileName);
  if(lines.length < 1){
     println(fileName+" can't load");
     return 0;
  }
  int i = 0;
  while(linetoskip(lines[i])){
    i++;
  }
  
  Scanner scanner_first = new Scanner(lines[i]);
  int curveCount = scanner_first.nextInt();
  scanner_first.close();
  println("there are " + curveCount + " curves");
    
  int currentCurve = curves.size();
  for (int j = 0 ; j < curveCount; j++) {
     curves.add(new LL());
  }

  while(i < lines.length){
    if(linetoskip(lines[i]) == false){
      int lineCount;
      if(lines[i].charAt(0) == 'P'){
        lineCount = addPCurve(lines, i, currentCurve);
        i += lineCount;
        currentCurve++;
      }else if(lines[i].charAt(0) == 'Q'){
        lineCount = addRCurve(lines, i, currentCurve);
        i += lineCount;
        currentCurve++;
      }
      i++;
    }//else{println("comment");}
  }
  return 1;
}


int addPCurve(String[] lines, int i, int currentCurve){
  Scanner scanner = new Scanner(lines[i]);
  scanner.next();
  int lineCount = scanner.nextInt();
  scanner.close();
  
  println("the curve has "+Integer.toString(lineCount)+" points");
  for (int j = 1 ; j < lineCount+1; j++) {
    if(lines[i+j].charAt(0) == '#'){
       lineCount ++; 
    }else{
      Scanner scannerIn = new Scanner(lines[i+j]);
      float theX = scannerIn.nextFloat();
      float theY = scannerIn.nextFloat();
      scannerIn.close();
      curves.get(currentCurve).add(theX, theY);
      //println("curves size", curves.size());
      //println("the point is "+theX+" "+theY);
    }
  }
  return lineCount;
}

int addRCurve(String[] lines, int i, int currentCurve){
  Scanner scanner = new Scanner(lines[i]);
  scanner.next();
  int lineCount = scanner.nextInt();
  scanner.close();
  
  println("the curve_R has "+Integer.toString(lineCount)+" points");
  for (int j = 1 ; j < lineCount+1; j++) {
    if(lines[i+j].charAt(0) == '#'){
       lineCount ++; 
    }else{
      Scanner scannerIn = new Scanner(lines[i+j]);
      float theW = scannerIn.nextFloat();
      float theX = scannerIn.nextFloat();
      float theY = scannerIn.nextFloat();
      scannerIn.close();
      curves.get(currentCurve).add(theX/theW, theY/theW);
      //println("curves size", curves.size());
      //println("the point is "+theX+" "+theY);
    }
  }
  return lineCount;
}

Node getClosestNode(){
  if(curves.size()<1) return null;
  int tempCurve = -1;
  Node firstNode = curves.get(0).head;
  Node theNode = null;
  float dist = getDist(mouseX, mouseY, 
               drawingScale(firstNode.x, false), drawingScale(firstNode.y, true));;
  for (int j = 0 ; j < curves.size(); j++) {
     Node temp = curves.get(j).head;
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
  if(dist < 0.5){
    currentCurve = tempCurve;
    return theNode;
  }
  
  currentCurve = -1;
  return null;
}

Node getClosestEdgeNode(){
  if(curves.size()<1) return null;
  int tempCurve = -1;
  Node firstNode = curves.get(0).head;
  Node theNode = null;
  float dist = lineDistance( 
               drawingScale(firstNode.x, false), drawingScale(firstNode.y, true),
               drawingScale(firstNode.next.x, false), drawingScale(firstNode.next.y, true),
               mouseX, mouseY);
               
  for (int j = 0 ; j < curves.size(); j++) {
     Node temp = curves.get(j).head;
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
  if(dist < 0.2){
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
