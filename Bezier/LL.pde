class LL{
  Node head, tail;
  int size;
  
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
  
  void add(float inX, float inY){
    Node newNode = new Node(inX, inY);
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
  
  void addBefore(Node node, float inX, float inY){
      Node newNode = new Node(inX, inY);
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
        print("("+temp.x+" "+temp.y+") ");
        temp = temp.next;  
      }
    println("totol size:", this.size);
  }
}
