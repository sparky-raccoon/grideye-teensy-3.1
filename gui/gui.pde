import processing.serial.*;

String temp = null;
int lf = 10;
float val;
int indice=0;
Serial myPort;
int i,j;
float [] data = new float[64];
int flag=0;
boolean not500=true;

void setup()
{
  size(400,400);
  printArray(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this,portName,9600);
  background(255);
  stroke(0);
  for (i=0; i<8; i++)
  { 
    for (j=0; j<8; j++)
    {
      rect(i*50,j*50,50,50);
    }
  }
  temp = myPort.readStringUntil(lf);
  temp = null;
  i=7;
  j=7; // j=0;
}

void draw()
{
  while (myPort.available() > 0) {
    temp = myPort.readStringUntil(lf);
    if (temp != null) {
      temp = trim(temp);
      val = float(temp);
      // println(val);
      get_data(val);
    }
  }
}

void get_data(float val) {
  if (val==500) { flag = 1; }
  do {
    data[indice] = val;
    if (indice==63) {
      if ((data[1]==500)&&(data[1]==data[2])) { not500=false; }
      if (not500==true) {
        change_color();
      }
      println("END");
      println();
      indice=0;
      i=7;
      j=7; // j=0
      flag=0;
      not500=true;
    }
    indice++;
  } while (flag == 1);
}

void change_color() {
  for (int t=0; t<64; t++) {
    // Représentation numérique 
    print(data[t]);
    print(" ");
    if ((t+1)%8==0) {
      println();
    } 
    choose_color(data[t]);
    rect(i*50,j*50,50,50); 
    display_data(data[t],i,j+1);
    i--;
    if ((t==7)||(t==15)||(t==23)||(t==31)||(t==39)||(t==47)||(t==55)||(t==63)) {
      j--; //j++
      i=7;
    }
  }
}


void choose_color(float vdata) {
  if (vdata<5) fill(0,0,255);
  else {
    if ((vdata>=5)&&(vdata<10)) fill(30,144,255);
    else {
      if ((vdata>=10)&&(vdata<15)) fill(0,206,209);
      else {
        if ((vdata>=15)&&(vdata<22)) fill(173,255,47); 
        else {
          if ((vdata>=22)&&(vdata<25.5)) fill(255,255,0); 
          else {
            if ((vdata>=25.5)&&(vdata<=31)) fill(255,155,0);
            else {
              if ((vdata>31)&&(vdata!=500)) fill(255,0,0);
              else fill(255,255,255);
            }
          }
        }
      }
    }
  }
}

void display_data(float vdata,int row,int column) {
  fill(0);
  text(vdata,row*50,column*50);
}
