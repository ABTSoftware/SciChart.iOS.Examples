uniform highp mat4 matWorldViewProj;
uniform highp vec4 screenSize;
attribute highp vec4 vPosition;
attribute highp vec4 vNormal;
attribute highp vec4 vTexCoord0;
attribute highp vec4 vTexCoord1;
attribute highp vec4 vColor;
attribute highp vec4 vColor1;
varying highp vec4 xlv_TEXCOORD5;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.x = (vTexCoord0.x * vTexCoord1.z);
  tmpvar_3.y = vTexCoord1.x;
  tmpvar_3.z = vTexCoord0.z;
  tmpvar_3.w = (vTexCoord0.w * vTexCoord1.y);
  tmpvar_1.xyz = mix (vPosition, vNormal, vTexCoord1.yyyy).xyz;
  tmpvar_1.w = 1.0;
  highp vec2 tmpvar_4;
  tmpvar_4.y = 0.0;
  highp vec4 outPosition_5;
  highp vec4 tmpvar_6;
  tmpvar_6.zw = vec2(0.0, 1.0);
  tmpvar_6.xy = tmpvar_1.xy;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * matWorldViewProj);
  outPosition_5 = (tmpvar_7 / abs(tmpvar_7.w));
  highp vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 1.0);
  tmpvar_8.xy = mix (vNormal, vPosition, vTexCoord1.yyyy).xy;
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * matWorldViewProj);
  highp vec2 tmpvar_10;
  tmpvar_10 = normalize(((tmpvar_9 / 
    abs(tmpvar_9.w)
  ).xy - outPosition_5.xy));
  outPosition_5.x = (outPosition_5.x - ((tmpvar_3.x * screenSize.z) * tmpvar_10.y));
  outPosition_5.y = (outPosition_5.y + ((tmpvar_3.x * screenSize.w) * tmpvar_10.x));
  tmpvar_4.x = (2.0 / vTexCoord0.z);
  tmpvar_4.y = (1.0/(tmpvar_4.x));
  highp vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_3.y;
  tmpvar_11.y = tmpvar_3.w;
  tmpvar_2.xzw = outPosition_5.xzw;
  tmpvar_2.y = -(outPosition_5.y);
  gl_Position = tmpvar_2;
  xlv_TEXCOORD5 = outPosition_5;
  xlv_COLOR0 = mix (vColor, vColor1, vTexCoord1.yyyy);
  xlv_TEXCOORD0 = tmpvar_11;
  xlv_TEXCOORD1 = tmpvar_4;
}

