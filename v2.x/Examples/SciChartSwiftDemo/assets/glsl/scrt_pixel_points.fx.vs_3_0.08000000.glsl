uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
uniform highp vec4 ClipPlanes[6];
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
attribute highp vec4 vColor1;
attribute highp vec4 vColor2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_COLOR1;
varying highp vec4 xlv_COLOR2;
varying highp vec4 xlv_COLOR3;
varying highp vec2 xlv_COLOR4;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = vPosition;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec2 tmpvar_4;
  highp mat4 tmpvar_5;
  tmpvar_5 = (matWorldView * matProj);
  highp vec4 tmpvar_6;
  tmpvar_6 = (vPosition * matWorld);
  bvec4 tmpvar_7;
  tmpvar_7 = bvec4(ClipPlanes[0]);
  bool tmpvar_8;
  tmpvar_8 = any(tmpvar_7);
  highp float tmpvar_9;
  if (tmpvar_8) {
    highp vec4 tmpvar_10;
    tmpvar_10.w = 1.0;
    tmpvar_10.xyz = tmpvar_6.xyz;
    tmpvar_9 = dot (tmpvar_10, ClipPlanes[0]);
  } else {
    tmpvar_9 = 1.0;
  };
  tmpvar_3.x = tmpvar_9;
  bvec4 tmpvar_11;
  tmpvar_11 = bvec4(ClipPlanes[1]);
  bool tmpvar_12;
  tmpvar_12 = any(tmpvar_11);
  highp float tmpvar_13;
  if (tmpvar_12) {
    highp vec4 tmpvar_14;
    tmpvar_14.w = 1.0;
    tmpvar_14.xyz = tmpvar_6.xyz;
    tmpvar_13 = dot (tmpvar_14, ClipPlanes[1]);
  } else {
    tmpvar_13 = 1.0;
  };
  tmpvar_3.y = tmpvar_13;
  bvec4 tmpvar_15;
  tmpvar_15 = bvec4(ClipPlanes[2]);
  bool tmpvar_16;
  tmpvar_16 = any(tmpvar_15);
  highp float tmpvar_17;
  if (tmpvar_16) {
    highp vec4 tmpvar_18;
    tmpvar_18.w = 1.0;
    tmpvar_18.xyz = tmpvar_6.xyz;
    tmpvar_17 = dot (tmpvar_18, ClipPlanes[2]);
  } else {
    tmpvar_17 = 1.0;
  };
  tmpvar_3.z = tmpvar_17;
  bvec4 tmpvar_19;
  tmpvar_19 = bvec4(ClipPlanes[3]);
  bool tmpvar_20;
  tmpvar_20 = any(tmpvar_19);
  highp float tmpvar_21;
  if (tmpvar_20) {
    highp vec4 tmpvar_22;
    tmpvar_22.w = 1.0;
    tmpvar_22.xyz = tmpvar_6.xyz;
    tmpvar_21 = dot (tmpvar_22, ClipPlanes[3]);
  } else {
    tmpvar_21 = 1.0;
  };
  tmpvar_3.w = tmpvar_21;
  bvec4 tmpvar_23;
  tmpvar_23 = bvec4(ClipPlanes[4]);
  bool tmpvar_24;
  tmpvar_24 = any(tmpvar_23);
  highp float tmpvar_25;
  if (tmpvar_24) {
    highp vec4 tmpvar_26;
    tmpvar_26.w = 1.0;
    tmpvar_26.xyz = tmpvar_6.xyz;
    tmpvar_25 = dot (tmpvar_26, ClipPlanes[4]);
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_4.x = tmpvar_25;
  bvec4 tmpvar_27;
  tmpvar_27 = bvec4(ClipPlanes[5]);
  bool tmpvar_28;
  tmpvar_28 = any(tmpvar_27);
  highp float tmpvar_29;
  if (tmpvar_28) {
    highp vec4 tmpvar_30;
    tmpvar_30.w = 1.0;
    tmpvar_30.xyz = tmpvar_6.xyz;
    tmpvar_29 = dot (tmpvar_30, ClipPlanes[5]);
  } else {
    tmpvar_29 = 1.0;
  };
  tmpvar_4.y = tmpvar_29;
  tmpvar_1.w = 1.0;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vTexCoord0;
  gl_Position = (tmpvar_1 * tmpvar_5);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = vColor;
  xlv_COLOR1 = vColor1;
  xlv_COLOR2 = vColor2;
  xlv_COLOR3 = tmpvar_3;
  xlv_COLOR4 = tmpvar_4;
}

