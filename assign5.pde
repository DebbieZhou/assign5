PImage bg1,bg2,enemy,fighter,hp,treasure,start1,start2,end1,end2,shoot;
PImage[] bomb = new PImage[5];
int bgX = 640 , ex = -3 , ey = floor(random(420)) , enemyState = 2 ;
int fx = 589 , fy = 300 , speed = 3 , blood = 2 , FRAMERATE = 100;
int tx = floor(random(600)) , ty = floor(random(440));
int bullet_now = 0 , legal_enemy_num = 5 , bomb_count = 0 , bullet_count = 0;
boolean []has_bullet = new boolean[5];
int [][]bullet_position = new int[5][2];
int [][]enemy_position = new int [8][2];
boolean []has_collision = new boolean[8];
int [][]collision_position = new int[8][2];
boolean []is_alive = new boolean[8];
boolean up = false ,down = false, left = false, right = false;
final int GAME_START = 0 , GAME_PLAYING = 1 , GAME_LOSE = 2;
int gameState = 0;
int value;
int ax, ay, aw, ah, bx, by, bw, bh;

void setup () {
  size(640, 480) ;
  bg1=loadImage("img/bg1.png"); bg2=loadImage("img/bg2.png");
  end2=loadImage("img/end1.png"); end1=loadImage("img/end2.png");
  enemy=loadImage("img/enemy.png"); fighter=loadImage("img/fighter.png");
  hp=loadImage("img/hp.png"); start2=loadImage("img/start1.png");
  start1=loadImage("img/start2.png"); treasure=loadImage("img/treasure.png");
  shoot=loadImage("img/shoot.png");
  frameRate(FRAMERATE);
  for(int i=0;i<8;i++){
    if(i<5){
      bomb[i]=loadImage("img/flame"+(i+1)+".png");
      has_bullet[i]=false;
    }
    has_collision[i]=false;
    is_alive[i]=true;
  }
}
int scoreChange(int value){
  //bullet
      for(int i=0;i<5;i++){
        if(has_bullet[i]){
          image(shoot,bullet_position[i][0],bullet_position[i][1]);
          bullet_position[i][0] -= 4;
          if(bullet_position[i][0]+30 < 0) has_bullet[i]=false;
          for(int a=0;a<legal_enemy_num;a++){
            if(is_alive[a])
             if(bullet_position[i][0]+30 > enemy_position[a][0] 
               && bullet_position[i][1]+27 > enemy_position[a][1]
               && bullet_position[i][0] < enemy_position[a][0]+60
               && bullet_position[i][1] < enemy_position[a][1]+60 ){
                 value += 20;
                 has_collision[a]=true;
                 for(int b=0;b<2;b++)
                   collision_position[a][b]=enemy_position[a][b];
                 is_alive[a]=false;
                 has_bullet[i]=false;
              }
          }
        }
      }
    return value;
}
boolean isHit(int ax,int ay,int aw,int ah,int bx,int by,int bw,int bh){
   if(ax+aw>=bx && bx+bw>=ax)
    if(ay+ah>=by && by+bh>=ay)return true;
return false;}
void draw()
{ 
  switch(gameState){  
    case GAME_START:
      image(start1,0,0);
      if(mouseY>=380 && mouseY<=415 && mouseX>=210 && mouseX<=455){
        image(start2,0,0);
        if(mousePressed) gameState = GAME_PLAYING;
      }
     break;

    case GAME_PLAYING:
      //background
      image(bg1, bgX % 1280 - 640 ,0);
      image(bg2,(bgX-640)%1280-640 ,0);
      ++bgX;
      
      //fighter
      image(fighter,fx,fy);
      if(up) fy -= speed;
      if(down) fy += speed;
      if(left) fx -= speed;
      if(right) fx += speed;
      
      //boundary check
      fx = max(0,fx); fx = min(fx,589);
      fy = max(0,fy); fy = min(fy,429);
        
      //hp
      noStroke();
      fill(255,0,0);
      if(blood>=0 && blood<=10) rect(26,22,20*blood,25);
      image(hp,20,20);
     
      //treasure
      image(treasure,tx,ty);
      if(fx+50>tx && fy+50>ty && fx<tx+40 && fy<ty+40){
        if(blood<10) ++blood;
        tx=floor(random(600)); ty=floor(random(440));
      }
      
     //enemy
     ex = (ex+3)%(940+500);//940=640+60*5
     enemy_position[0][0] = ex-60;
     if(ex==0){
        enemyState = (enemyState+1)%3;
        for(int i=0;i<8;i++)
          has_collision[i] = false;
        switch(enemyState){
          case 0: 
            legal_enemy_num = 5;
            ey=floor(random(420)); 
            break;
          case 1: 
            legal_enemy_num = 5;
            ey=floor(random(260));
            break;
          case 2:
            legal_enemy_num = 8;
            ey=floor(random(80,340));
            break;
       }
       for(int i=0;i<8;i++){
           if(i<legal_enemy_num) is_alive[i]=true;
           else is_alive[i]=false;
       }
       enemy_position[0][1] = ey; 
     }
  
     //approach fighter
     //if(enY<fy-1) enY+=2;
     //else if(enY>fy+1) enY-=2;
     
     switch(enemyState){
        case 0: 
          for( int i=1;i<5;i++ ){
            enemy_position[i][0]=enemy_position[0][0]-i*60;
            enemy_position[i][1]=enemy_position[0][1];
          }
          break;
        case 1: 
          for( int i=1;i<5;i++ ){
            enemy_position[i][0]=enemy_position[0][0]-i*60;
            enemy_position[i][1]=enemy_position[0][1]+i*40;
          }
          break;
        case 2:
         //for X
         for( int i=0;i<5;i++ ){
           if(i!=0) enemy_position[i][0]=enemy_position[0][0]-i*60;
           if(i!=4) enemy_position[i+4][0]=enemy_position[0][0]-i*60;  
         }
         //for Y
         for( int i=1;i<3;i++ ){
           enemy_position[i][1]=enemy_position[0][1]+i*40;
           enemy_position[i+4][1]=enemy_position[0][1]-i*40;  
         }
         for( int i=3;i<5;i++ )
           enemy_position[i][1]=enemy_position[4-i][1];
         enemy_position[7][1]=enemy_position[5][1];
         break;
      }
      
        // blood
        for(int i=0;i<legal_enemy_num;i++){
          if(is_alive[i])
           if(fx+50 > enemy_position[i][0] && fy+50 > enemy_position[i][1] 
            && fx < enemy_position[i][0]+60 && fy < enemy_position[i][1]+60){
              has_collision[i]=true;
              is_alive[i]=false;
              for(int a=0;a<2;a++)
                collision_position[i][a]=enemy_position[i][a];
              blood-=2;
              if(blood<=0) gameState = GAME_LOSE;  
           }
        }
        
        //flame
        for(int i=0;i<legal_enemy_num;i++){
          if(has_collision[i]){
            image(bomb[bomb_count],collision_position[i][0],collision_position[i][1]);
            if(frameCount%(FRAMERATE/10)==0){
              ++bomb_count;
              if(bomb_count==5){
                bomb_count = 0;
                has_collision[i] = false;
              }
            }
          }
        }
        
        //display alive enemy
        for(int i=0;i<legal_enemy_num;i++)
          if(is_alive[i])
            image(enemy,enemy_position[i][0],enemy_position[i][1]);
 
     value=scoreChange(value);   
     textSize(20);
     fill(255,255,255);
     text("Score:"+(value),0,420);
     break;
  
     case GAME_LOSE:
      image(end1,0,0);
      if(mouseY>=315 && mouseY<=350 && mouseX>=210 && mouseX<=436){
        image(end2,0,0);
        if(mousePressed){
          //initialize
          blood = 2 ; fx = 589 ; fy = 300;
          ey = floor(random(420)) ; ex = -3;
          tx = floor(random(600)); ty =floor( random(440));
          gameState = GAME_PLAYING; enemyState = 2;
          bullet_now = 0;
          for(int i=0;i<8;i++){
            if(i<5) has_bullet[i]=false;
            has_collision[i]=false;
            is_alive[i]=true;
          }
        }
      }
     break;
  }
}

void keyPressed(){
  bullet_count=0;
  if(key==CODED){
    switch(keyCode){
      case UP: up = true ; break;
      case DOWN: down = true ; break;
      case LEFT: left = true ; break;
      case RIGHT: right = true ; break;
    }
  }
  else if(key==' '){
    for(int i=0;i<5;i++)
      if(has_bullet[i]) ++bullet_count;
    if(bullet_count < 5){
      has_bullet[bullet_now] = true;
      bullet_position[bullet_now][0] = fx;
      bullet_position[bullet_now][1] = fy+12;
      bullet_now = (bullet_now+1)%5;
    }
  }
}

void keyReleased(){
  if(key==CODED){
    switch(keyCode){
      case UP: up = false ; break;
      case DOWN: down = false ; break;
      case LEFT: left = false ; break;
      case RIGHT: right = false ; break;
    }
  }
}
