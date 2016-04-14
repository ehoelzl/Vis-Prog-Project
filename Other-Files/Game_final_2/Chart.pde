
/*Need to update Chart every Second ie every 60 frames*/
/*When chart is too big, only show last 60 score Updates*/
class Chart{
  private int chartWidth;
  private int chartHeight;
  private int rectWidth;
  private int rectHeight;
  private int startPos; //starting Poisition in the array
  private int endPos;
  private int scores[];
  private float scale;
  private color chartColor = #A1E80C;
  private color rectColor = #0C14E8;
  
  private PGraphics chart;
  
  Chart(int chartWidth, int chartHeight){
    scores = new int[chartWidth]; //Maximum number of scores
    rectWidth = ((int)chartWidth / 60); //default rectangle width (60 rectangles)
    startPos = 0;
    endPos = 0;
    rectHeight = 3;
    this.chartWidth = chartWidth;
    this.chartHeight = chartHeight;
    chart = createGraphics( chartWidth, chartHeight, P3D);
  }
  protected  void updateScale(float newScale){
    this.scale = newScale;
     rectWidth = (int)((chartWidth/60f) * (scale/0.5f)); //Compute new width if scale changed
  }
  protected void update(double totalScore){
    scores[endPos] = (int)Math.floor(totalScore);
    endPos = (endPos+1) % scores.length;
    updateStartingPosition();
  }
  
  protected void drawChart(){
  chart.beginDraw();
  chart.background(chartColor);
  int i = startPos;
  while ( i != endPos){
    drawScore(i);
    i = (i+1) % scores.length;
  }
  chart.endDraw();
  image(chart, 435, 805);
  }
  
  /*Updates the startPos variable i.e the index of the first score to draw*/
  private void updateStartingPosition(){
    int count = chartWidth/rectWidth; //Number of scores to draw
    int newStart = (endPos - count) % scores.length;
    if (Math.abs(endPos - startPos) > count){
      startPos = (newStart < 0 ) ? newStart + scores.length : newStart; //check if modulus return negative value
    }  

} 
  
  /*Draws the score in the array given its index*/
  private void drawScore(int idx){
    int xCoord = (idx-startPos) * rectWidth ; // align to left
    int yCoord = chartHeight - rectHeight;
    chart.fill(rectColor);
    
    /*Draws scores[idx] rects above each other*/
    for (int i = 0; i < scores[idx]; i++){
      chart.rect(xCoord,yCoord,rectWidth, rectHeight);
      yCoord -= (rectHeight+1);
    }
  }
}