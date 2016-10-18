class Vertex{
  public float x;
  public float y;
  public float z;
  public float wt;
  
  Vertex(float x, float y, float z, float wt){
    this.x = x;
    this.y = y;
    this.z = z;
    this.wt = wt;        
  }
  
  Vertex(){
  }
  
  Vertex(Vertex v){
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
    this.wt = v.wt;
  }
  
  public String toString(){
    String tmp = "(" + (int)x + ", " + (int)y + ", " + (int)z + ")";
    return tmp;
  }
  
  public void setxy(float x, float y){
    this.x = x;
    this.y = y;
  }//function for mouse dragging
}