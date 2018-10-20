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
  int curveCount = scanner_first.nextInt();
  scanner_first.close();
  i++;
  println("there are " + curveCount + " curves");
    
  int currentCurve = curves.size();
  for (int j = 0 ; j < curveCount; j++) {
     curves.add(new LL());
  }
  
  int degree = -1, controlPoly=-1;

  while(i < lines.length){
    if(linetoskip(lines[i]) == false){
      if(degree<0){
        Scanner the_scan_line = new Scanner(lines[i]);
        degree = the_scan_line.nextInt();
        println("degree: "+degree+" at "+i);
        the_scan_line.close(); 
      }
      else if(controlPoly<0){
        
        println("in pooints: "+controlPoly+" at "+lines[i]);
        Scanner the_scan_line = new Scanner(lines[i]);
        controlPoly = the_scan_line.nextInt();
        the_scan_line.close(); 
        //println("pooints: "+controlPoly+" at "+i);
      }
      else if((degree > 0) && (controlPoly>0)){
        println("curve degree:"+degree+" ctrl points:"+controlPoly);
        //println("currentCurve "+currentCurve);
        int lineCount = addCurve(lines, i, currentCurve, degree, controlPoly);
        //println(curves.get(0).head.x);
        i += lineCount-1;
        currentCurve++;
        degree = -1;
        controlPoly = -1;
        println("end curve["+(currentCurve-1)+"] at line",i);
      }
    }//else{println("empty:"+i);}
    i++;

  }
  //println("read: "+curves.size() +" curves");
  return 1;
}

int writeFile(){
  String wrtName = "xuanhuang_"+writeCount+"_outfile.dat";
  println("writing to "+wrtName);
  String output = "";
  output += "#written data ,";
  output += curves.size()+" ,";
  for(int i=0;i<curves.size();i++){
    output += curves.get(i).degree+" ,";
    output += curves.get(i).size+" ,";
    Node temp = curves.get(i).head;
    while(temp != null){
      output += temp.x + " "+ temp.y +" ,";
      temp = temp.next;
    }
    output += "1 ,";
    output += curves.get(i).getTString() + ",";
  }
  String[] list = split(output, ',');
  writeCount+=1;
  
  saveStrings("BsplineData/fitting_result/"+wrtName, list);
  return 1;
}



int addCurve(String[] lines, int i, int currentCurve, int degree, int polyCount){
  //println("the curve has "+Integer.toString(polyCount)+" points");
  int lineCount = polyCount;
  println("start points");
  for (int j = 0 ; j < lineCount; j++) {
    if(lines[i+j].charAt(0) == '#'){
       lineCount ++; 
    }else{
      Scanner scannerIn = new Scanner(lines[i+j]);
      float theX = scannerIn.nextFloat();
      float theY = scannerIn.nextFloat();
      float theZ = 0;
      if(scannerIn.hasNextFloat()) {
        theZ = scannerIn.nextFloat();
        curves.get(currentCurve).is3D = true;
      }
      scannerIn.close();
      curves.get(currentCurve).add(theX, theY, theZ);
      //println("the point is "+theX+" "+theY+" "+theZ);
    }
  }
  while(linetoskip(lines[i+lineCount]) && (i+lineCount<lines.length-1) ) lineCount++;
  //println("end points", i+lineCount, lines.length);
  Scanner the_scan_line = new Scanner(lines[i+lineCount]);
  int has_t = 0;
  if(the_scan_line.hasNextInt())
    has_t = the_scan_line.nextInt();
  the_scan_line.close();
  //println("has_t",has_t);
  if(has_t != 1) {
    println("no knot vector");
    curves.get(currentCurve).t =new float[polyCount+degree+1];
    fillInModifiedOpenKnotV(curves.get(currentCurve).t, degree, polyCount);
    curves.get(currentCurve).degree = degree;
    curves.get(currentCurve).printT();
    return lineCount+1;
  }
  
  lineCount++;
  while(linetoskip(lines[i+lineCount])) lineCount++;
  Scanner the_scan_t_line = new Scanner(lines[i+lineCount]);
  ArrayList<Float> k_vect = new ArrayList<Float>();
  while(the_scan_t_line.hasNextFloat())
    k_vect.add(the_scan_t_line.nextFloat());
  the_scan_t_line.close();
  curves.get(currentCurve).t = new float[k_vect.size()];
  curves.get(currentCurve).degree = degree;
  for (int q=0; q<k_vect.size();q++) curves.get(currentCurve).t[q] = k_vect.get(q);
  if(curves.get(currentCurve).t[k_vect.size()-1] == curves.get(currentCurve).t[k_vect.size()-degree-1])
    curves.get(currentCurve).t[k_vect.size()-1] += 1;
  print("knot vector for curve["+currentCurve+"] degree "+curves.get(currentCurve).degree+" : ");
  curves.get(currentCurve).printT();
  
  return lineCount+1;
}
