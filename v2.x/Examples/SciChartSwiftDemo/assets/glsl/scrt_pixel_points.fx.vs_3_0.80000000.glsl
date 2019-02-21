uniform highp mat4 matWorld;
uniform highp mat4 matWorldViewProj;
uniform highp vec4 ClipPlanes[6];
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
attribute highp vec4 xlat_attrib_COLOR1;
attribute highp vec4 xlat_attrib_COLOR2;
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
  highp vec4 tmpvar_5;
  tmpvar_5 = (vPosition * matWorld);
  bvec4 tmpvar_6;
  tmpvar_6 = bvec4(ClipPlanes[0]);
  bool tmpvar_7;
  tmpvar_7 = any(tmpvar_6);
  highp float tmpvar_8;
  if (tmpvar_7) {
    highp vec4 tmpvar_9;
    tmpvar_9.w = 1.0;
    tmpvar_9.xyz = tmpvar_5.xyz;
    tmpvar_8 = dot (tmpvar_9, ClipPlanes[0]);
  } else {
    tmpvar_8 = 1.0;
  };
  tmpvar_3.x = tmpvar_8;
  bvec4 tmpvar_10;
  tmpvar_10 = bvec4(ClipPlanes[1]);
  bool tmpvar_11;
  tmpvar_11 = any(tmpvar_10);
  highp float tmpvar_12;
  if (tmpvar_11) {
    highp vec4 tmpvar_13;
    tmpvar_13.w = 1.0;
    tmpvar_13.xyz = tmpvar_5.xyz;
    tmpvar_12 = dot (tmpvar_13, ClipPlanes[1]);
  } else {
    tmpvar_12 = 1.0;
  };
  tmpvar_3.y = tmpvar_12;
  bvec4 tmpvar_14;
  tmpvar_14 = bvec4(ClipPlanes[2]);
  bool tmpvar_15;
  tmpvar_15 = any(tmpvar_14);
  highp float tmpvar_16;
  if (tmpvar_15) {
    highp vec4 tmpvar_17;
    tmpvar_17.w = 1.0;
    tmpvar_17.xyz = tmpvar_5.xyz;
    tmpvar_16 = dot (tmpvar_17, ClipPlanes[2]);
  } else {
    tmpvar_16 = 1.0;
  };
  tmpvar_3.z = tmpvar_16;
  bvec4 tmpvar_18;
  tmpvar_18 = bvec4(ClipPlanes[3]);
  bool tmpvar_19;
  tmpvar_19 = any(tmpvar_18);
  highp float tmpvar_20;
  if (tmpvar_19) {
    highp vec4 tmpvar_21;
    tmpvar_21.w = 1.0;
    tmpvar_21.xyz = tmpvar_5.xyz;
    tmpvar_20 = dot (tmpvar_21, ClipPlanes[3]);
  } else {
    tmpvar_20 = 1.0;
  };
  tmpvar_3.w = tmpvar_20;
  bvec4 tmpvar_22;
  tmpvar_22 = bvec4(ClipPlanes[4]);
  bool tmpvar_23;
  tmpvar_23 = any(tmpvar_22);
  highp float tmpvar_24;
  if (tmpvar_23) {
    highp vec4 tmpvar_25;
    tmpvar_25.w = 1.0;
    tmpvar_25.xyz = tmpvar_5.xyz;
    tmpvar_24 = dot (tmpvar_25, ClipPlanes[4]);
  } else {
    tmpvar_24 = 1.0;
  };
  tmpvar_4.x = tmpvar_24;
  bvec4 tmpvar_26;
  tmpvar_26 = bvec4(ClipPlanes[5]);
  bool tmpvar_27;
  tmpvar_27 = any(tmpvar_26);
  highp float tmpvar_28;
  if (tmpvar_27) {
    highp vec4 tmpvar_29;
    tmpvar_29.w = 1.0;
    tmpvar_29.xyz = tmpvar_5.xyz;
    tmpvar_28 = dot (tmpvar_29, ClipPlanes[5]);
  } else {
    tmpvar_28 = 1.0;
  };
  tmpvar_4.y = tmpvar_28;
  tmpvar_1.w = 1.0;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vTexCoord0;
  gl_Position = (tmpvar_1 * matWorldViewProj);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = vColor;
  xlv_COLOR1 = xlat_attrib_COLOR1;
  xlv_COLOR2 = xlat_attrib_COLOR2;
  xlv_COLOR3 = tmpvar_3;
  xlv_COLOR4 = tmpvar_4;
}

