//picture from http://www.wpclipart.com/recreation/games/chess/chess_set_symbols.png.html
//shane omoth october 23 2015
import processing.serial.*;
//import static javax.swing.JOptionPane.*;

Serial port = new Serial(this, Serial.list()[0], 9600);  // Create object from Serial class

//declare a class that will be able to contain the coordiantes and size of each space on the board
class spaces
{
  float spaceWidth;
  float spaceHeight;
  float spacePosX; 
  float spacePosY;
  spaces(float a, float b, float c, float d)
  {
    spaceWidth = a;
    spaceHeight = b; 
    spacePosY = c;
    spacePosX = d;
  }
};
//make an 8X8 array for the spaces
spaces[][] space = new spaces[8][8];

//declare constant values for each type of piece
final int whitePawn = 1;
final int whiteRook = 2;
final int whiteKnight = 3;
final int whiteBishop = 4;
final int whiteQueen = 5;
final int whiteKing = 6;

final int blackPawn = 7;
final int blackRook = 8;
final int blackKnight = 9;
final int blackBishop = 10;
final int blackQueen = 11;
final int blackKing = 12;

//integer to determine what kind of piece was selected
int selected;
//declare a class that can remember the last position coordinates and the new position coordinates
class pos
{
  int posX;
  int posY;
  pos(int x, int y)
  {
    posX = x;
    posY = y;
  }
};

pos newPos;
pos currPos;

//make 8X8 arrays for the entire game board and an 8X8 array to check where a specific piece can move
int[][] gameBoard = new int[8][8];
boolean[][] acceptedMovement = new boolean[8][8];

//variables used for performing kings castle
boolean blackKingMoved = false;
boolean blackRook1Moved = false;
boolean blackRook2Moved = false; 
boolean whiteKingMoved = false;
boolean whiteRook1Moved = false;
boolean whiteRook2Moved = false; 

//varible for whose turn it is
boolean whiteTurn = true;

//variable to load in an image from outside the program
PImage img;
/*
//function to make the program fullscreen
boolean sketchFullScreen()
{
  return true;
}
*/
void setup()
{
  //set window size to the screen size
  size(displayWidth, displayHeight, P2D);
  //fullScreen();

  //String portName = Serial.list()[0];
  //Serial myport = new Serial(this, Serial.list()[0], 9600);
  
  //load in an image for the chess pieces
  img = loadImage("chess_set_symbols.png");
  //find the position and size of each space on the board
  for(int i = 0; i < 8; i++)
  {
    for(int j = 0; j < 8; j++)
    {
    space[i][j] = new spaces((float)displayWidth / 10.0, (float)displayHeight / 10.0, 
    ((float)displayHeight * (float)(i / 10.0)) + (((float)displayHeight * (float)((2 / 10.0) * (i + 1.5))) / 10.0), 
    ((float)displayWidth * (float)(j / 10.0)) + (((float)displayWidth * (float)((2 / 10.0) * (j + 1.5))) / 10.0));
    }
  }
  //initialize every accepted movement to 0 and every space on the game board to 0
  for(int i = 0; i < 8; i++)
  {
    for(int j = 0; j < 8; j++)
    {
      gameBoard[i][j] = 0;
      acceptedMovement[i][j] = false;
    }
  }

  //set the chess board up (pieces in starting positions)
  gameBoard[0][0] = blackRook;
  gameBoard[0][1] = blackKnight;
  gameBoard[0][2] = blackBishop;
  gameBoard[0][4] = blackQueen;
  gameBoard[0][3] = blackKing;
  gameBoard[0][5] = blackBishop;
  gameBoard[0][6] = blackKnight;
  gameBoard[0][7] = blackRook;
  gameBoard[1][0] = blackPawn;
  gameBoard[1][1] = blackPawn;
  gameBoard[1][2] = blackPawn;
  gameBoard[1][3] = blackPawn;
  gameBoard[1][4] = blackPawn;
  gameBoard[1][5] = blackPawn;
  gameBoard[1][6] = blackPawn;
  gameBoard[1][7] = blackPawn;

  gameBoard[7][0] = whiteRook;
  gameBoard[7][1] = whiteKnight;
  gameBoard[7][2] = whiteBishop;
  gameBoard[7][4] = whiteQueen;
  gameBoard[7][3] = whiteKing;
  gameBoard[7][5] = whiteBishop;
  gameBoard[7][6] = whiteKnight;
  gameBoard[7][7] = whiteRook;
  gameBoard[6][0] = whitePawn;
  gameBoard[6][1] = whitePawn;
  gameBoard[6][2] = whitePawn;
  gameBoard[6][3] = whitePawn;
  gameBoard[6][4] = whitePawn;
  gameBoard[6][5] = whitePawn;
  gameBoard[6][6] = whitePawn;
  gameBoard[6][7] = whitePawn;
}

void mousePressed()
{
  //check if mouse left clicked
  if(mouseButton == LEFT)
  {
    //they have not allready selected a piece do this
    if(selected == 0)
    {
      for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
        {
          //make sure accepted movement is reset to all 0's
          acceptedMovement[i][j] = false;
          //check whose turn it is
          if(whiteTurn)
          {
            //if its whites turn make sure they have selected a white piece
            if(mouseX >= space[i][j].spacePosX && mouseX <= space[i][j].spacePosX + space[i][j].spaceWidth &&
            mouseY >= space[i][j].spacePosY && mouseY <= space[i][j].spacePosY + space[i][j].spaceHeight &&
            gameBoard[i][j] < 7 && gameBoard[i][j] != 0)
            {
              //set currPos to the position selected and selected to the piece selected
              currPos = new pos(j, i);
              selected = gameBoard[i][j];
              //break;
            }
          }
          else
          {
            //if its blacks turn make sure they have selected a black piece
            if(mouseX >= space[i][j].spacePosX && mouseX <= space[i][j].spacePosX + space[i][j].spaceWidth &&
            mouseY >= space[i][j].spacePosY && mouseY <= space[i][j].spacePosY + space[i][j].spaceHeight &&
            gameBoard[i][j] > 6)
            {
              currPos = new pos(j, i);
              selected = gameBoard[i][j];
              //break;
            }
          }
        }
      }
      //find the accepted movement for the selected piece
      if(selected == whitePawn) 
      {
        pawnAcceptedMovement(whitePawn);
      }
      else if(selected == blackPawn)
      {
        pawnAcceptedMovement(blackPawn);
      }
      else if(selected == whiteRook)
      {
        rookAcceptedMovement(whiteRook);
      }
      else if(selected == blackRook)
      {
        rookAcceptedMovement(blackRook);
      }
      else if(selected == whiteKnight)
      {
        knightAcceptedMovement(whiteKnight);
      }
      else if(selected == blackKnight)
      {
        knightAcceptedMovement(blackKnight);
      }
      else if(selected == whiteBishop)
      {
        bishopAcceptedMovement(whiteBishop);
      }
      else if(selected == blackBishop)
      {
        bishopAcceptedMovement(blackBishop);
      }
      else if(selected == whiteQueen)
      {
        rookAcceptedMovement(whiteQueen);
        bishopAcceptedMovement(whiteQueen);
      }
      else if(selected == blackQueen)
      {
        rookAcceptedMovement(blackQueen);
        bishopAcceptedMovement(blackQueen);
      }
      else if(selected == whiteKing)
      {
        kingAcceptedMovement(whiteKing);
      }
      else if(selected == blackKing)
      {
        kingAcceptedMovement(blackKing);
      }
    }
    //if a piece has already been selected
    else
    {
      for(int i = 0; i < 8; i++)
      {
        for(int j = 0; j < 8; j++)
        {
          if(mouseX >= space[i][j].spacePosX && mouseX <= space[i][j].spacePosX + space[i][j].spaceWidth &&
          mouseY >= space[i][j].spacePosY && mouseY <= space[i][j].spacePosY + space[i][j].spaceHeight)
          {
            //println("moved");
            //if new space that has been selected is an accepted movement move there
            if(acceptedMovement[i][j])
            {
              int kill = 0;
              int kingsCastle = 0;
              if(gameBoard[i][j] > 0)
                kill = 1;
              //println("moved");
              //set old space to 0
              gameBoard[currPos.posY][currPos.posX] = 0;
              //check if pawn has reached the other side of the board and if so change it to a queen
              if(selected == whitePawn && i == 0)
                gameBoard[i][j] = whiteQueen;
              else if(selected == blackPawn && i == 7)
                gameBoard[i][j] = blackQueen;
              
              //if a king is being moved then check for kings castle 
              //reson being that if they are doing kings castle the king must be moved as well as the rook
              else if(selected == blackKing)
              {
                gameBoard[i][j] = blackKing;
                //make sure king has not moved yet
                if(!blackKingMoved)
                {
                  //make sure rook has not moved yet
                  if(i == 0 && j == 1 && !blackRook1Moved)
                  {
                    //move rook
                    gameBoard[i][j+1] = blackRook;
                    gameBoard[0][0] = 0;
                    //set bool variable for rook moved to true
                    blackRook1Moved = true;
                    kingsCastle = 1;
                  }
                  else if(i == 0 && j == 5 && !blackRook2Moved)
                  {
                    gameBoard[i][j-1] = blackRook;
                    gameBoard[0][7] = 0;
                    blackRook2Moved = true;
                    kingsCastle = 1;
                  }
                }
                //set bool variable for king moved to true
                blackKingMoved = true;
              }
              else if(selected == whiteKing)
              {
                gameBoard[i][j] = whiteKing;
                if(!whiteKingMoved)
                {
                  if(i == 7 && j == 1 && !whiteRook1Moved)
                  {
                    gameBoard[i][j+1] = whiteRook;
                    gameBoard[7][0] = 0;
                    whiteRook1Moved = true;
                    kingsCastle = 1;
                  }
                  else if(i == 7 && j == 5 && !whiteRook2Moved)
                  {
                    gameBoard[i][j-1] = whiteRook;
                    gameBoard[7][7] = 0;
                    whiteRook2Moved = true;
                    kingsCastle = 1;
                  }
                }
                whiteKingMoved = true;
              }
              //move piece (no special rules)
              else
              {
                gameBoard[i][j] = selected;
              }
              selected = 0;
              //change whose turn it is
              if(whiteTurn)
                whiteTurn = false;
              else
                whiteTurn = true; 
              port.write(currPos.posY);
              port.write(currPos.posX);
              port.write(i);
              port.write(j);
              port.write(kill);
              port.write(kingsCastle);
              println(currPos.posY, ',', currPos.posX, ',', i, ',', j, ',', kill, ',', kingsCastle);
              //println(currPos.posY, currPos.posX, i, j, kill, kingsCastle);  
              //break;
            }
            //if trying to move to an unaccepted space then exit current move and let the player pick again
            else if(!acceptedMovement[i][j])
            {
              selected = 0;
              break;
              //background(#E81C1C);
            }
          }
        }
      }
    }
  }
}

void draw()
{
  //port.write('9');
  mousePressed();/*
  if (keyPressed == true) 
  {                           //if we clicked in the window
   port.write('1');         //send a 1
   println("1");   
  } else 
  {                           //otherwise
    port.write('0');          //send a 0
  }*/
  //set background to blue
  background(#0924AA);
  //set stoke weight to make boarders more visible
  strokeWeight(5);
  for(int i = 0; i < 8; i++)
  {
    for(int j = 0; j < 8; j++)
    {
      //find what color the specific space should be
      if(i == 1 || i == 3 || i == 5 || i == 7)
      {
        if(j == 1 || j == 3 || j == 5 || j == 7)
        {
          stroke(0);
          fill(0);
        }
        else
        {
          stroke(255);
          fill(255);
        }
      }
      if(i == 0 || i == 2 || i == 4|| i == 6)
      {
        if(j == 0 || j == 2 || j == 4 || j == 6)
        {
          stroke(0);
          fill(0);
        }
        else
        {
          stroke(255);
          fill(255);
        }
      }
      //set all borders to green for all accpeted movements
      if(acceptedMovement[i][j])
      {
        //strokeWeight(5);
        stroke(0, 255, 0);
      }
      if(gameBoard[i][j] == 0)
      { 
        //draw empty spaces
        rect(space[i][j].spacePosX, space[i][j].spacePosY, space[i][j].spaceWidth, space[i][j].spaceHeight);
      }
      //map image of each piece to spaces with pieces on them
      else if(gameBoard[i][j] == whitePawn) 
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((8.0/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, 964, 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, 964, 288);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((8.0/9.0) * 964), 288);
        endShape();
      }
      else if(gameBoard[i][j] == blackPawn)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((8.0/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, 964, 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, 964, 288 / 2);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((8.0/9.0) * 964), 288 / 2);
        endShape();
      }
      else if(gameBoard[i][j] == whiteRook)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((3.0/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((4.5/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((4.5/9.0) * 964), 288);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((3.0/9.0) * 964), 288);
        endShape();
      }
      else if(gameBoard[i][j] == blackRook)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((3.0/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((4.5/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((4.5/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((3.0/9.0) * 964), 288 / 2);
        endShape();
      }
      else if(gameBoard[i][j] == whiteKnight)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((6.3/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((7.7/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((7.7/9.0) * 964), 288);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((6.3/9.0) * 964), 288);
        endShape();
      }
      else if(gameBoard[i][j] == blackKnight)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((6.3/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((7.7/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((7.7/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((6.3/9.0) * 964), 288 / 2);
        endShape();
      }
      else if(gameBoard[i][j] == whiteBishop)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((4.7/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((6.0/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((6.0/9.0) * 964), 288);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((4.7/9.0) * 964), 288);
        endShape();
      }
      else if(gameBoard[i][j] == blackBishop)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((4.7/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((6.0/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((6.0/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((4.7/9.0) * 964), 288 / 2);
        endShape();
      }
      else if(gameBoard[i][j] == whiteQueen)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((1.5/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((3.0/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((3.0/9.0) * 964), 288);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((1.5/9.0) * 964), 288);
        endShape();
      }
      else if(gameBoard[i][j] == blackQueen)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, ((1.5/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((3.0/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((3.0/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, ((1.5/9.0) * 964), 288 / 2);
        endShape();
      }
      else if(gameBoard[i][j] == whiteKing)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, 0, 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((1.3/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((1.3/9.0) * 964), 288);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, 0, 288);
        endShape();
      }
      else if(gameBoard[i][j] == blackKing)
      {
        textureMode(IMAGE);
        beginShape();
          texture(img);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY, 0, 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY, ((1.3/9.0) * 964), 0);
            vertex(space[i][j].spacePosX + space[i][j].spaceWidth, space[i][j].spacePosY + space[i][j].spaceHeight, ((1.3/9.0) * 964), 288 / 2);
            vertex(space[i][j].spacePosX, space[i][j].spacePosY + space[i][j].spaceHeight, 0, 288 / 2);
        endShape();
      }
    }
  }
}

//funtion for finding the absolute value of a number
void absVal(int a)
{
  if(a < 0)
    a = -a;
}

void pawnAcceptedMovement(int colors)
{
  //check what color is moving
  if(colors < 7)
  {
    //pawn can move 2 spaces if it hasn't moved yet
    if(currPos.posY == 6) 
      if(gameBoard[currPos.posY - 1][currPos.posX] == 0 && gameBoard[currPos.posY - 2][currPos.posX] == 0)
        acceptedMovement[currPos.posY - 2][currPos.posX] = true;
     //make sure new space is inside the board
    if(currPos.posY - 1 >= 0)
    {
      //check if space in front of the pawn is vacant then pawn can move there
      if(gameBoard[currPos.posY - 1][currPos.posX] == 0)
        acceptedMovement[currPos.posY - 1][currPos.posX] = true;
      //if enemy pawn is diagnal to pawn then pawn can move there
      if(currPos.posX + 1 < 8)
        if(gameBoard[currPos.posY - 1][currPos.posX + 1] > 6)
          acceptedMovement[currPos.posY - 1][currPos.posX + 1] = true;
      if(currPos.posY - 1 >= 0 && currPos.posX - 1 >= 0)
        if(gameBoard[currPos.posY - 1][currPos.posX - 1] > 6)
          acceptedMovement[currPos.posY - 1][currPos.posX - 1] = true;
    }
  }
  if(colors > 6)
  {
    if(currPos.posY == 1)
      if(gameBoard[currPos.posY + 1][currPos.posX] == 0 && gameBoard[currPos.posY + 2][currPos.posX] == 0)
        acceptedMovement[currPos.posY + 2][currPos.posX] = true;
    if(currPos.posY + 1 < 8)
    {
      if(gameBoard[currPos.posY + 1][currPos.posX] == 0)
        acceptedMovement[currPos.posY + 1][currPos.posX] = true;
      if(currPos.posX + 1 < 8)
        if(gameBoard[currPos.posY + 1][currPos.posX + 1] < 7 && gameBoard[currPos.posY + 1][currPos.posX + 1] != 0)
          acceptedMovement[currPos.posY + 1][currPos.posX + 1] = true;
      if(currPos.posX - 1 >= 0)
        if(gameBoard[currPos.posY + 1][currPos.posX - 1] < 7 && gameBoard[currPos.posY + 1][currPos.posX - 1] != 0)
          acceptedMovement[currPos.posY + 1][currPos.posX - 1] = true;
    }
  }
}
void rookAcceptedMovement(int colors)
{
  //boolean vairbles used to check if the rook has reaches its limit in a direction
  boolean a = false;
  boolean b = false;
  boolean c = false;
  boolean d = false;
  if(colors < 7)
  {
    for(int i = 1; i < 8; i++)
    {
      if(!a)
      {
        //check where rook can move upwards
        if(currPos.posY + i < 8)
        {
          if(gameBoard[currPos.posY + i][currPos.posX] == 0)
            acceptedMovement[currPos.posY + i][currPos.posX] = true;
          else if(gameBoard[currPos.posY + i][currPos.posX] > 6)
          {
            acceptedMovement[currPos.posY + i][currPos.posX] = true;
            a = true;
          }
          else
            a = true;
        }
        else
          a = true;
      }
      if(!b)
      {
        //check where rook can move downwards
        if(currPos.posY - i >= 0)
        {
          if(gameBoard[currPos.posY - i][currPos.posX] == 0)
            acceptedMovement[currPos.posY - i][currPos.posX] = true;
          else if(gameBoard[currPos.posY - i][currPos.posX] > 6)
          {
            acceptedMovement[currPos.posY - i][currPos.posX] = true;
            b = true;
          }
          else
            b = true;
        }
        else
          b = true;
      }
      if(!c)
      {
        //check where rook can move right
        if(currPos.posX + i < 8)
        {
          if(gameBoard[currPos.posY][currPos.posX + i] == 0)
            acceptedMovement[currPos.posY][currPos.posX + i] = true;
          else if(gameBoard[currPos.posY][currPos.posX + i] > 6)
          {
            acceptedMovement[currPos.posY][currPos.posX + i] = true;
            c = true;
          }
          else
            c = true;
        }
        else
          c = true;
      }
      if(!d)
      {
        //check where rook can move left
        if(currPos.posX - i >= 0)
        {
          if(gameBoard[currPos.posY][currPos.posX - i] == 0)
            acceptedMovement[currPos.posY][currPos.posX - i] = true;
          else if(currPos.posX - i >= 0 && gameBoard[currPos.posY][currPos.posX - i] > 6)
          {
            acceptedMovement[currPos.posY][currPos.posX - i] = true;
            d = true;
          }
          else
            d = true;
        }
        else
          d = true;
      }
    }
  }
  if(colors > 6)
  {
    for(int i = 1; i < 8; i++)
    {
      if(!a)
      {
        if(currPos.posY + i < 8)
        {
          if(gameBoard[currPos.posY + i][currPos.posX] == 0)
            acceptedMovement[currPos.posY + i][currPos.posX] = true;
          else if(gameBoard[currPos.posY + i][currPos.posX] < 7)
          {
            acceptedMovement[currPos.posY + i][currPos.posX] = true;
            a = true;
          }
          else
            a = true;
        }
        else
          a = true;
      }
      if(!b)
      {
        if(currPos.posY - i >= 0)
        {
          if(gameBoard[currPos.posY - i][currPos.posX] == 0)
            acceptedMovement[currPos.posY - i][currPos.posX] = true;
          else if(gameBoard[currPos.posY - i][currPos.posX] < 7)
          {
            acceptedMovement[currPos.posY - i][currPos.posX] = true;
            b = true;
          }
          else
            b = true;
        }
        else
          b = true;
      }
      if(!c)
      {
        if(currPos.posX + i < 8)
        {
          if(gameBoard[currPos.posY][currPos.posX + i] == 0)
            acceptedMovement[currPos.posY][currPos.posX + i] = true;
          else if(gameBoard[currPos.posY][currPos.posX + i] < 7)
          {
            acceptedMovement[currPos.posY][currPos.posX + i] = true;
            c = true;
          }
          else
            c = true;
        }
        else
          c = true;
      }
      if(!d)
      {
        if(currPos.posX - i >= 0)
        {
          if(gameBoard[currPos.posY][currPos.posX - i] == 0)
            acceptedMovement[currPos.posY][currPos.posX - i] = true;
          else if(currPos.posX - i >= 0 && gameBoard[currPos.posY][currPos.posX - i] < 7)
          {
            acceptedMovement[currPos.posY][currPos.posX - i] = true;
            d = true;
          }
          else
            d = true;
        }
        else
          d = true;
      }
    }
  }
}
void knightAcceptedMovement(int colors)
{
  if(colors < 7)
  {
    //check every different space the knight can moves to
    //only way a knight can not move there is if it is ocupied by an ally piece or if it's off the board
    if(currPos.posY + 2 < 8 && currPos.posX + 1 < 8)
      if(gameBoard[currPos.posY + 2][currPos.posX + 1] > 6 || gameBoard[currPos.posY + 2][currPos.posX + 1] == 0)
        acceptedMovement[currPos.posY + 2][currPos.posX + 1] = true;

    if(currPos.posY + 2 < 8 && currPos.posX - 1 >= 0)
      if(gameBoard[currPos.posY + 2][currPos.posX - 1] > 6 || gameBoard[currPos.posY + 2][currPos.posX - 1] == 0)
        acceptedMovement[currPos.posY + 2][currPos.posX - 1] = true;

    if(currPos.posY - 2 >= 0 && currPos.posX + 1 < 8)
      if(gameBoard[currPos.posY - 2][currPos.posX + 1] > 6 || gameBoard[currPos.posY - 2][currPos.posX + 1] == 0)
        acceptedMovement[currPos.posY - 2][currPos.posX + 1] = true;

    if(currPos.posY - 2 >= 0 && currPos.posX - 1 >= 0)
      if(gameBoard[currPos.posY - 2][currPos.posX - 1] > 6 || gameBoard[currPos.posY - 2][currPos.posX - 1] == 0)
        acceptedMovement[currPos.posY - 2][currPos.posX - 1] = true;

    if(currPos.posY + 1 < 8 && currPos.posX + 2 < 8)
      if(gameBoard[currPos.posY + 1][currPos.posX + 2] > 6 || gameBoard[currPos.posY + 1][currPos.posX + 2] == 0)
        acceptedMovement[currPos.posY + 1][currPos.posX + 2] = true;

    if(currPos.posY + 1 < 8 && currPos.posX - 2 >= 0)
      if(gameBoard[currPos.posY + 1][currPos.posX - 2] > 6 || gameBoard[currPos.posY + 1][currPos.posX - 2] == 0)
        acceptedMovement[currPos.posY + 1][currPos.posX - 2] = true;

    if(currPos.posY - 1 < 8 && currPos.posX + 2 < 8)
      if(gameBoard[currPos.posY - 1][currPos.posX + 2] > 6 || gameBoard[currPos.posY - 1][currPos.posX + 2] == 0)
        acceptedMovement[currPos.posY - 1][currPos.posX + 2] = true;

    if(currPos.posY - 1 >= 0 && currPos.posX - 2 >= 0)
      if(gameBoard[currPos.posY - 1][currPos.posX - 2] > 6 || gameBoard[currPos.posY - 1][currPos.posX - 2] == 0)
        acceptedMovement[currPos.posY - 1][currPos.posX - 2] = true;
  }
  if(colors > 6)
  {
    if(currPos.posY + 2 < 8 && currPos.posX + 1 < 8)
      if(gameBoard[currPos.posY + 2][currPos.posX + 1] < 7)
        acceptedMovement[currPos.posY + 2][currPos.posX + 1] = true;

    if(currPos.posY + 2 < 8 && currPos.posX - 1 >= 0)
      if(gameBoard[currPos.posY + 2][currPos.posX - 1] < 7)
        acceptedMovement[currPos.posY + 2][currPos.posX - 1] = true;

    if(currPos.posY - 2 >= 0 && currPos.posX + 1 < 8)
      if(gameBoard[currPos.posY - 2][currPos.posX + 1] < 7)
        acceptedMovement[currPos.posY - 2][currPos.posX + 1] = true;

    if(currPos.posY - 2 >= 0 && currPos.posX - 1 >= 0)
      if(gameBoard[currPos.posY - 2][currPos.posX - 1] < 7)
        acceptedMovement[currPos.posY - 2][currPos.posX - 1] = true;

    if(currPos.posY + 1 < 8 && currPos.posX + 2 < 8)
      if(gameBoard[currPos.posY + 1][currPos.posX + 2] < 7)
        acceptedMovement[currPos.posY + 1][currPos.posX + 2] = true;

    if(currPos.posY + 1 < 8 && currPos.posX - 2 >= 0)
      if(gameBoard[currPos.posY + 1][currPos.posX - 2] < 7)
        acceptedMovement[currPos.posY + 1][currPos.posX - 2] = true;

    if(currPos.posY - 1 >= 0 && currPos.posX + 2 < 8)
      if(gameBoard[currPos.posY - 1][currPos.posX + 2] < 7)
        acceptedMovement[currPos.posY - 1][currPos.posX + 2] = true;

    if(currPos.posY - 1 >= 0 && currPos.posX - 2 >= 0)
      if(gameBoard[currPos.posY - 1][currPos.posX - 2] < 7)
        acceptedMovement[currPos.posY - 1][currPos.posX - 2] = true;
  }
}
void bishopAcceptedMovement(int colors)
{
  //same as rook but checks diagnal spaces
  boolean a = false;
  boolean b = false;
  boolean c = false;
  boolean d = false;
  if(colors < 7)
  {
    for(int i = 1; i < 8; i++)
    {
      if(!a)
      {
        if(currPos.posY + i < 8 && currPos.posX + i < 8)
        {
          if(gameBoard[currPos.posY + i][currPos.posX + i] == 0)
            acceptedMovement[currPos.posY + i][currPos.posX + i] = true;
          else if(gameBoard[currPos.posY + i][currPos.posX + i] > 6)
          {
            acceptedMovement[currPos.posY + i][currPos.posX + i] = true;
            a = true;
          }
          else
            a = true;
        }
        else
          a = true;
      }
      if(!b)
      {
        if(currPos.posY - i >= 0 && currPos.posX - i >= 0)
        {
          if(gameBoard[currPos.posY - i][currPos.posX - i] == 0)
            acceptedMovement[currPos.posY - i][currPos.posX - i] = true;
          else if(gameBoard[currPos.posY - i][currPos.posX - i] > 6)
          {
            acceptedMovement[currPos.posY - i][currPos.posX - i] = true;
            b = true;
          }
          else
            b = true;
        }
        else
          b = true;
      }
      if(!c)
      {
        if(currPos.posX + i < 8 && currPos.posY - i >= 0)
        {
          if(gameBoard[currPos.posY - i][currPos.posX + i] == 0)
            acceptedMovement[currPos.posY - i][currPos.posX + i] = true;
          else if(gameBoard[currPos.posY - i][currPos.posX + i] > 6)
          {
            acceptedMovement[currPos.posY - i][currPos.posX + i] = true;
            c = true;
          }
          else
            c = true;
        }
        else
          c = true;
      }
      if(!d)
      {
        if(currPos.posX - i >= 0 && currPos.posY + i < 8)
        {
          if(gameBoard[currPos.posY + i][currPos.posX - i] == 0)
            acceptedMovement[currPos.posY + i][currPos.posX - i] = true;
          else if(gameBoard[currPos.posY + i][currPos.posX - i] > 6)
          {
            acceptedMovement[currPos.posY + i][currPos.posX - i] = true;
            d = true;
          }
          else
            d = true;
        }
        else
          d = true;
      }
    }
  }
  if(colors > 6)
  {
    for(int i = 1; i < 8; i++)
    {
      if(!a)
      {
        if(currPos.posY + i < 8 && currPos.posX + i < 8)
        {
          if(gameBoard[currPos.posY + i][currPos.posX + i] == 0)
            acceptedMovement[currPos.posY + i][currPos.posX + i] = true;
          else if(gameBoard[currPos.posY + i][currPos.posX + i] < 7)
          {
            acceptedMovement[currPos.posY + i][currPos.posX + i] = true;
            a = true;
          }
            else
            a = true;
        }
        else
          a = true;
      }
      if(!b)
      {
        if(currPos.posY - i >= 0 && currPos.posX - i >= 0)
        {
          if(gameBoard[currPos.posY - i][currPos.posX - i] == 0)
            acceptedMovement[currPos.posY - i][currPos.posX - i] = true;
          else if(gameBoard[currPos.posY - i][currPos.posX - i] < 7)
          {
            acceptedMovement[currPos.posY - i][currPos.posX - i] = true;
            b = true;
          }
          else
            b = true;
        }
        else
          b = true;
      }
      if(!c)
      {
        if(currPos.posX + i < 8 && currPos.posY - i >= 0)
        {
          if(gameBoard[currPos.posY - i][currPos.posX + i] == 0)
            acceptedMovement[currPos.posY - i][currPos.posX + i] = true;
          else if(gameBoard[currPos.posY - i][currPos.posX + i] < 7)
          {
            acceptedMovement[currPos.posY - i][currPos.posX + i] = true;
            c = true;
          }
          else
            c = true;
        }
        else
          c = true;
      }
      if(!d)
      {
        if(currPos.posX - i >= 0 && currPos.posY + i < 8)
        {
          if(gameBoard[currPos.posY + i][currPos.posX - i] == 0)
            acceptedMovement[currPos.posY + i][currPos.posX - i] = true;
          else if(gameBoard[currPos.posY + i][currPos.posX - i] < 7)
          {
            acceptedMovement[currPos.posY + i][currPos.posX - i] = true;
            d = true;
          }
          else
            d = true;
        }
        else
          d = true;
      }
    }
  }
}
void kingAcceptedMovement(int colors)
{
  if(colors < 7)
  {
    //king can not move anywhere around it unless occupied by an ally or off the board
    for(int i = -1; i < 2; i++)
    {
      for(int j = -1; j < 2; j++)
      {
        if(currPos.posY + i < 8 && currPos.posY + i >= 0 && currPos.posX + j < 8 && currPos.posX + j >= 0)
          if(gameBoard[currPos.posY + i][currPos.posX + j] == 0 || gameBoard[currPos.posY + i][currPos.posX + j] > 6)
            acceptedMovement[currPos.posY + i][currPos.posX + j] = true;
      }
    }
    //don't want to allow king to move to same space otherwise it will skip the players turn
    acceptedMovement[currPos.posY][currPos.posX] = false;
    //check for kings castle much make sure king has not moved rook has not moved and there are now pieces inbetween them
    if(!whiteKingMoved)
    {
      if(!whiteRook1Moved)
      {
        if(gameBoard[7][1] == 0 && gameBoard[7][2] == 0)
          acceptedMovement[7][1] = true;
      }
      if(!whiteRook2Moved)
      {
        if(gameBoard[7][4] == 0 && gameBoard[7][5] == 0 && gameBoard[7][6] == 0)
          acceptedMovement[7][5] = true;
      }
    }
  }
  if(colors > 6)
  {
    for(int i = -1; i < 2; i++)
    {
      for(int j = -1; j < 2; j++)
      {
        if(currPos.posY + i < 8 && currPos.posY + i >= 0 && currPos.posX + j < 8 && currPos.posX + j >= 0)
           if(gameBoard[currPos.posY + i][currPos.posX + j] < 7)
             acceptedMovement[currPos.posY + i][currPos.posX + j] = true;
      }
    }
    acceptedMovement[currPos.posY][currPos.posX] = false;
    if(!blackKingMoved)
    {
      if(!blackRook1Moved)
      {
        if(gameBoard[0][1] == 0 && gameBoard[0][2] == 0)
          acceptedMovement[0][1] = true;
      }
      if(!blackRook2Moved)
      {
        if(gameBoard[0][4] == 0 && gameBoard[0][5] == 0 && gameBoard[0][6] == 0)
          acceptedMovement[0][5] = true;
      }
    }
  }
}
