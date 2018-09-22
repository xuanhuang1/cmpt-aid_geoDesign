
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
        //println("currentCurve "+currentCurve);
        lineCount = addPCurve(lines, i, currentCurve);
        //println(curves.get(0).head.x);
        i += lineCount;
        currentCurve++;
      }else if(lines[i].charAt(0) == 'Q'){
        lineCount = addRCurve(lines, i, currentCurve);
        i += lineCount;
        currentCurve++;
      }
    }//else{println("comment");}
    i++;
  }
  
  
  println("read: "+curves.size());
  return 1;
}

int writeFile(){
  if(crvName == null) return 0;
  String wrtName = "xuanhuang_"+crvName+"_crv.itd";
  println("writing from crv: "+crvName+" to "+wrtName);
  String output = "";
  output += "#fitting data from "+crvName+".crv ,";
  output += curves.size()+" ,";
  for(int i=0;i<curves.size();i++){
    output += "P "+curves.get(i).size+" ,";
    Node temp = curves.get(i).head;
    while(temp != null){
      output += temp.x + " "+ temp.y +" ,";
      temp = temp.next;
    }
  }
  String[] list = split(output, ',');
  
  saveStrings("fitting_result/"+wrtName, list);
  return 1;
}

int readCrvFile(String fileName){
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
  //println("there are " + curveCount + " curves");
    
  while(i < lines.length){
    if(linetoskip(lines[i]) == false){
      int lineCount;
      if(lines[i].charAt(0) == 'P'){
        lineCount = addCrvCurve(lines, i);
        i += lineCount;
        //print("a ");
      }
    }//else{println("comment");}
    i++;
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
int addCrvCurve(String[] lines, int i){
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
      displayCrv.add(theX, theY);
      //println("the point is "+theX+" "+theY);
    }
  }
  return lineCount;
}
