import java.util.List;

void setup() {
  size(500,500);
  //noLoop();
  frameRate(12);
}

int lightning = 0;
List<LightningBranch> branches = new ArrayList<LightningBranch>() {{
  add(new LightningBranch());
}};
int i = 0;
void draw() {
  if (i++ >= 10) {
    for (LightningBranch branch : branches) branch.update();
    i = 0;
  }
  noStroke();
  fill(0x22ffffff);
  rect(0, 0, 500, 500);
  fill(0);
  ellipse(250, 250, 15, 15);
  noFill();
  stroke(0);
  strokeWeight(4);
  ellipse(250, 250, 500, 500);
  
  noFill();
  for (LightningBranch branch : branches) {
    branch.draw();
  }
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
  private int dx = 0, dy = 0;
  private List<LightningBranch> children = new ArrayList<LightningBranch>();
  public static final int defaultdepth = 5;
  
  public LightningBranch() {
    this(defaultdepth);
  }
  
  private LightningBranch(int depth) { // TODO: clamp at plasma ball ring, animate, limit direction to vector
    double deg = Math.random() * 360;
    double magn= depth * 20;
    this.dx = (int)Math.round( Math.cos(deg) * magn );
    this.dy = (int)Math.round( Math.sin(deg) * magn );
    if (depth >= 1)
    for (int i = defaultdepth; i >= depth; i-=2) {
      this.children.add(new LightningBranch(depth-1));
    }
  }
  
  public void draw() {
    this.draw(250, 250);
  }
  
  private void draw(int ox, int oy) {
    int ex = ox + this.dx;
    int ey = ox + this.dy;
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
    for (LightningBranch child : children) {
      child.update();
    }
  }
}
