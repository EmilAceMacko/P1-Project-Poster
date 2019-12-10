// This class, "SideButton", extends the class "Button".
// This means it uses the Button class as a base, and EXTENDS it by adding its own variables and functions/methods.
class SideButton extends Button
{
  float radius;
  float clickFac = 1.0;
  float clickMin = 0.9;
  float clickMax = 1.0;
  float clickSpeed = 1.0 / 15.0;
  float visRadius;
  int side;
  
  float xStart, yStart;
  float animAway = 0;
  float animAwaySpeed = 1.0 / 8.0;
  boolean moveAway = false;
  
  float rayAnimMax = 2;
  float rayAnim = rayAnimMax;
  float rayAnimSpeed = 1.0 / 30.0;
  
  int coolDown = 0;
  int coolDownMax = 5;
  
  // Constructor for SideButton, sets up all our input parameters when we create an instance of SideButton.
  SideButton(float _x, float _y, int _side)
  {
    super(_x, _y, S*80, S*80, 1); // "super" in this context is the parent class "Button". Here we're calling the parent's constructor, so it can set up the parent's variables for this SideButton instance!
    // The rest of these variables below are unique to SideButton, and aren't part of the parent class Button.
    radius = w;
    visRadius = radius;
    side = _side; // -1 = left, 1 = right
    xStart = x;
    yStart = y;
    
    // Make sure the button starts as "moved away" depending on what side it's on (and if we're on the last/first page!)
    if((side == -1 && page <= pageMin) || (side == 1 && page >= pageMax))
    {
      moveAway = true; // This being true means the button should move away if it's inside the view (or keep being away if it's already outside the view!)
      animAway = 1; // Fully animated away to outside the view.
    }
  }
  
  // This function/method already exists in the parent class Button. But we want it to do more than originally, so we make it here in SideButton as well. This function/method is then run instead of the one in the parent!
  void update()
  {
    // Reduce cooldown timer:
    if(coolDown > 0) coolDown--;
    
    // Determine whether to move away (depending on page and side):
    if((side == -1 && round(lineAnim) <= pageMin) || (side == 1 && round(lineAnim) >= pageMax))
    {
      moveAway = true;
    }
    else moveAway = false;
    
    // Button go-away animation:
    if(moveAway)
    {
      animAway = constrain(animAway + animAwaySpeed, 0, 1);
    }
    else
    {
      animAway = constrain(animAway - animAwaySpeed, 0, 1);
    }
    x = xStart + side * animAway * radius;
    
    
    // Front page ray animation:
    if(rayAnim < 2) rayAnim += rayAnimSpeed; // Increment ray animation, makes the animation play!
    
    if(side == 1 && round(lineAnim) == pageMin) // If right button, and on the first page:
    {
      if(rayAnim >= rayAnimMax) rayAnim = 0; // And if ray animation has reached the maximum value, reset it back to zero so it plays again!
    }
    
    
    // Check for mouse click collision via parent's update function:
    super.update(); // "super" in this context, is the parent class "Button". The code inside the original function/method inside the parent won't run, until we TELL it to with this "super.update()" !
    
    if(down && !pageMoving && coolDown <= 0)
    {
      pageMoving = true; // Trigger page transition.
      dir = side; // Which side to move 1 page over to.
    }
    
    
    // Button click animation:
    if(down && !moveAway) // If button is down (and it's not moved away):
    {
      // Set clickFac to "clickFac - clickSpeed" (basically subtracting clickSpeed from clickFac), EXCEPT this setup
      // allows us to constrain the minimum and maximum allowed value, so clickFac never goes beyond clickMin and clickMax.
      clickFac = constrain(clickFac - clickSpeed, clickMin, clickMax); // clickFac shrinks until it hits clickMin.
    }
    else // Button is not down (or it is moved away):
    {
      // Same here as above, except this time we're adding clickSpeed to clickFac, still keeping
      // the result within the range of clickMin and clickMax.
      clickFac = constrain(clickFac + clickSpeed, clickMin, clickMax); // clickFac grows until it hits clickMax.
    }
    
    
    visRadius = radius * clickFac; // Make sure the "visual radius" gets affected by clickFac. visRadius is the true radius of the button, multiplied with clickFac (which makes visRadius shrink and grow!)
  }
  
  // This function/method also exists inside the parent class Button, however that function/method is blank, so we don't need a "super.display()" anywhere in here, since that would do nothing!
  void display()
  {
    fill(colors[1], 255);
    ellipse(x, y, visRadius, visRadius); // The circular button, using visRadius and not the normal radius!
    
    fill(colors[4], 255);
    triangle(x + visRadius/6 * -side, y, x + 4*visRadius/6 * -side, y + visRadius/3, x + 4*visRadius/6 * -side, y - visRadius/3); // The triangle arrow, also scaled according to visRadius!
    
    
    // Draw animated rays:
    if(rayAnim > 0 && rayAnim < 1)
    {
      pushMatrix();
      
      stroke(colors[1]);
      strokeWeight(radius/16);
      translate(x, y);
      rotate(-2*HALF_PI/3);
      for(int i = 0; i < 7; i++)
      {
        line(-radius*(1.25 + 0.25*easeSin(max(rayAnim*2-1, 0))), 0, -radius*(1.25 + 0.25*easeSin(min(rayAnim*2, 1.0))), 0);
        rotate(HALF_PI/4.5);
      }
      popMatrix();
    }
  }
}
