uniform highp mat4 matView;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldViewProj;
uniform highp mat4 TexCoordsSizeMultMap;
uniform highp vec4 ClipPlanes[6];
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
attribute highp vec4 xlat_attrib_COLOR1;
attribute highp vec4 xlat_attrib_COLOR2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD5;
varying highp vec4 xlv_COLOR1;
varying highp vec4 xlv_COLOR2;
varying highp vec4 xlv_COLOR3;
varying highp vec2 xlv_COLOR4;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec4 _pos_6;
  _pos_6.w = vPosition.w;
  highp vec3 tmpvar_7;
  tmpvar_7.x = matView[0].x;
  tmpvar_7.y = matView[0].y;
  tmpvar_7.z = matView[0].z;
  highp vec3 tmpvar_8;
  tmpvar_8.x = matView[1].x;
  tmpvar_8.y = matView[1].y;
  tmpvar_8.z = matView[1].z;
  highp int tmpvar_9;
  tmpvar_9 = int(vTexCoord0.x);
  highp vec4 v_10;
  v_10.x = TexCoordsSizeMultMap[0][tmpvar_9];
  v_10.y = TexCoordsSizeMultMap[1][tmpvar_9];
  v_10.z = TexCoordsSizeMultMap[2][tmpvar_9];
  v_10.w = TexCoordsSizeMultMap[3][tmpvar_9];
  highp vec2 tmpvar_11;
  tmpvar_11 = v_10.xy;
  highp vec4 v_12;
  v_12.x = TexCoordsSizeMultMap[0][tmpvar_9];
  v_12.y = TexCoordsSizeMultMap[1][tmpvar_9];
  v_12.z = TexCoordsSizeMultMap[2][tmpvar_9];
  v_12.w = TexCoordsSizeMultMap[3][tmpvar_9];
  highp vec2 tmpvar_13;
  tmpvar_13 = (v_12.zw * vTexCoord0.y);
  _pos_6.xyz = (vPosition.xyz + ((tmpvar_13.x * tmpvar_7) + (tmpvar_13.y * 
    -(tmpvar_8)
  )));
  tmpvar_1 = _pos_6;
  highp vec4 tmpvar_14;
  tmpvar_14 = (_pos_6 * matWorld);
  bvec4 tmpvar_15;
  tmpvar_15 = bvec4(ClipPlanes[0]);
  bool tmpvar_16;
  tmpvar_16 = any(tmpvar_15);
  highp float tmpvar_17;
  if (tmpvar_16) {
    highp vec4 tmpvar_18;
    tmpvar_18.w = 1.0;
    tmpvar_18.xyz = tmpvar_14.xyz;
    tmpvar_17 = dot (tmpvar_18, ClipPlanes[0]);
  } else {
    tmpvar_17 = 1.0;
  };
  tmpvar_4.x = tmpvar_17;
  bvec4 tmpvar_19;
  tmpvar_19 = bvec4(ClipPlanes[1]);
  bool tmpvar_20;
  tmpvar_20 = any(tmpvar_19);
  highp float tmpvar_21;
  if (tmpvar_20) {
    highp vec4 tmpvar_22;
    tmpvar_22.w = 1.0;
    tmpvar_22.xyz = tmpvar_14.xyz;
    tmpvar_21 = dot (tmpvar_22, ClipPlanes[1]);
  } else {
    tmpvar_21 = 1.0;
  };
  tmpvar_4.y = tmpvar_21;
  bvec4 tmpvar_23;
  tmpvar_23 = bvec4(ClipPlanes[2]);
  bool tmpvar_24;
  tmpvar_24 = any(tmpvar_23);
  highp float tmpvar_25;
  if (tmpvar_24) {
    highp vec4 tmpvar_26;
    tmpvar_26.w = 1.0;
    tmpvar_26.xyz = tmpvar_14.xyz;
    tmpvar_25 = dot (tmpvar_26, ClipPlanes[2]);
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_4.z = tmpvar_25;
  bvec4 tmpvar_27;
  tmpvar_27 = bvec4(ClipPlanes[3]);
  bool tmpvar_28;
  tmpvar_28 = any(tmpvar_27);
  highp float tmpvar_29;
  if (tmpvar_28) {
    highp vec4 tmpvar_30;
    tmpvar_30.w = 1.0;
    tmpvar_30.xyz = tmpvar_14.xyz;
    tmpvar_29 = dot (tmpvar_30, ClipPlanes[3]);
  } else {
    tmpvar_29 = 1.0;
  };
  tmpvar_4.w = tmpvar_29;
  bvec4 tmpvar_31;
  tmpvar_31 = bvec4(ClipPlanes[4]);
  bool tmpvar_32;
  tmpvar_32 = any(tmpvar_31);
  highp float tmpvar_33;
  if (tmpvar_32) {
    highp vec4 tmpvar_34;
    tmpvar_34.w = 1.0;
    tmpvar_34.xyz = tmpvar_14.xyz;
    tmpvar_33 = dot (tmpvar_34, ClipPlanes[4]);
  } else {
    tmpvar_33 = 1.0;
  };
  tmpvar_5.x = tmpvar_33;
  bvec4 tmpvar_35;
  tmpvar_35 = bvec4(ClipPlanes[5]);
  bool tmpvar_36;
  tmpvar_36 = any(tmpvar_35);
  highp float tmpvar_37;
  if (tmpvar_36) {
    highp vec4 tmpvar_38;
    tmpvar_38.w = 1.0;
    tmpvar_38.xyz = tmpvar_14.xyz;
    tmpvar_37 = dot (tmpvar_38, ClipPlanes[5]);
  } else {
    tmpvar_37 = 1.0;
  };
  tmpvar_5.y = tmpvar_37;
  tmpvar_1.w = 1.0;
  tmpvar_2 = (tmpvar_1 * matWorldViewProj);
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = tmpvar_11;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_COLOR0 = vColor;
  xlv_TEXCOORD5 = tmpvar_2;
  xlv_COLOR1 = xlat_attrib_COLOR1;
  xlv_COLOR2 = xlat_attrib_COLOR2;
  xlv_COLOR3 = tmpvar_4;
  xlv_COLOR4 = tmpvar_5;
}

