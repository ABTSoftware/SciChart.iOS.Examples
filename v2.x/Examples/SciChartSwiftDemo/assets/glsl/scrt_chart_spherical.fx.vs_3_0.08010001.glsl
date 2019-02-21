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
uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
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
  highp mat4 tmpvar_6;
  tmpvar_6 = (matWorldView * matProj);
  highp vec3 vsNormal_7;
  highp vec3 terrainNormal_8;
  terrainNormal_8 = vec3(0.0, 1.0, 0.0);
  if ((vTexCoord0.x > 0.999)) {
    terrainNormal_8 = vec3(1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.x < 0.001)) {
    terrainNormal_8 = vec3(-1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.y > 0.999)) {
    terrainNormal_8 = vec3(0.0, 0.0, 1.0);
  };
  if ((vTexCoord0.y < 0.001)) {
    terrainNormal_8 = vec3(0.0, 0.0, -1.0);
  };
  highp mat3 tmpvar_9;
  tmpvar_9[0] = matWorld[0].xyz;
  tmpvar_9[1] = matWorld[1].xyz;
  tmpvar_9[2] = matWorld[2].xyz;
  vsNormal_7 = (terrainNormal_8 * tmpvar_9);
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, GridParams.Params.ww);
  highp float tmpvar_10;
  tmpvar_10 = sqrt(dot (vPosition.xyz, vPosition.xyz));
  highp vec4 tmpvar_11;
  tmpvar_11 = (vPosition * matWorld);
  bvec4 tmpvar_12;
  tmpvar_12 = bvec4(ClipPlanes[0]);
  bool tmpvar_13;
  tmpvar_13 = any(tmpvar_12);
  highp float tmpvar_14;
  if (tmpvar_13) {
    highp vec4 tmpvar_15;
    tmpvar_15.w = 1.0;
    tmpvar_15.xyz = tmpvar_11.xyz;
    tmpvar_14 = dot (tmpvar_15, ClipPlanes[0]);
  } else {
    tmpvar_14 = 1.0;
  };
  tmpvar_4.x = tmpvar_14;
  bvec4 tmpvar_16;
  tmpvar_16 = bvec4(ClipPlanes[1]);
  bool tmpvar_17;
  tmpvar_17 = any(tmpvar_16);
  highp float tmpvar_18;
  if (tmpvar_17) {
    highp vec4 tmpvar_19;
    tmpvar_19.w = 1.0;
    tmpvar_19.xyz = tmpvar_11.xyz;
    tmpvar_18 = dot (tmpvar_19, ClipPlanes[1]);
  } else {
    tmpvar_18 = 1.0;
  };
  tmpvar_4.y = tmpvar_18;
  bvec4 tmpvar_20;
  tmpvar_20 = bvec4(ClipPlanes[2]);
  bool tmpvar_21;
  tmpvar_21 = any(tmpvar_20);
  highp float tmpvar_22;
  if (tmpvar_21) {
    highp vec4 tmpvar_23;
    tmpvar_23.w = 1.0;
    tmpvar_23.xyz = tmpvar_11.xyz;
    tmpvar_22 = dot (tmpvar_23, ClipPlanes[2]);
  } else {
    tmpvar_22 = 1.0;
  };
  tmpvar_4.z = tmpvar_22;
  bvec4 tmpvar_24;
  tmpvar_24 = bvec4(ClipPlanes[3]);
  bool tmpvar_25;
  tmpvar_25 = any(tmpvar_24);
  highp float tmpvar_26;
  if (tmpvar_25) {
    highp vec4 tmpvar_27;
    tmpvar_27.w = 1.0;
    tmpvar_27.xyz = tmpvar_11.xyz;
    tmpvar_26 = dot (tmpvar_27, ClipPlanes[3]);
  } else {
    tmpvar_26 = 1.0;
  };
  tmpvar_4.w = tmpvar_26;
  bvec4 tmpvar_28;
  tmpvar_28 = bvec4(ClipPlanes[4]);
  bool tmpvar_29;
  tmpvar_29 = any(tmpvar_28);
  highp float tmpvar_30;
  if (tmpvar_29) {
    highp vec4 tmpvar_31;
    tmpvar_31.w = 1.0;
    tmpvar_31.xyz = tmpvar_11.xyz;
    tmpvar_30 = dot (tmpvar_31, ClipPlanes[4]);
  } else {
    tmpvar_30 = 1.0;
  };
  tmpvar_5.x = tmpvar_30;
  bvec4 tmpvar_32;
  tmpvar_32 = bvec4(ClipPlanes[5]);
  bool tmpvar_33;
  tmpvar_33 = any(tmpvar_32);
  highp float tmpvar_34;
  if (tmpvar_33) {
    highp vec4 tmpvar_35;
    tmpvar_35.w = 1.0;
    tmpvar_35.xyz = tmpvar_11.xyz;
    tmpvar_34 = dot (tmpvar_35, ClipPlanes[5]);
  } else {
    tmpvar_34 = 1.0;
  };
  tmpvar_5.y = tmpvar_34;
  tmpvar_1.w = 1.0;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = tmpvar_2.xy;
  gl_Position = (tmpvar_1 * tmpvar_6);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = vPosition;
  xlv_TEXCOORD2 = vsNormal_7;
  xlv_TEXCOORD6 = tmpvar_10;
  xlv_TEXCOORD7 = tmpvar_2;
  xlv_COLOR4 = tmpvar_4;
  xlv_COLOR5 = tmpvar_5;
}

