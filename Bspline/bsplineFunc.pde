xyzPair pointOnCurve(float t, int curveIndex){
  LL theCurve = curves.get(curveIndex);
  if(theCurve.size == 0){
    println("null curve at:", curveIndex);
    return null;
  }
  int n = theCurve.size - 1;
  xyzPair result = ctAlgo(n, t, theCurve);
  //return result;
  return result;
}

float getBasis(float t_c, int i, int k, float[] t){
  if(k == 0){
    if( !(t_c < t[i]) && (t_c < t[i+1])) return 1;
    return 0;
  }
  if(i+1+k > t.length-1) return 0;
  if( !(t_c < t[i]) && (t_c < t[i+1+k])) {
    float B1 = getBasis(t_c,i,k-1,t);
    float B2 = getBasis(t_c,i+1,k-1,t);
    float part1 = B1, part2 = B2;
    if(B1 > 0) part1 *= (t_c-t[i])/(t[i+k]-t[i]);
    if(B2 > 0) part2 *= (t[i+k+1]-t_c)/(t[i+k+1]-t[i+1]);
    
    //println((t_c-t[i])+"/"+(t[i+k]-t[i]),i+"^"+(k-1)+":"+B1,";",
    //(t[i+k+1]-t_c)+"/"+(t[i+k+1]-t[i+1]),(i+1)+"^"+(k-1)+":"+B2);
    
    return part1+part2;
  }
  return 0;
}

xyzPair interpolate(xyzPair a, xyzPair b, float t_c, int k, int p, int i, float[] t){
  return null;//new xyzPair((t-t[i])/()*a.x+t*b.x, (1-t)*a.y+t*b.y , (1-t)*a.z+t*b.z );
}

xyzPair ctAlgo(int n, float t, LL curve){
  //println("alg, t:", t);
  xyzPair points[] = new xyzPair[curve.size];
  Node cNode = curve.head;
  for(int i=0;i<curve.size;i++){
    points[i] = new xyzPair(cNode.x, cNode.y, cNode.z);
    
    //print(points[i].x, points[i].y," ");
    cNode = cNode.next;
  }
  //println("t "+t+" J: "+getJ(t, curve.t, curve.degree));

  int k = curve.degree;
  //println(k);
  int J = getJ(t, curve.t, curve.degree);
  xyzPair res = new xyzPair(0,0,0);
  for(int m=J-k; m<J+1;m++){
    float B = getBasis(t,m,k,curve.t);
    //println(t, "getJ",J+" B_"+m+"^"+k,B);
    if(B == 0) continue;
    res.x += points[m].x*B;
    res.y += points[m].y*B;
    res.z += points[m].z*B;
  }
  return res;
}


int getJ(float x, float[] t, int k){
  for(int i=k; i<t.length-1; i++)
    if((!(x < t[i])) && (x < t[i+1])) return i;
  return -1;
}
