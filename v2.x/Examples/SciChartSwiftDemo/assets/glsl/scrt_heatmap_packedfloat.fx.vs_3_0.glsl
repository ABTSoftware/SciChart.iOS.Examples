uniform highp mat4 matProj;
uniform highp mat4 matWorldView;
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = vPosition.xyz;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_1.w = 1.0;
  tmpvar_2 = (tmpvar_1 * (matWorldView * matProj));
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = vTexCoord0;
  tmpvar_2.y = -(tmpvar_2.y);
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_COLOR0 = vColor;
}

