//Lawrence Li

import g4p_controls.*;
import java.util.*;

int WIDTH = 1100;
int HEIGHT = 600;
int NVAL = 50;
int MVAL = 50;
int KVAL = 3;
int LVAL = 3;
ArrayList<Integer> ubar = new ArrayList<Integer>(); //u knots
ArrayList<Integer> vbar = new ArrayList<Integer>(); //v knots
Surface sur = new Surface(); //global surface

//3D
float rotX = (PI/6),
      rotZ = (PI/48);
int transX = (WIDTH/2 -50);
int transY = (HEIGHT/2 - 50);

//for vertex drag
int boxSize = 5;
boolean overVertex = false; 
boolean locked = false;
int selectedRow = 0, selectedCol = 0;
int hoveredRow = 0, hoveredCol = 0;
int xOffset = 140;
int yOffset = 250;

String mode = "a";
boolean hidecp = false;
boolean hidetri = false;

//G4P GUI
GButton rmRowButton;
GButton addRowButton;
GButton rmColButton;
GButton addColButton;
GButton centDiffButton;

public void eDraw(PApplet e) {
 e.background(160);
 
}

void setup() {
  size(1100, 600, P3D);
  rectMode(CORNER);
  background(102);
  frameRate(60);  
  noLights();
  smooth(4); //anti-aliasing
  
/*
 *     create inital array of curves
 */
  sur.vertices = createObjects();
  
/*
 *    windows
 */
  createGUI();
 
  
/*
 *    UI components for render window
 */
  //buttons
  addRowButton = new GButton(this, 10, 30, 90, 20, "Add Row");
  rmRowButton = new GButton(this, 10, 55, 90, 20, "Remove Row");
  addColButton = new GButton(this, 10, 80, 90, 20, "Add Col.");
  rmColButton = new GButton(this, 10, 105, 90, 20, "Remove Col.");  
    
  
  //setup knots
  setKnots();
  
  //print surface information
  println("Surface: \n" + sur);
  
}//setup


void draw() {  
  background(230);
  stroke(255);     
  rectMode(CORNER);
  noLights(); 
  //check if mouse on deBoor point
  outerloop:
  for(int i = 0; i < sur.vertices.size(); i++) {
    ArrayList<Vertex> cur = sur.vertices.get(i);
    for(int j = 0; j < cur.size(); j++){
      
      Vertex p1 = cur.get(j);
      //rect((p1.x)/2 + 20, (p1.y)/2 +190, 5,5);
      if ((mouseX > ((p1.x-boxSize)/2 + xOffset)) && (mouseX < ((p1.x+boxSize)/2 + xOffset))
          && (mouseY > ((p1.y-boxSize)/2 +yOffset)) && (mouseY < ((p1.y+boxSize)/2 +yOffset))) {
        overVertex = true;  
        hoveredRow = i;
        hoveredCol = j;       
        break outerloop;
      }//if in boundary
      else {
        overVertex = false;
      }//if not in boundary
    }//for each col
  }//for each row
      
 /*
 *      text Strings
 */    
  String sind = "";
  String sval = "";
  if(selectedRow < sur.vertices.size() && selectedCol < sur.vertices.get(selectedRow).size()){
    Vertex selv = sur.vertices.get(selectedRow).get(selectedCol);
    sind = "Point: [" + selectedCol + ", " + selectedRow + "]";
    sval = "Value: " + selv + "   Weight:" + selv.wt;
  }//if legal
  
  fill(190,0,30);
  text(sind, 10, 10, 290, 80);
  fill(0,30,140);
  text(sval, 100, 10, 290, 80);   
  
  fill(0,100,0);
  text("Mode: 3D NURBS surface", 10, 480, 250, 80);  
  
  fill(0,0,200);
  String inst = "-Drag squares on left to change x,y.\n-Scroll mousewheel to change z.\n-Hold and drag right mouse button to rotate.\n-Space to hide triangles\n-'h' to hide control polygon\n-Arrow keys to move the surface";
  text(inst, 10, 500, 300, 120);
      
  //Render 3D
  if(mode == "a"){    
    rectMode(CENTER);
    lights();
    setupOutline();
    drawNURBS();    
  }//render NURBS surface
  fill(255,255,255);
}//draw

/*
 *    Listeners and Handlers
 */

void mousePressed() {
  if(overVertex && (mouseButton == LEFT)) {
    locked = true;
    selectedRow = hoveredRow;
    selectedCol = hoveredCol;        
    String tmp = ""+sur.vertices.get(selectedRow).get(selectedCol).wt;
    wtInput.setText(tmp);
  }//clicked point
  else {
    locked = false;
  }//not locked
  
}

void mouseDragged() {
  if(locked) {
    //undo rect((p1.x-2.5)/2 + 20, (p1.y-2.5)/2 +190, 5,5);
    sur.vertices.get(selectedRow).get(selectedCol).setxy(((mouseX)*2) - (xOffset*2), ((mouseY)*2)- (yOffset*2));
  }
  if(mousePressed && (mouseButton == RIGHT)){
    rotX = rotX + (((width/2 -mouseY)/float(width)))/50;
    rotZ = rotZ + (((height/2 - mouseX)/float(height)))/50;
  }//rotate cam
}

void mouseReleased() {
  locked = false;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e > 0){
    sur.vertices.get(selectedRow).get(selectedCol).z--;
  }//scroll down
  else if(e < 0){
    sur.vertices.get(selectedRow).get(selectedCol).z++;
  }//scroll up    
}//mouse wheel

void keyPressed() {
  if(key == 'h'){
    hidecp = !hidecp;  
  }//hide control polygon
  else if(key == ' '){
    hidetri = !hidetri;  
  }//hide triangles
  
  if(key == CODED){
    if(keyCode == UP){
      transY -= 10;
    }
    else if (keyCode == DOWN){
      transY += 10;
    }
    else if (keyCode == LEFT){
      transX -= 10;
    }
    else if (keyCode == RIGHT){
      transX += 10;
    }
  }//arrow keys
}//update mode on key press

public void handleButtonEvents(GButton button, GEvent event) {
  if(button == rmRowButton && event == GEvent.CLICKED && sur.vertices.size() > selectedRow){    
    sur.vertices.remove(selectedRow);      
  }//if clicked rm row button
  else if(button == rmColButton && event == GEvent.CLICKED && sur.vertices.size() > selectedRow
          && selectedCol < sur.vertices.get(selectedRow).size()){       
    for(int i = 0; i < sur.vertices.size(); i++){
      sur.vertices.get(i).remove(selectedCol);   
    }//loop through rows    
  }//if clicked rm col button
  else if(button == addRowButton && event == GEvent.CLICKED && sur.vertices.size() > selectedRow){
    ArrayList<Vertex> newrow = new ArrayList<Vertex>(sur.vertices.get(selectedRow));
    for(int i = 0; i < newrow.size(); i++){
      Vertex v = new Vertex(newrow.get(i));
      v.y = v.y + 20;
      newrow.set(i, v); 
    }//update value for row
    //add to array
    sur.vertices.add(selectedRow, newrow);
  }//if clicked add row button
  else if(button == addColButton && event == GEvent.CLICKED && sur.vertices.size() > selectedRow
          && sur.vertices.get(selectedRow).size() > selectedCol){
    for(int i = 0; i < sur.vertices.size(); i++){
      Vertex v = new Vertex(sur.vertices.get(i).get(selectedCol));
      v.x = v.x - 20;
      sur.vertices.get(i).add(selectedCol, v); 
    }//insert vertex for col in each row
  }//if clicked add col button  
  
  setKnots();
  println("Surface AFTER: \n" + sur);
}//button handler



ArrayList<ArrayList<Vertex>> createObjects(){
  ArrayList<ArrayList<Vertex>> tmp = new ArrayList<ArrayList<Vertex>>();  
  
  ArrayList<Vertex> row = new ArrayList<Vertex>();
  
  //row 3, col 0 to 3
  row = new ArrayList<Vertex>();
  row.add(new Vertex(0,240, 1, 100));
  row.add(new Vertex(80,240, 150, 1));
  row.add(new Vertex(160,240, 150, 1));
  row.add(new Vertex(240,240, 1, 100));
  tmp.add(row);
  
  //row 2, col 0 to 3  
  row = new ArrayList<Vertex>();
  row.add(new Vertex(0,160, 1, 1));
  row.add(new Vertex(80,160, 250, 1));
  row.add(new Vertex(160,160, 250, 1));
  row.add(new Vertex(240,160, 1, 1));
  tmp.add(row);
     
  //row 1, col 0 to 3
  row = new ArrayList<Vertex>();
  row.add(new Vertex(0,80, 1, 1));
  row.add(new Vertex(80,80, 70, 1));
  row.add(new Vertex(160,80, 70, 1));
  row.add(new Vertex(240,80, 1, 1));
  tmp.add(row);
      
 //row 0, col 0 to 3
  row = new ArrayList<Vertex>();
  row.add(new Vertex(0,0, 1, 10));
  row.add(new Vertex(80,0, 50, 1));
  row.add(new Vertex(160,0, 50, 1));
  row.add(new Vertex(240,0, 1, 10));
  tmp.add(row);
  
  return tmp;
}//create 2d array for surface

void setupOutline(){
  
    
  //draw row lines
  stroke(50);
  strokeWeight(1.5);
  for(int i = 0; i < sur.vertices.size(); i++){
    for(int j = 0; j < sur.vertices.get(i).size()-1; j++){      
      Vertex v1 = sur.vertices.get(i).get(j);
      Vertex v2 = sur.vertices.get(i).get(j+1);
      line((v1.x)/2 + xOffset, (v1.y)/2 + yOffset, (v2.x)/2 + xOffset, (v2.y)/2 + yOffset);      
    }//cols
  }//row
  
  //draw col lines
  for(int i = 0; i < sur.vertices.size() - 1; i++){
    for(int j = 0; j < sur.vertices.get(i).size(); j++){
      Vertex v1 = sur.vertices.get(i).get(j);
      Vertex v2 = sur.vertices.get(i+1).get(j);
      line((v1.x)/2 + xOffset, (v1.y)/2 + yOffset, (v2.x)/2 + xOffset, (v2.y)/2 + yOffset);     
    }//cols
  }//row
  
  //draw points
  stroke(50);
  for(int i = 0; i < sur.vertices.size(); i++) {     
    for(int j = 0; j < sur.vertices.get(i).size(); j++){
      Vertex p1 = sur.vertices.get(i).get(j);    
      
        //show selected
      if(locked && (selectedRow==i) & (selectedCol==j) ){
        fill(0,255,0);
      }
      else{    
        fill(0,0,255);        
      }
      rect((p1.x)/2 + xOffset, (p1.y)/2 + yOffset, 5,5);
    }//for each col            
  }//for each row
  
}//draw curve outline and circles for mini control area

void setKnots(){
    
    ubar = new ArrayList<Integer>(sur.vertices.get(0).size() - 1 + KVAL + 1); //knots
    vbar = new ArrayList<Integer>(sur.vertices.size() - 1 + KVAL + 1); //knots
    
    for(int i = 0; i < sur.vertices.get(0).size() - 1 + KVAL + 1; i++){
      ubar.add(i);
    }//init ubar default
    
    for(int i = 0; i < sur.vertices.size() - 1 + KVAL + 1; i++){
      vbar.add(i);
    }//init vbar default
    
    printKnots();
}//setup knots

ArrayList<Vertex> deBoor(ArrayList<Vertex> input, boolean leftRight){
  
    //deBoor alg
    int n = input.size() - 1; //get n                             
    float res = (NVAL/(sur.vertices.get(0).size()-LVAL+2 *1.0));//resolution, scale based on number of patches
    int order = LVAL;
    ArrayList<Integer> bar = new ArrayList<Integer>(vbar);
    
    if(leftRight){
      res = (MVAL/(sur.vertices.size()-KVAL+2 *1.0));
      order = KVAL;
      bar = ubar;
    }//if doing left right (on u)          
    
    int u_start = bar.get(order - 1);
    int u_end = bar.get(n+1);
    ArrayList<Vertex> rendpts = new ArrayList<Vertex>();
    
    for (float u = u_start; u < u_end; u += ((u_end - u_start) / (float)res)) {
      ArrayList<ArrayList<Vertex>> scheme = new ArrayList<ArrayList<Vertex>>(); //scheme
      scheme.add(new ArrayList<Vertex>(input));//0th generation            
      
      int I_u = floor(u);      
      //println("u:"+ u + " I_u:" + I_u);
      
      for (int j = 1; j <= (order - 1); j++) {        
        //ArrayList for new generation
        ArrayList<Vertex> newgen = new ArrayList<Vertex>();
        //buffer newgen
        for(int i = 0; i < (I_u - (order - 1));i++){
          newgen.add(new Vertex(0,0,0,1));
        }//init

        for (int i = (I_u - (order - 1)); i <= (I_u - j); i++) {
          float x = ((((bar.get(i + order) - u) / (bar.get(i + order) - bar.get(i + j))) * scheme.get(j - 1).get(i).x)
            + (((u - bar.get(i + j)) / (bar.get(i + order) - bar.get(i + j))) * scheme.get(j - 1).get(i + 1).x));
          float y = ((((bar.get(i + order) - u) / (bar.get(i + order) - bar.get(i + j))) * scheme.get(j - 1).get(i).y)
            + (((u - bar.get(i + j)) / (bar.get(i + order) - bar.get(i + j))) * scheme.get(j - 1).get(i + 1).y));            
          float z = ((((bar.get(i + order) - u) / (bar.get(i + order) - bar.get(i + j))) * scheme.get(j - 1).get(i).z)
            + (((u - bar.get(i + j)) / (bar.get(i + KVAL) - bar.get(i + j))) * scheme.get(j - 1).get(i + 1).z));
          float wt = ((((bar.get(i + order) - u) / (bar.get(i + order) - bar.get(i + j))) * scheme.get(j - 1).get(i).wt)
            + (((u - bar.get(i + j)) / (bar.get(i + KVAL) - bar.get(i + j))) * scheme.get(j - 1).get(i + 1).wt));
            
          Vertex v1 = new Vertex(x,y,z,wt);
          newgen.add(v1);        
        }//segments
        scheme.add(newgen); //add the new gen j;
        
      }//generation j
      
      Vertex vres = scheme.get(order-1).get(I_u - (order - 1));
     //println("Result:" + vres + "\n");
      rendpts.add(vres);
      
    }//loop through bar    
    
    //draw points from rendpts
    strokeWeight(1.2);
    //drawCurvePoints(rendpts, 255, 0, 255);
    strokeWeight(1);
    
    return rendpts;
  
}//deBoor

void printKnots(){
  String tmp="";
  for(int i = 0; i < ubar.size(); i++){
    tmp += ubar.get(i) + " ";
  }//for
  uKnotsInput.setText(tmp); //show knot bar
  
  tmp="";
  for(int i = 0; i < vbar.size(); i++){
    tmp += vbar.get(i) + " ";
  }//for
  vKnotsInput.setText(tmp); //show knot bar
}//returns Knot bar in string

ArrayList<Integer> parseKnots(String str){
  ArrayList<Integer> parsed = new ArrayList<Integer>();
  
  //parse the str  
  String[] splitted = str.split("\\s+");
  for(int i = 0; i < splitted.length; i++){
    parsed.add(Integer.valueOf(splitted[i]));
  }//add to parsed
  
  printKnots();
  return parsed;
  
}//parses input and returns a knot bar

void drawMesh(){  
  
  //draw points
  for(int i = 0; i < sur.vertices.size(); i++) {     
    for(int j = 0; j < sur.vertices.get(i).size(); j++){
      Vertex p1 = sur.vertices.get(i).get(j);    
      stroke(50);
      
      if(locked && (selectedRow==i) & (selectedCol==j) ){
        fill(0,255,0);
      }
      else{    
        fill(0,0,255);
      }
      
      pushMatrix();
      translate(p1.x, p1.y, p1.z);      
      noStroke();
      box(7);
      popMatrix();
      
    }//for each col            
  }//for each row
  
  stroke(0);
  strokeWeight(1.5);
  //horizontal
  for(int i = 0; i < sur.vertices.size(); i++){
    for(int j = 0; j < sur.vertices.get(i).size()-1; j++){      
      Vertex v1 = sur.vertices.get(i).get(j);
      Vertex v2 = sur.vertices.get(i).get(j+1);             
      line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
    }//cols
  }//row
  
  //vertical
  for(int i = 0; i < sur.vertices.size() - 1; i++){
    for(int j = 0; j < sur.vertices.get(i).size(); j++){
      Vertex v1 = sur.vertices.get(i).get(j);
      Vertex v2 = sur.vertices.get(i+1).get(j);
      line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);      
    }//cols
  }//row
  
}//draw control mesh

void drawNURBS(){
  //setup 3d environment
  translate(transX, transY, 0);
  rotateX(rotX);
  rotateZ(rotZ);
  
  int m = sur.vertices.size();
  int n = sur.vertices.get(0).size();
  
  //draw control mesh in 3D
  if(!hidecp)
    drawMesh();    
  
  //draw NURBS surface in 3D using bilinear interpolation and deBoor
  //iterate through 4pt. patches  
  
  
  //println("\nPatch index:");
  ArrayList<Surface> surVals = new ArrayList<Surface>(); //surface points from doing double deBoor
  
  for(int i = 0; i <= m - LVAL; i++){
    //println("Row " + i);
    for(int j = 0; j <= n - KVAL; j++){
      //println("Column " + j);
      ArrayList<ArrayList<Vertex>> pvs = new ArrayList<ArrayList<Vertex>>(); //array list of dpts for that surface
      Surface patch = new Surface();
      //add points to patch      
      for(int k = i; k < i+LVAL; k++){        
        ArrayList<Vertex> row = new ArrayList<Vertex>();
        for(int l = j; l < j+KVAL; l++){                    
          row.add(new Vertex(sur.vertices.get(k).get(l)));
        }//col
        pvs.add(row);
      }//row
      
      patch.vertices = pvs;
      //print(patch);
      //process the patch
      Surface result = new Surface();
      result = createPatch(patch);
      surVals.add(result); //create patch and add patch surface points
      
    }//column 0 rightwards, create patch
    //println();
  }//row 0 and upwards
  
  renderSurface(surVals);

}//drawNURBS

Surface createPatch(Surface patch){
  
  ArrayList<ArrayList<Vertex>> dbvals = new ArrayList<ArrayList<Vertex>>();
  //do leftRight multiple times
  for(int i = 0; i < patch.vertices.size(); i++){
    
    //homogenize before doing deboor
    ArrayList<Vertex> homogenized = new ArrayList<Vertex>(patch.vertices.get(i));
    for(int j = 0; j < homogenized.size(); j++){
      homogenized.get(j).x = homogenized.get(j).x * homogenized.get(j).wt;
      homogenized.get(j).y = homogenized.get(j).y * homogenized.get(j).wt;
      homogenized.get(j).z = homogenized.get(j).z * homogenized.get(j).wt;
    }//homogenize
    
    dbvals.add(new ArrayList<Vertex>(deBoor(homogenized, true)));    
  }//for each row in patch  
  
  
  ArrayList<ArrayList<Vertex>> surVals = new ArrayList<ArrayList<Vertex>>(); 
  //do deBoor in v direction  
  //create column
  for(int i = 0; i < dbvals.get(0).size();i++){
    ArrayList<Vertex> col = new ArrayList<Vertex>();
    for(int j = 0; j < dbvals.size(); j++){
       col.add(new Vertex(dbvals.get(j).get(i)));          
    }//row
    
    surVals.add(new ArrayList<Vertex>(deBoor(col, false))); //add vertical result points
  }//for each column
  
  Surface s = new Surface(surVals);
  return s;
  
}//create patch

void renderSurface(ArrayList<Surface> surVals){
  boolean first = true;
  Surface fullSur = new Surface();
    
  int col = 0;
  for(int i = 0; i < (sur.vertices.get(0).size() - KVAL+1); i++){
    //print(i + ":");
    //create Vertex array to render vertically
    Surface vertSur = new Surface();
    //init to base surface
    vertSur.vertices = new ArrayList<ArrayList<Vertex>>(surVals.get(i).vertices);
    for(int j = i + (sur.vertices.get(0).size() - KVAL+1); j < surVals.size(); j+=(sur.vertices.get(0).size() - KVAL+1)){
      //print(j + " ");
      
      ArrayList<ArrayList<Vertex>> tmp = new ArrayList<ArrayList<Vertex>>(surVals.get(j).vertices); //related patch vertices
      /*
      //draw related patches
      stroke(col,0,255);
      for(int k = 0; k < tmp.size(); k++){
        for(int l = 0; l < tmp.get(k).size() - 1; l++){
          line(tmp.get(k).get(l).x, tmp.get(k).get(l).y, tmp.get(k).get(l).z,
           tmp.get(k).get(l+1).x, tmp.get(k).get(l+1).y, tmp.get(k).get(l+1).z);          
        }
      }
      col+=90;
      */
      
      //add tmp vertices to vertSur      
      for(int k = 0; k < vertSur.vertices.size(); k++){
        vertSur.vertices.get(k).addAll(tmp.get(k)); 
      }//add to vertical surface
      
    }//gather column surfaces   
    
    //add col to full surface
    fullSur.vertices.addAll(vertSur.vertices);    
    
    //println();
  }//for each patch column
  
 
    
  ArrayList<ArrayList<Vertex>> surVer = new ArrayList<ArrayList<Vertex>>(fullSur.vertices);
  //dehomogenize the points
  for(int i = 0; i < surVer.size(); i++){
    for(int j = 0; j < surVer.get(i).size(); j++){  
      surVer.get(i).get(j).x = surVer.get(i).get(j).x/surVer.get(i).get(j).wt;
      surVer.get(i).get(j).y = surVer.get(i).get(j).y/surVer.get(i).get(j).wt;
      surVer.get(i).get(j).z = surVer.get(i).get(j).z/surVer.get(i).get(j).wt;
    }//col    
  }//row
  
  //draw surface in entirety in box format         
  
  noStroke();
  fill(255,0,255);
  //triangles
  beginShape(TRIANGLES);

  for(int i = 0; i < surVer.get(0).size() - 1; i++){
      for(int j = 0; j < surVer.size() - 1; j++){
        //upper triangle
        Vertex v = surVer.get(j).get(i);
        vertex(v.x, v.y, v.z);
        
        v = surVer.get(j).get(i+1);
        vertex(v.x, v.y, v.z);
        
        v = surVer.get(j+1).get(i);
        vertex(v.x, v.y, v.z);
        
        //lower triangle
        v = surVer.get(j).get(i+1);
        vertex(v.x, v.y, v.z);
        v = surVer.get(j+1).get(i);
        vertex(v.x, v.y, v.z);
        v = surVer.get(j+1).get(i+1);
        vertex(v.x, v.y, v.z);
      }//rows
  }//col

  endShape();
  
  if(!hidetri){
    stroke(0,0,0);
    for(int i = 0; i < surVer.size(); i++){
      for(int j = 0; j < surVer.get(i).size() - 1; j++){  
        line(surVer.get(i).get(j).x, surVer.get(i).get(j).y, surVer.get(i).get(j).z,
             surVer.get(i).get(j+1).x, surVer.get(i).get(j+1).y, surVer.get(i).get(j+1).z);
      }//for col
    }//for row
  
    for(int i = 0; i < surVer.get(0).size(); i++){
      for(int j = 0; j < surVer.size() - 1; j++){  
        line(surVer.get(j).get(i).x, surVer.get(j).get(i).y, surVer.get(j).get(i).z,
             surVer.get(j+1).get(i).x, surVer.get(j+1).get(i).y, surVer.get(j+1).get(i).z);
      }//for row
    }//for col
    
    // draw diagonals  
    for(int i = 0; i < surVer.get(0).size() - 1; i++){
        for(int j = 0; j < surVer.size() - 1; j++){
          //upper triangle        
          Vertex v = surVer.get(j).get(i+1);        
          Vertex v2 = surVer.get(j+1).get(i);                
          line(v.x, v.y, v.z,
             v2.x, v2.y, v2.z);
        }//rows
    }//col
  }//check if hidetri
  
}//connect and render the patches