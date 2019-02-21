uniform highp mat4 matWorldViewProj;
uniform highp vec4 screenSize;
attribute highp vec4 vPosition;
attribute highp vec4 vNormal;
attribute highp vec4 vTexCoord1;
attribute highp vec4 vColor;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = vPosition.xyz;
  tmpvar_1.w = 1.0;
  highp vec4 tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.y = 0.0;
  tmpvar_2 = (tmpvar_1 * matWorldViewProj);
  highp float tmpvar_4;
  tmpvar_4 = tmpvar_2.w;
  tmpvar_2 = (tmpvar_2 / tmpvar_2.w);
  highp vec4 tmpvar_5;
  tmpvar_5 = (vNormal * matWorldViewProj);
  highp vec2 tmpvar_6;
  tmpvar_6 = normalize(((tmpvar_5 / tmpvar_5.w).xy - tmpvar_2.xy));
  tmpvar_2.x = (tmpvar_2.x - ((vTexCoord1.x * screenSize.z) * tmpvar_6.y));
  tmpvar_2.y = (tmpvar_2.y + ((vTexCoord1.x * screenSize.w) * tmpvar_6.x));
  tmpvar_2 = (tmpvar_2 * tmpvar_4);
  tmpvar_3.x = (2.0 / vTexCoord1.z);
  tmpvar_3.y = (1.0/(tmpvar_3.x));
  gl_Position = tmpvar_2;
  xlv_COLOR0 = vColor;
  xlv_TEXCOORD0 = tmpvar_3;
}

