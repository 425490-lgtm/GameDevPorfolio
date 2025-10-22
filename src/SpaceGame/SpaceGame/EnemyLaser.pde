class EnemyLaser {
  int x, y, speed;
  EnemyLaser(int x, int y) {
    this.x = x;
    this.y = y;
    speed = 7;
  }
  void display() {
    fill(255, 255, 0);
    rectMode(CENTER);
    rect(x, y, 4, 10);
  }
  void move() {
    y += speed;
  }
  boolean offscreen() {
    return y > height;
  }
  boolean intersect(Spaceship s) {
    return dist(x, y, s.x, s.y) < 30;
  }
}
