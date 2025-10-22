class EnemyShip {
  int x, y, w, h, health;
  ArrayList<EnemyLaser> shots = new ArrayList<EnemyLaser>();
  int shootTimer;
  SoundFile laserSound;
  color darkRed;
  color whiteC;
  color yellow;

  EnemyShip() {
    x = int(random(100, width - 100));
    y = -60;
    w = 80;
    h = 90;
    health = 100;
    shootTimer = millis() + int(random(1000, 2500));
    // Initialize colors inside constructor
    darkRed = color(150, 0, 0);
    whiteC  = color(240);
    yellow  = color(255, 220, 40);
  }


  // Pass PApplet instance from main sketch
  EnemyShip(PApplet parent) {
    x = int(random(100, parent.width - 100));
    y = -60;
    w = 80;
    h = 90;
    health = 100;
    shootTimer = parent.millis() + int(random(1000, 2500));

    // Load the sound using the parent sketch
    laserSound = new SoundFile(parent, "laser_sound.mp3");
  }

  void fireLaser() {
    shots.add(new EnemyLaser(x, y + h/2));
    laserSound.play();
  }


  // Shared initialization
  void initDefaults() {
    w = 80;
    h = 90;
    health = 100;
    shootTimer = millis() + int(random(1000, 2500));
  }

  void display() {
    pushMatrix();
    translate(x, y);

    // Flip the ship 180 degrees so it faces downwards
    rotate(PI);

    noStroke();

    // --- Main Hull ---
    fill(darkRed);
    beginShape();
    vertex(0, -h/2);        // top nose (after rotation this will point downward)
    vertex(w/2.2, h/3);     // right front wing
    vertex(w/4, h/2);       // right rear
    vertex(-w/4, h/2);      // left rear
    vertex(-w/2.2, h/3);    // left front wing
    endShape(CLOSE);

    // --- Central Cockpit ---
    fill(whiteC);
    ellipse(0, -h/6, w/3, h/4);

    // --- Accent Stripes ---
    fill(yellow);
    rectMode(CENTER);
    rect(0, h/8, w/6, h/3, 5);

    // --- Engine Glow (now visually on top after rotate) ---
    fill(yellow, 180);
    ellipse(-w/6, h/2 + 10, 15, 15);
    ellipse(w/6, h/2 + 10, 15, 15);
    fill(yellow, 80);
    ellipse(-w/6, h/2 + 10, 35, 35);
    ellipse(w/6, h/2 + 10, 35, 35);

    popMatrix();
  }

  void move() {
    y += 2 + level * 0.5; // moves faster each level
  }

  void update() {
    move();
    display();
    if (millis() > shootTimer) {
      // spawn lasers from the "bottom" of the ship (y + h/2)
      shots.add(new EnemyLaser(x, y + h/2));
      shootTimer = millis() + int(random(1500, 3000));
    }

    // Draw and update shots so they always behave correctly
    for (int i = shots.size()-1; i >= 0; i--) {
      EnemyLaser el = shots.get(i);
      el.display();
      el.move();
      if (el.offscreen()) {
        shots.remove(i);
      } else if (el.intersect(s1)) {
        s1.health -= 10;
        shots.remove(i);
      }
    }
  }

  boolean hit(Laser l) {
    float d = dist(x, y, l.x, l.y);
    return d < 40;
  }

  boolean offscreen() {
    return y > height + 50;
  }
}
