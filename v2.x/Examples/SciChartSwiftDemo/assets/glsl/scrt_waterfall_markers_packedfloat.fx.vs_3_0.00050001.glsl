uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
uniform highp vec4 PackedFloatParams;
uniform highp vec4 TextureDimensionsInv;
uniform highp vec4 WaterFallSliceOffsset;
uniform highp vec4 WorldXZOffsetSize;
uniform sampler2D HeightMapTexture;
attribute highp vec4 vPosition;
attribute highp vec3 vNormal;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
attribute highp vec4 vTexCoord1;
attribute highp vec4 vTexCoord2;
attribute highp vec4 vColor1;
attribute highp vec4 vColor2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_COLOR1;
varying highp vec4 xlv_COLOR2;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.w = vPosition.w;
  tmpvar_2.xyw = vTexCoord1.xyw;
  highp vec4 tmpvar_3;
  tmpvar_2.z = (vTexCoord1.z + WaterFallSliceOffsset.y);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_2.x;
  tmpvar_4.y = WaterFallSliceOffsset.y;
  highp vec2 _texCoord_5;
  _texCoord_5 = ((tmpvar_4 - WorldXZOffsetSize.xy) * (1.0/(WorldXZOffsetSize.zw)));
  _texCoord_5.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_5.x);
  _texCoord_5.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_5.y);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DLod (HeightMapTexture, _texCoord_5, 0.0);
  highp vec4 rgba_7;
  rgba_7 = tmpvar_6.zyxw;
  tmpvar_2.y = clamp ((vTexCoord1.y * (
    (dot (rgba_7.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x)), WaterFallSliceOffsset.z, WaterFallSliceOffsset.w);
  tmpvar_1.xyz = (vPosition.xyz * vTexCoord2.xyz);
  tmpvar_1.xyz = (tmpvar_1.xyz + tmpvar_2.xyz);
  tmpvar_1.w = 1.0;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = vTexCoord0;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = matWorld[0].xyz;
  tmpvar_8[1] = matWorld[1].xyz;
  tmpvar_8[2] = matWorld[2].xyz;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_COLOR0 = vColor;
  xlv_TEXCOORD1 = (tmpvar_1 * matWorld);
  xlv_TEXCOORD2 = (vNormal * tmpvar_8);
  xlv_COLOR1 = vColor1;
  xlv_COLOR2 = vColor2;
}

