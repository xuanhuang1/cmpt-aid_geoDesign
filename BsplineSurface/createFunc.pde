int flipCount = 0;

void flip(){
  if(flipCount <2 ){
    for(int i=0;i<surfaces.size();i++){
      Node temp = surfaces.get(i).head;
      while(temp != null){
        float tempXval = temp.x;
        temp.x = temp.y;
        temp.y = tempXval;
        temp = temp.next;
      }
    }
    flipCount++;
  }
  else if(flipCount <4){
    for(int i=0;i<surfaces.size();i++){
      Node temp = surfaces.get(i).head;
      while(temp != null){
        float tempXval = temp.x;
        temp.x = temp.z;
        temp.z = tempXval;
        temp = temp.next;
      }
    }
    flipCount++;
  }else if(flipCount < 6){
    for(int i=0;i<surfaces.size();i++){
      Node temp = surfaces.get(i).head;
      while(temp != null){
        float tempZval = temp.z;
        temp.z = temp.y;
        temp.y = tempZval;
        temp = temp.next;
      }
    }
    flipCount++;
  }else flipCount = 0;
}

void ySymetric(){
  for(int i=0;i<surfaces.size();i++){
    int numCount = 0;
    Node[] points = new Node[surfaces.get(i).sizeV*surfaces.get(i).sizeU];
    Node temp = surfaces.get(i).head;
    while(temp != null){
       points[numCount] = temp;
       numCount++;
       temp = temp.next;
    }
    for(int j=0;j<surfaces.get(i).sizeV;j++){
      for(int k=0;k <= surfaces.get(i).sizeU/2;k++){
        if(k == surfaces.get(i).sizeU-k-1) points[j*surfaces.get(i).sizeU+k].x = 0;
        else points[(j+1)*surfaces.get(i).sizeU-k-1].x = -points[j*surfaces.get(i).sizeU+k].x;
        points[(j+1)*surfaces.get(i).sizeU-k-1].y = points[j*surfaces.get(i).sizeU+k].y;
        points[(j+1)*surfaces.get(i).sizeU-k-1].z = points[j*surfaces.get(i).sizeU+k].z;
        if((k == surfaces.get(i).sizeU/2) || (k==0)) points[j*surfaces.get(i).sizeU+k].x = 0;
      }
    }
  }
}
