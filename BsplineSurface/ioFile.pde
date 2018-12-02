int writeCount = 2;
boolean linetoskip(String s){
  if(s.trim().isEmpty()) return true;
  if(s.charAt(0) == '#') return true;
  return false;
}

int readFile(String fileName){
  String[] lines = loadStrings(fileName);
  if(lines.length < 1){
     println(fileName+" can't load");
     return 0;
  }
  println("reading:"+fileName);
  int i = 0;
  while(linetoskip(lines[i])){
    i++;
  }
  Scanner scanner_first = new Scanner(lines[i]);
  int surfaceCount = scanner_first.nextInt();
  scanner_first.close();
  i++;
  println("there are " + surfaceCount + " surfaces");
    
  int currentSurface = surfaces.size();
  for (int j = 0 ; j < surfaceCount; j++) {
     surfaces.add(new LL());
  }
  
  int lengthU = -1, lengthV = -1;

  while(i < lines.length){
    if(linetoskip(lines[i]) == false){
      if(surfaces.get(currentSurface).degreeU<0){
        Scanner the_scan_line = new Scanner(lines[i]);
        surfaces.get(currentSurface).degreeU = the_scan_line.nextInt();
        surfaces.get(currentSurface).degreeV = the_scan_line.nextInt();
        println("degree: <"+surfaces.get(currentSurface).degreeU +" "+surfaces.get(currentSurface).degreeV+"> at line "+i);
        the_scan_line.close(); 
      }else if(lengthU<0){
        Scanner the_scan_line = new Scanner(lines[i]);
        lengthU = the_scan_line.nextInt();
        lengthV = the_scan_line.nextInt();
        println("t length: <"+lengthU +" "+lengthV+"> at line"+i);
        the_scan_line.close();
      }else if(surfaces.get(currentSurface).u == null){
        getKVector(lines[i], currentSurface, surfaces.get(currentSurface).degreeU, lengthU, true);
      }else if(surfaces.get(currentSurface).v == null){
        getKVector(lines[i], currentSurface, surfaces.get(currentSurface).degreeV, lengthV, false);
      }else {
        surfaces.get(currentSurface).sizeU = (lengthU - surfaces.get(currentSurface).degreeU-1);
        surfaces.get(currentSurface).sizeV = (lengthV - surfaces.get(currentSurface).degreeV-1);
        println("There should be "+ surfaces.get(currentSurface).sizeU,"x",surfaces.get(currentSurface).sizeV+" points");
        i += addControlPoints(lines, i, currentSurface, surfaces.get(currentSurface).sizeU*surfaces.get(currentSurface).sizeV);
        lengthU = -1;
        lengthV = -1;
    }
    }//else{println("empty:"+i);}
    i++;

  }
  //println("read: "+surfaces.size() +" surfaces");
  return 1;
}

int readFileInterpo(String fileName){
  println("interpo: "+fileName);
  String[] lines = loadStrings(fileName);
  if(lines.length < 1){
     println(fileName+" can't load");
     return 0;
  }
  println("reading:"+fileName);
  int i = 0;
  while(linetoskip(lines[i])){
    i++;
  }
  Scanner scanner_first = new Scanner(lines[i]);
  int curveCount = scanner_first.nextInt();
  int degree = scanner_first.nextInt();
  int contrlPts = scanner_first.nextInt();
  scanner_first.close();
  i++;
  println("there are    " + curveCount + " curve    of degree",degree, "   with   ",contrlPts,"control points");
  int currentSurface = surfaces.size();
  surfaces.add(new LL());
  surfaces.get(currentSurface).degreeU = degree;
  surfaces.get(currentSurface).sizeV = curveCount;
  surfaces.get(currentSurface).sizeU = contrlPts;
  
  while(i < lines.length){
    if(linetoskip(lines[i]) == false){
      if(surfaces.get(currentSurface).u == null){
        getKVector(lines[i], currentSurface, surfaces.get(currentSurface).degreeU, degree+contrlPts+1, true);
      }else {
        println("There should be "+ surfaces.get(currentSurface).sizeU,"x",surfaces.get(currentSurface).sizeV+" points");
        i += addControlPoints(lines, i, currentSurface, surfaces.get(currentSurface).sizeU*surfaces.get(currentSurface).sizeV);
      }
    }//else{println("empty:"+i);}
    i++;
  }
  surfaces.get(currentSurface).degreeV = 1;
  float[] vt = new float[curveCount+1+1];
  fillInModifiedOpenKnotV(vt, 1, curveCount);
  surfaces.get(currentSurface).v = vt;
  surfaces.get(currentSurface).isFitting = true;
  return 1;
}

int writeFile(){
  String wrtName = "xuanhuang_"+writeCount+"_outfile.dat";
  println("writing to "+wrtName);
  String output = "";
  output += "#written data ,";
  output += surfaces.size()+" ,";
  for(int i=0;i<surfaces.size();i++){
    output += surfaces.get(i).degree+" ,";
    output += surfaces.get(i).size+" ,";
    Node temp = surfaces.get(i).head;
    while(temp != null){
      output += temp.x + " "+ temp.y +" ,";
      temp = temp.next;
    }
    output += "1 ,";
    output += surfaces.get(i).getTString() + ",";
  }
  String[] list = split(output, ',');
  writeCount+=1;
  
  saveStrings("BsplineData/fitting_result/"+wrtName, list);
  return 1;
}



int addControlPoints(String[] lines, int i, int currentSurface, int polyCount){
  //println("the curve has "+Integer.toString(polyCount)+" points");
  int lineCount = polyCount;
  println("start points");
  for (int j = 0 ; j < lineCount; j++) {
    if(linetoskip(lines[i+j]) == true){
       println();
       lineCount ++; 
    }else{
      Scanner scannerIn = new Scanner(lines[i+j]);
      float theX = scannerIn.nextFloat();
      float theY = scannerIn.nextFloat();
      float theZ = scannerIn.nextFloat();
      
      scannerIn.close();
      surfaces.get(currentSurface).add(theX, theY, theZ);
      println("the point ["+j+ "] is "+theX+" "+theY+" "+theZ);
    }
  }
  return lineCount;
}

float[] getKVector(String theLine, int currentSurface, int degree, int lengthK, boolean isU){
  Scanner the_scan_t_line = new Scanner(theLine);
  float[] k_vect = new float[lengthK];
  for(int j=0;j<lengthK;j++)
    k_vect[j] = (the_scan_t_line.nextFloat());
  the_scan_t_line.close();
  if(k_vect[k_vect.length-1] == k_vect[k_vect.length-degree-1])
    k_vect[k_vect.length-1] += 1;
  if(isU){
    surfaces.get(currentSurface).u = k_vect;
    print("knot vector u for curve["+currentSurface+"] degree "+degree+" : ");
    for(int j=0;j<surfaces.get(currentSurface).u.length;j++)
      print(surfaces.get(currentSurface).u[j]+" ");
    println();
    return k_vect;
  }else 
  surfaces.get(currentSurface).v = k_vect;
  print("knot vector v for curve["+currentSurface+"] degree "+degree+" : ");
  for(int j=0;j<surfaces.get(currentSurface).v.length;j++)
    print(surfaces.get(currentSurface).v[j]+" ");
  println();
  
  return k_vect;
}
