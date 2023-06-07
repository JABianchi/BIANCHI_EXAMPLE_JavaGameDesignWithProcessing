/* Game Class Starter File
 * Authors: Joel A. Bianchi
 * Last Edit: 6/6/2023
 */

//import processing.sound.*;

//GAME VARIABLES
private int msElapsed = 0;
String titleText = "Zapdos in the Sky";
String extraText = "Watch out for Articuno";

//Screens
Screen currentScreen;
World currentWorld;
Grid currentGrid;

//Splash Screen Variables
Screen splashScreen;
String splashBgFile = "images/zapdos_splash.jpg";
PImage splashBg;

//Sky Screen Variables
Grid skyGrid;
String skyBgFile = "images/sky.png";
PImage skyBg;

PImage player1;
String player1File = "images/zapdos.png";
int player1Row = 3;
int player1Col = 4;
int health = 3;

PImage enemy;
AnimatedSprite enemySprite;

AnimatedSprite exampleSprite;
boolean doAnimation;

//EndScreen variables
World endScreen;
PImage endBg;
String endBgFile = "images/youwin.png";

//Example Variables
//HexGrid hGrid = new HexGrid(3);
//SoundFile song;


//Required Processing method that gets run once
void setup() {

  //Match the screen size to the background image size
  size(1500,500);
  
  //Set the title on the title bar
  surface.setTitle(titleText);

  //Load BG images used
  splashBg = loadImage(splashBgFile);
  splashBg.resize(1500,500);
  skyBg = loadImage(skyBgFile);
  skyBg.resize(1500,500);
  endBg = loadImage(endBgFile);
  endBg.resize(1500,500);

  //setup the screens/worlds/grids in the Game
  splashScreen = new Screen("splash", splashBg);
  skyGrid = new Grid("sky", skyBg, 5,15);
  endScreen = new World("end", endBg);
  currentScreen = splashScreen;

  //setup the sprites  
  player1 = loadImage(player1File);
  player1.resize(skyGrid.getTileWidthPixels(),skyGrid.getTileHeightPixels());
  // enemy = loadImage("images/articuno.png");
  // enemy.resize(100,100);
  enemySprite = new AnimatedSprite("sprites/ship.png", "sprites/ship.json");
  enemySprite.resize(75,50);
  exampleSprite = new AnimatedSprite("sprites/horse_run.png", "sprites/horse_run.json");
  exampleAnimationSetup();

  //add sprites to the Screens
  System.out.println("Adding sprites to sky world...");
  // skyGrid.addSpriteCopyTo(enemySprite, 1000,100);
  // skyGrid.addSpriteCopyTo(enemySprite, 900, 400);
  skyGrid.printSprites();
  System.out.println("Done adding sprites to sky world..");


  
  //Other Setup
  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();
  
  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image
  println("Game started...");

}

//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {

  updateTitleBar();

  //handle sprites on screen
  if (msElapsed % 300 == 0) {
    populateSprites();
    moveSprites();
  }
  updateScreen();
  
  //check for end of game
  if(isGameOver()){
    endGame();
  }
  
  //handle timing
  msElapsed +=100;
  skyGrid.pause(100);

}

//Known Processing method that automatically will run whenever a key is pressed
void keyPressed(){

  //check what key was pressed
  System.out.println("Key pressed: " + keyCode); //keyCode gives you an integer for the key

  //What to do when a key is pressed?
  
  //set [W] key to move the player1 up
  if(player1Row !=0 && keyCode == 87){

    //Erase image from previous location
    GridLocation oldLoc = new GridLocation(player1Row, player1Col);
    skyGrid.clearTileImage(oldLoc);

    //change the field for player1Row
    player1Row--;

  }

  //set [RIGHT] key to move the player1 up
  if(player1Col !=  skyGrid.getNumCols()-1 && keyCode == 39){

    //Erase image from previous location
    GridLocation oldLoc = new GridLocation(player1Row, player1Col);
    skyGrid.clearTileImage(oldLoc);

    //change the field for player1Col
    player1Col++;
  }

}

//Known Processing method that automatically will run when a mouse click triggers it
void mouseClicked(){
  
  //check if click was successful
  System.out.println("Mouse was clicked at (" + mouseX + "," + mouseY + ")");
  if(currentGrid != null){
    System.out.println("Grid location: " + currentGrid.getGridLocation());
  }

  //what to do if clicked? (Make player1 jump back)
  GridLocation clickedLoc = skyGrid.getGridLocation();
  GridLocation player1Loc = new GridLocation(player1Row,player1Col);
  
  if(clickedLoc.equals(player1Loc)){
    player1Col--;
  }

  //Toggle the animation on & off
  doAnimation = !doAnimation;
  System.out.println("doAnimation: " + doAnimation);
  if(currentGrid != null){
    currentGrid.setMark("X",currentGrid.getGridLocation());
  }

}




//------------------ CUSTOM  METHODS --------------------//

//method to update the Title Bar of the Game
public void updateTitleBar(){

  if(!isGameOver()) {
    //set the title each loop
    surface.setTitle(titleText + "    " + extraText + " " + health);

    //adjust the extra text as desired
  
  }

}

//method to update what is drawn on the screen each frame
public void updateScreen(){

  //Update the Background
  background(currentScreen.getBg());

  //splashScreen update
  if(splashScreen.getScreenTime() > 3000 && splashScreen.getScreenTime() < 5000){
    currentScreen = skyGrid;
  }

  //skyGrid Screen Updates
  if(currentScreen == skyGrid){
    currentGrid = skyGrid;

    //Display the Player1 image
    GridLocation player1Loc = new GridLocation(player1Row,player1Col);
    skyGrid.setTileImage(player1Loc, player1);
      
    //update other screen elements
    skyGrid.showSprites();
    skyGrid.showImages();
    skyGrid.showGridSprites();

    checkExampleAnimation();
    
  }

  //if


}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){

  //What is the index for the last column?
  int lastCol = skyGrid.getNumCols()-1;

  //Loop through all the rows in the last column
  for(int r=0; r<skyGrid.getNumRows(); r++){

    //Generate a random number
    double rando = Math.random();

    //10% of the time, decide to add an image to a Tile
    if(rando < 0.1){
      //skyGrid.setTileImage(new GridLocation(r,lastCol), enemy);
      //System.out.println("Populating in row " + r);
      skyGrid.setTileSprite(new GridLocation(r, lastCol), enemySprite);
    }
  }
}

//Method to move around the enemies/sprites on the screen
public void moveSprites(){

  //loop through all of the grid tiles
  for(int r=0; r<skyGrid.getNumRows(); r++){
    for (int c=0; c<skyGrid.getNumCols(); c++){

      //Store GridLocation
      GridLocation loc = new GridLocation(r,c);

      //clear out the horses in the first column
      if(c==0){
        skyGrid.clearTileSprite(loc);
      }

      //only move if i'm not in the first column
      if(c!=0){
        GridLocation nextLoc = new GridLocation(r,c-1);

        //check if collision with player1
        checkCollision(loc, nextLoc);

        //check if there is an image/sprite
        if(skyGrid.hasTileSprite(loc)){
          //move the sprite to the new location
          skyGrid.setTileSprite( nextLoc, skyGrid.getTileSprite(loc) );

          //animate the sprite!
          skyGrid.getTileSprite(nextLoc).animate(1.0);
          
          //clear the sprite from old loc
          skyGrid.clearTileSprite(loc);
        }
      }
    }
  }

}


//Method to check if there is a collision between Sprites on the Screen
public boolean checkCollision(GridLocation loc, GridLocation nextLoc){

  //check current location first
  PImage image = skyGrid.getTileImage(loc);
  AnimatedSprite sprite = skyGrid.getTileSprite(loc);
  if(image == null && sprite == null){
    return false;
  }

  //check next location
  PImage nextImage = skyGrid.getTileImage(nextLoc);
  AnimatedSprite nextSprite = skyGrid.getTileSprite(nextLoc);
  if(nextImage == null && nextSprite == null){
    return false;
  }

  //check if enemy runs into player
  if(enemySprite.equals(sprite) && player1.equals(nextImage)){
    System.out.println("EnemySprite hits Zapdos");

    //clear out the enemy if it hits the player
    skyGrid.clearTileSprite(loc);

    //lose health
    health--;
  }

  //check if a player collides into enemy
  if(player1.equals(image) && enemySprite.equals(nextSprite)){
    System.out.println("EnemySprite ran into Zapdos!");

    //Remove the image at that original location using the clearTileImage() or clearTileSprite() method from the Grid class.
    skyGrid.clearTileSprite(nextLoc);

    //Lose 1 Health from player1
    health--;
  }

  return true;
}

//method to indicate when the main game is over
public boolean isGameOver(){
  if(health <0){
    return true;
  }
  return false; //by default, the game is never over
}

//method to describe what happens after the game is over
public void endGame(){
    System.out.println("Game Over!");

    //Update the title bar

    //Show any end imagery
    currentScreen = endScreen;
    //image(endBg, 100,100);

}

//example method that creates 1 horse run along the screen
public void exampleAnimationSetup(){  
  int i = 2;
  exampleSprite = new AnimatedSprite("sprites/horse_run.png", 50.0, i*75.0, "sprites/horse_run.json");
  exampleSprite.resize(200,200);
}

//example method that animates the horse Sprites
public void checkExampleAnimation(){
  if(doAnimation){

    exampleSprite.animateHorizontal(5.0, 1.0, true);
    System.out.println("animating!");
  }
}
