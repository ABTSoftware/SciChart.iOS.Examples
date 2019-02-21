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
uniform sGridParams GridParams;
attribute highp vec4 vPosition;
attribute highp vec4 vTexCoord0;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp float xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.w = vPosition.w;
  tmpvar_2.zw = vTexCoord0.zw;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_1.xz = ((vPosition.xz * MeshCellOfssetScalePosition.xy) + MeshCellOfssetScalePosition.zw);
  highp vec2 _texCoord_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (vTexCoord0.xy * MeshCellOfssetScaleTexCoord.xy);
  _texCoord_6 = (tmpvar_7 + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_6.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_6.x);
  _texCoord_6.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_6.y);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DLod (HeightMapTexture, _texCoord_6, 0.0);
  highp vec4 rgba_9;
  rgba_9 = tmpvar_8.zyxw;
  tmpvar_1.y = (((
    dot (rgba_9.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8))
   * PackedFloatParams.y) + PackedFloatParams.x) * vPosition.w);
  highp vec3 vertexC_10;
  highp vec3 vertexB_11;
  highp vec3 vertexA_12;
  highp vec2 tmpvar_13;
  tmpvar_13.y = 0.0;
  tmpvar_13.x = TextureDimensionsInv.x;
  highp vec2 tmpvar_14;
  tmpvar_14.x = 0.0;
  tmpvar_14.y = TextureDimensionsInv.y;
  vertexA_12.xz = vec2(0.0, 0.0);
  highp vec3 tmpvar_15;
  tmpvar_15.yz = vec2(0.0, 0.0);
  tmpvar_15.x = ((MeshCellSize.x * TextureDimensionsInv.x) * 2.0);
  vertexB_11.xz = tmpvar_15.xz;
  highp vec3 tmpvar_16;
  tmpvar_16.xy = vec2(0.0, 0.0);
  tmpvar_16.z = ((MeshCellSize.y * TextureDimensionsInv.y) * 2.0);
  vertexC_10.xz = tmpvar_16.xz;
  highp vec2 _texCoord_17;
  _texCoord_17 = (tmpvar_7 + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_17.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_17.x);
  _texCoord_17.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_17.y);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2DLod (HeightMapTexture, _texCoord_17, 0.0);
  highp vec4 rgba_19;
  rgba_19 = tmpvar_18.zyxw;
  vertexA_12.y = (((
    (dot (rgba_19.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec2 _texCoord_20;
  _texCoord_20 = (((vTexCoord0.xy + tmpvar_13) * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_20.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_20.x);
  _texCoord_20.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_20.y);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2DLod (HeightMapTexture, _texCoord_20, 0.0);
  highp vec4 rgba_22;
  rgba_22 = tmpvar_21.zyxw;
  vertexB_11.y = (((
    (dot (rgba_22.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec2 _texCoord_23;
  _texCoord_23 = (((vTexCoord0.xy + tmpvar_14) * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_23.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_23.x);
  _texCoord_23.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_23.y);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2DLod (HeightMapTexture, _texCoord_23, 0.0);
  highp vec4 rgba_25;
  rgba_25 = tmpvar_24.zyxw;
  vertexC_10.y = (((
    (dot (rgba_25.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  highp vec3 a_26;
  a_26 = (vertexA_12 - vertexB_11);
  highp vec3 b_27;
  b_27 = (vertexA_12 - vertexC_10);
  highp mat3 tmpvar_28;
  tmpvar_28[0] = matWorld[0].xyz;
  tmpvar_28[1] = matWorld[1].xyz;
  tmpvar_28[2] = matWorld[2].xyz;
  highp vec2 _texCoord_29;
  _texCoord_29 = ((vTexCoord0.zw * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_29.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_29.x);
  _texCoord_29.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_29.y);
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2DLod (HeightMapTexture, _texCoord_29, 0.0);
  highp vec4 rgba_31;
  rgba_31 = tmpvar_30.zyxw;
  highp float tmpvar_32;
  tmpvar_32 = GridParams.Params.w;
  highp float tmpvar_33;
  tmpvar_33 = mix (tmpvar_1.y, ((
    (dot (rgba_31.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y)
   + PackedFloatParams.x) * vPosition.w), tmpvar_32);
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, vec2(tmpvar_32));
  tmpvar_5 = tmpvar_2;
  tmpvar_2.xy = clamp (tmpvar_2.xy, 0.0, 1.0);
  tmpvar_2.xy = mix (TextureDimensionsInv.xy, TextureDimensionsInv.zw, tmpvar_2.xy);
  tmpvar_2.xy = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  tmpvar_1.y = ((tmpvar_1.y * MeshCellOfssetScaleHeights.x) + MeshCellOfssetScaleHeights.y);
  tmpvar_4 = tmpvar_1;
  highp vec2 _texCoord_34;
  _texCoord_34 = ((tmpvar_2.xy * MeshCellOfssetScaleTexCoord.xy) + MeshCellOfssetScaleTexCoord.zw);
  _texCoord_34.x = mix (TextureDimensionsInv.x, TextureDimensionsInv.z, _texCoord_34.x);
  _texCoord_34.y = mix (TextureDimensionsInv.y, TextureDimensionsInv.w, _texCoord_34.y);
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2DLod (HeightMapOffsetsTexture, _texCoord_34, 0.0);
  highp vec2 tmpvar_36;
  tmpvar_36 = tmpvar_35.xy;
  tmpvar_1.xz = (tmpvar_1.xz + tmpvar_36);
  tmpvar_1.w = 1.0;
  tmpvar_3.xy = tmpvar_2.xy;
  tmpvar_3.zw = tmpvar_2.zw;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = (-(normalize(
    ((a_26.yzx * b_27.zxy) - (a_26.zxy * b_27.yzx))
  )) * tmpvar_28);
  xlv_TEXCOORD6 = tmpvar_33;
  xlv_TEXCOORD7 = tmpvar_5;
}

