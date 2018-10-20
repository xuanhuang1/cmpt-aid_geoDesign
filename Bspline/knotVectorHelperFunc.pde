
void fillInModifiedOpenKnotV(float []t, int degree, int n){
  for(int i=0;i<degree;i++) t[i] = 0;
  for(int i=degree;i<n;i++) t[i] = (.0f+i-degree)/(.0f+n - degree);
  for(int i=n;i<n+degree;i++) t[i] = 1;
  t[n+degree] = 1 + 1/(.0f+n - degree);
}

void fillInUniformFloatKnotV(float []t, int degree, int n){
  for(int i=0;i<degree+n+1;i++) t[i] = (i-degree+0.0f)/(n-degree);
}

float[] increT(float []t, int degree, int ctrlPs){
  float newItems[] = new float[t.length+1];
  if(t[0] == t[1]) fillInModifiedOpenKnotV(newItems, degree,ctrlPs+1);
  else fillInUniformFloatKnotV(newItems, degree,ctrlPs+1);
  println("the incremented v is:");
  println(newItems);
  return newItems;
}

float[] decreT(float []t, int degree, int ctrlPs){
  if(t.length-1 < 2*(degree+1)) return null;
  
  float newItems[] = new float[t.length-1];
  if(t[0] == t[1]) fillInModifiedOpenKnotV(newItems, degree,ctrlPs-1);
  else fillInUniformFloatKnotV(newItems, degree,ctrlPs-1);
  println("the decremented v is:");
  println(newItems);
  return newItems;
}
