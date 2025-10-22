class Laser {
  // Member Variables
  int x, y, w, h, speed;
  //PImage l1;
  // Constructor
  Laser(int x, int y) {
    this.x = x;
    this.y = y;
    w = 4;
    h = 10;
    //l1 = loadImage("Laser2.png");
    speed = 10;
  }
  // Member Methods
  void display() {
    rectMode(CENTER);
    fill(255, 0, 0);
    rect(x, y, w, h);
    
    //imageMode(CENTER);
    //l1.resize(w, w);
    //image(l1, x, y);
  }

  void move() {
    y = y - speed;
  }

  boolean reachedTop() {
    if (y<0-10) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock r) {
    float d = dist(x,y,r.x,r.y);
    if(d<50) {
      return true;
    } else {
      return false;
    }
  }
}
