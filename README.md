Project Description:

  This project was made for the purpose of interacting with an Arduino controlled version of wizard’s chess. It is a graphical chess game that you can open through processing. The program has error checking for a chess game including the queen being able to move left , right, up, down, and diagonally. The rook can move up, down, left and right. The bishop can move diagonally. The Knight can move in L patterns. The pawn can move forward 2 if it has not moved yet cannot take an enemy piece in front of it, if it has moved can only move forward 1 space and if an enemy piece is diagonally forward to the pawn it can take that piece. Each piece must have a clear path to the destination space except for the Knight and no piece can take an allied piece. Finally no piece can move off the board. The program also has built in function to perform kings castle (if the king and the rook have not moved and the spaces between them then the king can move two spaces to the left or right depending on which rook the player performs kings castle with, and if this is done the rook will also move to the other side of the king (in the space next to it)). The game in its current state does not allow the player to choose what they want to change a pawn to when it reaches the other side of the board so the piece will default to a queen and the game also cannot detect if a kings is in check or checkmate so this is left up to the players. There is no built in AI to play against as this is meant to be a 2 player game.
  
  When the game is opened it should have a blue background with spaces between each space on the board and have all the pieces in the correct positions to start a game of chess. When moving the pieces the players must take turns so white move first then black must move and so on. When moving a piece the game will show green borders around any space that the piece may move to, and if the player clicks on any space without a green border around it the move is cancelled and the player will have to select a piece again. With this program you can play a game of chess on your computer against another player.
  
  the .ino file will be uploaded to the arduino and after the track and everything has been built the arduino will be able to take commands sent by the .pde code when it is running and will then perform the moves according to the information sent over a serial connection.
  
Manifest:

  -	Graphic_chess.pde
  
  -	You will also need to download the picture with all the chess pieces from this website:
  http://www.wpclipart.com/recreation/games/chess/chess_set_symbols.png.html 
  
  -	chess.ino
  
  -	makeblock XY Plotter

Installation:

  1.	Download and install processing from http://www.processing.org 
  2.	Save graphic_chess in the processing folder
  3.	Download chess pieces from http://www.wpclipart.com/recreation/games/chess/chess_set_symbols.png.html the picture 		should   be 964X288 and saved in the same folder as the graphic_chess.pde file
  4.	You should then be able to open the file and run the program
  5.	download and install the arduino IDE from http://arduino.cc/en/Main/Software
  6.	download the arduino .ino file
  7.	then create your circuit with the arduino (for this project I used the this motor shield http://www.robotshop.com/ca/en/dual-stepper-motor-driver-shield-arduino.html However it does not work and overheats to quickly to play a game of chess so only 1 motor can be used at a time currently here is the one I will be trying soon http://www.robotshop.com/ca/en/motor-shield-kit-arduino-v2.html but using this one will require you to use the adafruit libraries so the .ino file will have to be changed) put the shield on top of the arduino hook up the motors to the shield use a 6v battery so you can power an electromagnet connect the battery ground to the ground from the arduino and connect that to the electromagnet connect the power supply to the electromagnet and connect pin 9 on the arduino to the electromagnet
  8.	create the board:
  	First buy the track and build it (makeblock XY plotter)
	Place the electro magnet where the pen should be (I used a grove electromagnet, I also screwed it on to the XY plotter with cardboard underneath it to protect it from short circuiting)
	The track is attached to a plywood board (with screws) roughly 2ft by 2ft to keep the track in place
	There are supports screwed in to the ply wood board at each of the four corners on the ply wood and each support is about 5 ¼ inches tall other dimensions for the supports are irrelevant as long as they can support the board and do not interfere with the track
	The actual board was 1/8 inch thick hard board and again roughly 2ft by 2ft 
	The board must have a frame to keep it straight (not sinking in the middle due to how thin it is)
	The frame is 1 inch thick with an 1/8 inch groove in it making the bottom of the 1/8 inch board starting ¾ inches into the frame (this means the board is 6 inches above the plywood base)
	The hard board must have a chess board drawn on it and for my purposes I made the board 14 inches by 14 inches with the center of the first space being the absolute farthest the track can go in both the x and y directions. Therefore the track cannot actually reach the farthest end of the of the chess board on the left side or on the bottom, I did this so that I can move the track to back to these points when I start a game very easily and I can be sure the track is at the first space.
  9. plug a computer into the arduino
  10. upload the .ino code to the arduino
  11. start up the graphic_chess code 
  12. play the game on the computer and the pieces will move on the chess board



Copyright:

	(c) graphic_chess

Credits: 

	Programs written by Shane Omoth
	XY plotter made by makeblock
	electromagnet made by grove
	Picture from http://www.wpclipart.com/recreation/games/chess/chess_set_symbols.png.html  

