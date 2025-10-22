import processing.sound.*;

// Kai Li Cantwell | September 17, 2025 | SpaceGame
Spaceship s1;
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<PowerUp> powups = new ArrayList<PowerUp>();
Timer rockTimer, puTimer;
int score, rocksPassed;
PImage go1, bg1;
boolean play;
int level = 1;
int nextLevelScore = 500;
boolean bossActive = false;
Boss boss;
ArrayList<EnemyShip> enemies = new ArrayList<EnemyShip>();
Timer enemyTimer;
SoundFile laserSound;
int enemiesHit = 0;        // Enemy ships destroyed
int enemiesPassed = 0;     // Enemy ships that reach bottom
int rocksHit = 0;          // Rocks hit by lasers
int shotsFired = 0;  // add this for accuracy tracking
int shotsHit = 0;    // if you want to count how many lasers hit enemies or rocks




void setup() {
  size(800, 800);
  //fullScreen();
  background(22);
  s1 = new Spaceship();
  puTimer = new Timer(10000);
  puTimer.start();
  rockTimer = new Timer(1000);
  rockTimer.start();
  go1 = loadImage("GameOverSpace.png");
  bg1 = loadImage("SpaceGameStart.png");
  score = 0;
  rocksPassed = 0;
  play = false;
  enemyTimer = new Timer(4000); // enemies appear every 4 seconds
  enemyTimer.start();
  laserSound = new SoundFile(this, "laser_sound.mp3");
}

void draw() {
  //Start screen criteria
  if (!play) {
    startScreen();
  } else {
    background(22);


    //Distributes a rock on a timer
    if (puTimer.isFinished()) {
      powups.add(new PowerUp());
      puTimer.start();
    }
    //Display and Move powerups
    for (int i = 0; i<powups.size(); i++) {
      PowerUp pu = powups.get(i);
      pu.display();
      pu.move();

      //check bottom
      if (pu.reachedBottom()) {
        powups.remove(pu);
        i--;
      }
      // Check ship collision
      if (pu.intersect(s1)) {
        if (pu.type == 'h') {
          s1.health += 100;
        } else if (pu.type == 't') {
          s1.turretCount = min(s1.turretCount + 1, 5);
        } else if (pu.type == 'a') {
          s1.laserCount += 100;
        }
        powups.remove(i);
        i--;
        continue;
      }
    }

    //Distribute Stars
    stars.add(new Star());

    //Display and Remove stars
    for (int i = 0; i < stars.size(); i++) {
      Star star = stars.get(i);
      star.display();
      star.move();
      if (star.reachedBottom()) {
        stars.remove(star);
        i--;
      }
      println("Stars: " + stars.size());
    }

    //Distributes a rock on a timer
    if (rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start();
    }

    //Displays and moves all rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      rock.display();
      rock.move();

      if (s1.intersect(rock)) {
        rocks.remove(rock);
        score+=rock.diam;
        s1.health-=5;
      }

      if (rock.reachedBottom()) {
        rocksPassed++;
        rocks.remove(rock);
        i--;
      }
      println("Rocks: " + rocks.size());
    }

    // Level system
    if (score >= nextLevelScore && !bossActive) {
      level++;
      nextLevelScore += 500;
      if (level == 5) { // Boss appears at level 5
        bossActive = true;
        boss = new Boss();
      }
    }

    // Enemy spawning
    if (!bossActive && enemyTimer.isFinished()) {
      enemies.add(new EnemyShip());
      enemyTimer.start();
    }

    // Update enemies
    for (int i = enemies.size()-1; i >= 0; i--) {
      EnemyShip e = enemies.get(i);
      e.update();

      // Check if laser hits enemy
      for (int j = lasers.size()-1; j >= 0; j--) {
        Laser l = lasers.get(j);
        if (e.hit(l)) {
          lasers.remove(j);      // Remove laser
          enemies.remove(i);     // Remove enemy ship
          enemiesHit++;          // Count hit
          shotsHit++;
          break;                 // Stop checking other lasers for this enemy
        }
      }

      // Check if enemy passed bottom
      if (e.offscreen()) {
        enemies.remove(i);
        enemiesPassed++;         // Count passed
      }
    }


    // Boss battle
    if (bossActive) {
      boss.update();
      for (int j = lasers.size()-1; j >= 0; j--) {
        Laser l = lasers.get(j);
        if (boss.hit(l)) {
          boss.health -= 10;
          lasers.remove(j);
          score += 10;
        }
      }

      if (boss.health <= 0) {
        fill(255, 255, 0);
        textSize(50);
        textAlign(CENTER);
        text("YOU WIN!", width/2, height/2);
        noLoop();
      }
    }


    //Display and move lasers
    for (int i = 0; i < lasers.size(); i++) {
      Laser laser = lasers.get(i);
      for (int j=0; j<rocks.size(); j++) {
        Rock r = rocks.get(j);
        if (laser.intersect(r)) {
          lasers.remove(laser);
          r.diam -= 50;
          shotsHit++;                // counts as a hit
          rocksHit++;               // Count this rock hit
          if (r.diam<5) {
            rocks.remove(r);
          }
          score+=r.diam;
          break;
        }
      }
      
      laser.display();
      laser.move();
      if (laser.reachedTop()) {
        lasers.remove(laser);
      }
      println("Lasers: " + lasers.size());
    }

    checkLevelUp();

    //rock1.display();
    //rock1.move();

    s1.display();
    s1.move(mouseX, mouseY);

    infoPanel();
    //Game over criteria
    if (s1.health<1) {
      gameOver();
    }
  }
}

void mousePressed() {
  if (!play) {
    play = true;
    resetGame();
  } else {
    if (s1.fire()) {
      lasers.add(new Laser(s1.x, s1.y));
      s1.laserCount--;
      shotsFired++;
      laserSound.play();
    }
  }
}

void resetGame() {
  s1 = new Spaceship();
  rocks.clear();
  lasers.clear();
  stars.clear();
  powups.clear();
  score = 0;
  level = 1;
  rocksHit = 0;
  rocksPassed = 0;
  enemiesHit = 0;
  enemiesPassed = 0;
  shotsFired = 0;
  shotsHit = 0;
  loop();
}




void infoPanel() {
  //rectMode(CENTER);
  //fill(127, 127);
  //noStroke();
  //rect(width-123, height-680, width-570, 225);
  fill(255);
  textSize(30);
  text("InfoPanel", width-230, width-760, height-20);
  text("Score: " + score, width-230, width-675, height-20);
  text("Orbs Passed: " + rocksPassed, width-230, width-585, height-20);
  text("Orbs Hit: " + rocksHit, width-230, width-550, height-20);
  text("Enemies Hit: " + enemiesHit, width-230, width-520, height-20);
  text("Enemies Passed: " + enemiesPassed, width-230, width-490, height-20);
  text("Health: " + s1.health, width-230, width-645);
  text("Ammo: " + s1.laserCount, width-230, width-615, height-20);
  text("Level: " + level, width-230, width-460, height-20);
  //Health Bar
  //fill(255);
  //rect(50,height-100,100,10);
  //fill(255,0,0);
  //rect(50,height-100,s1.health,10);
}


void checkLevelUp() {
  // Level up every 2 enemy ships and 5 rocks
  if (enemiesHit >= level * 2 && rocksHit >= level * 5) {
    level++;
    enemiesHit = 0;   // reset counter for next level
    rocksHit = 0;     // reset counter for next level
    //make enemies spawn faster or move faster
    rockTimer.totalTime = max(200, rockTimer.totalTime - 100);  // rocks spawn faster
  }
}


void gameOver() {
  image(go1, 0, 0);
  background(go1);
  fill(255, 0, 0);
  textSize(75);
  text("GAME OVER", 120, 200);

  textSize(30);
  fill(255);
  text("Final Stats:", 120, 270);

  float accuracy = 0;
  if (shotsFired > 0) {
    accuracy = (float(shotsHit) / shotsFired) * 100;
  }

  text("Final Score: " + score, 120, 320);
  text("Level Reached: " + level, 120, 360);
  text("Orbs Hit: " + rocksHit, 120, 400);
  text("Orbs Passed: " + rocksPassed, 120, 440);
  text("Enemy Ships Hit: " + enemiesHit, 120, 480);
  text("Enemy Ships Passed: " + enemiesPassed, 120, 520);
  text("Shots Fired: " + shotsFired, 120, 560);
  text("Shots Hit: " + shotsHit, 120, 600);
  text("Accuracy: " + nf(accuracy, 0, 1) + "%", 120, 640);
  
  //textSize(30);
  //text("Final Stats:", width-740, width-600, height-20);
  //text("Score: " + score, width-740, width-565, height-20);
  //text("Orbs Passed: " + rocksPassed, width-740, width-535, height-20);
  //text("Health: " + s1.health, width-740, width-505);
  //text("Ammo: " + s1.laserCount, width-740, width-475, height-20);
  
  //textSize(24);
  //fill(200);
  //text("Click to Restart", 120, 700);
  noLoop();
}


void startScreen() {
  image(bg1, 0, 0);
  background(bg1);
  fill(0, 0, 255);
  textSize(50);
  text("Click to start!", width-730, width-400, height-20);
  if (mousePressed) {
    play = true;
  }
}
