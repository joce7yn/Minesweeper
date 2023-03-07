import de.bezier.guido.*;
public final static int NUM_ROWS = 16;
public final static int NUM_COLS = 16;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  for (int m = 0; m < 40; m++) {
    setMines();
  }
}
public void setMines()
{
  int r = (int)(Math.random() * NUM_ROWS);
  int c = (int)(Math.random() * NUM_COLS);
  if (mines.contains(buttons[r][c]) == false) {
    mines.add(buttons[r][c]);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!buttons[r][c].clicked && !mines.contains(buttons[r][c])) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  String loser = "You  Lose :(";
  for (int i = 0; i < mines.size(); i++) {
    if (mines.get(i).flagged == true) {
      mines.get(i).flagged = false;
    }
    mines.get(i).clicked = true;
  }
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (buttons[r][c].clicked && mines.contains(buttons[r][c])) {
        for (int l = 2; l < loser.length() + 2; l++) {
          buttons[7][l].setLabel(loser.substring(l - 2, l - 1));
        }
      }
    }
  }
}
public void displayWinningMessage()
{
  String winner = "You Win!";
  for (int r = 1; r < 15; r++) { 
    for (int c = 4; c < winner.length() + 4; c++) {
      buttons[r][c].setLabel(winner.substring(c - 4, c - 3));
    }
  }
}
public boolean isValid(int r, int c)
{
  if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) {
    return true;
  } else {
    return false;
  }
}
public int countMines(int r, int c)
{
  int numMines = 0;
  for (int a = r - 1; a <= r + 1; a++) {
    for (int b = c - 1; b <= c + 1; b++) {
      if (isValid(a, b)) {
        if (mines.contains(buttons[a][b]) && !(a==r && b==c))
          numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed ()
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      if (flagged == true) {
        flagged = false;
        clicked = false;
      } else if (flagged == false) {
        flagged = true;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int r = myRow - 1; r <= myRow + 1; r++) {
        for (int c = myCol - 1; c <= myCol + 1; c++) {
          if (isValid(r, c) && buttons[r][c].clicked == false)
            buttons[r][c].mousePressed();
        }
      }
    }
  }
  public void draw ()
  {    
    if (flagged)
      fill(#464646);
    else if ( clicked && mines.contains(this) )
      fill(#760E0E);
    else if (clicked)
      fill( #A9C9E8 );
    else
      fill( #F5CBD2 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
