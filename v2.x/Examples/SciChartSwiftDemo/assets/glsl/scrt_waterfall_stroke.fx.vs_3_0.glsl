uniform highp vec4 TextureDimensionsInv;
uniform highp vec4 WaterFallSliceOffsset;
uniform highp vec4 WorldXZOffsetSize;
uniform highp mat4 matWorldViewProj;
uniform highp vec4 screenSize;
uniform sampler2D HeightMapTexture;
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
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_1.w = 1.0;
  tmpvar_2.xyw = tmpvar_1.xyw;
  tmpvar_3.xyw = vNormal.xyw;
  tmpvar_2.z = (vPosition.z + WaterFallSliceOffsset.y);
  tmpvar_3.z = (vNormal.z + WaterFallSliceOffsset.y);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_2.x;
  tmpvar_4.y = WaterFallSliceOffsset.y;
  highp float tmpvar_5;
  highp vec2 _texCoord_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (1.0/(WorldXZOffsetSize.zw));
  _texCoord_6 = ((tmpvar_4 - WorldXZOffsetSize.xy) * tmpvar_7);
  _texCoord_6.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_6.x);
  _texCoord_6.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_6.y);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DLod (HeightMapTexture, _texCoord_6, 0.0);
  tmpvar_5 = tmpvar_8.w;
  tmpvar_2.y = clamp ((vPosition.y * tmpvar_5), WaterFallSliceOffsset.z, WaterFallSliceOffsset.w);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_3.x;
  tmpvar_9.y = WaterFallSliceOffsset.y;
  highp float tmpvar_10;
  highp vec2 _texCoord_11;
  _texCoord_11 = ((tmpvar_9 - WorldXZOffsetSize.xy) * tmpvar_7);
  _texCoord_11.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_11.x);
  _texCoord_11.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_11.y);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2DLod (HeightMapTexture, _texCoord_11, 0.0);
  tmpvar_10 = tmpvar_12.w;
  tmpvar_3.y = clamp ((vNormal.y * tmpvar_10), WaterFallSliceOffsset.z, WaterFallSliceOffsset.w);
  highp vec4 tmpvar_13;
  highp vec2 tmpvar_14;
  highp vec4 outPosition_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = tmpvar_2.xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * matWorldViewProj);
  outPosition_15 = (tmpvar_17 / abs(tmpvar_17.w));
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_3.xyz;
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * matWorldViewProj);
  highp vec2 tmpvar_20;
  tmpvar_20 = normalize(((tmpvar_19 / 
    abs(tmpvar_19.w)
  ).xy - outPosition_15.xy));
  outPosition_15.x = (outPosition_15.x - ((vTexCoord0.x * screenSize.z) * tmpvar_20.y));
  outPosition_15.y = (outPosition_15.y + ((vTexCoord0.x * screenSize.w) * tmpvar_20.x));
  tmpvar_13.xyw = outPosition_15.xyw;
  tmpvar_13.z = (outPosition_15.z - (outPosition_15.z * 1e-5));
  tmpvar_14.x = (0.5 * (1.0 - (
    (vTexCoord0.z - 2.0)
   / vTexCoord0.z)));
  tmpvar_14.y = vTexCoord0.y;
  gl_Position = tmpvar_13;
  xlv_COLOR0 = vColor;
  xlv_TEXCOORD0 = tmpvar_14;
}

