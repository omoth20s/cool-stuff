//declare a class to save positions of the magnet, piece and new positions
class pos
{
  public:
  int posX;
  int posY;
};
pos newPos;
pos currPos;
pos magnetCurrPos;
//variables for performing special moves
int killPiece;
int kingsCastle;
//array to recieve input from computer
int pieces[6];
//variable to keep track of how many inputs have been taken in
int h = 0;
//variables for knowing how far to move
int moveX;
int moveY;

//electromagnet sig pin = 9
int electromagnet = 9;

//variables to find which way motors should move
bool moveXForward;
bool moveYForward;

//this was how many steps half a space in for me
int moveOneSpace = 1000;

//pins for motors
int dirPin1 = 3;
int stepperPin1 = 2;
int dirPin2 = 7;
int stepperPin2 = 6;

void setup() {
  pinMode(dirPin1, OUTPUT);
  pinMode(stepperPin1, OUTPUT);
  pinMode(dirPin2, OUTPUT);
  pinMode(stepperPin2, OUTPUT);
  pinMode(electromagnet, OUTPUT);
  pinMode(10, OUTPUT);
  Serial.begin(9600);
  //magnet pos starts at (7, 7)
  magnetCurrPos.posY = 7;
  magnetCurrPos.posX = 7;
  //pieces[0] = 10;
}


void loop(){
  if (Serial.available()) 
  { // If data is available to read,
    if(h > 5)
    {
      h = 0;
    }
    //read values from serial port
    pieces[h] = Serial.read();
    h++;
  }
  if(h == 6)
  {
    //set all variables for easier programming
      currPos.posY = pieces[0];
      currPos.posX = pieces[1];
      newPos.posY = pieces[2];
      newPos.posX = pieces[3];
      killPiece = pieces[4];
      kingsCastle = pieces[5];
      h = 9;
  }
  if (h == 9) 
  {
    h = 8;
    //if performing a kings castle do this
    if(kingsCastle == 1)
    {
      //find how to move
      if(magnetCurrPos.posY < newPos.posY)
        moveYForward = true;
      else
        moveYForward = false;
      if(magnetCurrPos.posX < newPos.posX)
        moveXForward = true;
      else
        moveXForward = false;
      //check which king is moving and which way to move it
      if(newPos.posX == 1)
      {
        if(newPos.posY == 0)
        {
          if(magnetCurrPos.posX < currPos.posX)
            moveX = currPos.posX - magnetCurrPos.posX;
          else
            moveX = magnetCurrPos.posX - currPos.posX;
          moveY = magnetCurrPos.posY;
          //move to space king starts on
          step(moveXForward, moveYForward, moveOneSpace * moveX * 2, moveOneSpace * moveY * 2);
          moveX = magnetCurrPos.posX - newPos.posX;
          //turn electromagnet on
          digitalWrite(electromagnet, HIGH);
          //move king
          moveOneWayX(false, moveOneSpace * moveX * 2);
          //turn electromagnet off
          digitalWrite(electromagnet, LOW);
          moveX = magnetCurrPos.posX;
          //move to rook
          moveOneWayX(false, moveOneSpace * moveX * 2);
          moveX = newPos.posX + 1 - magnetCurrPos.posX;
          //turn electromagnet on
          digitalWrite(electromagnet, HIGH);
          //move rook to correct position
          moveOneWayY(true, moveOneSpace);
          moveOneWayX(true, moveOneSpace * moveX * 2);
          moveOneWayY(false, moveOneSpace);
          //turn electromagnet off
          digitalWrite(electromagnet, LOW);
        }
        else
        {
          if(magnetCurrPos.posX < currPos.posX)
            moveX = currPos.posX - magnetCurrPos.posX;
          else
            moveX = magnetCurrPos.posX - currPos.posX;
          moveY = currPos.posY - magnetCurrPos.posY;
          step(moveXForward, moveYForward, moveOneSpace * moveX * 2, moveOneSpace * moveY * 2);
          moveX = magnetCurrPos.posX - newPos.posX;
          //turn electromagnet on
          digitalWrite(electromagnet, HIGH);
          moveOneWayX(false, moveOneSpace * moveX * 2);
          //turn electromagnet off
          digitalWrite(electromagnet, LOW);
          moveX = magnetCurrPos.posX;
          moveOneWayX(false, moveOneSpace * moveX * 2);
          moveX = newPos.posX + 1 - magnetCurrPos.posX;
          //turn electromagnet on
          digitalWrite(electromagnet, HIGH);
          moveOneWayY(false, moveOneSpace);
          moveOneWayX(true, moveOneSpace * moveX * 2);
          moveOneWayY(true, moveOneSpace);
          //turn electromagnet off
          digitalWrite(electromagnet, LOW);
        }
        magnetCurrPos.posY = newPos.posY;
        magnetCurrPos.posX = newPos.posX + 1;
      }
      else
      {
        if(newPos.posY == 0)
        {
          if(magnetCurrPos.posX < currPos.posX)
            moveX = currPos.posX - magnetCurrPos.posX;
          else
            moveX = magnetCurrPos.posX - currPos.posX;
          moveY = currPos.posY - magnetCurrPos.posY;
          step(moveXForward, moveYForward, moveOneSpace * moveX * 2, moveOneSpace * moveY * 2);
          moveX = newPos.posX - magnetCurrPos.posX;
          //turn electromagnet on
          digitalWrite(electromagnet, HIGH);
          moveOneWayX(true, moveOneSpace * moveX * 2);
          //turn electromagnet off
          digitalWrite(electromagnet, LOW);
          moveX = 7 - magnetCurrPos.posX;
          moveOneWayX(true, moveOneSpace * moveX * 2);
          moveX = magnetCurrPos.posX - newPos.posX - 1;
          //turn electromagnet on
          digitalWrite(electromagnet, HIGH);
          moveOneWayY(true, moveOneSpace);
          moveOneWayX(false, moveOneSpace * moveX * 2);
          moveOneWayY(false, moveOneSpace);
          //turn electromagnet off
          digitalWrite(electromagnet, LOW);
        }
        else
        {
          if(magnetCurrPos.posX < currPos.posX)
            moveX = currPos.posX - magnetCurrPos.posX;
          else
            moveX = magnetCurrPos.posX - currPos.posX;
          moveY = currPos.posY - magnetCurrPos.posY;
          step(moveXForward, moveYForward, moveOneSpace * moveX * 2, moveOneSpace * moveY * 2);
          moveX = newPos.posX - magnetCurrPos.posX;
          //turn electromagnet on
          digitalWrite(electromagnet, HIGH);
          moveOneWayX(true, moveOneSpace * moveX * 2);
          //turn electromagnet off
          digitalWrite(electromagnet, LOW);
          moveX = 7 - magnetCurrPos.posX;
          moveOneWayX(true, moveOneSpace * moveX * 2);
          moveX = magnetCurrPos.posX - newPos.posX - 1;
          //turn electromagnet on
          digitalWrite(electromagnet, HIGH);
          moveOneWayY(false, moveOneSpace);
          moveOneWayX(false, moveOneSpace * moveX * 2);
          moveOneWayY(true, moveOneSpace);
          //turn electromagnet off
          digitalWrite(electromagnet, LOW);
        }
        //set magnets new current position
        magnetCurrPos.posY = newPos.posY;
        magnetCurrPos.posX = newPos.posX - 1;
      }
    }
    else
    {
      //if a piece must be killed do this
      if(killPiece == 1)
      {
        if(magnetCurrPos.posY < newPos.posY)
          moveYForward = true;
        else
          moveYForward = false;
        if(magnetCurrPos.posX < newPos.posX)
          moveXForward = true;
        else
          moveXForward = false;
        if(moveYForward)
          moveY = newPos.posY - magnetCurrPos.posY;
        else
          moveY = magnetCurrPos.posY - newPos.posY;
        if(moveXForward)
          moveX = newPos.posX - magnetCurrPos.posX;
        else
          moveX = magnetCurrPos.posX - newPos.posX;
          //move to piece
        step(moveXForward, moveYForward, moveOneSpace * moveX * 2, moveOneSpace * moveY * 2);
        //turn electromagnet on
        digitalWrite(electromagnet, HIGH);
        //move piece off the board
        moveOneWayY(true, moveOneSpace);
        moveOneWayX(true, moveOneSpace * (newPos.posX + 1) * 2);
        moveOneWayY(false, moveOneSpace);
        //turn electromagnet off
        digitalWrite(electromagnet, LOW);
        moveOneWayX(false, moveOneSpace * 2);
        magnetCurrPos.posY = newPos.posY;
        magnetCurrPos.posX = 0;
      }
      //find where piece is in relation to the magnet
      if(magnetCurrPos.posY < currPos.posY)
        moveYForward = true;
      else
        moveYForward = false;
      if(magnetCurrPos.posX < currPos.posX)
        moveXForward = true;
      else
        moveXForward = false;
      if(moveYForward)
        moveY = currPos.posY - magnetCurrPos.posY;
      else
        moveY = magnetCurrPos.posY - currPos.posY;
      if(moveXForward)
        moveX = currPos.posX - magnetCurrPos.posX;
      else
        moveX = magnetCurrPos.posX - currPos.posX;
      //move to the piece
      step(moveXForward, moveYForward, moveOneSpace * moveX * 2, moveOneSpace * moveY * 2);
      if(currPos.posY < newPos.posY)
        moveYForward = true;
      else
        moveYForward = false;
      if(currPos.posX < newPos.posX)
        moveXForward = true;
      else
        moveXForward = false;
      if(moveYForward)
        moveY = newPos.posY - currPos.posY;
      else
        moveY = currPos.posY - newPos.posY;
      if(moveXForward)
        moveX = newPos.posX - currPos.posX;
      else
        moveX = currPos.posX - newPos.posX;
      //turn electromagnet on
      digitalWrite(electromagnet, HIGH);
      delay(200);
      //decide how to move the piece then move it
      if(moveX == moveY)
        moveDiagnal(moveXForward, moveYForward, moveOneSpace * moveX * 2);
      else if(moveX != 0 && moveY != 0)
      {
        moveOneWayX(moveXForward, moveOneSpace);
        moveOneWayY(moveYForward, (moveOneSpace * moveY * 2) - 1);
        moveOneWayX(moveXForward, (moveOneSpace * moveX * 2) - 1);
        moveOneWayY(moveYForward, moveOneSpace);
      }
      else if(moveY == 0)
        moveOneWayX(moveXForward, moveOneSpace * moveX * 2);
      else if(moveX == 0)
        moveOneWayY(moveYForward, moveOneSpace * moveY * 2);
      //turn electromagnet off
      digitalWrite(electromagnet, LOW);
      delay(200);
      //set new magnet position
      magnetCurrPos = newPos;
    }
  }
}

void step(bool dir1, bool dir2, int steps1, int steps2){
  //choose which way to move
  digitalWrite(dirPin1,dir1);
  digitalWrite(dirPin2,dir2);
  delay(50);
  //only try to move x if x is greater than 0
  if(steps1 > 0)
  {
    //move steps steps far with X motor
    for(int i=0;i<steps1;i++){
      digitalWrite(stepperPin1, HIGH);
      delayMicroseconds(800);
      digitalWrite(stepperPin1, LOW);
      delayMicroseconds(800);
    }
  }
  //only try to move y if y is greater than 0
  if(steps2 > 0)
  {
    //move steps steps far with Y motor
    for(int i=0;i<steps2;i++){
      digitalWrite(stepperPin2, HIGH);
      delayMicroseconds(800);
      digitalWrite(stepperPin2, LOW);
      delayMicroseconds(800);
    }
  }
}

void moveDiagnal(bool dir1, bool dir2, int steps){
  //choose which way to move
  digitalWrite(dirPin1,dir1);
  digitalWrite(dirPin2,dir2);
  delay(50);
  //move steps steps far with both motors at the same time
  for(int i=0;i<steps;i++){
    digitalWrite(stepperPin1, HIGH);
    digitalWrite(stepperPin2, HIGH);
    delayMicroseconds(800);
    digitalWrite(stepperPin1, LOW);
    digitalWrite(stepperPin2, LOW);
    delayMicroseconds(800);
  }
}

void moveOneWayX(bool dir, int steps){
  //choose which way to move
  digitalWrite(dirPin1,dir);
  delay(50);
  //move steps steps far with X motor
  for(int i=0;i<steps;i++){
    digitalWrite(stepperPin1, HIGH);
    delayMicroseconds(800);
    digitalWrite(stepperPin1, LOW);
    delayMicroseconds(800);
  }
}

void moveOneWayY(bool dir, int steps){
  //choose which way to move
  digitalWrite(dirPin2,dir);
  delay(50);
  //move steps steps far with Y motor
  for(int i=0;i<steps;i++){
    digitalWrite(stepperPin2, HIGH);
    delayMicroseconds(800);
    digitalWrite(stepperPin2, LOW);
    delayMicroseconds(800);
  }
}
