class My2DPoint {
  float x;
  float y;
  
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}
My2DPoint projectPoint(My3DPoint eye, My3DPoint p){
  float w = (p.z - eye.z)/(-eye.z);
  float x = (p.x - eye.x)/w;/// z;
  float y = (p.y- eye.y)/w ;// z;
  return new My2DPoint(x,y);
}

class My2DBox{
  My2DPoint[] s;
  
  My2DBox(My2DPoint[] s){
    this.s = s;
  }
  
  void render(){
    for(int i = 0; i < 4; i++) {//first face
      stroke(#319359);
      line(s[i].x, s[i].y, s[(i+1)%4].x, s[(i+1)%4].y);
      stroke(#FF9A2E);
      line(s[i].x, s[i].y, s[i+4].x, s[i+4].y);
    }
    for (int i = 4; i < 8; i++){
      stroke(#1A18ED);
      line(s[i].x, s[i].y, s[(i+1)%4+ 4].x, s[(i+1)%4+ 4].y);
    }
  }
}



class My3DBox {
  My3DPoint[] p;
   My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{
      new My3DPoint(x,y+dimY,z+dimZ),
      new My3DPoint(x,y,z+dimZ),
      new My3DPoint(x+dimX,y,z+dimZ),
      new My3DPoint(x+dimX,y+dimY,z+dimZ),
      new My3DPoint(x,y+dimY,z),
      origin,
      new My3DPoint(x+dimX,y,z),
      new My3DPoint(x+dimX,y+dimY,z)
    };
  }
  
  My3DBox(My3DPoint[] p) {
  this.p = p;
  }
}

float[] homogeneous3DPoint (My3DPoint p){
  float[] result = {p.x,p.y,p.z, 1};
  return result;
}

My2DBox projectBox (My3DPoint eye, My3DBox box){
  My2DPoint[] points = new My2DPoint[8];
  for (int i = 0; i < 8 ; i++){
    points[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(points);
}

float[][]  rotateXMatrix(float angle) {
return(new float[][] {{1, 0 , 0 , 0},
                      {0, cos(angle), sin(angle) , 0},
                      {0, -sin(angle) , cos(angle) , 0},
                      {0, 0 , 0 , 1}});
}

float[][] rotateYMatrix(float angle){
  return(new float[][] {{cos(angle), 0 , sin(angle) , 0},
                        {0, 1 , 0 , 0},
                        {-sin(angle), 0 , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}

float[][] rotateZMatrix(float angle){
 return(new float[][] { {cos(angle),  -sin(angle),0 , 0},
                        {sin(angle), cos(angle) , 0 , 0},
                        {0, 0 , 1 , 0},
                        {0, 0 , 0 , 1}});
}

float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] { {x, 0, 0, 0},
                        {0, y , 0 , 0},
                        {0, 0 , z , 0},
                        {0, 0 , 0 , 1}});
}

float[][] translationMatrix(float x, float y, float z){
    return(new float[][] { {1, 0, 0, x},
                           {0, 1, 0 , y},
                           {0, 0 , 1 , z},
                           {0, 0 , 0 , 1}});
}

float[] matrixProduct(float[][] a, float[] b){
  float[] res = new float[a.length];
  if (a[0].length == b.length){
    for ( int i = 0; i < a.length; i++){
      float sum = 0;
      for (int j = 0; j < b.length; j++){
        sum += a[i][j]*b[j];
      }
      res[i] = sum;
    }
  }
  return res;
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}

My3DBox transformBox(My3DBox box , float[][] matrix){
  My3DPoint[] newPoints = new My3DPoint[box.p.length];
  for (int i = 0; i < box.p.length; i++) {
    newPoints[i] = euclidian3DPoint(matrixProduct(matrix, homogeneous3DPoint(box.p[i])));
  }
  
  return new My3DBox(newPoints);
}

void settings(){
  size(1000, 1000, P2D);
}

void setup(){
background(#FFFFFF);
}

void draw() {
  background(255, 255, 255);
  translate(width/2,height/2);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  

    float[][] xRotation = rotateXMatrix(angleX);
    float[][] yRotation = rotateYMatrix(angleY);
    float[][] scaleMatrix = scaleMatrix(scale,scale,scale);
    input3DBox = transformBox(input3DBox, xRotation);
    input3DBox = transformBox(input3DBox, yRotation);
    input3DBox = transformBox(input3DBox, scaleMatrix);
    
    projectBox(eye, input3DBox).render();
    

}

float scale = 1;
void mouseDragged(){
  if(mouseY - pmouseY > 0){
  scale /= 1.1 ;
}
  if (mouseY - pmouseY < 0){
    scale *=  1.1;
  }
  if(scale > 300){
    scale = 300;
  } else if (scale < 0){
    scale = 0;
  }
}

float angleX = 0;
float angleY = 0;
void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      angleX = ((angleX+ (PI/16))% (2*PI));
    }
    else if(keyCode == DOWN){
      angleX = ((angleX-(PI/16))% (2*PI));
    }
    if(keyCode == RIGHT){
      angleY = ((angleY + (PI/16))% (2*PI));
    }
    else if(keyCode == LEFT){
      angleY = ((angleY - (PI/16))% (2*PI)); 
    }
    
  }
}