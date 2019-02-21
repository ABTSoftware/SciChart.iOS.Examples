uniform highp mat4 matProj;
uniform highp mat4 matWorldView;
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
attribute highp vec4 vColor1;
attribute highp vec4 vColor2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_COLOR1;
varying highp vec4 xlv_COLOR2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = vPosition.xyz;
  highp vec4 tmpvar_2;
  tmpvar_1.w = 1.0;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vTexCoord0;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = vColor;
  xlv_COLOR1 = vColor1;
  xlv_COLOR2 = vColor2;
}

