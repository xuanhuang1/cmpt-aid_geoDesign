class LL{
  Node head, tail;
  float[] u ,v , t; 
  int size, sizeU, sizeV, degree, degreeU, degreeV;
  boolean isFitting;
  
  LL(){
    head = null;
    tail = null;
    size = 0;
    sizeU = -1;
    sizeV = -1;
    isFitting = false;
    degree = -1;
    degreeU = -1;
    degreeV = -1;
    u = null;
    v = null;
  }
  
  void delete(Node node){
      float []decreResult = decreT(t, degree, t.length - 1 - degree);
      if(decreResult==null){
        print("the vector:"); printT();
        println("doesn't have enough points to delete for its degree:", degree);
        return;
      }else t = decreResult;
      
      if(node.prev != null)
        node.prev.next = node.next;
      else // node is head
        head = node.next;
        
      if(node.next != null)
        node.next.prev = node.prev;  
      else // node is tail
        tail = node.prev;
      
      node = null;
      
      size--;
  }
  
  void empty(){
    while(this.size>0){
      this.delete(tail);
    }
  }
  
  void add(float inX, float inY, float inZ){
    Node newNode = new Node(inX, inY, inZ);
    if(head == null){
      head = newNode;
      tail = newNode;
    }else{
      tail.next = newNode;
      newNode.prev = tail;
      tail = newNode;
    }
    size++;
    //println("add");
  }
  
  void insert(float inX, float inY, float inZ){
    add(inX, inY, inZ);
    t = increT(t, degree, t.length - 1 - degree);
    //println("-insert");
  }
  
  void insertBefore(Node node, float inX, float inY, float inZ){
      Node newNode = new Node(inX, inY, inZ);
      if(node.prev!= null){
        node.prev.next = newNode;
        newNode.prev = node.prev;
        node.prev = newNode;
      }else head = newNode;
      
      newNode.next = node;
      
      t = increT(t, degree, t.length - 1 - degree);
      size++;
  }
  
  void printList(){
    Node temp = head;
      while(temp != null){
        print("("+temp.x+" "+temp.y+" "+temp.z+") ");
        temp = temp.next;  
      }
    println("totol size:", this.size,"is isFitting?", this.isFitting);
  }
  
  void printT(){
    for(int i=0;i<u.length;i++)
      print(u[i]+" ");
      println();
  }
  
  String getTString(){
    String a="";
    for(int i=0;i<t.length;i++)
      a+=t[i]+" ";
    return a;
  }
}
