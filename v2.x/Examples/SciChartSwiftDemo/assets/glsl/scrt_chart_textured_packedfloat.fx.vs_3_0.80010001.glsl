struct sGridParams {
  highp vec4 ContourScale;
  highp vec4 ContourOffset;
  highp vec4 ContourThickness;
  highp vec4 ContourColorX;
  highp vec4 ContourColorY;
  highp vec4 ContourColorZ;
  highp vec4 Params;
  highp vec4 SurfaceNormal;
};
uniform highp mat4 matWorld;
uniform highp mat4 matWorldViewProj;
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
  tmpvar_1.yw = vPosition.yw;
  tmpvar_2 = vTexCoord0;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec3 tmpvar_5;
  highp float tmpvar_6;
  highp vec4 tmpvar_7;
  highp vec4 tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_1.xz = ((vPosition.xz * MeshCellOfssetScalePosition.xy) + MeshCellOfssetScalePosition.zw);
  highp vec2 _texCoord_10;
  _texCoord_10 = vTexCoord0.xy;
  highp float tmpvar_11;
  if ((((
    (vTexCoord0.x <= -0.1)
   || 
    (vTexCoord0.x >= 1.1)
  ) || (vTexCoord0.y <= -0.1)) || (vTexCoord0.y >= 1.1))) {
    tmpvar_11 = 0.0;
  } else {
    _texCoord_10 = ((vTexCoord0.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_10.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_10.x);
    _texCoord_10.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_10.y);
    lowp vec4 tmpvar_12;
    tmpvar_12 = texture2DLod (HeightMapTexture, _texCoord_10, 0.0);
    highp vec4 tmpvar_13;
    tmpvar_13 = tmpvar_12;
    tmpvar_11 = (((
      dot (tmpvar_13.wxyz, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8))
     * PackedFloatParams.y) + PackedFloatParams.x) * vPosition.w);
  };
  tmpvar_1.y = tmpvar_11;
  highp vec3 terrainNormal_14;
  highp vec3 vertexC_15;
  highp vec3 vertexB_16;
  highp vec3 vertexA_17;
  highp vec2 uvC_18;
  highp vec2 uvB_19;
  highp vec2 tmpvar_20;
  tmpvar_20.y = 0.0;
  tmpvar_20.x = TextureDimensionsInv.x;
  uvB_19 = (vTexCoord0.xy + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.x = 0.0;
  tmpvar_21.y = TextureDimensionsInv.y;
  uvC_18 = (vTexCoord0.xy + tmpvar_21);
  vertexA_17 = vec3(0.0, 0.0, 0.0);
  highp vec3 tmpvar_22;
  tmpvar_22.yz = vec2(0.0, 0.0);
  tmpvar_22.x = ((MeshCellSize.x * TextureDimensionsInv.x) * 2.0);
  vertexB_16 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23.xy = vec2(0.0, 0.0);
  tmpvar_23.z = ((MeshCellSize.y * TextureDimensionsInv.y) * 2.0);
  vertexC_15 = tmpvar_23;
  highp vec2 _texCoord_24;
  _texCoord_24 = vTexCoord0.xy;
  highp float tmpvar_25;
  if ((((
    (vTexCoord0.x <= -0.1)
   || 
    (vTexCoord0.x >= 1.1)
  ) || (vTexCoord0.y <= -0.1)) || (vTexCoord0.y >= 1.1))) {
    tmpvar_25 = 0.0;
  } else {
    _texCoord_24 = ((vTexCoord0.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_24.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_24.x);
    _texCoord_24.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_24.y);
    lowp vec4 tmpvar_26;
    tmpvar_26 = texture2DLod (HeightMapTexture, _texCoord_24, 0.0);
    highp vec4 tmpvar_27;
    tmpvar_27 = tmpvar_26;
    tmpvar_25 = ((dot (tmpvar_27.wxyz, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y) + PackedFloatParams.x);
  };
  vertexA_17.y = ((tmpvar_25 * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec2 _texCoord_28;
  _texCoord_28 = uvB_19;
  highp float tmpvar_29;
  if ((((
    (uvB_19.x <= -0.1)
   || 
    (uvB_19.x >= 1.1)
  ) || (uvB_19.y <= -0.1)) || (uvB_19.y >= 1.1))) {
    tmpvar_29 = 0.0;
  } else {
    _texCoord_28 = ((uvB_19 * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_28.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_28.x);
    _texCoord_28.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_28.y);
    lowp vec4 tmpvar_30;
    tmpvar_30 = texture2DLod (HeightMapTexture, _texCoord_28, 0.0);
    highp vec4 tmpvar_31;
    tmpvar_31 = tmpvar_30;
    tmpvar_29 = ((dot (tmpvar_31.wxyz, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y) + PackedFloatParams.x);
  };
  vertexB_16.y = ((tmpvar_29 * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec2 _texCoord_32;
  _texCoord_32 = uvC_18;
  highp float tmpvar_33;
  if ((((
    (uvC_18.x <= -0.1)
   || 
    (uvC_18.x >= 1.1)
  ) || (uvC_18.y <= -0.1)) || (uvC_18.y >= 1.1))) {
    tmpvar_33 = 0.0;
  } else {
    _texCoord_32 = ((uvC_18 * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_32.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_32.x);
    _texCoord_32.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_32.y);
    lowp vec4 tmpvar_34;
    tmpvar_34 = texture2DLod (HeightMapTexture, _texCoord_32, 0.0);
    highp vec4 tmpvar_35;
    tmpvar_35 = tmpvar_34;
    tmpvar_33 = ((dot (tmpvar_35.wxyz, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y) + PackedFloatParams.x);
  };
  vertexC_15.y = ((tmpvar_33 * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec3 a_36;
  a_36 = (vertexA_17 - vertexB_16);
  highp vec3 b_37;
  b_37 = (vertexA_17 - vertexC_15);
  terrainNormal_14 = -(normalize((
    (a_36.yzx * b_37.zxy)
   - 
    (a_36.zxy * b_37.yzx)
  )));
  if ((vTexCoord0.x > 0.999)) {
    terrainNormal_14 = vec3(1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.x < 0.001)) {
    terrainNormal_14 = vec3(-1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.y > 0.999)) {
    terrainNormal_14 = vec3(0.0, 0.0, 1.0);
  };
  if ((vTexCoord0.y < 0.001)) {
    terrainNormal_14 = vec3(0.0, 0.0, -1.0);
  };
  highp mat3 tmpvar_38;
  tmpvar_38[0] = matWorld[0].xyz;
  tmpvar_38[1] = matWorld[1].xyz;
  tmpvar_38[2] = matWorld[2].xyz;
  tmpvar_5 = (terrainNormal_14 * tmpvar_38);
  highp vec2 _texCoord_39;
  _texCoord_39 = vTexCoord0.zw;
  highp float tmpvar_40;
  if ((((
    (vTexCoord0.z <= -0.1)
   || 
    (vTexCoord0.z >= 1.1)
  ) || (vTexCoord0.w <= -0.1)) || (vTexCoord0.w >= 1.1))) {
    tmpvar_40 = 0.0;
  } else {
    _texCoord_39 = ((vTexCoord0.zw * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_39.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_39.x);
    _texCoord_39.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_39.y);
    lowp vec4 tmpvar_41;
    tmpvar_41 = texture2DLod (HeightMapTexture, _texCoord_39, 0.0);
    highp vec4 tmpvar_42;
    tmpvar_42 = tmpvar_41;
    tmpvar_40 = (((
      dot (tmpvar_42.wxyz, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8))
     * PackedFloatParams.y) + PackedFloatParams.x) * vPosition.w);
  };
  highp float tmpvar_43;
  tmpvar_43 = GridParams.Params.w;
  tmpvar_6 = mix (tmpvar_11, tmpvar_40, tmpvar_43);
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, vec2(tmpvar_43));
  tmpvar_7 = tmpvar_2;
  tmpvar_2.xy = clamp (tmpvar_2.xy, 0.0, 1.0);
  tmpvar_2.xy = mix (TextureDimensionsInv.xy, TextureDimensionsInv.zw, tmpvar_2.xy);
  tmpvar_2.xy = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  tmpvar_1.y = ((tmpvar_11 * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  tmpvar_4 = tmpvar_1;
  highp vec2 _texCoord_44;
  _texCoord_44 = tmpvar_2.xy;
  highp vec2 tmpvar_45;
  if ((((
    (tmpvar_2.x <= -0.1)
   || 
    (tmpvar_2.x >= 1.1)
  ) || (tmpvar_2.y <= -0.1)) || (tmpvar_2.y >= 1.1))) {
    tmpvar_45 = vec2(0.0, 0.0);
  } else {
    _texCoord_44 = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_44.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_44.x);
    _texCoord_44.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_44.y);
    lowp vec4 tmpvar_46;
    tmpvar_46 = texture2DLod (HeightMapOffsetsTexture, _texCoord_44, 0.0);
    highp vec2 tmpvar_47;
    tmpvar_47 = tmpvar_46.xy;
    tmpvar_45 = tmpvar_47;
  };
  tmpvar_1.xz = (tmpvar_1.xz + tmpvar_45);
  highp vec4 tmpvar_48;
  tmpvar_48 = (tmpvar_1 * matWorld);
  bvec4 tmpvar_49;
  tmpvar_49 = bvec4(ClipPlanes[0]);
  bool tmpvar_50;
  tmpvar_50 = any(tmpvar_49);
  highp float tmpvar_51;
  if (tmpvar_50) {
    highp vec4 tmpvar_52;
    tmpvar_52.w = 1.0;
    tmpvar_52.xyz = tmpvar_48.xyz;
    tmpvar_51 = dot (tmpvar_52, ClipPlanes[0]);
  } else {
    tmpvar_51 = 1.0;
  };
  tmpvar_8.x = tmpvar_51;
  bvec4 tmpvar_53;
  tmpvar_53 = bvec4(ClipPlanes[1]);
  bool tmpvar_54;
  tmpvar_54 = any(tmpvar_53);
  highp float tmpvar_55;
  if (tmpvar_54) {
    highp vec4 tmpvar_56;
    tmpvar_56.w = 1.0;
    tmpvar_56.xyz = tmpvar_48.xyz;
    tmpvar_55 = dot (tmpvar_56, ClipPlanes[1]);
  } else {
    tmpvar_55 = 1.0;
  };
  tmpvar_8.y = tmpvar_55;
  bvec4 tmpvar_57;
  tmpvar_57 = bvec4(ClipPlanes[2]);
  bool tmpvar_58;
  tmpvar_58 = any(tmpvar_57);
  highp float tmpvar_59;
  if (tmpvar_58) {
    highp vec4 tmpvar_60;
    tmpvar_60.w = 1.0;
    tmpvar_60.xyz = tmpvar_48.xyz;
    tmpvar_59 = dot (tmpvar_60, ClipPlanes[2]);
  } else {
    tmpvar_59 = 1.0;
  };
  tmpvar_8.z = tmpvar_59;
  bvec4 tmpvar_61;
  tmpvar_61 = bvec4(ClipPlanes[3]);
  bool tmpvar_62;
  tmpvar_62 = any(tmpvar_61);
  highp float tmpvar_63;
  if (tmpvar_62) {
    highp vec4 tmpvar_64;
    tmpvar_64.w = 1.0;
    tmpvar_64.xyz = tmpvar_48.xyz;
    tmpvar_63 = dot (tmpvar_64, ClipPlanes[3]);
  } else {
    tmpvar_63 = 1.0;
  };
  tmpvar_8.w = tmpvar_63;
  bvec4 tmpvar_65;
  tmpvar_65 = bvec4(ClipPlanes[4]);
  bool tmpvar_66;
  tmpvar_66 = any(tmpvar_65);
  highp float tmpvar_67;
  if (tmpvar_66) {
    highp vec4 tmpvar_68;
    tmpvar_68.w = 1.0;
    tmpvar_68.xyz = tmpvar_48.xyz;
    tmpvar_67 = dot (tmpvar_68, ClipPlanes[4]);
  } else {
    tmpvar_67 = 1.0;
  };
  tmpvar_9.x = tmpvar_67;
  bvec4 tmpvar_69;
  tmpvar_69 = bvec4(ClipPlanes[5]);
  bool tmpvar_70;
  tmpvar_70 = any(tmpvar_69);
  highp float tmpvar_71;
  if (tmpvar_70) {
    highp vec4 tmpvar_72;
    tmpvar_72.w = 1.0;
    tmpvar_72.xyz = tmpvar_48.xyz;
    tmpvar_71 = dot (tmpvar_72, ClipPlanes[5]);
  } else {
    tmpvar_71 = 1.0;
  };
  tmpvar_9.y = tmpvar_71;
  tmpvar_1.w = 1.0;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = tmpvar_2.xy;
  gl_Position = (tmpvar_1 * matWorldViewProj);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = tmpvar_7;
  xlv_COLOR4 = tmpvar_8;
  xlv_COLOR5 = tmpvar_9;
}

