import java.util.List;

void setup() {
  size(500,500);
}

int lightning = 0;
List<List<Float>> vertices = new ArrayList<List<Float>>();
int i = 0;
void draw() {
  if (i++ >= 10) {
    for (List<Float> vertice : vertices) {
      double deg = Math.random() * 360;
      float ox = vertice.get(0);
      float oy = vertice.get(1);
      double dist = Math.sqrt((ox - 250) * (oy - 250));
      double magn = 15 + Math.random() * dist / 100;
      vertice.set(0, vertice.get(2));
      vertice.set(1, vertice.get(3));
      vertice.set(2, ox+(float)(Math.ceil(Math.cos(deg)) * magn));
      vertice.set(3, oy+(float)(Math.ceil(Math.sin(deg)) * magn));
    }
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
  for (List<Float> vertice : vertices) {
    double dist = Math.sqrt((vertice.get(2) - 250) * (vertice.get(3) - 250));
    stroke(blend(0xff0000ff, 0xaaaaaaff, (float)(dist/350)));
    strokeWeight(Math.max((float)Math.ceil((1 - dist/400) * 8), 4));
    line(vertice.get(0), vertice.get(1), vertice.get(2), vertice.get(3));
  }
}

void mousePressed() {
  List<Float> newVertice = new ArrayList<Float>();
  newVertice.add(250f); newVertice.add(250f);
  newVertice.add(250f); newVertice.add(250f);
  vertices.add(newVertice);
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
