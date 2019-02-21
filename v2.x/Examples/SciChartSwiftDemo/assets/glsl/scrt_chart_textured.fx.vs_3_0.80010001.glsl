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
    tmpvar_11 = (texture2DLod (HeightMapTexture, _texCoord_10, 0.0).w * vPosition.w);
  };
  tmpvar_1.y = tmpvar_11;
  highp vec3 terrainNormal_12;
  highp vec3 vertexC_13;
  highp vec3 vertexB_14;
  highp vec3 vertexA_15;
  highp vec2 uvC_16;
  highp vec2 uvB_17;
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = TextureDimensionsInv.x;
  uvB_17 = (vTexCoord0.xy + tmpvar_18);
  highp vec2 tmpvar_19;
  tmpvar_19.x = 0.0;
  tmpvar_19.y = TextureDimensionsInv.y;
  uvC_16 = (vTexCoord0.xy + tmpvar_19);
  vertexA_15 = vec3(0.0, 0.0, 0.0);
  highp vec3 tmpvar_20;
  tmpvar_20.yz = vec2(0.0, 0.0);
  tmpvar_20.x = ((MeshCellSize.x * TextureDimensionsInv.x) * 2.0);
  vertexB_14 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21.xy = vec2(0.0, 0.0);
  tmpvar_21.z = ((MeshCellSize.y * TextureDimensionsInv.y) * 2.0);
  vertexC_13 = tmpvar_21;
  highp vec2 _texCoord_22;
  _texCoord_22 = vTexCoord0.xy;
  highp float tmpvar_23;
  if ((((
    (vTexCoord0.x <= -0.1)
   || 
    (vTexCoord0.x >= 1.1)
  ) || (vTexCoord0.y <= -0.1)) || (vTexCoord0.y >= 1.1))) {
    tmpvar_23 = 0.0;
  } else {
    _texCoord_22 = ((vTexCoord0.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_22.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_22.x);
    _texCoord_22.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_22.y);
    tmpvar_23 = texture2DLod (HeightMapTexture, _texCoord_22, 0.0).w;
  };
  vertexA_15.y = ((tmpvar_23 * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec2 _texCoord_24;
  _texCoord_24 = uvB_17;
  highp float tmpvar_25;
  if ((((
    (uvB_17.x <= -0.1)
   || 
    (uvB_17.x >= 1.1)
  ) || (uvB_17.y <= -0.1)) || (uvB_17.y >= 1.1))) {
    tmpvar_25 = 0.0;
  } else {
    _texCoord_24 = ((uvB_17 * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_24.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_24.x);
    _texCoord_24.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_24.y);
    tmpvar_25 = texture2DLod (HeightMapTexture, _texCoord_24, 0.0).w;
  };
  vertexB_14.y = ((tmpvar_25 * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec2 _texCoord_26;
  _texCoord_26 = uvC_16;
  highp float tmpvar_27;
  if ((((
    (uvC_16.x <= -0.1)
   || 
    (uvC_16.x >= 1.1)
  ) || (uvC_16.y <= -0.1)) || (uvC_16.y >= 1.1))) {
    tmpvar_27 = 0.0;
  } else {
    _texCoord_26 = ((uvC_16 * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_26.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_26.x);
    _texCoord_26.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_26.y);
    tmpvar_27 = texture2DLod (HeightMapTexture, _texCoord_26, 0.0).w;
  };
  vertexC_13.y = ((tmpvar_27 * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec3 a_28;
  a_28 = (vertexA_15 - vertexB_14);
  highp vec3 b_29;
  b_29 = (vertexA_15 - vertexC_13);
  terrainNormal_12 = -(normalize((
    (a_28.yzx * b_29.zxy)
   - 
    (a_28.zxy * b_29.yzx)
  )));
  if ((vTexCoord0.x > 0.999)) {
    terrainNormal_12 = vec3(1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.x < 0.001)) {
    terrainNormal_12 = vec3(-1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.y > 0.999)) {
    terrainNormal_12 = vec3(0.0, 0.0, 1.0);
  };
  if ((vTexCoord0.y < 0.001)) {
    terrainNormal_12 = vec3(0.0, 0.0, -1.0);
  };
  highp mat3 tmpvar_30;
  tmpvar_30[0] = matWorld[0].xyz;
  tmpvar_30[1] = matWorld[1].xyz;
  tmpvar_30[2] = matWorld[2].xyz;
  tmpvar_5 = (terrainNormal_12 * tmpvar_30);
  highp vec2 _texCoord_31;
  _texCoord_31 = vTexCoord0.zw;
  highp float tmpvar_32;
  if ((((
    (vTexCoord0.z <= -0.1)
   || 
    (vTexCoord0.z >= 1.1)
  ) || (vTexCoord0.w <= -0.1)) || (vTexCoord0.w >= 1.1))) {
    tmpvar_32 = 0.0;
  } else {
    _texCoord_31 = ((vTexCoord0.zw * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_31.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_31.x);
    _texCoord_31.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_31.y);
    tmpvar_32 = (texture2DLod (HeightMapTexture, _texCoord_31, 0.0).w * vPosition.w);
  };
  highp float tmpvar_33;
  tmpvar_33 = GridParams.Params.w;
  tmpvar_6 = mix (tmpvar_11, tmpvar_32, tmpvar_33);
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, vec2(tmpvar_33));
  tmpvar_7 = tmpvar_2;
  tmpvar_2.xy = clamp (tmpvar_2.xy, 0.0, 1.0);
  tmpvar_2.xy = mix (TextureDimensionsInv.xy, TextureDimensionsInv.zw, tmpvar_2.xy);
  tmpvar_2.xy = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  tmpvar_1.y = ((tmpvar_11 * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  tmpvar_4 = tmpvar_1;
  highp vec2 _texCoord_34;
  _texCoord_34 = tmpvar_2.xy;
  highp vec2 tmpvar_35;
  if ((((
    (tmpvar_2.x <= -0.1)
   || 
    (tmpvar_2.x >= 1.1)
  ) || (tmpvar_2.y <= -0.1)) || (tmpvar_2.y >= 1.1))) {
    tmpvar_35 = vec2(0.0, 0.0);
  } else {
    _texCoord_34 = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
    _texCoord_34.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_34.x);
    _texCoord_34.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_34.y);
    lowp vec4 tmpvar_36;
    tmpvar_36 = texture2DLod (HeightMapOffsetsTexture, _texCoord_34, 0.0);
    highp vec2 tmpvar_37;
    tmpvar_37 = tmpvar_36.xy;
    tmpvar_35 = tmpvar_37;
  };
  tmpvar_1.xz = (tmpvar_1.xz + tmpvar_35);
  highp vec4 tmpvar_38;
  tmpvar_38 = (tmpvar_1 * matWorld);
  bvec4 tmpvar_39;
  tmpvar_39 = bvec4(ClipPlanes[0]);
  bool tmpvar_40;
  tmpvar_40 = any(tmpvar_39);
  highp float tmpvar_41;
  if (tmpvar_40) {
    highp vec4 tmpvar_42;
    tmpvar_42.w = 1.0;
    tmpvar_42.xyz = tmpvar_38.xyz;
    tmpvar_41 = dot (tmpvar_42, ClipPlanes[0]);
  } else {
    tmpvar_41 = 1.0;
  };
  tmpvar_8.x = tmpvar_41;
  bvec4 tmpvar_43;
  tmpvar_43 = bvec4(ClipPlanes[1]);
  bool tmpvar_44;
  tmpvar_44 = any(tmpvar_43);
  highp float tmpvar_45;
  if (tmpvar_44) {
    highp vec4 tmpvar_46;
    tmpvar_46.w = 1.0;
    tmpvar_46.xyz = tmpvar_38.xyz;
    tmpvar_45 = dot (tmpvar_46, ClipPlanes[1]);
  } else {
    tmpvar_45 = 1.0;
  };
  tmpvar_8.y = tmpvar_45;
  bvec4 tmpvar_47;
  tmpvar_47 = bvec4(ClipPlanes[2]);
  bool tmpvar_48;
  tmpvar_48 = any(tmpvar_47);
  highp float tmpvar_49;
  if (tmpvar_48) {
    highp vec4 tmpvar_50;
    tmpvar_50.w = 1.0;
    tmpvar_50.xyz = tmpvar_38.xyz;
    tmpvar_49 = dot (tmpvar_50, ClipPlanes[2]);
  } else {
    tmpvar_49 = 1.0;
  };
  tmpvar_8.z = tmpvar_49;
  bvec4 tmpvar_51;
  tmpvar_51 = bvec4(ClipPlanes[3]);
  bool tmpvar_52;
  tmpvar_52 = any(tmpvar_51);
  highp float tmpvar_53;
  if (tmpvar_52) {
    highp vec4 tmpvar_54;
    tmpvar_54.w = 1.0;
    tmpvar_54.xyz = tmpvar_38.xyz;
    tmpvar_53 = dot (tmpvar_54, ClipPlanes[3]);
  } else {
    tmpvar_53 = 1.0;
  };
  tmpvar_8.w = tmpvar_53;
  bvec4 tmpvar_55;
  tmpvar_55 = bvec4(ClipPlanes[4]);
  bool tmpvar_56;
  tmpvar_56 = any(tmpvar_55);
  highp float tmpvar_57;
  if (tmpvar_56) {
    highp vec4 tmpvar_58;
    tmpvar_58.w = 1.0;
    tmpvar_58.xyz = tmpvar_38.xyz;
    tmpvar_57 = dot (tmpvar_58, ClipPlanes[4]);
  } else {
    tmpvar_57 = 1.0;
  };
  tmpvar_9.x = tmpvar_57;
  bvec4 tmpvar_59;
  tmpvar_59 = bvec4(ClipPlanes[5]);
  bool tmpvar_60;
  tmpvar_60 = any(tmpvar_59);
  highp float tmpvar_61;
  if (tmpvar_60) {
    highp vec4 tmpvar_62;
    tmpvar_62.w = 1.0;
    tmpvar_62.xyz = tmpvar_38.xyz;
    tmpvar_61 = dot (tmpvar_62, ClipPlanes[5]);
  } else {
    tmpvar_61 = 1.0;
  };
  tmpvar_9.y = tmpvar_61;
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

