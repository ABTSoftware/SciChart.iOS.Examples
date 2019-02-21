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
  tmpvar_1 = vPosition;
  tmpvar_2 = vTexCoord0;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec3 vsNormal_6;
  highp vec3 terrainNormal_7;
  terrainNormal_7 = vec3(0.0, 1.0, 0.0);
  if ((vTexCoord0.x > 0.999)) {
    terrainNormal_7 = vec3(1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.x < 0.001)) {
    terrainNormal_7 = vec3(-1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.y > 0.999)) {
    terrainNormal_7 = vec3(0.0, 0.0, 1.0);
  };
  if ((vTexCoord0.y < 0.001)) {
    terrainNormal_7 = vec3(0.0, 0.0, -1.0);
  };
  highp mat3 tmpvar_8;
  tmpvar_8[0] = matWorld[0].xyz;
  tmpvar_8[1] = matWorld[1].xyz;
  tmpvar_8[2] = matWorld[2].xyz;
  vsNormal_6 = (terrainNormal_7 * tmpvar_8);
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, GridParams.Params.ww);
  highp float tmpvar_9;
  tmpvar_9 = sqrt(dot (vPosition.xyz, vPosition.xyz));
  highp vec4 tmpvar_10;
  tmpvar_10 = (vPosition * matWorld);
  bvec4 tmpvar_11;
  tmpvar_11 = bvec4(ClipPlanes[0]);
  bool tmpvar_12;
  tmpvar_12 = any(tmpvar_11);
  highp float tmpvar_13;
  if (tmpvar_12) {
    highp vec4 tmpvar_14;
    tmpvar_14.w = 1.0;
    tmpvar_14.xyz = tmpvar_10.xyz;
    tmpvar_13 = dot (tmpvar_14, ClipPlanes[0]);
  } else {
    tmpvar_13 = 1.0;
  };
  tmpvar_4.x = tmpvar_13;
  bvec4 tmpvar_15;
  tmpvar_15 = bvec4(ClipPlanes[1]);
  bool tmpvar_16;
  tmpvar_16 = any(tmpvar_15);
  highp float tmpvar_17;
  if (tmpvar_16) {
    highp vec4 tmpvar_18;
    tmpvar_18.w = 1.0;
    tmpvar_18.xyz = tmpvar_10.xyz;
    tmpvar_17 = dot (tmpvar_18, ClipPlanes[1]);
  } else {
    tmpvar_17 = 1.0;
  };
  tmpvar_4.y = tmpvar_17;
  bvec4 tmpvar_19;
  tmpvar_19 = bvec4(ClipPlanes[2]);
  bool tmpvar_20;
  tmpvar_20 = any(tmpvar_19);
  highp float tmpvar_21;
  if (tmpvar_20) {
    highp vec4 tmpvar_22;
    tmpvar_22.w = 1.0;
    tmpvar_22.xyz = tmpvar_10.xyz;
    tmpvar_21 = dot (tmpvar_22, ClipPlanes[2]);
  } else {
    tmpvar_21 = 1.0;
  };
  tmpvar_4.z = tmpvar_21;
  bvec4 tmpvar_23;
  tmpvar_23 = bvec4(ClipPlanes[3]);
  bool tmpvar_24;
  tmpvar_24 = any(tmpvar_23);
  highp float tmpvar_25;
  if (tmpvar_24) {
    highp vec4 tmpvar_26;
    tmpvar_26.w = 1.0;
    tmpvar_26.xyz = tmpvar_10.xyz;
    tmpvar_25 = dot (tmpvar_26, ClipPlanes[3]);
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_4.w = tmpvar_25;
  bvec4 tmpvar_27;
  tmpvar_27 = bvec4(ClipPlanes[4]);
  bool tmpvar_28;
  tmpvar_28 = any(tmpvar_27);
  highp float tmpvar_29;
  if (tmpvar_28) {
    highp vec4 tmpvar_30;
    tmpvar_30.w = 1.0;
    tmpvar_30.xyz = tmpvar_10.xyz;
    tmpvar_29 = dot (tmpvar_30, ClipPlanes[4]);
  } else {
    tmpvar_29 = 1.0;
  };
  tmpvar_5.x = tmpvar_29;
  bvec4 tmpvar_31;
  tmpvar_31 = bvec4(ClipPlanes[5]);
  bool tmpvar_32;
  tmpvar_32 = any(tmpvar_31);
  highp float tmpvar_33;
  if (tmpvar_32) {
    highp vec4 tmpvar_34;
    tmpvar_34.w = 1.0;
    tmpvar_34.xyz = tmpvar_10.xyz;
    tmpvar_33 = dot (tmpvar_34, ClipPlanes[5]);
  } else {
    tmpvar_33 = 1.0;
  };
  tmpvar_5.y = tmpvar_33;
  tmpvar_1.w = 1.0;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = tmpvar_2.xy;
  gl_Position = (tmpvar_1 * matWorldViewProj);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = vPosition;
  xlv_TEXCOORD2 = vsNormal_6;
  xlv_TEXCOORD6 = tmpvar_9;
  xlv_TEXCOORD7 = tmpvar_2;
  xlv_COLOR4 = tmpvar_4;
  xlv_COLOR5 = tmpvar_5;
}

