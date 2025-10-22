class Spaceship {
  // Member Variables
  int x, y, w, health, laserCount, turretCount;
  // Constructor
  Spaceship() {
    x = width/2;
    y = height/2;
    w = 100;
    health = 100;
    laserCount = 450;
    turretCount = 1;
  }
  // Member Methods
  void display() {
    pushMatrix();
    translate(x, y);

    // Colors
    color grey = color(180, 180, 185);
    color navy = color(20, 40, 90);
    color yellow = color(255, 235, 40);

    // Ship body
    fill(grey);
    stroke(100);
    strokeWeight(2);
    beginShape();
    vertex(0, -60);  // nose
    vertex(35, 40);  // right wing tip
    vertex(20, 60);  // right bottom
    vertex(-20, 60); // left bottom
    vertex(-35, 40); // left wing tip
    endShape(CLOSE);

    // Cockpit (navy blue oval)
    fill(navy);
    noStroke();
    ellipse(0, -20, 25, 40);

    // Side panels (navy blue stripes on wings)
    fill(navy);
    rect(-27, 20, 12, 25, 3);
    rect(27, 20, 12, 25, 3);

    // Engine glow (electric yellow circle)
    fill(yellow);
    ellipse(-10, 62, 15, 15);
    ellipse(10, 62, 15, 15);

    // Glow effect
    noStroke();
    fill(yellow, 80);
    ellipse(-10, 62, 35, 35);
    ellipse(10, 62, 35, 35);

    popMatrix();
  }

  void move(int x, int y) {
    this.x = x;
    this.y = y;
  }

  boolean fire() {
    if(laserCount>0) {
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
