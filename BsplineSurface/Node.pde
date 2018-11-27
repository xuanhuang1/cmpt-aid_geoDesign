  class Node{
    Node next, prev;
    float x,y,z;
    int indexOfCurve;
    Node(float inX, float inY, float inZ){
      x = inX;
      y = inY;
      z = inZ;
      next = null;
      prev = null;
    }
  }
