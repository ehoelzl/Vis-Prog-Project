class Ball{
  float radius;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float normalForce = 1;
  float mu = 0.11;
  PVector friction;
  float mass;
  float maxSpeed = 5;
  float elasticity = 0.4;
  
  Ball(float rad, float mass) {
    this.mass = mass;
    radius = rad;
    location = new PVector(0, - .04*PLATE_DIM/2 - radius, 0);
    velocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
    friction = new PVector(0,0,0);
    velocity.limit(maxSpeed);
  }
  
  void display() {
    pushMatrix();
    noStroke();
    lights();
    fill(#F5A800);
    translate(location.x, location.y, location.z);
    sphere(radius);
    popMatrix();
  }
  void display2D(){
    pushMatrix();
    noStroke();
    lights();
    fill(#F5A800);
    translate(location.x,location.z,0);
    sphere(radius);
    popMatrix();
  }
  
  void update(){
    float mag = normalForce*mu;
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(mag);
    
    acceleration.x = (sin(rotateZ) * GRAVITY + friction.x)/mass;
    acceleration.z = (-(sin(rotateX) * GRAVITY) + friction.z)/mass;
    
    velocity = velocity.add(acceleration);
    
    
    location = location.add(velocity);
    checkEdges();
  }
  
  private void checkEdges() {
    if(location.x + radius > PLATE_DIM/2) {
      velocity.x = (velocity.x * -1)*elasticity;
      location.x = PLATE_DIM/2 - radius;
    } else if (location.x-radius < -PLATE_DIM/2) {
      velocity.x = (velocity.x * -1)*elasticity;
      location.x = -PLATE_DIM/2 + radius;
    }
    
    if(location.z + radius> PLATE_DIM/2) {
      velocity.z = (velocity.z * -1)*elasticity;
      location.z = PLATE_DIM/2 - radius;
    } else if (location.z - radius < -PLATE_DIM/2) {
      velocity.z = (velocity.z * -1)*elasticity;
      location.z = -PLATE_DIM/2 + radius;
    }
     
  }
  
   
}