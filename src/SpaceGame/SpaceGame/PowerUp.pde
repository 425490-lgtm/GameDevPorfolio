class PowerUp {
  // Member Variables
  int x, y, diam, speed;
  char type;
  PImage r1;
  color c1;

  // Constructor
  PowerUp() {
    x = int(random(width));
    y = -100;
    diam = 100;
    speed = int(random(1, 10));
    if (random(10)>7) {
      type = 'a'; //this is AMMO
      //c1 = color(255,0,0);
      r1 = loadImage("AmmoPU.png");
    } else if (random(10)>5.0) {
      type = 'h'; //this is health
      //c1 = color(0,255,0);
      r1 = loadImage("HealthPU.png");
    } else {
      type = 't'; //this is turret count
      //c1 = color(0,0,255);
      r1 = loadImage("TurretPU.png");
    }
  }
  // Member methods
  void display() {
    //fill(c1);
    //ellipse(x,y,diam,diam);
    //fill(255);
    //textAlign(CENTER);
    //text(type,x,y);
    imageMode(CENTER);
    r1.resize(diam, diam);
    image(r1, x, y);
  }

  void move() {
    y = y + speed;
  }

  boolean reachedBottom() {
    if (y>height+100) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean intersect(Spaceship s) {
    float d = dist(x,y,s.x,s.y);
    if(d<50) {
      return true;
    } else {
      return false;
    }
  }
}
