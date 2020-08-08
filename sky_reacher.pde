//Ultrasound plane, a game with a plane and an ultrasound sensor 

int i, j,k;
int  Life, Life1, Life2;
int Score, player , chance , score1, score2;
float DistancePlaneBird;
float DistancePlaneBomb;


float PlaneY; //plane Y-coordinates
float Angle;
int DistanceUltra;
int IncomingDistance;


float StarX;
float StarY;
float BombX;
float BombY;

float CityX ;  //for X position




String DataIn; //incoming data on the serial port

//5 a 32 cm


float [] CloudX = new float[6];
float [] CloudY = new float[6];




PImage Cloud;
PImage Star;
PImage Plane;
PImage City;
PImage Bomb;



// serial port config
import processing.serial.*; 
Serial myPort;    



//preparation
final int stateWaitBeforeProgram = 0;
final int stateNormalProgram = 1;
int state = stateWaitBeforeProgram;

void setup() 
{

    myPort = new Serial(this, Serial.list()[1], 9600); 

    myPort.bufferUntil(10);  

    frameRate(30);//initial speed
    

    size(800, 600);
    rectMode(CORNERS) ; //we give the corners coordinates 
    noCursor(); //removes Cursor
    textSize(16);

    PlaneY = 300; //initial plane value(starting point)
    


    Cloud = loadImage("cloud.png");  //load a picture
    Star = loadImage("star.png");  
    Plane = loadImage("plane.png"); //the new plane picture
    Bomb =loadImage("bomb.png");

        City = loadImage("city.png");  //some grass


    //int clouds position
    for  (int i = 1; i <= 5; i = i+1) {
        CloudX[i]=random(1000);
        CloudY[i]=random(400);
    }


    Score = 0;
    score1 = 0;
    score2 = 0;
    Life=3;
    Life1 = 3;
    Life2 = 3;
 //   player =1;
    chance =1;
}


//incoming data event on the serial port


void serialEvent(Serial p) { 
    DataIn = p.readString(); 
    // println(DataIn);

    IncomingDistance = int(trim(DataIn)); //conversion from string to integer

    println(IncomingDistance); //checks
    if (IncomingDistance == 0)   // potentiometer sends a 0 
 {   player = 1;
     myPort.write('0');
}
    if (IncomingDistance == 1)
 {   player =2;
  myPort.write('0');
 }
 
    if (IncomingDistance>1  && IncomingDistance<100 ) {
        DistanceUltra = IncomingDistance; //save the value only if its in the range 1 to 100     }
    }
}
void draw()

{ //textFont(algerian);
  if (state == stateWaitBeforeProgram)
{
 
 background(0);
  
  textSize(80);
  fill(244,8,8);
  text ("SKY REACHER " + player,80,200); 
  textSize(32);
  fill(211,86,241);
  if( player == 1)
  {
  if ( Life ==0)
  {
           textSize(60);
        fill(244,8,8);
        text("GAME OVER :'') ",200,300);
        textSize(30);       
        fill(185,39,137);
        text("BETTER LUCK NEXT TIME",240,350);
         text("Click to start again",240,400);
         text("SCORE " + Score ,350,450);
 
  }
else
{  
  text("CLICK HERE TO START YOUR JOURNEY",125,300);
}}
 
  
  else if ( player ==2 )
  {if ( chance == 1)
  {
    if ( Life1 ==0)
    {
           textSize(30);
        fill(21,255,72);
        text("GAME OVER Player 1'') ",220,300);
         text("Click to start Player 2",220,400);
        // chance =2;
         
  }
  else
  {text("Click to start Player 1",240,400);
  }
  }
  if ( chance == 2)
  {
    if (Life2 == 0)
    {   
      text("GAME OVER ;) ",200,300);
      text(" Player 2:  " + score2 + "   Player 1:  " + score1 ,200,400); 
      if ( score2 > score1)
      { text(" Player 2 wins " ,250,500);
      }
      
      else if ( score1 > score2)
      { text(" Player 1 wins" ,250,500);
      }
      
      else
      { text(" it's a Draw" ,250,500);
      }
      
    }
    else
    {textSize(30);
        fill(21,255,72);
        text("GAME OVER Player 1'') ",200,300);
         text("Click to start Player 2",240,400);
    }
  }
  
 
}
   else
  {
    fill(185,39,137);
  text("CLICK HERE TO START YOUR JOURNEY",125,300);
}
  
}
else {
 

     
  if ( player ==1)
{
  if (Life > 0)
 { game();}
  else
   { background(0);
     fill(244,8,8);
     textSize(120);
     text("GAME OVER",350,300);
     text("SCORE " + Score ,350,400);
     state = stateWaitBeforeProgram;

   
}}

else //if(player ==  2)
      { if (chance ==1)
      { game();
      score1 = Score;
      Life1 = Life;
      if (Life1 == 0)
      { //Life = 3;
      background(0);
     fill(244,8,8);
     textSize(120);
     text("GAME OVER PLAYER 1",350,300);
     state = stateWaitBeforeProgram;
       Life=3;
  Score =0;
  PlaneY = 300;
       chance =2;
       // Redirect to welcome screen after this
       
      }        
      }
      else 
      {game();
      score2 = Score;
      Life2 = Life;
      if (Life2 == 0)
      {// Redirect to welcome screen after this
     // exit();
        background(0);
     fill(244,8,8);
     textSize(120);
     text("GAME OVER PLAYER 2",350,300);
     state = stateWaitBeforeProgram;
    }
      }
         
      }
   
}
}
//main drawing loop
void game() 
{
    background(0, 0, 0);
    SkyDraw(); //draw the sky(function)
    fill(5, 72, 0);
    if(Score>0){
    frameRate(15*(Score+1));}
     if(score1>0)
     {
    frameRate(15*(score1+1));}
    



    //rect(0, 580, 800, 600); 

   

    for  (int i = -2; i <= 4; i = i+1) {  //a loop to display the city picture 6 times

        image(City, 224*i  + CityX, 550, 224, 58);  // 224 58 : picture size
    }

    //calculates the X city translation. Same formulae than the star
    CityX = CityX  -  cos(radians(Angle))*10;

    if (CityX < -224) {  
        CityX=224;
    }


    text(Angle, 10, 30); 
    text(PlaneY, 10, 60); 


    // check the distance between the plane and bird and increase the score
    DistancePlaneBird = sqrt(pow((400-StarX), 2) + pow((PlaneY-StarY), 2)) ;
    DistancePlaneBomb=sqrt(pow((400-BombX), 2) + pow((PlaneY-BombY), 2)) ;
    

    if (DistancePlaneBird < 40) {
        //we hit the bird   
        Score = Score+ 1;

        //reset the bird position
        StarX = 900;
        StarY = random(600);
    }
    if(DistancePlaneBomb<40){
      //we hit the bomb
      Life=Life-1;
      Score=Score-1;
      if(Life==1){
 // return Score;      //exit();//plz change to gameover sort of thing later
      }
      BombX=800;
      BombY = random(600);
    }
      
    

    //here we draw the score
    textSize(20);
    fill(255,250,0);
    text("Score :", 200, 30); 
    text( Score, 270, 30);
    textSize(20);
    fill(255,250,0);
    text("Life :", 300, 30);
    text( Life, 350, 30);



   
    Angle = (18- DistanceUltra)*4;  



    PlaneY = PlaneY + sin(radians(Angle))*10; //calculates the vertical position of the plane

    //check the height range to keep the plane on the screen 
    if (PlaneY < 0) {
        PlaneY=0;
    }

    if (PlaneY > 600) {
        background(0);
        Life =0;
 
      //  return Score;
        
    }

    TraceAvion(PlaneY, Angle);//function for drawing the plane on the screen

    StarX = StarX - cos(radians(Angle))*10;
    BombX=BombX-cos(radians(Angle))*10;

    if (StarX < -30) {
        StarX=900;
        StarY = random(600);
    }
    if(BombX<-30){
      BombX=800;
      BombY=random(600);
    }

    //draw and move the clouds
    for  (int i = 1; i <= 5; i = i+1) {
        CloudX[i] = CloudX[i] - cos(radians(Angle))*(10+2*i);

        image(Cloud, CloudX[i], CloudY[i], 200, 200);

        if (CloudX[i] < -300) {
            CloudX[i]=1000;
            CloudY[i] = random(400);
        }
    }

    image(Star, StarX, StarY, 59, 38); //displays the useless bird. 59 and 38 are the size in pixels of the picture
    image(Bomb,BombX,BombY,59,38);
}



void SkyDraw() {
    //draw the sky

    noStroke();
    rectMode(CORNERS);

    for  (int i = 1; i < 600; i = i+10) {
        fill( 10   +i*0.165, 31   +i*0.118, 96  + i*0.075   );
        //fill(238,126,20);
        rect(0, i, 800, i+10);
    }
}


void TraceAvion(float Y, float AngleInclinaison) {
    //draw the plane at given position and angle

    noStroke();
    pushMatrix();//saves the current coordinate system to the matrix stack 
    translate(400, Y);
    rotate(radians(AngleInclinaison)); //in degres  


   

    scale(0.5);  

    
    image(Plane, -111, -55, 223, 110); // 223 110 : picture size



    popMatrix(); //  Pops the current transformation matrix off the matrix stack
}
void mousePressed() {
 
 
if (state == stateWaitBeforeProgram) {
 state =stateNormalProgram ;
 
}
else {
 
 // normal program 
 // do nothing here
}
if( player ==1)
{
if ( Life == 0)
{
  Life=3;
  Score =0;
  PlaneY = 300;

}}
 
} // func 
//file end
