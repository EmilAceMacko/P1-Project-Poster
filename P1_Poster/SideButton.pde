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
  
  int coolDown = 0;
  int coolDownMax = 30;
  
  SideButton(float _x, float _y, int _side)
  {
    super(_x, _y, 80, 80, 1);
    radius = w;
    visRadius = radius;
    side = _side; // -1 = left, 1 = right
    xStart = x;
    yStart = y;
    
    if((side == -1 && page <= pageMin) || (side == 1 && page >= pageMax))
    {
      moveAway = true;
      animAway = 1;
    }
  }
  
  void update()
  {
    if(coolDown > 0) coolDown--;
    
    
    if((side == -1 && page <= pageMin) || (side == 1 && page >= pageMax))
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
    
    // Check for mouse click collision via parent's update function:
    super.update();
    
    if(down && !pageMoving && coolDown <= 0)
    {
      pageMoving = true; // Trigger page transition.
      dir = side; // Which side to move 1 page over to.
    }
    
    
    // Button click animation:
    if(down && !moveAway) // If button is down:
    {
      clickFac = constrain(clickFac - clickSpeed, clickMin, clickMax);
    }
    else // Button is not down:
    {
      clickFac = constrain(clickFac + clickSpeed, clickMin, clickMax);
    }
    
    
    visRadius = radius * clickFac;
  }
  
  void display()
  {
    fill(#789ABC, 255);
    ellipse(x, y, visRadius, visRadius);
    
    fill(#CDEFFF, 255);
    triangle(x + visRadius/6 * -side, y, x + 4*visRadius/6 * -side, y + visRadius/3, x + 4*visRadius/6 * -side, y - visRadius/3);
    
  }
}
