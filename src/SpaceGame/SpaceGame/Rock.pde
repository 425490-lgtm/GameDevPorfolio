class Rock {
  // Member Variables
  int x, y, diam, speed;
  PImage r1;

  // Constructor
  Rock() {
    x = int(random(width));
    y = -100;
    diam = int(random(50, 100));
    speed = int(random(1, 10));
    if (random(10)>6.6) {
      r1 = loadImage("PurpleOrb.png");
    } else if (random(10)>5.0) {
      r1 = loadImage("OrangeOrb.png");
    } else {
      r1 = loadImage("GreenDisk.png");
    }
  }
  // Member methods
  void display() {
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
}
