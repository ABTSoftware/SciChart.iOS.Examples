uniform highp mat4 matProj;
uniform highp mat4 matWorldView;
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.xyz = vPosition.xyz;
  tmpvar_2.x = vTexCoord0.x;
  highp vec4 tmpvar_3;
  tmpvar_2.y = (1.0 - vTexCoord0.y);
  tmpvar_1.w = 1.0;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = tmpvar_2;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_3;
}

