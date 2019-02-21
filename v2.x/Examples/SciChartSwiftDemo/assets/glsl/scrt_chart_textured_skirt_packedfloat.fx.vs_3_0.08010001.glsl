struct sGridParams {
  highp vec4 ContourScale;
  highp vec4 ContourOffset;
  highp vec4 ContourThickness;
  highp vec4 ContourColorX;
  highp vec4 ContourColorY;
  highp vec4 ContourColorZ;
  highp vec4 Params;
  highp vec4 SurfaceNormal;
  highp vec4 Lighting;
};
uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
uniform highp vec4 PackedFloatParams;
uniform sampler2D HeightMapTexture;
uniform sampler2D HeightMapOffsetsTexture;
uniform highp vec4 TextureDimensionsInv;
uniform highp vec4 MeshCellOfssetScalePosition;
uniform highp vec4 MeshCellOfssetScaleTexCoord;
uniform highp vec4 MeshCellOfssetScaleHeights;
uniform highp vec4 ClipPlanes[6];
uniform sGridParams GridParams;
attribute highp vec4 vPosition;
attribute highp vec4 vTexCoord0;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp float xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
varying highp vec4 xlv_COLOR4;
varying highp vec2 xlv_COLOR5;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.w = vPosition.w;
  tmpvar_2.zw = vTexCoord0.zw;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  highp vec2 tmpvar_7;
  highp mat4 tmpvar_8;
  tmpvar_8 = (matWorldView * matProj);
  tmpvar_1.xz = ((vPosition.xz * MeshCellOfssetScalePosition.xy) + MeshCellOfssetScalePosition.zw);
  highp vec2 _texCoord_9;
  _texCoord_9 = ((vTexCoord0.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_9.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_9.x);
  _texCoord_9.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_9.y);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DLod (HeightMapTexture, _texCoord_9, 0.0);
  highp vec4 rgba_11;
  rgba_11 = tmpvar_10.zyxw;
  tmpvar_1.y = (((
    dot (rgba_11.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8))
   * PackedFloatParams.y) + PackedFloatParams.x) * vPosition.w);
  highp vec3 vsNormal_12;
  highp mat3 tmpvar_13;
  tmpvar_13[0] = matWorld[0].xyz;
  tmpvar_13[1] = matWorld[1].xyz;
  tmpvar_13[2] = matWorld[2].xyz;
  vsNormal_12 = (GridParams.SurfaceNormal.xyz * tmpvar_13);
  highp vec2 _texCoord_14;
  _texCoord_14 = ((vTexCoord0.zw * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_14.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_14.x);
  _texCoord_14.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_14.y);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DLod (HeightMapTexture, _texCoord_14, 0.0);
  highp vec4 rgba_16;
  rgba_16 = tmpvar_15.zyxw;
  highp float tmpvar_17;
  tmpvar_17 = GridParams.Params.w;
  highp float tmpvar_18;
  tmpvar_18 = mix (tmpvar_1.y, ((
    (dot (rgba_16.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * vPosition.w), tmpvar_17);
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, vec2(tmpvar_17));
  tmpvar_5 = tmpvar_2;
  tmpvar_2.xy = clamp (tmpvar_2.xy, 0.0, 1.0);
  tmpvar_2.xy = mix (TextureDimensionsInv.xy, TextureDimensionsInv.zw, tmpvar_2.xy);
  tmpvar_2.xy = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  tmpvar_1.y = ((tmpvar_1.y * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  tmpvar_4 = tmpvar_1;
  highp vec2 _texCoord_19;
  _texCoord_19 = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_19.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_19.x);
  _texCoord_19.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_19.y);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2DLod (HeightMapOffsetsTexture, _texCoord_19, 0.0);
  highp vec2 tmpvar_21;
  tmpvar_21 = tmpvar_20.xy;
  tmpvar_1.xz = (tmpvar_1.xz + tmpvar_21);
  highp vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_1 * matWorld);
  bvec4 tmpvar_23;
  tmpvar_23 = bvec4(ClipPlanes[0]);
  bool tmpvar_24;
  tmpvar_24 = any(tmpvar_23);
  highp float tmpvar_25;
  if (tmpvar_24) {
    highp vec4 tmpvar_26;
    tmpvar_26.w = 1.0;
    tmpvar_26.xyz = tmpvar_22.xyz;
    tmpvar_25 = dot (tmpvar_26, ClipPlanes[0]);
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_6.x = tmpvar_25;
  bvec4 tmpvar_27;
  tmpvar_27 = bvec4(ClipPlanes[1]);
  bool tmpvar_28;
  tmpvar_28 = any(tmpvar_27);
  highp float tmpvar_29;
  if (tmpvar_28) {
    highp vec4 tmpvar_30;
    tmpvar_30.w = 1.0;
    tmpvar_30.xyz = tmpvar_22.xyz;
    tmpvar_29 = dot (tmpvar_30, ClipPlanes[1]);
  } else {
    tmpvar_29 = 1.0;
  };
  tmpvar_6.y = tmpvar_29;
  bvec4 tmpvar_31;
  tmpvar_31 = bvec4(ClipPlanes[2]);
  bool tmpvar_32;
  tmpvar_32 = any(tmpvar_31);
  highp float tmpvar_33;
  if (tmpvar_32) {
    highp vec4 tmpvar_34;
    tmpvar_34.w = 1.0;
    tmpvar_34.xyz = tmpvar_22.xyz;
    tmpvar_33 = dot (tmpvar_34, ClipPlanes[2]);
  } else {
    tmpvar_33 = 1.0;
  };
  tmpvar_6.z = tmpvar_33;
  bvec4 tmpvar_35;
  tmpvar_35 = bvec4(ClipPlanes[3]);
  bool tmpvar_36;
  tmpvar_36 = any(tmpvar_35);
  highp float tmpvar_37;
  if (tmpvar_36) {
    highp vec4 tmpvar_38;
    tmpvar_38.w = 1.0;
    tmpvar_38.xyz = tmpvar_22.xyz;
    tmpvar_37 = dot (tmpvar_38, ClipPlanes[3]);
  } else {
    tmpvar_37 = 1.0;
  };
  tmpvar_6.w = tmpvar_37;
  bvec4 tmpvar_39;
  tmpvar_39 = bvec4(ClipPlanes[4]);
  bool tmpvar_40;
  tmpvar_40 = any(tmpvar_39);
  highp float tmpvar_41;
  if (tmpvar_40) {
    highp vec4 tmpvar_42;
    tmpvar_42.w = 1.0;
    tmpvar_42.xyz = tmpvar_22.xyz;
    tmpvar_41 = dot (tmpvar_42, ClipPlanes[4]);
  } else {
    tmpvar_41 = 1.0;
  };
  tmpvar_7.x = tmpvar_41;
  bvec4 tmpvar_43;
  tmpvar_43 = bvec4(ClipPlanes[5]);
  bool tmpvar_44;
  tmpvar_44 = any(tmpvar_43);
  highp float tmpvar_45;
  if (tmpvar_44) {
    highp vec4 tmpvar_46;
    tmpvar_46.w = 1.0;
    tmpvar_46.xyz = tmpvar_22.xyz;
    tmpvar_45 = dot (tmpvar_46, ClipPlanes[5]);
  } else {
    tmpvar_45 = 1.0;
  };
  tmpvar_7.y = tmpvar_45;
  tmpvar_1.w = 1.0;
  tmpvar_3.xy = tmpvar_2.xy;
  tmpvar_3.zw = tmpvar_2.zw;
  gl_Position = (tmpvar_1 * tmpvar_8);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = vsNormal_12;
  xlv_TEXCOORD6 = tmpvar_18;
  xlv_TEXCOORD7 = tmpvar_5;
  xlv_COLOR4 = tmpvar_6;
  xlv_COLOR5 = tmpvar_7;
}

