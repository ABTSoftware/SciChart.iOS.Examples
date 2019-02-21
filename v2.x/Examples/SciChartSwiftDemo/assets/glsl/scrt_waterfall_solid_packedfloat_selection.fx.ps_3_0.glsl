precision highp float;
uniform highp vec4 SelectionIndex;
void main ()
{
  gl_FragData[0] = SelectionIndex;
}

