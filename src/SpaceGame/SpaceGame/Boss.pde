class Boss {
  int x, y, health;
  ArrayList<EnemyLaser> shots = new ArrayList<EnemyLaser>();
  int shootTimer;

  Boss() {
    x = width / 2;
    y = 150;
    health = 1000;
    shootTimer = millis() + 1000;
  }

  void display() {
    pushMatrix();
    translate(x, y);
    fill(70, 100, 70);  // dark green
    rectMode(CENTER);
    rect(0, 0, 300, 120, 20);
    fill(180);
    rect(0, -40, 220, 40, 10);
    fill(255, 0, 0);
    ellipse(0, 0, 50, 50);
    popMatrix();

    // boss lasers
    for (int i = shots.size()-1; i >= 0; i--) {
      EnemyLaser el = shots.get(i);
      el.display();
      el.move();
      if (el.offscreen()) {
        shots.remove(i);
      } else if (el.intersect(s1)) {
        s1.health -= 15;
        shots.remove(i);
      }
    }
  }

  void update() {
    if (millis() > shootTimer) {
      for (int i = -1; i <= 1; i++) {
        shots.add(new EnemyLaser(x + i * 50, y + 60));
      }
      shootTimer = millis() + 800;
    }
    display();
  }

  boolean hit(Laser l) {
    float d = dist(x, y, l.x, l.y);
    return d < 150;
  }
}
