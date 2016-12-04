Button[][] buttons;
int state = 0;
//-2 - failure
//-1 - success

//0 - join table
//1 - sit at table
//2 - place bets
//3 - play
//4 - offer insurance
//5 - offer even money
//6 - other message

Client client;
String username = "";
int money = 100;
String message;
int lastMessage = 0;

int fontSize = 32;
boolean next = true;

void setup(){
  size(600, 600);
  //fullScreen();
  buttons = new Button[10][];
  username += (char)random('A', 'Z'+1);
  for(int i=0;i<5;i++){
    username += (char)random('a', 'z'+1);
  }
  client = new Client("localhost", 4949);
  
  
  buttons[0] = new Button[]{new Button(10, 10, width-20, height-20, "Join as\n" + username, fontSize, color(170), color(0), new Action(){
    public void execute(){
      writeString("J " + username);
    }
  })
  };
  
}

void draw(){
  //if it has been long enough since our last message..
  if(millis() - lastMessage > 1000 && next){
    //see if we got anything useful from the server!
    String in = readString();
    if(in != null){
      lastMessage = millis();
      char type = in.charAt(0);
      if(in.length() > 2){
        in = in.substring(2);
      }
      else{
        in = "";
      }
      
      if(type == 'Y'){
        state = -1;
        message = in;
      }
      else if(type == 'N'){
        state = -2;
        message = in;
      }
      else if(type == 'S'){
        state = 1;
        String[] seats = in.split(";");
        buttons[1] = new Button[seats.length];
        for(int i=0;i<seats.length;i++){
          String[] data = seats[i].split(" ");
          int seat = Integer.parseInt(data[0]);
          String user = data[1];
          int h = (height - 10 - 10 - 10*(seats.length-1))/seats.length;
          int y = 10 + i * (h + 10);
          if(user.equals("O")){
            buttons[1][i] = new Button(10, y, width-20, h, "Seat " + i, fontSize, color(170), color(0), new Action(){
              public void execute(){
                writeString("S " + (int)random(buttons[1].length));
              }
            });
          }
          else{
            buttons[1][i] = new Button(10, y, width-20, h, user, fontSize, color(100), color(170), new Action(){
              public void execute(){
              }
            });
          }
        }
      }
      else if(type == 'T'){
        state = 2;
        int h = (height - 10 - 10 - 10*(4-1))/4;
        buttons[2] = new Button[]{
          new Button(10, 10 + 0 * (h + 10), width-20, h, "Bet $10", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("B 10");
            }
          }),
          new Button(10, 10 + 1 * (h + 10), width-20, h, "Bet $30", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("B 30");
            }
          }),
          new Button(10, 10 + 2 * (h + 10), width-20, h, "Bet $50", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("B 50");
            }
          })
          ,
          new Button(10, 10 + 3 * (h + 10), width-20, h, "Leave", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("L");
            }
          })
        };
      }
      else if(type == 'G'){
        state = 3;
        int h = (height - 10 - 10 - 10*(4-1))/4;
        buttons[3] = new Button[]{
          new Button(10, 10 + 0 * (h + 10), width-20, h, "Hit", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("H");
            }
          }),
          new Button(10, 10 + 1 * (h + 10), width-20, h, "Stay", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("T");
            }
          }),
          new Button(10, 10 + 2 * (h + 10), width-20, h, "Split", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("P");
            }
          }),
          new Button(10, 10 + 3 * (h + 10), width-20, h, "Double", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("D");
            }
          })
        };
      }
      else if(type == 'I'){
        state = 4;
        int h = (height - 10 - 10 - 10*(2-1))/2;
        buttons[4] = new Button[]{
          new Button(10, 10 + 0 * (h + 10), width-20, h, "Accept Insurance", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("I");
            }
          }),
          new Button(10, 10 + 1 * (h + 10), width-20, h, "Decline Insurance", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("N");
            }
          })
        };
      }
      else if(type == 'E'){
        state = 5;
        int h = (height - 10 - 10 - 10*(2-1))/2;
        buttons[5] = new Button[]{
          new Button(10, 10 + 0 * (h + 10), width-20, h, "Accept Even Money", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("E");
            }
          }),
          new Button(10, 10 + 1 * (h + 10), width-20, h, "Decline Even Money", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("N");
            }
          })
        };
      }
      else if(type == 'D'){
        state = 6;
        message = "The dealer has a blackjack.";
      }
      else if(type == 'K'){
        state = 6;
        message = "The dealer busted.";
      }
      else if(type == 'B'){
        state = 6;
        message = "You have a blackjack!";
      }
      else if(type == 'O'){
        state = 6;
        message = "You busted.";
      }
      else if(type == 'W'){
        state = 6;
        message = "Your wager won!";
      }
      else if(type == 'P'){
        state = 6;
        message = "Your wager pushed.";
      }
      else if(type == 'L'){
        state = 6;
        message = "Your wager lost.";
      }
    }
  }
  
  background(0);
  if(state >= 0 && state < 6){
    for(Button b : buttons[state]){
      b.render();
    }
  }
  
  else{
    //failure message
    if(state == -2){
      fill(255, 100, 100);
    }
    //success message
    else if(state == -1){
      fill(100, 255, 100);
    }
    //other game notification
    else if(state == 6){
      fill(255);
    }
    textAlign(CENTER, CENTER);
    textSize(fontSize);
    text(message, 0, 0, width, height);
  }
}

void mousePressed(){
  next = true;
  if(state >= 0 && state < 6){
    for(Button b : buttons[state]){
      if(b.isOver(mouseX, mouseY)){
        b.click();
      }
    }
  }
}

class Button{
  private Action action;
  private int x, y, w, h, textsize;
  private color bgcolor;
  private color textcolor;
  private String text;
  
  public Button(int x, int y, int w, int h, String text, int textsize, color bg, color textcolor, Action a){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.textsize = textsize;
    this.bgcolor = bg;
    this.textcolor = textcolor;
    this.action = a;
  }
  
  public void render(){
    fill(bgcolor);
    rect(x, y, w, h, 5);
    fill(textcolor);
    textAlign(CENTER, CENTER);
    textSize(textsize);
    text(text, x, y, w, h);
  }
  
  public boolean isOver(int x, int y){
    return x > this.x && x < this.x + w
        && y > this.y && y < this.y + h;
  }
  
  public void click(){
    action.execute();
  }
}

interface Action{
  void execute();
}

public void writeString(String message){
  client.write(message + '\n');
}

public String readString(){
  String in = client.readStringUntil('\n');
  return in==null?null:in.trim();
  
}