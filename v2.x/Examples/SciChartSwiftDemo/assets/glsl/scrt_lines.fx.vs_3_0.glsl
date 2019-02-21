uniform highp mat4 matWorldViewProj;
uniform highp vec4 screenSize;
attribute highp vec4 vPosition;
attribute highp vec4 vNormal;
attribute highp vec3 vTexCoord0;
attribute highp vec4 vColor;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = vPosition.xyz;
  tmpvar_1.w = 1.0;
  highp vec2 tmpvar_2;
  tmpvar_2.y = 0.0;
  highp vec4 outPosition_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * matWorldViewProj);
  outPosition_3 = (tmpvar_5 / abs(tmpvar_5.w));
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = vNormal.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * matWorldViewProj);
  highp vec2 tmpvar_8;
  tmpvar_8 = normalize(((tmpvar_7 / 
    abs(tmpvar_7.w)
  ).xy - outPosition_3.xy));
  outPosition_3.x = (outPosition_3.x - ((vTexCoord0.x * screenSize.z) * tmpvar_8.y));
  outPosition_3.y = (outPosition_3.y + ((vTexCoord0.x * screenSize.w) * tmpvar_8.x));
  tmpvar_2.x = (2.0 / vTexCoord0.z);
  tmpvar_2.y = (1.0/(tmpvar_2.x));
  gl_Position = outPosition_3;
  xlv_COLOR0 = vColor;
  xlv_TEXCOORD0 = tmpvar_2;
}

