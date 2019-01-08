int displayWidth = 640;
int displayHeight = 480;


Mesh cube = new Mesh();
Camera mainCamera = new Camera();

void setup() {
  size(displayWidth, displayHeight);
  
  cube.vertices = cubeVertices;
  cube.tris = cubeTris;
  cube.position = new PVector (1.5,-1,3);
  
  background(BLACK);
}

void draw() {
  background(BLACK);
  
  if (keyPressed) {
    if (key == 'a') {
      mainCamera.position.add(new PVector(-0.05, 0, 0));
    }
    
    if (key == 'd') {
      mainCamera.position.add(new PVector(0.05, 0, 0));
    }
    
    if (key == 'w') {
      mainCamera.position.add(new PVector(0, 0, 0.05));
    }
    
    if (key == 's') {
      mainCamera.position.add(new PVector(0, 0, -0.05));
    }
    
    if (key == 'j') {
      mainCamera.rotation.add(new PVector(0, -0.01, 0));
    }
    
    if (key == 'l') {
      mainCamera.rotation.add(new PVector(0, 0.01, 0));
    }
    
    if (key == 'i') {
      mainCamera.rotation.add(new PVector(0.01, 0, 0));
    }
    
    if (key == 'k') {
      mainCamera.rotation.add(new PVector(-0.01, 0, 0));
    }
  }
  
  cube.rotate(new PVector(0.5, 0.5, 0.5));
  drawMesh(cube);
}



class Camera {
  public PVector position = new PVector(0, 0, 0);
  public PVector rotation = new PVector(0, 0, -1);
  public PVector displaySurface = new PVector (0, 0, 1);
}

class Mesh {
  public PVector[] vertices;
  public int[][] tris;
  public PVector position = new PVector(0, 0, 0);
  
  public void rotate(PVector rotation) {
    for(int i = 0; i < vertices.length; i++) {
      //Place at origin
      vertices[i].cross(this.position);
      //X rotation
      //X does not change
      vertices[i].y = (vertices[i].y * cos(radians(rotation.x))) + (vertices[i].z * -sin(radians(rotation.x)));
      vertices[i].z = (vertices[i].y * sin(radians(rotation.x))) + (vertices[i].z * cos(radians(rotation.x)));
      
      //Y rotation
      vertices[i].x = (vertices[i].x * cos(radians(rotation.x))) + (vertices[i].z * sin(radians(rotation.x)));
      //Y does not change
      vertices[i].z = (vertices[i].x * -sin(radians(rotation.x))) + (vertices[i].z * cos(radians(rotation.x)));
      
      //Z rotation
      vertices[i].x = (vertices[i].x * cos(radians(rotation.x))) + (vertices[i].y * -sin(radians(rotation.x)));
      vertices[i].y = (vertices[i].x * sin(radians(rotation.x))) + (vertices[i].y * cos(radians(rotation.x)));
      //Z does not change
      
      //Return to original spot
      vertices[i].cross(this.position.mult(-1));
      
    }
  }
  
}






void drawMesh (Mesh mesh) {
  //Draw points
  for (int i = 0; i < mesh.vertices.length; i++) {
   PVector projectedVector = project(PVector.add(mesh.vertices[i], mesh.position), mainCamera);
   stroke(WHITE);
   point(rasterizePoint(projectedVector).x, rasterizePoint(projectedVector).y);
   print("Point: " + str(i) + " " + str(projectedVector.x) + " " + str(projectedVector.y) + "\n");
 }
 
 fill(BLACK);
 stroke(WHITE);
 //Draw tris
 for (int i = 0; i < mesh.tris.length; i++) {
   
   PVector projectedVector1 = project(PVector.add(mesh.vertices[mesh.tris[i][0]], mesh.position), mainCamera);
   PVector projectedVector2 = project(PVector.add(mesh.vertices[mesh.tris[i][1]], mesh.position), mainCamera);
   PVector projectedVector3 = project(PVector.add(mesh.vertices[mesh.tris[i][2]], mesh.position), mainCamera);
   
   //triangle(rasterizePoint(projectedVector1).x, rasterizePoint(projectedVector1).y, rasterizePoint(projectedVector2).x, rasterizePoint(projectedVector2).y, rasterizePoint(projectedVector3).x, rasterizePoint(projectedVector3).y);
   
   line(rasterizePoint(projectedVector1).x, rasterizePoint(projectedVector1).y, rasterizePoint(projectedVector2).x, rasterizePoint(projectedVector2).y);
   line(rasterizePoint(projectedVector2).x, rasterizePoint(projectedVector2).y, rasterizePoint(projectedVector3).x, rasterizePoint(projectedVector3).y);
   line(rasterizePoint(projectedVector3).x, rasterizePoint(projectedVector3).y, rasterizePoint(projectedVector1).x, rasterizePoint(projectedVector1).y);
 }
}



PVector project(PVector vertex, Camera cam) {
  
  float xTransform = vertex.x - cam.position.x;
  float yTransform = vertex.y - cam.position.y;
  float zTransform = vertex.z - cam.position.z;
  
  //Apply camera transformation matrix
  float cameraTransformX = cos(cam.rotation.y) * ((sin(cam.rotation.z) * yTransform) + cos(cam.rotation.z) * xTransform) - sin(cam.rotation.y) * zTransform;
  float cameraTransformY = sin(cam.rotation.x) * ( (cos(cam.rotation.y) * zTransform) + sin(cam.rotation.y) * ( sin(cam.rotation.z) * yTransform + cos(cam.rotation.z) * xTransform) ) + cos(cam.rotation.x) * ( cos(cam.rotation.z) * yTransform - sin(cam.rotation.z) * xTransform);
  float cameraTransformZ = cos(cam.rotation.x) * ( (cos(cam.rotation.y) * zTransform) + sin(cam.rotation.y) * ( sin(cam.rotation.z) * yTransform + cos(cam.rotation.z) * xTransform) ) - sin(cam.rotation.x) * ( cos(cam.rotation.z) * yTransform - sin(cam.rotation.z) * xTransform);
  
  float projectedX = ( cam.displaySurface.z / cameraTransformZ ) * cameraTransformX + cam.displaySurface.x;
  float projectedY = ( cam.displaySurface.z / cameraTransformZ ) * cameraTransformY + cam.displaySurface.y;
  
  return new PVector(projectedX, projectedY, cameraTransformZ);
}

PVector rasterizePoint(PVector vertex) {
  
  float rasterX = vertex.x *((0.5 * displayWidth) + (displayWidth / 2));
  float rasterY = vertex.y * ((0.5 * displayHeight) + (displayHeight / 2));
  
  return new PVector(rasterX, rasterY);
}



//Cube data
PVector[] cubeVertices = {
  new PVector(-0.5, -0.5, -0.5),
  new PVector(-0.5, 0.5, -0.5),
  new PVector(0.5, 0.5, -0.5),
  new PVector(0.5, -0.5, -0.5),
  new PVector(-0.5, -0.5, 0.5),
  new PVector(-0.5, 0.5, 0.5),    
  new PVector(0.5, 0.5, 0.5),
  new PVector(0.5, -0.5, 0.5)
};

int[][] cubeTris = {
  //south
  {0, 1, 2},
  {2, 3, 0},
  //east
  {3, 2, 6},
  {6, 7, 3},
  //west
  {4, 5, 1},
  {1, 0, 4},
  //north
  {4, 5, 6},
  {6, 7, 4},
  //top
  {1, 5, 6},
  {6, 2, 1},
  //bottom
  {0, 4, 7},
  {7, 3, 0}
};



//Color definitions
color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color BLUE = color(0, 0, 255);
color BLACK = color(0, 0, 0);
color WHITE = color(255, 255, 255);
