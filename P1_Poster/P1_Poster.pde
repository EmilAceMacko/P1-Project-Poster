/*
    Full resolution for test: 1080 x 1920 (rotated 90 degrees clock-wise).
    Resolution for development: 540 x 960 (the full resolution is 2.0x this resolution.).
*/

final float S = 1.0; // The global scale value for all drawing ("final" means it can't be changed when the program runs!)
// This means EVERYTHING DRAWN must have its coordinates multiplied by 'S'! Otherwise it will not scale when we change S to 2!

// Page:
int page = 1;
int pageMin = 1;
int pageMax = 5;

// Page outliner:
float lineLength, lineX, lineY, lineWeight, lineAnim;
float dotRadius;

// Side buttons:
SideButton buttonR, buttonL;
// Images:
PImage images[];
// Colors:
color colors[] = {
  #000000, // Black
  #FFFFFF, // White
  
};


// Mouse click variables:
boolean clickStart = false;
boolean clickHold = false;
boolean clickEnd = false;


// Page transition animation:
boolean pageMoving = false; // Whether we're currently transitioning to another page.
float anim = 0; // The animation timer for the page transition (goes from 0 to 1).
float animSpeed = 1.0/30.0; // The animation speed for the page transition (duration = 1.0 / frames, where 60 frames = 1 second).
int dir = 0;

void setup()
{
  //fullScreen();
  size(540, 960);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  noStroke();
  
  
  // Image array:
  images = new PImage[1];
  images[0] = loadImage("test.jpg");
  
  
  buttonL = new SideButton(0, height/2, -1);
  buttonR = new SideButton(width, height/2, 1);
  
  
  lineLength = width/2;
  lineX = width/2;
  lineY = height - 64 * S;
  lineWeight = 8*S;
  lineAnim = page;
  dotRadius = 16*S;
}


void mousePressed() // This function runs for every frame where a mouse button is being held down.
{
  if(!clickHold) clickStart = true; // If we weren't already holding the button, then this is the first frame of the click/hold, so mark clickStart as true!
  clickHold = true; // Also mark clickHold as true, regardless of whether this is the beginning of the click/hold.
}
void mouseReleased() // This function runs only for the frame where a mouse button is released.
{
  clickEnd = true; // This is the end of the click/hold, so mark clickEnd as true.
  clickHold = false; // And mark clickHold as false, since we're no longer click-holding.
}


void draw()
{
  background(0);
  
  // Draw background image:
  image(images[0], 0, 0);
  
  
  // Page transition code:
  if(pageMoving)
  {
    anim += animSpeed;
    lineAnim = page + anim * dir;
    
    if(anim >= 1)
    {
      page += dir; // Move to page.
      lineAnim = page;
      
      // Reset variables:
      pageMoving = false;
      dir = 0;
      anim = 0;
      buttonL.coolDown = buttonL.coolDownMax;
      buttonR.coolDown = buttonR.coolDownMax;
    }
  }
  
  
  // Update side buttons:
  buttonL.update();
  buttonR.update();
  
  // Draw side buttons:
  buttonL.display();
  buttonR.display();
  
  
  //----------------- Page line:
  stroke(#3377FF);
  strokeWeight(lineWeight);
  
  // Background line:
  line(lineX - lineLength/2, lineY, lineX + lineLength/2, lineY);
  noStroke();
  
  float lineNormal = (lineAnim % 1.0);
  float lineEntryPoint = 0.1;
  
  // Moving transition dot:
  fill(#3377FF);
  if(lineNormal > lineEntryPoint && lineNormal < 1 - lineEntryPoint)
  {
    ellipse(lineX + (floor(lineAnim) + easeSin(lineAnim % 1.0) - 3) * lineLength/4, lineY, dotRadius*0.75, dotRadius*0.75);
  }
  
  // Background dots:
  for(int i = 1; i < 6; i++)
  {
    ellipse(lineX + (i-3) * lineLength/4, lineY, dotRadius, dotRadius);
  }
  
  // Light-up dot:
  if(lineNormal < lineEntryPoint || lineNormal > 1-lineEntryPoint) // If the line-dot is close enough to a page-dot:
  {
    fill(#FFFFFF);
    float _r = dotRadius*0.75 * (1.0 - abs(0.5 - ((lineNormal - 0.5 + 2.0) % 1.0)) / lineEntryPoint);
    ellipse(lineX + (round(lineAnim)-3) * lineLength/4, lineY, _r, _r);
  }
  
  
  // Reset click variables: (We're doing this at the end of the draw function to clean up these one-time click variables for the next frame! By clean up, I mean marking them as false)
  clickStart = false; // clickStart should only be true for the one frame where the click/hold begins, so mark it as false. If it WERE true before, then it has already had 1 frame to be true by now!
  clickEnd = false; // Same goes for clickEnd, it should only be true for one frame (and not multiple frames in a row).
  // clickHold is the ONLY one of these three variables that gets to be true for multiple frames at a time, so this variable is NOT marked false here. It's only ever marked false in the clickReleased() function above!
}
