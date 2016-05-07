int maxx = 680;
int maxy = 400;

float tank_size = 24.0;
float cannon_length = 0.75 * tank_size; 


float x1 = (maxx / 2.0) - 32.0;
float y1 = maxy / 2.0;
float x2 = (maxx / 2.0) + 32.0;
float y2 = maxy / 2.0;
//Follow classic angles: 
// *  3 o'clock: 0.0 PI
// * 12 o'clock: 0.5 PI, 
// *  9 o'clock: 1.0 PI
// *  6 o'clock: 1.5 PI
float angle1 = 1.0 * PI;
float angle2 = 0.0 * PI;
int score1 = 0;
int score2 = 0;

boolean left_wheel_1_forward = false; 
boolean right_wheel_1_forward = false; 
boolean left_wheel_1_backward = false; 
boolean right_wheel_1_backward = false;
boolean left_shoot_1 = false;
boolean right_shoot_1 = false;

boolean left_wheel_2_forward = false; 
boolean right_wheel_2_forward = false; 
boolean left_wheel_2_backward = false; 
boolean right_wheel_2_backward = false;
boolean left_shoot_2 = false;
boolean right_shoot_2 = false;

float bullet_size = 16.0;

float bullet1_x = 2.25 * maxx;
float bullet1_y = 0.5 * maxy;
float bullet1_angle = 0.0 * PI;

float bullet2_x = 2.75 * maxx;
float bullet2_y = 2.5 * maxy;
float bullet2_angle = 0.0 * PI;

void setup()
{
  size(680,400);
  textSize(32);
}

void draw()
{
  background(0);

  draw_score();
  draw_tanks();
  draw_bullets();
  
  move_tanks();
  move_bullets();
  check_collisions();
}

void check_collisions()
{
  //Bullet-bullet
  if (dist(bullet1_x,bullet1_y,bullet2_x,bullet2_y) < bullet_size) {
    bullet1_x = 2.0 * maxx;
    bullet2_x = 2.0 * maxx;
    bullet1_angle = 0.0;
    bullet2_angle = 0.0;
  }
  if (dist(bullet1_x,bullet1_y,x2,y2) < (0.5 * bullet_size) + (0.5 * tank_size)) {
    bullet1_x = 2.0 * maxx;
    bullet1_angle = 0.0;
    ++score2;
  }
  if (dist(bullet2_x,bullet2_y,x1,y1) < (0.5 * bullet_size) + (0.5 * tank_size)) {
    bullet2_x = 2.0 * maxx;
    bullet2_angle = 0.0;
    ++score1;
  }
}

void draw_bullets()
{
  stroke(128,128,128);
  strokeWeight(3);
  fill(196,196,196);
  if (
       bullet1_x > -0.5 * bullet_size 
    && bullet1_x < maxx + (0.5 * bullet_size)
    && bullet1_y > -0.5 * bullet_size 
    && bullet1_y < maxy + (0.5 * bullet_size)
  ) { 
    ellipse(bullet1_x, bullet1_y, bullet_size, bullet_size);
  }
  if (
       bullet2_x > -0.5 * bullet_size 
    && bullet2_x < maxx + (0.5 * bullet_size)
    && bullet2_y > -0.5 * bullet_size 
    && bullet2_y < maxy + (0.5 * bullet_size)
  ) { 
    ellipse(bullet2_x, bullet2_y, bullet_size, bullet_size);
  }
}


void draw_score()
{
  stroke(0); fill(0);
  rect(1 * maxx / 4, 4,64,32);
  rect(3 * maxx / 4, 4,64,32);
  fill(255,0,0); stroke(196,0,0);
  text(score1, 1 * maxx / 4, 32);
  fill(0,0,255); stroke(0,0,225);
  text(score2, 3 * maxx / 4, 32);
}

void draw_tanks()
{
  fill(255,0,0); stroke(196,0,0);
  draw_tank(x1,y1,angle1);

  fill(0,0,255); stroke(0,0,225);
  draw_tank(x2,y2,angle2);
}

void draw_tank(float x, float y, float angle)
{
  //Tracks
  /*
  
                 (xc,yc)
                  |   |
                  |   |
     (xlf,ylf)    |   |    (xrf,yrf)
      |     |     |   |     |     |
      (xl,yl) --- (x,y) --- (xr,yr)
      |     |               |     |       
     (xlb,ylb)             (xrb,yrb)
  */
  strokeWeight(1);
  ellipse(x,y,tank_size,tank_size);
  //Cannon
  float xc = x + (cos(angle) * cannon_length); 
  float yc = y - (sin(angle) * cannon_length); 
  strokeCap(PROJECT);
  strokeWeight(5);
  line(x,y,xc,yc);
  //Left tracks
  float xl = x + (cos(angle - (0.5 * PI)) * tank_size * 0.5);
  float yl = y - (sin(angle - (0.5 * PI)) * tank_size * 0.5); 
  float xlf = xl + (cos(angle) * tank_size * 0.5);
  float ylf = yl - (sin(angle) * tank_size * 0.5); 
  float xlb = xl + (cos(angle + PI) * tank_size * 0.5);
  float ylb = yl - (sin(angle + PI) * tank_size * 0.5); 
  line(xlf,ylf,xlb,ylb);
  //Right tracks
  float xr = x + (cos(angle + (0.5 * PI)) * tank_size * 0.5);
  float yr = y - (sin(angle + (0.5 * PI)) * tank_size * 0.5); 
  float xrf = xr + (cos(angle) * tank_size * 0.5);
  float yrf = yr - (sin(angle) * tank_size * 0.5); 
  float xrb = xr + (cos(angle + PI) * tank_size * 0.5);
  float yrb = yr - (sin(angle + PI) * tank_size * 0.5); 
  line(xrf,yrf,xrb,yrb);
  line(x,y,x + (cos(angle) * 16.0),y - (sin(angle) * 16.0));
}

void keyPressed() {
  if (key == 'q' || key == 'Q') { left_wheel_1_forward = true; }
  if (key == 'u') { right_wheel_1_forward = true; }
  if (key == 'z') { left_wheel_1_backward = true; }  
  if (key == 'm') { right_wheel_1_backward = true; }

  if (key == 'a') { left_shoot_1 = true; }
  if (key == 'j') { right_shoot_1 = true; }

  if (key == 'r') { left_wheel_2_forward = true; }
  if (key == 'p') { right_wheel_2_forward = true; }
  if (key == 'v') { left_wheel_2_backward = true; }
  if (key == '/') { right_wheel_2_backward = true; }

  if (key == 'f') { left_shoot_2 = true; }
  if (key == ';') { right_shoot_2 = true; }
}

void keyReleased() {
  if (key == 'q') { left_wheel_1_forward = false; }
  if (key == 'u') { right_wheel_1_forward = false; }
  if (key == 'z') { left_wheel_1_backward = false; }
  if (key == 'm') { right_wheel_1_backward = false; }
  if (key == 'a') { left_shoot_1 = false; }
  if (key == 'j') { right_shoot_1 = false; }
  
  if (key == 'r') { left_wheel_2_forward = false; }
  if (key == 'p') { right_wheel_2_forward = false; }
  if (key == 'v') { left_wheel_2_backward = false; }
  if (key == '/') { right_wheel_2_backward = false; }
  if (key == 'f') { left_shoot_2 = false; }
  if (key == ';') { right_shoot_2 = false; }
}

void move_bullets()
{
  double velocity = 2.0;
  bullet1_x += cos(bullet1_angle) * velocity; 
  bullet1_y -= sin(bullet1_angle) * velocity; 
  bullet2_x += cos(bullet2_angle) * velocity; 
  bullet2_y -= sin(bullet2_angle) * velocity; 
}

void move_tanks()
{
  double velocity = 1.0;
  double delta_angle = PI * 0.01;
  //Forward
  if (left_wheel_1_forward && right_wheel_1_forward) { 
    x1 += cos(angle1) * velocity; 
    y1 -= sin(angle1) * velocity; 
  }
  else if (left_wheel_1_forward) { angle1 -= delta_angle; }
  else if (right_wheel_1_forward) { angle1 += delta_angle; }

  if (left_wheel_2_forward && right_wheel_2_forward) { 
    x2 += cos(angle2) * velocity; 
    y2 -= sin(angle2) * velocity; 
  }
  else if (left_wheel_2_forward) { angle2 -= delta_angle; }
  else if (right_wheel_2_forward) { angle2 += delta_angle; }
  //Backward
  if (left_wheel_1_backward && right_wheel_1_backward) { 
    x1 -= cos(angle1) * velocity; 
    y1 += sin(angle1) * velocity; 
  }
  else if (left_wheel_1_backward) { angle1 += delta_angle; }
  else if (right_wheel_1_backward) { angle1 -= delta_angle; }

  if (left_wheel_2_backward && right_wheel_2_backward) { 
    x2 -= cos(angle2) * velocity; 
    y2 += sin(angle2) * velocity; 
  }
  else if (left_wheel_2_backward) { angle2 += delta_angle; }
  else if (right_wheel_2_backward) { angle2 -= delta_angle; }
  //Shoot  
  if (left_shoot_1 && right_shoot_1 
    && !(bullet1_x > -0.5 * bullet_size && bullet1_x < maxx + (0.5 * bullet_size) && bullet1_y > -0.5 * bullet_size  && bullet1_y < maxy + (0.5 * bullet_size))
  )
  {
    bullet1_x = x1 + (cos(angle1) * (cannon_length + (0.5 * bullet_size)));
    bullet1_y = y1 - (sin(angle1) * (cannon_length + (0.5 * bullet_size)));
    bullet1_angle = angle1;
  }
  if (left_shoot_2 && right_shoot_2 
    && !(bullet2_x > -0.5 * bullet_size && bullet2_x < maxx + (0.5 * bullet_size) && bullet2_y > -0.5 * bullet_size  && bullet2_y < maxy + (0.5 * bullet_size))
  )
  {
    bullet2_x = x2 + (cos(angle2) * (cannon_length + (0.5 * bullet_size)));
    bullet2_y = y2 - (sin(angle2) * (cannon_length + (0.5 * bullet_size)));
    bullet2_angle = angle2;
  }
}