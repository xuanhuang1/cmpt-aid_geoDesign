class LL{
  Node head, tail;
  float[] t; 
  int size, degree;
  
  LL(){
    head = null;
    tail = null;
    size = 0;
  }
  
  void delete(Node node){
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
  }
  
  void addBefore(Node node, float inX, float inY, float inZ){
      Node newNode = new Node(inX, inY, inZ);
      if(node.prev!= null){
        node.prev.next = newNode;
        newNode.prev = node.prev;
        node.prev = newNode;
      }else head = newNode;
      
      newNode.next = node;
      size++;
  }
  
  void printList(){
    Node temp = head;
      while(temp != null){
        print("("+temp.x+" "+temp.y+" "+temp.z+") ");
        temp = temp.next;  
      }
    println("totol size:", this.size);
  }
  
  void printT(){
    for(int i=0;i<t.length;i++)
      print(t[i]+" ");
      println();
  }
}
