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
uniform highp vec4 MeshCellSize;
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
  highp vec2 tmpvar_10;
  tmpvar_10 = (vTexCoord0.xy * MeshCellOfssetScaleTexCoord.xy);
  _texCoord_9 = (tmpvar_10 + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_9.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_9.x);
  _texCoord_9.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_9.y);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2DLod (HeightMapTexture, _texCoord_9, 0.0);
  highp vec4 rgba_12;
  rgba_12 = tmpvar_11.zyxw;
  tmpvar_1.y = (((
    dot (rgba_12.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8))
   * PackedFloatParams.y) + PackedFloatParams.x) * vPosition.w);
  highp vec3 vsNormal_13;
  highp vec3 vertexC_14;
  highp vec3 vertexB_15;
  highp vec3 vertexA_16;
  highp vec2 tmpvar_17;
  tmpvar_17.y = 0.0;
  tmpvar_17.x = TextureDimensionsInv.x;
  highp vec2 tmpvar_18;
  tmpvar_18.x = 0.0;
  tmpvar_18.y = TextureDimensionsInv.y;
  vertexA_16.xz = vec2(0.0, 0.0);
  highp vec3 tmpvar_19;
  tmpvar_19.yz = vec2(0.0, 0.0);
  tmpvar_19.x = ((MeshCellSize.x * TextureDimensionsInv.x) * 2.0);
  vertexB_15.xz = tmpvar_19.xz;
  highp vec3 tmpvar_20;
  tmpvar_20.xy = vec2(0.0, 0.0);
  tmpvar_20.z = ((MeshCellSize.y * TextureDimensionsInv.y) * 2.0);
  vertexC_14.xz = tmpvar_20.xz;
  highp vec2 _texCoord_21;
  _texCoord_21 = (tmpvar_10 + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_21.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_21.x);
  _texCoord_21.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_21.y);
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2DLod (HeightMapTexture, _texCoord_21, 0.0);
  highp vec4 rgba_23;
  rgba_23 = tmpvar_22.zyxw;
  vertexA_16.y = (((
    (dot (rgba_23.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec2 _texCoord_24;
  _texCoord_24 = (((vTexCoord0.xy + tmpvar_17) * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_24.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_24.x);
  _texCoord_24.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_24.y);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2DLod (HeightMapTexture, _texCoord_24, 0.0);
  highp vec4 rgba_26;
  rgba_26 = tmpvar_25.zyxw;
  vertexB_15.y = (((
    (dot (rgba_26.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec2 _texCoord_27;
  _texCoord_27 = (((vTexCoord0.xy + tmpvar_18) * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_27.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_27.x);
  _texCoord_27.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_27.y);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2DLod (HeightMapTexture, _texCoord_27, 0.0);
  highp vec4 rgba_29;
  rgba_29 = tmpvar_28.zyxw;
  vertexC_14.y = (((
    (dot (rgba_29.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec3 a_30;
  a_30 = (vertexA_16 - vertexB_15);
  highp vec3 b_31;
  b_31 = (vertexA_16 - vertexC_14);
  highp mat3 tmpvar_32;
  tmpvar_32[0] = matWorld[0].xyz;
  tmpvar_32[1] = matWorld[1].xyz;
  tmpvar_32[2] = matWorld[2].xyz;
  vsNormal_13 = (-(normalize(
    ((a_30.yzx * b_31.zxy) - (a_30.zxy * b_31.yzx))
  )) * tmpvar_32);
  highp vec2 _texCoord_33;
  _texCoord_33 = ((vTexCoord0.zw * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_33.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_33.x);
  _texCoord_33.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_33.y);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2DLod (HeightMapTexture, _texCoord_33, 0.0);
  highp vec4 rgba_35;
  rgba_35 = tmpvar_34.zyxw;
  highp float tmpvar_36;
  tmpvar_36 = GridParams.Params.w;
  highp float tmpvar_37;
  tmpvar_37 = mix (tmpvar_1.y, ((
    (dot (rgba_35.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * vPosition.w), tmpvar_36);
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, vec2(tmpvar_36));
  tmpvar_5 = tmpvar_2;
  tmpvar_2.xy = clamp (tmpvar_2.xy, 0.0, 1.0);
  tmpvar_2.xy = mix (TextureDimensionsInv.xy, TextureDimensionsInv.zw, tmpvar_2.xy);
  tmpvar_2.xy = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  tmpvar_1.y = ((tmpvar_1.y * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  tmpvar_4 = tmpvar_1;
  highp vec2 _texCoord_38;
  _texCoord_38 = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_38.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_38.x);
  _texCoord_38.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_38.y);
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2DLod (HeightMapOffsetsTexture, _texCoord_38, 0.0);
  highp vec2 tmpvar_40;
  tmpvar_40 = tmpvar_39.xy;
  tmpvar_1.xz = (tmpvar_1.xz + tmpvar_40);
  highp vec4 tmpvar_41;
  tmpvar_41 = (tmpvar_1 * matWorld);
  bvec4 tmpvar_42;
  tmpvar_42 = bvec4(ClipPlanes[0]);
  bool tmpvar_43;
  tmpvar_43 = any(tmpvar_42);
  highp float tmpvar_44;
  if (tmpvar_43) {
    highp vec4 tmpvar_45;
    tmpvar_45.w = 1.0;
    tmpvar_45.xyz = tmpvar_41.xyz;
    tmpvar_44 = dot (tmpvar_45, ClipPlanes[0]);
  } else {
    tmpvar_44 = 1.0;
  };
  tmpvar_6.x = tmpvar_44;
  bvec4 tmpvar_46;
  tmpvar_46 = bvec4(ClipPlanes[1]);
  bool tmpvar_47;
  tmpvar_47 = any(tmpvar_46);
  highp float tmpvar_48;
  if (tmpvar_47) {
    highp vec4 tmpvar_49;
    tmpvar_49.w = 1.0;
    tmpvar_49.xyz = tmpvar_41.xyz;
    tmpvar_48 = dot (tmpvar_49, ClipPlanes[1]);
  } else {
    tmpvar_48 = 1.0;
  };
  tmpvar_6.y = tmpvar_48;
  bvec4 tmpvar_50;
  tmpvar_50 = bvec4(ClipPlanes[2]);
  bool tmpvar_51;
  tmpvar_51 = any(tmpvar_50);
  highp float tmpvar_52;
  if (tmpvar_51) {
    highp vec4 tmpvar_53;
    tmpvar_53.w = 1.0;
    tmpvar_53.xyz = tmpvar_41.xyz;
    tmpvar_52 = dot (tmpvar_53, ClipPlanes[2]);
  } else {
    tmpvar_52 = 1.0;
  };
  tmpvar_6.z = tmpvar_52;
  bvec4 tmpvar_54;
  tmpvar_54 = bvec4(ClipPlanes[3]);
  bool tmpvar_55;
  tmpvar_55 = any(tmpvar_54);
  highp float tmpvar_56;
  if (tmpvar_55) {
    highp vec4 tmpvar_57;
    tmpvar_57.w = 1.0;
    tmpvar_57.xyz = tmpvar_41.xyz;
    tmpvar_56 = dot (tmpvar_57, ClipPlanes[3]);
  } else {
    tmpvar_56 = 1.0;
  };
  tmpvar_6.w = tmpvar_56;
  bvec4 tmpvar_58;
  tmpvar_58 = bvec4(ClipPlanes[4]);
  bool tmpvar_59;
  tmpvar_59 = any(tmpvar_58);
  highp float tmpvar_60;
  if (tmpvar_59) {
    highp vec4 tmpvar_61;
    tmpvar_61.w = 1.0;
    tmpvar_61.xyz = tmpvar_41.xyz;
    tmpvar_60 = dot (tmpvar_61, ClipPlanes[4]);
  } else {
    tmpvar_60 = 1.0;
  };
  tmpvar_7.x = tmpvar_60;
  bvec4 tmpvar_62;
  tmpvar_62 = bvec4(ClipPlanes[5]);
  bool tmpvar_63;
  tmpvar_63 = any(tmpvar_62);
  highp float tmpvar_64;
  if (tmpvar_63) {
    highp vec4 tmpvar_65;
    tmpvar_65.w = 1.0;
    tmpvar_65.xyz = tmpvar_41.xyz;
    tmpvar_64 = dot (tmpvar_65, ClipPlanes[5]);
  } else {
    tmpvar_64 = 1.0;
  };
  tmpvar_7.y = tmpvar_64;
  tmpvar_1.w = 1.0;
  tmpvar_3.xy = tmpvar_2.xy;
  tmpvar_3.zw = tmpvar_2.zw;
  gl_Position = (tmpvar_1 * tmpvar_8);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = vsNormal_13;
  xlv_TEXCOORD6 = tmpvar_37;
  xlv_TEXCOORD7 = tmpvar_5;
  xlv_COLOR4 = tmpvar_6;
  xlv_COLOR5 = tmpvar_7;
}

