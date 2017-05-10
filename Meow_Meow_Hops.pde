import processing.serial.*;
import processing.sound.*;
Serial port;
SoundFile file;
String audioName = "no_problem.mp3";
String path;
int val;

PImage backImg,catImgMenu, waterImg1,waterImg2,waterImg3, startImg,coin,cloud;    //game assets and menu screens
PImage orig,squid,jake,pusheen,tiger,zombie,bowtie,crown,pikachu,fabulous;   //cat sprites
PImage origSad,pusheenSad,tigerSad,bowtieSad,zombieSad,pikachuSad,crownSad,fabulousSad; //sad cat sprites
PFont highScoreFont,scoreFont;
int inc = 0;
int vx_water = 0;
int vx_bg = 0;
int vx_cloud;
int gdelay = 50;
int ground = 450;
int y_water = ground +130;
int gamestate = 1, score = 0, highScore = 0, x = 0, y=ground, vy = 0;
int wx[] = new int[1], wy[] = new int[1],wtype[] = new int[2];
int cx[] = new int[10], cy[] = new int[10];
int cloudX[] = new int [2], cloudY[]=new int[2];
boolean isMoving=true;
boolean isDrowning = false;
boolean isDoubleJump = false;
int catSkin = 9;

void setup() {
port = new Serial(this, Serial.list()[0], 9600);
 
 loadMusic();
  size(1280,760);
  fill(0);
  textSize(30);  

  loadImages();

 scoreFont = createFont("sketches bold",80);

 
 //String[] fontList = PFont.list();
  //printArray(fontList);

  
}
void draw() { //runs 60 times a second

 val=0;
  
  
 
  increaseDifficulty();

  readFromPort();

  if(gamestate == 0) {
    delay(gdelay);
    imageMode(CORNER);
    image(backImg, x, 0);   //displays background
    image(backImg, x+backImg.width, 0);   //displays background
    
    
    
   setDrowning();    
    
   readFromSensor();
   setMovement();
   setGround();
    
    
    
    
    x -= vx_bg; //moves the background
   
    y+=vy;    //makes the cat jump

    
    
    
    if(y<450){ //if cat is jumping
    vy += 1;  //gravity, essentially
    y += vy;  //moves the thing down
    }
    
    if(x == -1200) x = 0; //i think this loops the background
    
    drawClouds();
    drawCoins();
    drawWater();
    drawCat();
    drawText();
    
   
  
  }
  else {
    showMenu();
    drawOutfit();
    changeOutfit();
    
    
    
    }
  
    
  
}

void checkCollision(int i){
  
 
    if(y>800) gamestate =1;
    
    
   if ((width/2)-(wx[i]-80)>0 && (width/2)-(wx[i]+getWaterLength(wtype[i]))<0 && y==ground){
      isDrowning=true;
      isMoving=false;
   }
}
void drawCoins(){
  
  
   for(int i = 0 ; i < 10; i++) {
     image(coin,cx[i],cy[i]);
     if (cx[i] < 0-50) {cx[i]= width; cy[i] = (int)random(200,ground);}
     cx[i] -= vx_water;
     coinCollision();
   }
   
   
 
}

void drawOutfit(){
 switch(catSkin){
    case 1:  image(orig, width/2-40, 475 );   
              break;
    case 2:  image(bowtie, width/2 - 40, 475  );   
              break;
    
    case 3:  image(fabulous, width/2 - 40, 475  );   
              break;
              
   
    case 4:   image(crown, width/2 - 40, 475  );   
              break;
    case 5:   image(pusheen, width/2 - 40, 475  );   
              break;
    case 6:   image(tiger, width/2 - 40, 475  );   
              break;
    case 7:   image(pikachu, width/2 - 40, 475  );   
              break;
    case 8:   image(jake, width/2 - 40, 475  );   
              break;
    case 9:   image(zombie, width/2 - 40, 475  );   
              break;
    case 10:  image(squid, width/2 - 40, 475  );   
              break;
    default:  image(orig, width/2 - 40, 475  );   
              break;
  } 
}

void readFromPort(){
while (port.available() > 0) {   ////reads serial input
    val = port.read();
  }
}
  
  
void drawText(){
    
   fill(94,58,18);
   textFont(scoreFont);
   text(""+score, width/2-30, 90);        //scoring!
   
   text("HS:"+highScore, 1000, 90);
 
  }
  
  
  void readFromSensor(){
     if(val==2) {
      if( y ==ground || isDoubleJump){
            isMoving = true;
            vy = -14;
            y-=1;
          }
          isDoubleJump=true;
    }
   
    if(val==3 || isDoubleJump) {
      if( y ==ground){
            isMoving = true;
            vy = -20;
            y-=1;
          }
          isDoubleJump=true;
    }
  }
  
void drawCat(){
  
  if(!isDrowning){
  switch(catSkin){
    case 1:  image(orig, width/2,y );   
              break;
    case 2:  image(bowtie, width/2,y );   
              break;
    
    case 3:  image(fabulous, width/2,y );   
              break;
              
   
    case 4:   image(crown, width/2,y );   
              break;
    case 5:   image(pusheen, width/2,y );   
              break;
    case 6:   image(tiger, width/2,y );   
              break;
    case 7:   image(pikachu, width/2,y );   
              break;
    case 8:   image(jake, width/2,y );   
              break;
    case 9:   image(zombie, width/2,y );   
              break;
    case 10:  image(squid, width/2,y );   
              break;
    default:  image(orig, width/2,y );   
              break;
  }
  }
  else{
    switch(catSkin){
   case 1:  image(origSad, width/2,y );   
              break;
    case 2:  image(bowtieSad, width/2,y );   
              break;
    
    case 3:  image(fabulousSad, width/2,y );   
              break;
              
   
    case 4:   image(crownSad, width/2,y );   
              break;
    case 5:   image(pusheenSad, width/2,y );   
              break;
    case 6:   image(tigerSad, width/2,y );   
              break;
    case 7:   image(pikachuSad, width/2,y );   
              break;
    case 8:   image(jake, width/2,y );   
              break;
    case 9:   image(zombieSad, width/2,y );   
              break;
    case 10:  image(squid, width/2,y );   
              break;
    default:  image(origSad, width/2,y );   
              break;
  }
  }
    
    
}

void increaseDifficulty(){
  if (score%10==0 && score>9){
    inc+=0;
  }
  }

void loadMusic(){
   path = sketchPath(audioName);
   file = new SoundFile(this, path);
   file.play();
}

void coinCollision(){
  
  for( int i = 0 ; i < 10; i++){
  if(abs(width/2+100 -cx[i])<100 && abs( y+50- cy[i])<100){
        score +=1;
       highScore = max(score, highScore); 
      cy[i]=1500;
  }
      
  }
}

void drawWater(){
  
  
  
  for(int i = 0 ; i < 1; i++) {
      
      imageMode(CORNERS); 
      
      if (wtype[i]==1)  image(waterImg1, wx[i], wy[i]);    
      else if (wtype[i] ==2) image(waterImg2, wx[i], wy[i]);   
      else image(waterImg3, wx[i], wy[i]);  
      
      
      if(wx[i] < 0 - getWaterLength(wtype[i])) {                                              //if the water edge disappears, it respawns on the right
        wy[i] = y_water;
        wx[i] = width;
        wtype[i] = (int) random(1,4);
      }
      if(wx[i] == width/2) highScore = max(++score, highScore);   //score is incremented when pole passes through center.
      
      checkCollision(i);     //collision detection
      
      wx[i] -= vx_water;        //speed of the poles moving to the left
 }
}

int getWaterLength(int x){
  switch(x){
  case 1: return 120;
  case 2: return 200;
  case 3: return 400;
  default: return 0;
  }
}
  
 
void showMenu(){
    imageMode(CENTER);
    image(startImg, width/2,height/2);
    textFont(scoreFont);
    text("High Score:"+highScore, 420, 750);
   
}

void loadImages(){
  
    
    backImg =loadImage("bg.png");
    backImg.resize(1280,800);
    waterImg1 =loadImage("small water.png");
    waterImg2 =loadImage("medium_water.png");
    waterImg3 =loadImage("big water.png");    
    startImg=loadImage("menu.png");
    startImg.resize(1280,800);
    orig =loadImage("orig.png");  // loads custom images into the game
    orig.resize(240,160);
   origSad = loadImage("origSad.png");
   origSad.resize(240,160);
    squid =loadImage("squid.png"); 
    squid.resize(240,160);
    jake =loadImage("jake.png"); 
    jake.resize(240,160);
    pusheen =loadImage("pusheen.png"); 
    pusheen.resize(240,160);
    pusheenSad =loadImage("pusheenSad.png");  // loads custom images into the game
    pusheenSad.resize(240,160);
    tigerSad =loadImage("tigerSad.png");  // loads custom images into the game
    tigerSad.resize(240,160);
    tiger =loadImage("tiger.png");  // loads custom images into the game
    tiger.resize(240,160);
    zombieSad =loadImage("zombieSad.png");  // loads custom images into the game
    zombieSad.resize(240,160);
    zombie =loadImage("zombie.png");  // loads custom images into the game
    zombie.resize(240,160);
    bowtieSad =loadImage("bowtieSad.png");  // loads custom images into the game
    bowtieSad.resize(240,160);
    bowtie =loadImage("bowtie.png");  // loads custom images into the game
    bowtie.resize(240,160);
    tigerSad =loadImage("tigerSad.png");  // loads custom images into the game
    tigerSad.resize(240,160);
    tiger =loadImage("tiger.png");  // loads custom images into the game
    tiger.resize(240,160);
    fabulousSad =loadImage("fabulousSad.png");  // loads custom images into the game
    fabulousSad.resize(240,160);
    fabulous =loadImage("fabulous.png");  // loads custom images into the game
    fabulous.resize(240,160);
    pikachuSad =loadImage("pikachuSad.png");  // loads custom images into the game
    pikachuSad.resize(240,160);
    pikachu =loadImage("pikachu.png");  // loads custom images into the game
    pikachu.resize(240,160);
    crownSad =loadImage("crownSad.png");  // loads custom images into the game
    crownSad.resize(240,160);
    crown =loadImage("crown.png");  // loads custom images into the game
    crown.resize(240,160);
    coin = loadImage("coin.png");
    cloud = loadImage("cloud.png");
    
  
}

void setMovement(){
 if(isMoving){
        vx_water = 50+inc;
        vx_bg = 50+inc;
        vx_cloud = 3;
    }
    else{
      vx_water = 0;
      vx_bg = 0;
      vx_cloud = 0;
    }
    
}

void setDrowning(){
  if(isDrowning){
      vy+=1;
      y+=vy;
    }
}

void setGround(){
  if(!isDrowning){
      
          if(y>ground) {     //stops the cat from going down the floor
            vy=0;
            y=ground;
            isDoubleJump=false;
          }
    }
}


void changeOutfit(){
  if(val ==2 ) catSkin=(catSkin+1)%10;
  else if(val == 3)
  mousePressed();
}

  
  
void mousePressed() {
  
   isMoving = true;
  if(gamestate==1) {
    wx[0] = 1200;
    wy[0] = y_water;
    wtype[0] = 3;
    wx[0] = 1800;
    wy[0] = y_water;
    wtype[0] = 3;
    
    cloudX[0] = 500; cloudY[0] = (int)random(100,400);
    cloudX[1] = 1000; cloudY[1] = (int)random(100,400);
    
  
    cx[0] =1200; cy[0]=(int)random(200,ground);
    cx[1] =1300; cy[1]=(int)random(200,ground);
    cx[2] =1400; cy[2]=(int)random(200,ground);
    cx[3] =1500; cy[3]=(int)random(200,ground);
    cx[4] =1600; cy[4]=(int)random(200,ground);
    cx[5] =1700; cy[5]=(int)random(200,ground);
    cx[6] =1800; cy[6]=(int)random(200,ground);
    cx[7] =1900; cy[7]=(int)random(200,ground);
    cx[8] =2000; cy[8]=(int)random(200,ground);
    cx[9] =2100; cy[9]=(int)random(200,ground);

  
    x = gamestate = score = 0;
    isDrowning=false;
    delay(600);
    
  }
}

void drawClouds(){
  
  for(int i=0; i<2;i++){
    image(cloud,cloudX[i],cloudY[i]);
    if(cloudX[i] < 0-200) {cloudX[i] = width; cloudY[i] = (int)random(100,400);}
    cloudX[i]-=vx_cloud;
  }
  
}

void keyPressed(){
  if(key=='w'){
    isMoving = true;
  }
  if( y ==ground || isDoubleJump){
          if(key=='q'){
            vy = -20;
            y-=1;
          }
          if(key=='e'){
            vy = -14;
            y-=1;
          }
          isDoubleJump=true;
  }

  if (keyCode == 37) catSkin = catSkin-1;
  if (keyCode == 39) catSkin = (catSkin+1)%11;
}
