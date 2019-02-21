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
uniform sampler2D HeightMapTexture;
uniform highp vec4 DataPositionOffset;
uniform highp vec4 DisplacementAxesConstraints;
uniform highp vec4 ClipPlanes[6];
uniform sGridParams GridParams;
attribute highp vec4 vPosition;
attribute highp vec4 vTexCoord0;
attribute highp vec3 vNormal;
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
  tmpvar_1 = vPosition;
  tmpvar_2 = vTexCoord0;
  highp mat4 vMatWorldViewProj_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec4 tmpvar_7;
  highp vec2 tmpvar_8;
  vMatWorldViewProj_3 = (matWorldView * matProj);
  highp vec3 tmpvar_9;
  highp vec3 offset_10;
  offset_10 = DataPositionOffset.xyz;
  if ((((
    (vTexCoord0.x <= -0.1)
   || 
    (vTexCoord0.x >= 1.1)
  ) || (vTexCoord0.y <= -0.1)) || (vTexCoord0.y >= 1.1))) {
    tmpvar_9 = DataPositionOffset.xyz;
  } else {
    highp vec3 tmpvar_11;
    if (bool(DisplacementAxesConstraints.w)) {
      tmpvar_11 = DisplacementAxesConstraints.xyz;
    } else {
      tmpvar_11 = (normalize(vPosition.xyz) * DisplacementAxesConstraints.xyz);
    };
    lowp vec4 tmpvar_12;
    tmpvar_12 = texture2DLod (HeightMapTexture, vTexCoord0.xy, 0.0);
    highp float tmpvar_13;
    tmpvar_13 = tmpvar_12.x;
    offset_10 = (DataPositionOffset.xyz + (tmpvar_11 * vec3(tmpvar_13)));
    tmpvar_9 = offset_10;
  };
  tmpvar_1.xyz = (vPosition.xyz + tmpvar_9);
  highp mat3 tmpvar_14;
  tmpvar_14[0] = matWorld[0].xyz;
  tmpvar_14[1] = matWorld[1].xyz;
  tmpvar_14[2] = matWorld[2].xyz;
  tmpvar_6 = (vNormal * tmpvar_14);
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, GridParams.Params.ww);
  tmpvar_5 = tmpvar_1;
  highp float tmpvar_15;
  tmpvar_15 = sqrt(dot (tmpvar_1.xyz, tmpvar_1.xyz));
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_1 * matWorld);
  bvec4 tmpvar_17;
  tmpvar_17 = bvec4(ClipPlanes[0]);
  bool tmpvar_18;
  tmpvar_18 = any(tmpvar_17);
  highp float tmpvar_19;
  if (tmpvar_18) {
    highp vec4 tmpvar_20;
    tmpvar_20.w = 1.0;
    tmpvar_20.xyz = tmpvar_16.xyz;
    tmpvar_19 = dot (tmpvar_20, ClipPlanes[0]);
  } else {
    tmpvar_19 = 1.0;
  };
  tmpvar_7.x = tmpvar_19;
  bvec4 tmpvar_21;
  tmpvar_21 = bvec4(ClipPlanes[1]);
  bool tmpvar_22;
  tmpvar_22 = any(tmpvar_21);
  highp float tmpvar_23;
  if (tmpvar_22) {
    highp vec4 tmpvar_24;
    tmpvar_24.w = 1.0;
    tmpvar_24.xyz = tmpvar_16.xyz;
    tmpvar_23 = dot (tmpvar_24, ClipPlanes[1]);
  } else {
    tmpvar_23 = 1.0;
  };
  tmpvar_7.y = tmpvar_23;
  bvec4 tmpvar_25;
  tmpvar_25 = bvec4(ClipPlanes[2]);
  bool tmpvar_26;
  tmpvar_26 = any(tmpvar_25);
  highp float tmpvar_27;
  if (tmpvar_26) {
    highp vec4 tmpvar_28;
    tmpvar_28.w = 1.0;
    tmpvar_28.xyz = tmpvar_16.xyz;
    tmpvar_27 = dot (tmpvar_28, ClipPlanes[2]);
  } else {
    tmpvar_27 = 1.0;
  };
  tmpvar_7.z = tmpvar_27;
  bvec4 tmpvar_29;
  tmpvar_29 = bvec4(ClipPlanes[3]);
  bool tmpvar_30;
  tmpvar_30 = any(tmpvar_29);
  highp float tmpvar_31;
  if (tmpvar_30) {
    highp vec4 tmpvar_32;
    tmpvar_32.w = 1.0;
    tmpvar_32.xyz = tmpvar_16.xyz;
    tmpvar_31 = dot (tmpvar_32, ClipPlanes[3]);
  } else {
    tmpvar_31 = 1.0;
  };
  tmpvar_7.w = tmpvar_31;
  bvec4 tmpvar_33;
  tmpvar_33 = bvec4(ClipPlanes[4]);
  bool tmpvar_34;
  tmpvar_34 = any(tmpvar_33);
  highp float tmpvar_35;
  if (tmpvar_34) {
    highp vec4 tmpvar_36;
    tmpvar_36.w = 1.0;
    tmpvar_36.xyz = tmpvar_16.xyz;
    tmpvar_35 = dot (tmpvar_36, ClipPlanes[4]);
  } else {
    tmpvar_35 = 1.0;
  };
  tmpvar_8.x = tmpvar_35;
  bvec4 tmpvar_37;
  tmpvar_37 = bvec4(ClipPlanes[5]);
  bool tmpvar_38;
  tmpvar_38 = any(tmpvar_37);
  highp float tmpvar_39;
  if (tmpvar_38) {
    highp vec4 tmpvar_40;
    tmpvar_40.w = 1.0;
    tmpvar_40.xyz = tmpvar_16.xyz;
    tmpvar_39 = dot (tmpvar_40, ClipPlanes[5]);
  } else {
    tmpvar_39 = 1.0;
  };
  tmpvar_8.y = tmpvar_39;
  tmpvar_1.w = 1.0;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = tmpvar_2.xy;
  gl_Position = (tmpvar_1 * vMatWorldViewProj_3);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = tmpvar_5;
  xlv_TEXCOORD2 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_15;
  xlv_TEXCOORD7 = tmpvar_2;
  xlv_COLOR4 = tmpvar_7;
  xlv_COLOR5 = tmpvar_8;
}

