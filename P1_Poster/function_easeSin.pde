// Eases an otherwise linear path into a smooth sine-curve motion between 0 and 1.
float easeSin(float t) // Parameter should be between 0 and 1!
{
  return (sin((t - 0.5) * PI) + 1) / 2;
}
