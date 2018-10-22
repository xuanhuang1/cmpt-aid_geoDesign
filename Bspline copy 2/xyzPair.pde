class xyzPair{
  float x,y,z;
  xyzPair(float inX, float inY, float inZ){
    x = inX;
    y = inY;
    z = inZ;
  }
}

float drawingScale(float x, boolean isY){
  if(isY) x = -x;
  return 30*x;
}

float localPos(float x, boolean isY){
  if(isY){
    x = height/2 - x;
  }else{
    x -= width/2;
  }
  return x/30.0;
}

float dataScale(float d, boolean isY){
  if(isY) d = -d;
  return d/30;
}
