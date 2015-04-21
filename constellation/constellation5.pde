

/*
   This program is an example of projection mapping.
   It detects the people in range of kinect and after getting there co-ordinates,
   it connects each point with each other point, creating constellation effect or 
   more literally this program detects and connects people with each other by projecting lines between them.
   --------------------------------------------------
   Requirements: 
   Device: Microsoft Kinect, Projector
   Language: Processing
   Library: SimpleOpenNI for processing
   --------------------------------------------------
   For more details visit www.thesagarsutar.me/portfolio/constellation
   or contact: sagy26.1991@gmail.com
   
*/

import SimpleOpenNI.*;

SimpleOpenNI  context;
PVector com = new PVector();                                   
PVector[] pplCoords = new PVector[]{new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0), 
                                    new PVector(0,0)};

int userCount = 0;

void setup()
{
  size(1024,720);
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();
 
  background(0,0,0,0);
  frameRate(20);
  stroke(100,255,0);
  strokeWeight(10);
  smooth();  
}

void draw()
{
  background(0,0,0,0);
  // update the cam
  context.update();
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  
  if( userList.length>0)//
  {//
    println("No one in a range");//
  }//
  
  for(int i=0; i<userList.length; i++)
  {
    // draw the center of mass
    if( context.getCoM(userList[i],com))
    {
      //println("without calibration: X:" + com.x + " Y: " + com.y);
      // below two lines calibrates x, y co-ordinates with projector 
      pplCoords[i].x = round(map(com.x, 2000,-2060 ,0,1024));   
      pplCoords[i].y = round(map(com.y,455,-760,0,720));
      //println("userID: " + userList[i] + "X:" + com.x + " Y: " + com.y);
      
      println("CALIB userID: " + userList[i] + "X:" + pplCoords[i].x + " Y: " +pplCoords[i].y);
      stroke(100,255,0);
      ellipse(pplCoords[i].x, pplCoords[i].y,20,20);
      
      for(int j=i+1; j<userList.length; j++) {
       line(pplCoords[i].x, pplCoords[i].y, pplCoords[j].x, pplCoords[j].y);
      }
      //println("with calibration: X:" + pplCoords[i].x + " Y: " + pplCoords[i].y);
    }
    
  }
}


void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
 // curContext.startTrackingSkeleton(userId);
 userCount++;
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  int numUsers = curContext.getNumberOfUsers();
  int[] users = curContext.getUsers();
  for(int i = 0; i<numUsers; i++) {
    if(users[i] == userId) {
      println("gotit");
      stroke(0,0,0);
      for(int j=0; j<users.length; j++) {
        line(pplCoords[i].x, pplCoords[i].y, pplCoords[j].x, pplCoords[j].y);
      }
    }
  }
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

/*
void connectPoints(SimpleOpenNI contextRef) {
  int[] userList = contextRef.getUsers();
  stroke(100,255,0);
  strokeWeight(10);
  float startX, startY;
  for(int i=0;i<userList.length;i++)
  {  
    if(context.getCoM(userList[i],com))
    {
      startX = com.x;
      startY = com.y;
      for(int j=i+1; j<userList.length; j++) {
          context.getCoM(userList[j],com);
          line(startX, startY, com.x, com.y);
      }
    }
  }
}


void connectPoints1(PVector[] pplCoords, int userListSize) {
  strokeWeight(10);
  float startX, startY;
  for(int i=0;i<userListSize;i++)
  {  
      startX = pplCoords[i].x;
      startY = pplCoords[i].y;
      for(int j=i+1; j<userListSize; j++) {
          line(startX, startY, pplCoords[j].x, pplCoords[j].y);
      }
  }
}*/

String getCoordString() {
  String dataString = "";
  
  for(int i = 0; i< 8; i++) {
    PVector cord = pplCoords[i];
    dataString = dataString + cord.x + "," + cord.y + ";";
  }
  println(dataString);
  return dataString;
}
