# NURBSeditor
An Interactive Editor for Three Dimensional NURBS surfaces. Written in Processing using the G4P GUI library.

![Alt text](/screenshot.PNG "Screenshot")

## Running the program

1. Download Processing at https://processing.org/download/.
2. Place the files in C:\Users\YOURNAME\Documents\Processing
3. Open “NURBSeditor.pde”.
4. Click the Run button.
5. The program can be stopped by pressing the Stop button.


## User Interface
- Each point can be dragged in the left point array in the main window by clicking and holding down the left mouse button. The z value is changed by scrolling the mousewheel.
- Adding and Removing rows/columns is done by clicking the related point and pressing the respective Add and Remove buttons on the left.
[a] 3D NURBS Surface editor
- The deBoor control points are represented as blue squares.
- The resulting surface is in pink.
- The knot values, weight, resolution (N,M), and orders (k, l) can be changed in the smaller, second window.
- Press ‘h’ to hide the control polygon.
- Press space to hide the surface triangles (in black).
- Hold the right mouse button and drag to rotate the surface.
