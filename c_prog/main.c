
int main()
{
  while(1);
  
}

int *leds = 0x80000000;
int *sw   = 0x80002000;

int int_handler(int mcause)
{
  *leds = *sw;
  return 0;
}