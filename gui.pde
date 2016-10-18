/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:335117:
  appc.background(230);
  
  fill(50);
  
  /*text("Weight:", 10, 130, 100, 20);
  /*text("N:", 185, 140, 20,20);
  text("k:", 160, 140, 20,20);
  text("M:", 185, 160, 20,20);
  text("l:", 160, 160, 20,20);
  
  fill(10);
  text("u knots:", 105, 140, 100,20);
  text("v knots:", 105, 160, 100,20);*/
} //_CODE_:window1:335117:

// Variable declarations 
// autogenerated do not edit
GWindow window1;
GTextField nInput;
GTextField mInput;
GTextField kInput;
GTextField lInput;
GTextField wtInput;
GTextField uKnotsInput;
GTextField vKnotsInput;
GLabel nLabel;
GLabel mLabel;
GLabel kLabel;
GLabel lLabel;
GLabel wtLabel;
GLabel uLabel;
GLabel vLabel;

public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) {
  if(textcontrol == nInput && event == GEvent.ENTERED){
    NVAL = new Integer(nInput.getText());
  }//user entered value for N
  else if(textcontrol == mInput && event == GEvent.ENTERED){
    MVAL = new Integer(mInput.getText());
  }//user entered value for M
  else if(textcontrol == wtInput && event == GEvent.ENTERED){
    //if(selectedRow < sur.vertices.size() && selectedCol < sur.vertices.get(selectedRow).size()){
      sur.vertices.get(selectedRow).get(selectedCol).wt = new Float(wtInput.getText());
    //}//in bounds
  }//user entered value for wt
  else if(textcontrol == kInput && event == GEvent.ENTERED){
    KVAL = new Integer(kInput.getText());   
    setKnots();
  }//user entered value for k
  else if(textcontrol == lInput && event == GEvent.ENTERED){
    LVAL = new Integer(lInput.getText());   
    setKnots();
  }//user entered value for l
  else if(textcontrol == uKnotsInput && event == GEvent.ENTERED){
    ubar = parseKnots(uKnotsInput.getText());
    printKnots();
  }//user entered for u knots
  else if(textcontrol == vKnotsInput && event == GEvent.ENTERED){
    vbar = parseKnots(vKnotsInput.getText());
    printKnots();
  }//user entered for v knots
  
}//textfield handler



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("3D NURBS Editor");
  //second window
  window1 = GWindow.getWindow(this, "Controls", 100, 100, 300, 200, JAVA2D);
  window1.noLoop();
  window1.addDrawHandler(this, "win_draw1");
  
  //add gui elements
  //N input
  nInput = new GTextField(window1, 30, 10, 30, 15, G4P.SCROLLBARS_NONE);  
  String tmp = ""+NVAL;
  nInput.setText(tmp);
  nLabel = new GLabel(window1, 10, 10, 20, 15, "N:");
  //M input
  mInput = new GTextField(window1, 30, 30, 30, 15);
  tmp = ""+MVAL;
  mInput.setText(tmp);
  mLabel = new GLabel(window1, 10, 30, 20, 15, "M:");
  
  //k input
  kInput = new GTextField(window1, 100, 10, 40, 15);
  tmp = ""+KVAL;
  kInput.setText(tmp);
  kLabel = new GLabel(window1, 80, 10, 20, 15, "k:");
  //l input
  lInput = new GTextField(window1, 100, 30, 40, 15);
  tmp = ""+LVAL;
  lInput.setText(tmp);
  lLabel = new GLabel(window1, 80, 30, 20, 15, "l:");
  //wt input
  wtInput = new GTextField(window1, 65, 90, 40, 15);
  tmp = ""+sur.vertices.get(selectedRow).get(selectedCol).wt;
  wtInput.setText(tmp);
  wtLabel = new GLabel(window1, 10, 90, 55, 15, "Weight:");
  
  //knots
  uKnotsInput = new GTextField(window1, 50, 140, 180, 15);
  uLabel = new GLabel(window1, 30, 140, 20, 15, "u:");
  vKnotsInput = new GTextField(window1, 50, 160, 180, 15);
  uLabel = new GLabel(window1, 30, 160, 20, 15, "v:");
  
  
  //nInput2.addEventHandler(this, "textfield1_change1");
  window1.loop();
}