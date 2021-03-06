/*
  Bubble Pop
  By Tino Zinyama
*/

// audio library import
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// game state enum
enum GameState{
  PREGAME,
  SHOOTER,
  INFLATOR,
  PAUSED,
  MODESELECT,
  GAMEOVER
}

// audio variables
Minim soundManager;
AudioPlayer backgroundSong;
AudioPlayer gunEffect;
AudioPlayer popEffect;

// time varibles
float time;
float timeDelta;
static final float MAXTIME = 30.0;

// score variables
int score;
int highScore;
int shooterHighScore = 0;
int inflatorHighScore = 0;

// Game object variables
Cannon player;
BulletManager bulletManager;
BubbleManager bubbleManager;
BubbleManager inflatableManager;

// Particla managers for different game stages
ParticleManager introParticles1;
ParticleManager introParticles2;
ParticleManager introParticles3;

ParticleManager backParticles1;
ParticleManager backParticles2;
ParticleManager backParticles3;
ParticleManager backParticles4;
ParticleManager backParticles5;

// color palete
color[] colors = {#3AAACF, #6E84D6, #35C0CD, #5EC4CD, #4284D3, #6899D3};

GameState gameState;
boolean isShooter; // flag to determine what mode game was in before being paused


void setup(){
  size (1280, 720);
  smooth();
  frameRate(60);
  noCursor();
  
  // audio variables
  soundManager = new Minim(this);
  backgroundSong = soundManager.loadFile("nightrave.mp3");
  gunEffect = soundManager.loadFile("shoot.mp3");
  popEffect = soundManager.loadFile("pop.mp3");
  backgroundSong.loop();
  
  // place player on a random location on screen
  player = new Cannon(random(100, width-100), random(300, height-100));
  
  bulletManager = new BulletManager(player);
  
  introParticles1 =  new ParticleManager(width/2, 50, 15);
  introParticles2 =  new ParticleManager(width/2 - 300, 400, 12);
  introParticles3 =  new ParticleManager(width/2 + 300, 400, 12);
  
  backParticles1 = new ParticleManager(0.1 * width, -100, 10);
  backParticles2 = new ParticleManager(0.3 * width, -100, 10);
  backParticles3 = new ParticleManager(0.5 * width, -100, 10);
  backParticles4 = new ParticleManager(0.7 * width, -100, 10);
  backParticles5 = new ParticleManager(0.9 * width, -100, 10);
  
  gameState = GameState.PREGAME;
  score = 0;
  highScore = 0;
  
  time = 0;
  timeDelta = 0.01666;  // approx time for each frame
  
  setupLevels();
}

void draw()
{
  background(0);
  gameManager();
}

void gameManager()
{
  if (gameState == GameState.PREGAME){
    preGame();
  }
  else if (gameState == GameState.MODESELECT){
    gameModeSelect();
  }
  else if (gameState == GameState.SHOOTER || gameState == GameState.INFLATOR){
    inGame();
  }
  else if (gameState == GameState.PAUSED){
    gamePaused();
  }
  else if (gameState == GameState.GAMEOVER){
    gameOver();
  }
}

void preGame(){
  introParticles1.run();
  introParticles2.run();
  introParticles3.run();
  
  noStroke();
  ellipseMode(CENTER);
  fill(#0B61A4);
  ellipse(width/2, 400, 600, 300);
  fill(#3F92D2);
  ellipse(width/2, 400, 570, 270);
  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("Bubble Wars", width/2, 350);
  textSize(10);
  fill(0);
  text("By Tino Zinyama", width/2 + 75, 375);
  fill(255);
  textSize(25);
  text("Press ENTER to Begin", width/2, 420);
    
  bubbleManager.run();
}

void gameModeSelect(){
  introParticles1.run();
  introParticles2.run();
  introParticles3.run();
  
  noStroke();
  ellipseMode(CENTER);
  fill(#0B61A4);
  ellipse(width/2, 400, 600, 300);
  fill(#3F92D2);
  ellipse(width/2, 400, 570, 270);
  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("Bubble Wars", width/2, 350);
  textSize(10);
  text("By Tino Zinyama", width/2 + 75, 375);
  
  //gun select options
  fill(0);
  textSize(25);
  text("Select Game Mode", width/2, 420);
  fill(255);
  textSize(18);
  text("1 : Bubble Shooter", width/2, 460);
  text("2 : Bubble Inflator", width/2, 490);
    
  bubbleManager.run(); 
}

void inGame(){
  time += timeDelta;
    
  if (time > MAXTIME + 0.25)
    gameState = GameState.GAMEOVER;

  backParticles1.run();
  backParticles2.run();
  backParticles3.run();
  backParticles4.run();
  backParticles5.run();
      
  bulletManager.run();
  bubbleManager.run();
  player.display();
  
  scoreManager();
}

void gamePaused(){
  backParticles1.run();
  backParticles2.run();
  backParticles3.run();
  backParticles4.run();
  backParticles5.run();
  
  introParticles2.run();
  introParticles3.run();
  
  scoreManager();
  
  noStroke();
  ellipseMode(CENTER);
  fill(#0B61A4);
  ellipse(width/2, 400, 600, 300);
  fill(#3F92D2);
  ellipse(width/2, 400, 570, 270);
  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("Game Paused", width/2, 350);
  textSize(25);
  text("Press ENTER To Continue", width/2, 420); 
}

void gameOver(){
  backParticles1.run();
  backParticles2.run();
  backParticles3.run();
  backParticles4.run();
  backParticles5.run();
  
  introParticles2.run();
  introParticles3.run();
  
  noStroke();
  ellipseMode(CENTER);
  fill(#0B61A4);
  ellipse(width/2, 400, 600, 300);
  fill(#3F92D2);
  ellipse(width/2, 400, 570, 270);
  
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  //choose which highScore to display
  text( (score >= highScore ? "Congratulations!" : "Game Over"), width/2, 350);
  textSize(25);
  text((score >= highScore ? "New High Score " : "Your Score ") + score, width/2, 410);
  fill(0);
  textSize(20);
  text("Press ENTER To Continue", width/2, 460);
}
 
void setupLevels(){  //Todo: make this into a class
  
  switch(gameState){
    
    case PREGAME:  //INTRO SCREEN
      bubbleManager = new BubbleManager(false);
      break;
   
    case SHOOTER:  //SHOOTER
      isShooter = true;
      bubbleManager = new BubbleManager(false);
      highScore = shooterHighScore;
      break;
      
    case INFLATOR: //INFLATOR
      isShooter = false;
      bubbleManager = new BubbleManager(true);  //create inflatable bubbles
      highScore = inflatorHighScore;
      break;

    default:
      break;
  }
}

void scoreManager()
{
  // score background
  noStroke();
  fill(#0B61A4);
  ellipseMode(CENTER);
  ellipse(0, 0, 300, 150);
  fill(#3F92D2);
  ellipse(0, 0, 280, 130);
  
  switch(gameState){
    case SHOOTER: //Bubble shooter mode
      if (score > shooterHighScore){
        shooterHighScore = score;
        highScore = shooterHighScore;
      }
      break;
    case INFLATOR: //Bubble Inflator Mode
      if (score > inflatorHighScore){
        inflatorHighScore = score;
        highScore = inflatorHighScore;
      }
      break;
   default:
     break;
  }
  
  //score text
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Score: " + score, 50, 15);
  //select which high score to display
  textSize(13);
  text("High Score: " + highScore, 50, 37);
  
  //time background
  noStroke();
  fill(#0B61A4);
  ellipseMode(CENTER);
  ellipse(width, 0, 300, 150);
  fill(#3F92D2);
  ellipse(width, 0, 280, 130);
  
  //time text
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Time: " + int(MAXTIME - time), width - 50, 25);
  
}

void mouseReleased(){
  if(gameState == GameState.SHOOTER || gameState == GameState.INFLATOR){
     player.shoot(); 
  }
}

void keyPressed(){
  
  if (key == ENTER || key ==  'g'){  //g for controller
    switch(gameState){
      case PREGAME:
        // start shooter mode
        gameState = GameState.MODESELECT;
        break;
      case SHOOTER:
        // pause the game
        gameState = GameState.PAUSED;
        break;
      case INFLATOR:
        // pause the game
        gameState = GameState.PAUSED;
        break;
      case PAUSED:
        //continue paused game
        gameState = (isShooter ? GameState.SHOOTER : GameState.INFLATOR);
        break;
      case GAMEOVER:
        // restart the game
        backgroundSong.close();
        setup();
      default:
        break;
    }
  }
  
  if (gameState == GameState.MODESELECT && (key == '1' || key == 'w')){ // w for controller
    //start bubble shooter mode
    gameState = GameState.SHOOTER;
    setupLevels();
  }
  else if (gameState == GameState.MODESELECT && (key == '2' || key == 'd')){ // d for controller
    //start bubble inflator mode
    gameState = GameState.INFLATOR;
    setupLevels();
  }
}

void stop(){
  //Close the sound channels
  backgroundSong.close();
  gunEffect.close();
  popEffect.close();
  soundManager.stop();
  super.stop();
}