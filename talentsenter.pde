import processing.serial.*;

class Player {
  float x, y;
  PImage sprite; 
  int points;
  
  Player(){
    x = 50;
    y = height - 150;
    sprite = loadImage("sprite.png");
  }

  void draw() {
    // image(img, a, b)
    image(sprite, x, y, 50, 50);   
    text(points, 50,50);
  }
  
  void debug(){
    println("x=", x," y=",y);
  }
  
  void update(int a){
   
    float target = map(a, -1023, 1023, 0, width);
    float dx = target - x;
    x = x + 0.05*dx; 
  }
  
}

class Enemy {
  float x, y;
  PImage sprite; 
  float speed;
  float h, w;
  
  Enemy(){
    y = 20;
    x = random(400);
    speed = 1; 
    h = 20;
    w = 20;
    sprite = loadImage("pokeball.png");
  }
  
  void draw(){
    image(sprite, x, y, h, w);
  }
  
  void update(){
    y = y + speed; 
  }
  
  void collide(Player p){
    if(p.x <= x + w && p.x >= x - w){
      if(p.y <= y + h && p.y >= y - h){
        print("collision!");
        p.points = p.points + 1;
      }
    }
  }
  
}

Player bjorn;
Serial port;
PImage bg;

Enemy[] pokeballs = new Enemy[0];

void setup() {
  size(500, 500);
  bg = loadImage("bg.png");
 
  bjorn = new Player(); 
  printArray(Serial.list());
  port = new Serial(this, "/dev/cu.usbmodem1412", 115200);
  
  
}

void draw() {
  //background(120);
  image(bg, 0, 0, 500, 500);
  

  
  float b = random(1000);
  if(b < 10){
    Enemy pokeball = new Enemy();
    pokeballs = (Enemy[])append(pokeballs, pokeball);
  }
  
  for(int i = 0; i < pokeballs.length; i = i + 1){ 
    pokeballs[i].collide(bjorn);
    pokeballs[i].update();
    pokeballs[i].draw();
  }
  
  
  bjorn.draw();
  
  if(port.available() > 0){
    String buffer = port.readString();
    if(buffer != null){
      int a = int(buffer);
      bjorn.update(a);
      //println(buffer);
    }
  }
  
  
}