
/*Need to update Chart every Second ie every 60 frames*/
/*When chart is too big, only show last 60 score Updates*/
class Chart{
  private int chartWidth;
  private int chartHeight;
  private int rectWidth;
  private int rectHeight;
  private int endPos;
  private int scores[];
  private int maxScore_displayed;
  private float scale;
  private color chartColor =#010A01;
  private color rectColor = #FFFFFF;

  private PGraphics chart;
  
  /*Constructor of ChartBoard given the width and height in pixels*/
  Chart(int chartWidth, int chartHeight){
    scores = new int[chartWidth]; //Maximuxm number of scores
    rectWidth = ((int)chartWidth / 60); //default rectangle width (60 rectangles)
    endPos = 0;
    maxScore_displayed  = 0;
    rectHeight = 3;
    this.chartWidth = chartWidth;
    this.chartHeight = chartHeight;
    chart = createGraphics( chartWidth, chartHeight, P3D);
  }
  
  /*Updates the scale factor given a new Scale and adjusts the width accordingly*/
  protected  void updateScale(float newScale){
    this.scale = newScale;
     rectWidth = (int)((chartWidth/60f) * (scale/0.5f)); //Compute new width if scale changed
     if (rectWidth <= 1){
       rectWidth = 1;
     }
  }
  
  /*Updates the score table with the last obtained score and rescales the height of the rectangles if we reached the top*/
  protected void update(double totalScore){
    //maxScore_displayed = (int)Math.max(maxScore_displayed, totalScore);
    scores[endPos] = (int)totalScore;
    endPos = (endPos+1) % scores.length;
    //updateStartingPosition();
  }
  
  protected void drawChart(){
  chart.beginDraw();
  chart.background(chartColor);
  int count = chartWidth/rectWidth;
  //chart.noStroke();
  chart.fill(rectColor);
  for (int i = 0; i < count ; i++){
    drawScore(calibrate(endPos, i), count - i);
    
  }
  chart.endDraw();
  image(chart, 435, 805);
  }
  
  private int calibrate(int position, int idx){
      return (position-idx) < 0 ? position-idx + scores.length : position-idx;
  }
  
 /*Draws the score in the array given its index*/
  private void drawScore(int idx, int offset){
    int xCoord = offset * rectWidth ; // align to left
    int yCoord = chartHeight - rectHeight;
    
    /*Draws scores[idx] rects above each other*/
    for (int i = 0; i < Math.min(scores[idx], chartHeight); i++){
      chart.rect(xCoord,yCoord,rectWidth, rectHeight);
      yCoord -= (rectHeight);
    }
  }
}