uniform highp mat4 matWorldViewProj;
uniform highp vec4 screenSize;
attribute highp vec4 vPosition;
attribute highp vec4 vNormal;
attribute highp vec4 vTexCoord0;
attribute highp vec4 vColor;
varying highp vec4 xlv_TEXCOORD5;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = vPosition.xyz;
  highp vec4 tmpvar_2;
  tmpvar_1.w = 1.0;
  highp vec2 tmpvar_3;
  tmpvar_3.y = 0.0;
  highp vec4 outPosition_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 1.0);
  tmpvar_5.xy = tmpvar_1.xy;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * matWorldViewProj);
  outPosition_4 = (tmpvar_6 / abs(tmpvar_6.w));
  highp vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.0, 1.0);
  tmpvar_7.xy = vNormal.xy;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * matWorldViewProj);
  highp vec2 tmpvar_9;
  tmpvar_9 = normalize(((tmpvar_8 / 
    abs(tmpvar_8.w)
  ).xy - outPosition_4.xy));
  outPosition_4.x = (outPosition_4.x - ((vTexCoord0.x * screenSize.z) * tmpvar_9.y));
  outPosition_4.y = (outPosition_4.y + ((vTexCoord0.x * screenSize.w) * tmpvar_9.x));
  tmpvar_3.x = (2.0 / vTexCoord0.z);
  tmpvar_3.y = (1.0/(tmpvar_3.x));
  highp vec2 tmpvar_10;
  tmpvar_10.x = vTexCoord0.y;
  tmpvar_10.y = vTexCoord0.w;
  tmpvar_2.xzw = outPosition_4.xzw;
  tmpvar_2.y = -(outPosition_4.y);
  gl_Position = tmpvar_2;
  xlv_TEXCOORD5 = outPosition_4;
  xlv_COLOR0 = vColor;
  xlv_TEXCOORD0 = tmpvar_10;
  xlv_TEXCOORD1 = tmpvar_3;
}

