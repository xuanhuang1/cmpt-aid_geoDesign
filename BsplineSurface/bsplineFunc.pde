xyzPair pointOnCurve(float t, int curveIndex){
  LL theCurve = surfaces.get(curveIndex);
  if(theCurve.size == 0){
    println("null curve at:", curveIndex);
    return null;
  }
  int n = theCurve.size - 1;
  xyzPair result = ctAlgo(t, theCurve);
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

xyzPair ctAlgo(float tu, LL curve){
  //println("alg, t:", t);
  xyzPair points[] = new xyzPair[curve.size];
  Node cNode = curve.head;
  for(int i=0;i<curve.size;i++){
    points[i] = new xyzPair(cNode.x, cNode.y, cNode.z);
    
    //print(points[i].x, points[i].y," ");
    cNode = cNode.next;
  }
  //println("t "+t+" J: "+getJ(t, curve.t, curve.degree));

  int ku = curve.degreeU, kv = curve.degreeV;
  int Ju = getJ(tu, curve.u, curve.degreeU);
  xyzPair res = new xyzPair(0,0,0);
  for(int m=Ju-ku; m<Ju+1;m++){
    float B = getBasis(tu,m,ku,curve.u);
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
