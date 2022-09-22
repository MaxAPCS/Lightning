import java.util.List;

List<LightningBranch> branches = new ArrayList<LightningBranch>();
void setup() {
  size(500,500);
  //noLoop();
  frameRate(12);
  branches.add(new LightningBranch());
}

int lightning = 0;
int i = 0;
void draw() {
  if (i++ >= 6) {
    for (LightningBranch branch : branches) branch.update();
    i = 0;
  }
  noStroke();
  fill(0x44ffffff);
  rect(0, 0, 500, 500);
  fill(0);
  ellipse(250, 250, 15, 15);
  noFill();
  for (LightningBranch branch : branches) branch.draw();
  noFill();
  stroke(0);
  strokeWeight(4);
  ellipse(250, 250, 500, 500);
}

void mousePressed() {
  branches.add(new LightningBranch());
}

// "Borrowed" from StackOverflow
int blend( int i1, int i2, float ratio ) {
    ratio = ratio > 1f ? 1f : (ratio < 0f ? 0f : ratio);
    float iRatio = 1.0f - ratio;

    int a1 = (i1 >> 24 & 0xff);
    int r1 = ((i1 & 0xff0000) >> 16);
    int g1 = ((i1 & 0xff00) >> 8);
    int b1 = (i1 & 0xff);

    int a2 = (i2 >> 24 & 0xff);
    int r2 = ((i2 & 0xff0000) >> 16);
    int g2 = ((i2 & 0xff00) >> 8);
    int b2 = (i2 & 0xff);

    int a = (int)((a1 * iRatio) + (a2 * ratio));
    int r = (int)((r1 * iRatio) + (r2 * ratio));
    int g = (int)((g1 * iRatio) + (g2 * ratio));
    int b = (int)((b1 * iRatio) + (b2 * ratio));

    return a << 24 | r << 16 | g << 8 | b;
}

class LightningBranch {
  private float dir; // DEGREES
  private int magnitude;
  
  private List<LightningBranch> children = new ArrayList<LightningBranch>();
  public static final int defaultdepth = 4;
  
  public LightningBranch() {
    this(defaultdepth, (float)(Math.random() * 360));
  }
  
  private LightningBranch(int depth, float degrees) { // TODO: clamp at plasma ball ring, animate, limit direction to vector
    double degrange = Math.abs(defaultdepth-depth)*16;
    this.dir = (float)(degrees + (Math.random() * degrange)-(degrange/2));
    this.magnitude = (int)Math.floor(depth * (Math.random()*10+10));
    if (depth > 1)
    for (int i = defaultdepth; i >= depth; i-=2) {
      this.children.add(new LightningBranch(depth-1, this.dir));
    }
  }
  
  public void draw() {
    this.draw(250, 250);
  }
  
  private void draw(float ox, float oy) {
    float ex = (float)(ox + Math.cos(this.dir*PI/180) * this.magnitude);
    float ey = (float)(ox + Math.sin(this.dir*PI/180) * this.magnitude);
    double distsq = Math.abs((ex - 250) * (ey - 250));
    float radperc= Math.min(Math.max((float)(distsq / (250 * 250)), 0f), 1f);
    stroke(blend(0xff0000ff, 0xaaeeaaff, radperc));
    strokeWeight((1.1f-radperc) * 10);
    line(ox, oy, ex, ey);
    for (LightningBranch child : children) {
      child.draw(ex, ey);
    }
  }
  
  public void update() {
    this.dir += Math.random()*20-10;
    this.magnitude += Math.random()*2-1;
    for (LightningBranch child : children) {
      child.update();
    }
  }
}
