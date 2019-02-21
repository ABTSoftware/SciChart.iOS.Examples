uniform highp vec4 TextureDimensionsInv;
uniform highp vec4 WaterFallSliceOffsset;
uniform highp vec4 WorldXZOffsetSize;
uniform highp mat4 matWorldViewProj;
uniform highp vec4 PackedFloatParams;
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
  highp vec2 _texCoord_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (1.0/(WorldXZOffsetSize.zw));
  _texCoord_5 = ((tmpvar_4 - WorldXZOffsetSize.xy) * tmpvar_6);
  _texCoord_5.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_5.x);
  _texCoord_5.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_5.y);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DLod (HeightMapTexture, _texCoord_5, 0.0);
  highp vec4 rgba_8;
  rgba_8 = tmpvar_7.zyxw;
  tmpvar_2.y = clamp ((vPosition.y * (
    (dot (rgba_8.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x)), WaterFallSliceOffsset.z, WaterFallSliceOffsset.w);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_3.x;
  tmpvar_9.y = WaterFallSliceOffsset.y;
  highp vec2 _texCoord_10;
  _texCoord_10 = ((tmpvar_9 - WorldXZOffsetSize.xy) * tmpvar_6);
  _texCoord_10.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_10.x);
  _texCoord_10.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_10.y);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2DLod (HeightMapTexture, _texCoord_10, 0.0);
  highp vec4 rgba_12;
  rgba_12 = tmpvar_11.zyxw;
  tmpvar_3.y = clamp ((vNormal.y * (
    (dot (rgba_12.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x)), WaterFallSliceOffsset.z, WaterFallSliceOffsset.w);
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

