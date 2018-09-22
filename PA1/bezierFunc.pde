xyPair pointOnCurve(float t, int curveIndex){
  LL theCurve = curves.get(curveIndex);
  if(theCurve.size == 0){
    println("null curve at:", curveIndex);
    return null;
  }
  int n = theCurve.size - 1;
  xyPair result = ctAlgo(n, t, theCurve);
  return result;
}

xyPair interpolate(xyPair a, xyPair b, float t){
  return new xyPair((1-t)*a.x+t*b.x, (1-t)*a.y+t*b.y);
}

xyPair ctAlgo(int n, float t, LL curve){
  //println("alg, t:", t);
  xyPair points[] = new xyPair[curve.size];
  Node cNode = curve.head;
  for(int i=0;i<curve.size;i++){
    points[i] = new xyPair(cNode.x, cNode.y);
    
    //print(points[i].x, points[i].y," ");
    cNode = cNode.next;
  }
  //println();
  
  int iter = n;
  while(iter > 0){
    for(int i=0;i<iter;i++){
      points[i] = interpolate(points[i], points[i+1], t);
      //print(points[i].x, points[i].y," ");
    }
    //println();
    iter--;
  }
  return points[0];
}
