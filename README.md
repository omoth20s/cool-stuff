Project Description:

  This project was made for the purpose of interacting with an Arduino controlled version of wizard’s chess. It is a graphical chess game that you can open through processing. The program has error checking for a chess game including the queen being able to move left , right, up, down, and diagonally. The rook can move up, down, left and right. The bishop can move diagonally. The Knight can move in L patterns. The pawn can move forward 2 if it has not moved yet cannot take an enemy piece in front of it, if it has moved can only move forward 1 space and if an enemy piece is diagonally forward to the pawn it can take that piece. Each piece must have a clear path to the destination space except for the Knight and no piece can take an allied piece. Finally no piece can move off the board. The program also has built in function to perform kings castle (if the king and the rook have not moved and the spaces between them then the king can move two spaces to the left or right depending on which rook the player performs kings castle with, and if this is done the rook will also move to the other side of the king (in the space next to it)). The game in its current state does not allow the player to choose what they want to change a pawn to when it reaches the other side of the board so the piece will default to a queen and the game also cannot detect if a kings is in check or checkmate so this is left up to the players. There is no built in AI to play against as this is meant to be a 2 player game.
  
  When the game is opened it should have a blue background with spaces between each space on the board and have all the pieces in the correct positions to start a game of chess. When moving the pieces the players must take turns so white move first then black must move and so on. When moving a piece the game will show green borders around any space that the piece may move to, and if the player clicks on any space without a green border around it the move is cancelled and the player will have to select a piece again. With this program you can play a game of chess on your computer against another player.
  
Manifest:

  •	Graphic_chess.pde
  
  •	You will also need to download the picture with all the chess pieces from this website:
  http://www.wpclipart.com/recreation/games/chess/chess_set_symbols.png.html 

Installation:

  1.	Download and install processing from http://www.processing.org 
  2.	Save graphic_chess in the processing folder
  3.	Download chess pieces from http://www.wpclipart.com/recreation/games/chess/chess_set_symbols.png.html the picture 		should   be 964X288 and saved in the same folder as the graphic_chess.pde file
  4.	You should then be able to open the file and run the program


Copyright:

Credits: 

	Program written by Shane Omoth
	Picture from

