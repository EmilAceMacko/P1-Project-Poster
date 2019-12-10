/*
    Full resolution for test: 1080 x 1920 (rotated 90 degrees clock-wise by Windows).
    Resolution for development: 540 x 960 (the full resolution is 2.0x this resolution.).
*/

final float S = 1.0; // The global scale value for all drawing ("final" means it can't be changed when the program runs!)
// This means EVERYTHING DRAWN must have its coordinates multiplied by 'S'! Otherwise it will not scale when we change S to 2!
// This goes EXCEPT for when the number is directly factoring the width/height variables!

// Page:
int page = 1; // The current page being viewed.
int pageMin = 1; // The minimum page number that the user can go to.
int pageMax = 5; // The maximum page number that the user can go to.

// Page visuals:
int circleOpacity = 180;
float titleAnim = 0;
float titleAnimSpeed = 1.0 / 60.0;

// Page outliner:
float lineLength, lineX, lineY, lineWeight, lineAnim;
float dotRadius;

// Side button objects:
SideButton buttonR, buttonL;

// Color array (in hexadecimal form):
color colors[] = {
  #000000, // Black
  #FFFFFF, // White
  #610A59, // Text (darker red)
  #903A68, // Dark red
  #5D9ECC, // Blue
  #FFD3B5, // Light yellow
};
// Image array:
PImage images[]; // Images have to be loaded in setup().
// Font array:
PFont fonts[]; // Fonts also have to be loaded in setup().
int fontSize = 32;

// Page transition animation:
boolean pageMoving = false; // Whether we're currently transitioning to another page.
float anim = 0; // The animation timer for the page transition (goes from 0 to 1).
float animSpeed = 1.0/45.0; // The animation speed for the page transition (duration = 1.0 / frames, where 60 frames = 1 second).
int dir = 0; // Which direction we're travelling (1 = right, 0 = none, -1 = left).

int fade = 0; // The variable that controls the opacity of the fade-overlay (goes from 0 to 255, and back to 0);

void setup()
{
  //fullScreen();
  size(540, 960); // */ size(1080, 1920);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  noStroke();
  
  buttonL = new SideButton(0, height/2, -1);
  buttonR = new SideButton(width, height/2, 1);
  
  // Load images into the image array:
  images = new PImage[6];
  images[0] = loadImage("AAU_STUDENTERRAPPORT_white_rgb.png");
  images[1] = loadImage("BG_1.jpg");
  images[2] = loadImage("BG_2.jpg");
  images[3] = loadImage("BG_3.jpg");
  images[4] = loadImage("BG_4.jpg");
  images[5] = loadImage("BG_5.jpg");
  
  // Load fonts into the font array:
  fonts = new PFont[4];
  fonts[0] = createFont("verdana.ttf", fontSize, true); // Standard
  fonts[1] = createFont("verdanab.ttf", fontSize, true); // Bold
  fonts[2] = createFont("verdanai.ttf", fontSize, true); // Italics
  fonts[3] = createFont("verdanaz.ttf", fontSize, true); // Bold italics
  
  lineLength = width/2;
  lineX = width/2;
  lineY = height - 64 * S;
  lineWeight = 8*S;
  lineAnim = page;
  dotRadius = 16*S;
}


void draw()
{
  
  // Page transition code:
  if(pageMoving)
  {
    anim += animSpeed; // Increment from 0 to 1 by "animSpeed" per frame.
    lineAnim = page + anim * dir; // Set lineAnim to the current page, plus "anim" if "dir" is positive, or minus "anim" if "dir" is negative.
    
    if(anim >= 1) // If anim has reached 1, then the animation is over:
    {
      page += dir; // Set the current page to +1 or -1 depending on what direction we went.
      lineAnim = page; // Set "lineAnim" to the "page" value.
      
      // Reset variables:
      pageMoving = false; // We're no longer moving between pages.
      dir = 0; // No direction.
      anim = 0; // Reset animation value back to zero.
      buttonL.coolDown = buttonL.coolDownMax; // Add cooldown to the buttons so...
      buttonR.coolDown = buttonR.coolDownMax; // ... they can't be clicked for a little bit.
    }
  }
  
  
  // Front page animation code:
  if(round(lineAnim) == 1)
  {
    titleAnim += titleAnimSpeed;
    if(titleAnim >= 1.0) titleAnim = 0;
  }
  
  
  //----------------- Draw page:
  
  background(colors[3]);
  
  switch(round(lineAnim))
  {
    case(1): // Front page:
    {
      // Draw background image:
      image(images[1], 0, 0, width, height);
      
      // Draw AAU logo:
      image(images[0], width/2 - S*0.8*images[0].width/2, S*0.5*images[0].height/2, S*0.8*images[0].width, S*0.8*images[0].height);
      
      // Draw circles:
      fill(colors[5]);
      float sizeAnim = 1 - 0.1*easeSin(titleAnim*2);
      ellipse(width/2, 3*height/4, width*0.4*sizeAnim, width*0.2*sizeAnim);
      
      // Draw text:
      fill(colors[1]);
      textAlign(CENTER, CENTER);
      textFont(fonts[1], fontSize*S*2);
      text("Fremtidens\nteknologi", width/2, height/2-208*S);
      
      fill(colors[2]);
      textAlign(CENTER, CENTER);
      
      textFont(fonts[1], fontSize*S*2*sizeAnim);
      text("Prøv mig!", width/2, 3*height/4 - height*0.025*sizeAnim);
      textFont(fonts[0], fontSize*S*0.8*sizeAnim);
      text("Jeg er interaktiv!", width/2, 3*height/4 + height*0.05*sizeAnim);
      
      // Draw arrow:
      float posAnim = (0.5 - easeSin(titleAnim*2)) * width/8;
      fill(colors[5]);
      stroke(colors[5]);
      strokeWeight(16);
      strokeJoin(ROUND);
      rect(width/2 - 40*S + posAnim, height/2, 160*S, 64*S);
      triangle(width/2 + 40*S + posAnim, height/2 - 64*S, width/2 + 40*S + posAnim, height/2 + 64*S, width/2 + (120)*S + posAnim, height/2);
      
      noStroke();
      
      break;
    }
    
    case(2): // NFC page:
    {
      // Draw background image:
      image(images[2], 0, 0, width, height);
      
      // Draw circles:
      fill(colors[5], circleOpacity);
      circle(width/2, height/2, height/3);
      
      // Draw text:
      fill(colors[2]);
      rectMode(CORNER);
      
      textAlign(CENTER, CENTER);
      textFont(fonts[1], fontSize*S);
      text("Hvad er NFC?", width/2, height/2-196*S);
      
      textAlign(LEFT, TOP);
      textFont(fonts[0], fontSize*S*0.5);
      text("NFC står for “Near Field Communication”, eller Nærfeltskommunikation, som er en teknologi som de fleste allerede bruger i dagligdagen, til f.eks:", width/2 - 170*S, height/2 - 128*S, 340*S, 320*S);
      
      float pointSize = 3*S;
      
      circle(width/2 - 164*S, height/2 + 12*S, pointSize);
      text("Kontaktløs betaling med dankort", width/2 - 150*S, height/2);
      circle(width/2 - 164*S, height/2 + 42*S, pointSize);
      text("Nøglebrikker/nøglekort", width/2 - 150*S, height/2 + 30*S);
      circle(width/2 - 164*S, height/2 + 72*S, pointSize);
      text("Rejsekort", width/2 - 150*S, height/2 + 60*S);
      
      text("Denne teknologi har eksisteret længe, og den er sikker, fordi den kun kan kommunikerer indenfor meget korte afstande.", width/2 - 170*S, height/2 + 104*S, 340*S, 320*S);
      
      break;
    }
    
    case(3): // Implant page:
    {
      // Draw background image:
      image(images[3], 0, 0, width, height);
      
      // Draw circles:
      fill(colors[5], circleOpacity);
      circle(width/2, height/2, height/2.5);
      
      // Draw text:
      fill(colors[2]);
      rectMode(CORNER);
      
      textAlign(CENTER, CENTER);
      textFont(fonts[1], fontSize*S);
      text("Nye muligheder med NFC", width/2 - 160*S, height/2-420*S, 320*S, 300*S);
      
      textAlign(LEFT, TOP);
      textFont(fonts[0], fontSize*S*0.5);
      text("En ny mode indenfor NFC verdenen er at implanterer chippen direkte under huden, så man nemmere kan bruge den i dagligdagen. I Sverige er allerede over 4000 implanterede NFC chips i brug.\n"
      +"\nNår chippen sidder inde under huden, kan den bruges på samme måde som hvis den sad i et kort eller en nøglebrik, bortset fra, at den nu ikke kan mistes.\n"
      +"\nSelve chippen er mindre end de fleste tror, den er faktisk kun på størrelse med et riskorn. At få implanteret en NFC chip er ligesom at få taget en blodprøve. Og når den først er under huden, åbner man op for mange nye muligheder.", width/2 - 170*S, height/2 - 190*S, 340*S, 1000*S);
      
      break;
    }
    
    case(4): // Use page:
    {
      // Draw background image:
      image(images[4], 0, 0, width, height);
      
      // Draw circles:
      fill(colors[5], circleOpacity);
      circle(width/2, height/2, height/2.75);
      
      // Draw text:
      fill(colors[2]);
      rectMode(CORNER);
      
      textAlign(CENTER, CENTER);
      textFont(fonts[1], fontSize*S);
      text("Fremtidsmuligheder", width/2, height/2-250*S);
      
      textAlign(LEFT, TOP);
      textFont(fonts[0], fontSize*S*0.5);
      text("Med en NFC implantation, er fremtidsmulighederne store.\nI fremtiden, for eksempel:", width/2 - 160*S, height/2 - 190*S, 320*S, 320*S);
      
      float pointSize = 3*S;
      
      text("Kan de lange ventetider hos lægen forkortes, fordi din lægejournal allerede er klar på din NFC chip.\n"
      +"Kan man få hurtigere diagnosticering, da NFC chippen som sidder under huden, selv kan foretage målinger, og spare lægen og dig selv tiden.\n"
      +"Kan man få bedre hjælp ved nødsituationer, hvis der er nogen til at videreføre journal info fra NFC chippen via deres telefon til f.eks. alarmcentralen.", width/2 - 150*S, height/2 - 80*S, 320*S, 500*S);
      
      circle(width/2 - 164*S, height/2 - 68*S, pointSize);
      circle(width/2 - 164*S, height/2 + 12*S, pointSize);
      circle(width/2 - 164*S, height/2 + 118*S, pointSize);
      
      break;
    }
    
    case(5): // Conclusion/End page:
    {
      // Draw background image:
      image(images[5], 0, 0, width, height);
      
      // Draw AAU logo:
      image(images[0], width/2 + 45*S, height/2 + 240*S, S*0.8*images[0].width, S*0.8*images[0].height);
      
      // Draw circles:
      fill(colors[5], circleOpacity);
      ellipse(width/2, height/2 - 590*S, width/1.5, width/1.5);
      ellipse(width/2 + 125*S, height/2, width/3, width/3);
      ellipse(width/3 - 30*S, height/2 + 250*S, width/4.5, width/4.5);
      
      // Draw text:
      fill(colors[2]);
      rectMode(CORNER);
      
      textAlign(CENTER, CENTER);
      textFont(fonts[1], fontSize*S);
      text("Føler du dig klar?", width/2, height/2-320*S);
      
      textAlign(LEFT, TOP);
      textFont(fonts[0], fontSize*S*0.5);
      text("Fremtiden ser kun lysere ud fra nu af.\nKontakt os gerne for mere information om mulighederne med NFC implantationer.", width/2, height/2 - 80*S, 225*S, 500*S);
      
      text("Kontakt:\nTlf: 12 34 56 78\nE-mail: foobar@mail.net", width/2 - 220*S, height/2 + 210*S, 340*S, 320*S);
      
      break;
    }
  }
  
  rectMode(CENTER);
  
  
  
  //----------------- Draw fade:
  
  if(pageMoving) // If a page transition is happening:
  {
    // Use the easing function, and some math, to make the "fade" variable go smoothly from 0 to 255, and back to 0 (over the duration it takes "anim" to go from 0 to 1).
    fade = int(easeSin(anim*2) * 255);
    
    fill(colors[3], int(fade));
    rect(width/2, height/2, width, height); // Draw a rectangle with the background color (and the fade opacity) that encompasses the entire screen!
  }
  else fade = 0; // Set "fade" to 0 when the page is not moving/transitioning.
  
  
  //----------------- Update & draw side buttons:
  
  // Update side buttons:
  buttonL.update();
  buttonR.update();
  
  // Draw side buttons:
  buttonL.display();
  buttonR.display();
  
  
  //----------------- Draw page progress bar:
  stroke(colors[1]);
  strokeWeight(lineWeight);
  
  // Back-most line:
  line(lineX - lineLength/2, lineY, lineX + lineLength/2, lineY);
  noStroke();
  
  float lineNormal = (lineAnim % 1.0); // Get the "ratio" of how far between any two page-dots the dot should be. (E.g. if the dot is halfway between 2 and 3, then the lineAnim value is 2.5, and we want lineNormal to be 0.5.
  float lineEntryPoint = 0.1; // 10 percent, the point where the dot has fully disappeared from the page-dot and has begun travelling between page-dots.
  
  // Moving transition dot:
  fill(colors[1]);
  if(lineNormal > lineEntryPoint && lineNormal < 1 - lineEntryPoint) // If the dot is greater than 0.1 or less than 0.9, then draw it travelling along the line between the page-dots.
  {
    ellipse(lineX + (floor(lineAnim) + easeSin(lineAnim % 1.0) - 3) * lineLength/4, lineY, dotRadius*0.75, dotRadius*0.75);
  }
  
  // Background dots:
  for(int i = 1; i < 6; i++) // A regular for-loop, that runs 5 times.
  {
    ellipse(lineX + (i-3) * lineLength/4, lineY, dotRadius, dotRadius); // Draw each of the page-dots.
  }
  
  // Light-up dot:
  if(lineNormal < lineEntryPoint || lineNormal > 1-lineEntryPoint) // If the line-dot is close enough to a page-dot (closer than 10 percent)!
  {
    fill(colors[4]);
    float _r = dotRadius*0.75 * (1.0 - abs(0.5 - ((lineNormal - 0.5 + 2.0) % 1.0)) / lineEntryPoint); // Calculate the animated radius for the appearing/disappearing light-dot.
    ellipse(lineX + (round(lineAnim)-3) * lineLength/4, lineY, _r, _r); // Draw the light-dot with the calculated radius (and at the correct page-dot).
  }
}
