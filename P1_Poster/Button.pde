abstract class Button
{
  float x, y, w, h;
  int shape;
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
    if(collision(mouseX, mouseY) && clickHold)
    {
      down = true;
    }
    else down = false;
  }
  
  boolean collision(float xM, float yM)
  {
    if(shape == 0) // Square shape
    {
      // Test for square collision against the coordinate provided (xM, yM), and return true/false depending on whether it's true or false.
      return ( xM >= x-w/2   &&   xM <= x+w/2   &&   yM >= y-h/2   &&   yM <= y+h/2 ) ? true : false;
    }
    else // Circle shape
    {
      // Test for circle collision against the coordinate provided (xM, yM), and return true/false depending on whether it's true or false.
      return ( sqrt( pow((xM - x)/w, 2) + pow((yM - y)/h, 2) ) <= 1.0 ) ? true : false;
    }
  }
  
  void display()
  {
  }
}
