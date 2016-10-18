class Surface{
  
  ArrayList<ArrayList<Vertex>> vertices = new ArrayList<ArrayList<Vertex>>();
  
  Surface(ArrayList<ArrayList<Vertex>> vertices){
    this.vertices = vertices;
  }
  
  Surface(){
  }
  
  public String toString(){
    String tmp = "";
    for(int i = 0; i < this.vertices.size(); i++) {
      for(int j = 0; j < this.vertices.get(i).size(); j++) {
        tmp += vertices.get(i).get(j).toString() + " ";
      }
      tmp += "\n";
    }
    return tmp;
  }
}