int displayWidth = 512;
int displayHeight = 512;


PVector[] vertices = {
  new PVector(0, 0, 0),
  new PVector(0, 1, 0),
  new PVector(1, 1, 0),
  new PVector(1, 0, 0),
  new PVector(0, 0, 1),
  new PVector(0, 1, 1),    
  new PVector(1, 1, 1),
  new PVector(1, 0, 1)
};

int[][] tris = {
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
  {7, 3, 0},
};

float vertCount = 0;

void setup() {
  size(displayWidth, displayHeight);
  setupTriData();
  PVector translate = new PVector(-1, -3, 3);
  translateCube(translate);
  background(BLACK);
}

void draw() {
  background(BLACK);
  vertCount += 0.02;
  //testRotate();
  translateCube(new PVector( cos(vertCount) * 0.05, sin(vertCount) * 0.05, 0));
  //Draw points
  for (int i = 0; i < vertices.length; i++) {
   PVector projectedVector = project(vertices[i]);
   stroke(WHITE);
   point(rasterizePoint(projectedVector).x, rasterizePoint(projectedVector).y);
   print("Point: " + str(i) + " " + str(projectedVector.x) + " " + str(projectedVector.y) + "\n");
 }
 
 //Draw tris
 for (int i = 0; i < tris.length; i++) {
   PVector projectedVector1 = project(vertices[tris[i][0]]);
   PVector projectedVector2 = project(vertices[tris[i][1]]);
   PVector projectedVector3 = project(vertices[tris[i][2]]);
   
   line(rasterizePoint(projectedVector1).x, rasterizePoint(projectedVector1).y, rasterizePoint(projectedVector2).x, rasterizePoint(projectedVector2).y);
   line(rasterizePoint(projectedVector2).x, rasterizePoint(projectedVector2).y, rasterizePoint(projectedVector3).x, rasterizePoint(projectedVector3).y);
   line(rasterizePoint(projectedVector3).x, rasterizePoint(projectedVector3).y, rasterizePoint(projectedVector1).x, rasterizePoint(projectedVector1).y);
 }
}


void setupTriData() {
  //TODO
}

void testRotate() {
  float theta = radians(0.1);
  for (int i = 0; i < vertices.length; i++) {
    vertices[i].y = (vertices[i].y * sin(theta)) + (vertices[i].y * cos(theta));
    vertices[i].x = (vertices[i].x * cos(theta)) - (vertices[i].y * sin(theta));
  }
}

PVector project(PVector vertex) {
  
  float orthoX = vertex.x * (1 / vertex.z);
  float orthoY = vertex.y * (1 / vertex.z);
  float orthoZ = 0; //z is not used in this projection
  
  return new PVector(orthoX, orthoY, orthoZ);
}

PVector rasterizePoint(PVector vertex) {
  
  float rasterX = vertex.x * (0.5 * displayWidth) + (displayWidth / 2);
  float rasterY = vertex.y * (0.5 * displayHeight) + (displayHeight / 2);
  
  return new PVector(rasterX, rasterY);
}

void translateCube(PVector vector) {
  for (int i = 0; i < vertices.length; i++) {
    vertices[i].add(vector);
  }
}


//Color definitions
color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color BLUE = color(0, 0, 255);
color BLACK = color(0, 0, 0);
color WHITE = color(255, 255, 255);
