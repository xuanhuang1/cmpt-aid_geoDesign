class xyPair{
  float x,y;
  xyPair(float inX, float inY){
    x = inX;
    y = inY;
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

float dataScale(float x, boolean isY){
  if(isY) x = -x;
  return x/30;
}
