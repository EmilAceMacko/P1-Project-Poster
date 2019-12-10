// The class "Button" is a basic button class that isn't meant to exist on its own. But other button classes can use this class as a template if they need the properties of a Button!
// This was made in case we needed different types of buttons doing different things.
class Button
{
  float x, y, w, h;
  int shape; // The shape of the button. 0 == Square, and 1 == Circle (though actually, ANY other value than zero is considered a circle!)
  boolean down = false; // Whether the button is held down.
  
  Button(float _x, float _y, float _w, float _h, int _shape)
  {
    x = _x; // X-coordinate of the button's center.
    y = _y; // Y-coordinate of the button's center.
    w = _w; // Width of the button.
    h = _h; // Height of the button.
    shape = _shape;
  }
  
  void update()
  {
    // If the mouse is overlapping the button, AND the mouse button is being held:
    if(collision(mouseX, mouseY) && mousePressed)
    {
      down = true; // Button is down!
    }
    else down = false; // Button is not down!
  }
  
  // This is a collision function that returns a boolean, either true or false. This function belongs to this class Button, but any of this class children can call it with "super.collision(xM, yM)" !
  boolean collision(float xM, float yM)
  {
    if(shape == 0) // Square shape:
    {
      // Test for square collision against the coordinate provided (xM, yM), and return true/false depending on whether there is a collision.
      if( xM >= x-w/2   &&   xM <= x+w/2   &&   yM >= y-h/2   &&   yM <= y+h/2 )
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    else // Circle shape: (This is why any other shape value than zero is a circle. If not equal to zero, e.g. if not a square, ELSE, then it must be a circle! There's no other answer!)
    {
      // Test for circle collision against the coordinate provided (xM, yM), and return true/false depending on whether there is a collision.
      if( sqrt( pow((xM - x)/w, 2) + pow((yM - y)/h, 2) )   <=   1.0 )
      {
        return true;
      }
      else
      {
        return false;
      }
    }
  }
  
  void display()
  {
    /*  This function/method does absolutely nothing on its own!
    
        However, just in case we wanted to store children of Button inside a Button-type array, this Button class would NEED a
        display() function/method here, otherwise the children's display() functions/methods wouldn't be callable!
    */
  }
}
