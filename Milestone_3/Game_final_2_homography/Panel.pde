

class Panel {
  
PFont font = createFont("Xenotron.ttf", 19);
color bgColor =#6943AF;
PGraphics background;
PGraphics topView;
PGraphics scoreBoard;
float scale;
int topViewDim = 180;
double totalScore, lastScore = 0;
double velocity = 0;
Chart chartGraph;
HScrollbar bar;

  Panel(){
    scale = topViewDim/PLATE_DIM;
    background = createGraphics(width, 200, P3D);
    topView = createGraphics(topViewDim, topViewDim, P3D);
    scoreBoard = createGraphics(200, 190, P3D);
    chartGraph = new Chart(540, 100);
    bar = new HScrollbar(435, 910, 540, 15);
  }
  
  public void drawPanel(Ball ball){
    drawBackground();
    drawTopView(ball);
    drawScoreBoard();
    bar.updateBar();
    chartGraph.updateScale(bar.getPos());
    bar.drawScrollbar();
    chartGraph.drawChart();
    
   
   
  }
  
  private void drawBackground(){
    background.beginDraw();
    background.background(bgColor);
    background.endDraw();
    image(background, 0, 800);
  }
  
  private void drawTopView(Ball b){
    topView.beginDraw();
    topView.background(plateColor);
    topView.translate(topViewDim/2, topViewDim/2);
    topView.fill(ballColor);
    topView.ellipse(b.location.x*scale, b.location.z*scale ,b.radius*2*scale, b.radius*2*scale);
    topView.fill(cylinderColor);
    for (PVector v : cylinders){
      topView.ellipse(v.x*scale, v.y*scale, cylinderBaseSize*2*scale, cylinderBaseSize*2*scale);
    }
    topView.endDraw();
    image(topView,10, 810);
  }
  
  double epsilon = .01;
  protected void updateScore(Boolean cylinderHit, double velocityMag){
    int velMag = (int)Math.floor(velocityMag/100);
    if (velMag != 0){
      if (cylinderHit){
          totalScore += velMag;
          lastScore = velMag;
        } else {
          totalScore = Math.max(0,totalScore - velMag);
          lastScore = -velMag;
        }
        chartGraph.update(totalScore);
      }
  }
  
  protected void updateVelocity(double vel){
    velocity =Math.round(vel/100);
  }
  
  final String totalScore_s = "Total score";
  final String vel = "Velocity";
  final String lastScore_s = "Last score";
  
  private void drawScoreBoard(){
    scoreBoard.beginDraw();
    scoreBoard.background(bgColor);
    scoreBoard.noFill();//fill(#4B2E2E);
    scoreBoard.stroke(#FFFFFF);
    scoreBoard.strokeWeight(5);
    scoreBoard.rect(0,0,200, 190);
    scoreBoard.fill(#151313);
    scoreBoard.textFont(font); //here we can change the font
    
    scoreBoard.text(totalScore_s, 5, 30);
    scoreBoard.text(String.format("%.0f", totalScore), 70, 60);
    scoreBoard.text(vel, 35,90); 
    scoreBoard.text(String.format("%.0f", velocity), 70, 120);
    scoreBoard.text(lastScore_s, 15, 150);
    scoreBoard.text(String.format("%.0f", lastScore), 70, 180);
    scoreBoard.endDraw();
    image(scoreBoard, topViewDim + 30, 805);
  }





}