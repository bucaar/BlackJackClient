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
int bet = 10;
int side = 10;
String message;
int lastMessage = 0;

int fontSize = 72;

Button downButton;

void setup(){
  //size(600, 600);
  buttons = new Button[10][];
  username = new Name().generateName();
  client = new Client("192.168.43.38", 4949);
  
  int h = (height - 10 - 10 - 10*(3-1))/3;
  
  buttons[0] = new Button[]{
    new Button(10, 10 + 0 * (h + 10), width-20, h, "Welcome to BlackJack!", fontSize, color(100), color(170), new Action(){
      public void execute(){
        println("click");
      }
    }),
    new Button(10, 10 + 1 * (h + 10), width-20, h,  "Join as " + username, fontSize, color(170), color(0), new Action(){
      public void execute(){
        writeString("J " + username);
      }
    }),
    new Button(10, 10 + 2 * (h + 10), width-20, h, "Exit", fontSize, color(170), color(0), new Action(){
      public void execute(){
        exit();
      }
    })
  };
}

void draw(){
  //if it has been long enough since our last message..
  if(millis() - lastMessage > 1500){
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
          final int SEAT = Integer.parseInt(data[0]);
          String user = data[1];
          int h = (height - 10 - 10 - 10*(seats.length-1))/seats.length;
          int y = 10 + i * (h + 10);
          //final int SEAT = i;
          if(user.equals("O")){
            buttons[1][i] = new Button(10, y, width-20, h, "Seat " + SEAT, fontSize, color(170), color(0), new Action(){
              public void execute(){
                writeString("S " + SEAT);
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
        try{
          money = Integer.parseInt(in);
        }
        catch(Exception e){}
        final int h = (height - 10 - 10 - 10*(5-1))/5;
        buttons[2] = new Button[]{
          new Button(10, 10 + 0 * (h + 10), width-20, h, "You have $" + money, fontSize, color(100), color(170), new Action(){
            public void execute(){
              
            }
          }),
          new Button(10, 10 + 1 * (h + 10), width-20, h, "Increase Bet", fontSize, color(170), color(0), new Action(){
            public void execute(){
              bet += 10;
              
              buttons[2][2] = new Button(10, 10 + 2 * (h + 10), width-20, h, "Bet $" + bet, fontSize, color(170), color(0), new Action(){
                public void execute(){
                  writeString("B " + bet);
                }
              });
              
            }
          }),
          new Button(10, 10 + 2 * (h + 10), width-20, h, "Bet $" + bet, fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("B " + bet);
            }
          }),
          new Button(10, 10 + 3 * (h + 10), width-20, h, "Decrease Bet", fontSize, color(170), color(0), new Action(){
            public void execute(){
              bet -= 10;
              if( bet<0){
                bet = 0;
              }
              
              buttons[2][2] = new Button(10, 10 + 2 * (h + 10), width-20, h, "Bet $" + bet, fontSize, color(170), color(0), new Action(){
                public void execute(){
                  writeString("B " + bet);
                }
              });
              
            }
          }),
          new Button(10, 10 + 4 * (h + 10), width-20, h, "Leave Table", fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("L");
            }
          })
        };
      }
      else if(type == 'G'){
        state = 3;
        side = bet;
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
          new Button(10, 10 + 2 * (h + 10), width-20, h, "Split $" + side, fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("P " + side);
            }
          }),
          new Button(10, 10 + 3 * (h + 10), width-20, h, "Double $" + side, fontSize, color(170), color(0), new Action(){
            public void execute(){
              writeString("D " + side);
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
  
  background(60,160,80);
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
  
  //text(frameRate,100,100);
}

void mousePressed(){
  if(state >= 0 && state < 6){
    for(Button b : buttons[state]){
      if(b.isOver(mouseX, mouseY)){
        //b.click();
        downButton = b;
        break;
      }
    }
  }
}

void mouseReleased(){
  if(state >= 0 && state < 6){
    for(Button b : buttons[state]){
      if(b.isOver(mouseX, mouseY)){
        //b.click();
        if(downButton == b){
          b.click();
          break;
        }
        //break;
      }
    }
  }
  downButton = null;
}

void mouseDragged(){
  if(downButton != null && !downButton.isOver(mouseX, mouseY)){
    downButton = null;
  }
}

class Button{
  private Action action;
  private int x, y, w, h, textsize;
  private color bgcolor;
  private color textcolor;
  private String text;
  
  private float glow = 0;
  
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
    strokeWeight(5);
    stroke(brightness(bgcolor)-50);
    fill(bgcolor);
    if(!mousePressed){
      glow = 0;
    }
    if(isOver(mouseX, mouseY) && downButton == this){
      fill(brightness(bgcolor)+cos(glow)*25);
      glow+=.15;
    }
    rect(x, y, w, h, min(w, h)/5);
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
  if(client == null)
    return null;
  String in = client.readStringUntil('\n');
  return in==null?null:in.trim();
  
}