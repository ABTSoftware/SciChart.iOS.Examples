uniform highp mat4 matProj;
uniform highp mat4 matWorldView;
attribute highp vec4 vPosition;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = vPosition.xyz;
  tmpvar_1.w = 1.0;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
}

