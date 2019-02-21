uniform highp mat4 matProj;
uniform highp mat4 matWorldView;
uniform highp vec4 PackedFloatParams;
uniform highp vec4 TextureDimensionsInv;
uniform highp vec4 WaterFallSliceOffsset;
uniform highp vec4 WaterFallTexCoordCalcParams;
uniform highp vec4 WorldXZOffsetSize;
uniform sampler2D HeightMapTexture;
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
  highp vec2 tmpvar_2;
  tmpvar_1.xyw = vPosition.xyw;
  tmpvar_2.y = vTexCoord0.y;
  highp vec4 tmpvar_3;
  tmpvar_1.z = (vPosition.z + WaterFallSliceOffsset.y);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_1.x;
  tmpvar_4.y = WaterFallSliceOffsset.y;
  highp vec2 _texCoord_5;
  _texCoord_5 = ((tmpvar_4 - WorldXZOffsetSize.xy) * (1.0/(WorldXZOffsetSize.zw)));
  _texCoord_5.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_5.x);
  _texCoord_5.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_5.y);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DLod (HeightMapTexture, _texCoord_5, 0.0);
  highp vec4 rgba_7;
  rgba_7 = tmpvar_6.zyxw;
  tmpvar_1.y = clamp ((vPosition.y * (
    (dot (rgba_7.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x)), WaterFallSliceOffsset.z, WaterFallSliceOffsset.w);
  tmpvar_2.x = abs(((1.0 - 
    ((mix (tmpvar_1.y, WaterFallSliceOffsset.y, WaterFallTexCoordCalcParams.x) - WaterFallTexCoordCalcParams.y) / WaterFallTexCoordCalcParams.z)
  ) - WaterFallTexCoordCalcParams.w));
  tmpvar_1.w = 1.0;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = 0.0;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_COLOR0 = vColor;
  xlv_COLOR1 = vColor1;
  xlv_COLOR2 = vColor2;
}

