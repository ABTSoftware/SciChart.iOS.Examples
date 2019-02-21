uniform highp mat4 matView;
uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
uniform highp mat4 TexCoordsSizeMultMap;
uniform highp vec4 ClipPlanes[6];
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
attribute highp vec4 vColor1;
attribute highp vec4 vColor2;
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
  highp mat4 tmpvar_6;
  tmpvar_6 = (matWorldView * matProj);
  highp vec4 _pos_7;
  _pos_7.w = vPosition.w;
  highp vec3 tmpvar_8;
  tmpvar_8.x = matView[0].x;
  tmpvar_8.y = matView[0].y;
  tmpvar_8.z = matView[0].z;
  highp vec3 tmpvar_9;
  tmpvar_9.x = matView[1].x;
  tmpvar_9.y = matView[1].y;
  tmpvar_9.z = matView[1].z;
  highp int tmpvar_10;
  tmpvar_10 = int(vTexCoord0.x);
  highp vec4 v_11;
  v_11.x = TexCoordsSizeMultMap[0][tmpvar_10];
  v_11.y = TexCoordsSizeMultMap[1][tmpvar_10];
  v_11.z = TexCoordsSizeMultMap[2][tmpvar_10];
  v_11.w = TexCoordsSizeMultMap[3][tmpvar_10];
  highp vec2 tmpvar_12;
  tmpvar_12 = v_11.xy;
  highp vec4 v_13;
  v_13.x = TexCoordsSizeMultMap[0][tmpvar_10];
  v_13.y = TexCoordsSizeMultMap[1][tmpvar_10];
  v_13.z = TexCoordsSizeMultMap[2][tmpvar_10];
  v_13.w = TexCoordsSizeMultMap[3][tmpvar_10];
  highp vec2 tmpvar_14;
  tmpvar_14 = (v_13.zw * vTexCoord0.y);
  _pos_7.xyz = (vPosition.xyz + ((tmpvar_14.x * tmpvar_8) + (tmpvar_14.y * 
    -(tmpvar_9)
  )));
  tmpvar_1 = _pos_7;
  highp vec4 tmpvar_15;
  tmpvar_15 = (_pos_7 * matWorld);
  bvec4 tmpvar_16;
  tmpvar_16 = bvec4(ClipPlanes[0]);
  bool tmpvar_17;
  tmpvar_17 = any(tmpvar_16);
  highp float tmpvar_18;
  if (tmpvar_17) {
    highp vec4 tmpvar_19;
    tmpvar_19.w = 1.0;
    tmpvar_19.xyz = tmpvar_15.xyz;
    tmpvar_18 = dot (tmpvar_19, ClipPlanes[0]);
  } else {
    tmpvar_18 = 1.0;
  };
  tmpvar_4.x = tmpvar_18;
  bvec4 tmpvar_20;
  tmpvar_20 = bvec4(ClipPlanes[1]);
  bool tmpvar_21;
  tmpvar_21 = any(tmpvar_20);
  highp float tmpvar_22;
  if (tmpvar_21) {
    highp vec4 tmpvar_23;
    tmpvar_23.w = 1.0;
    tmpvar_23.xyz = tmpvar_15.xyz;
    tmpvar_22 = dot (tmpvar_23, ClipPlanes[1]);
  } else {
    tmpvar_22 = 1.0;
  };
  tmpvar_4.y = tmpvar_22;
  bvec4 tmpvar_24;
  tmpvar_24 = bvec4(ClipPlanes[2]);
  bool tmpvar_25;
  tmpvar_25 = any(tmpvar_24);
  highp float tmpvar_26;
  if (tmpvar_25) {
    highp vec4 tmpvar_27;
    tmpvar_27.w = 1.0;
    tmpvar_27.xyz = tmpvar_15.xyz;
    tmpvar_26 = dot (tmpvar_27, ClipPlanes[2]);
  } else {
    tmpvar_26 = 1.0;
  };
  tmpvar_4.z = tmpvar_26;
  bvec4 tmpvar_28;
  tmpvar_28 = bvec4(ClipPlanes[3]);
  bool tmpvar_29;
  tmpvar_29 = any(tmpvar_28);
  highp float tmpvar_30;
  if (tmpvar_29) {
    highp vec4 tmpvar_31;
    tmpvar_31.w = 1.0;
    tmpvar_31.xyz = tmpvar_15.xyz;
    tmpvar_30 = dot (tmpvar_31, ClipPlanes[3]);
  } else {
    tmpvar_30 = 1.0;
  };
  tmpvar_4.w = tmpvar_30;
  bvec4 tmpvar_32;
  tmpvar_32 = bvec4(ClipPlanes[4]);
  bool tmpvar_33;
  tmpvar_33 = any(tmpvar_32);
  highp float tmpvar_34;
  if (tmpvar_33) {
    highp vec4 tmpvar_35;
    tmpvar_35.w = 1.0;
    tmpvar_35.xyz = tmpvar_15.xyz;
    tmpvar_34 = dot (tmpvar_35, ClipPlanes[4]);
  } else {
    tmpvar_34 = 1.0;
  };
  tmpvar_5.x = tmpvar_34;
  bvec4 tmpvar_36;
  tmpvar_36 = bvec4(ClipPlanes[5]);
  bool tmpvar_37;
  tmpvar_37 = any(tmpvar_36);
  highp float tmpvar_38;
  if (tmpvar_37) {
    highp vec4 tmpvar_39;
    tmpvar_39.w = 1.0;
    tmpvar_39.xyz = tmpvar_15.xyz;
    tmpvar_38 = dot (tmpvar_39, ClipPlanes[5]);
  } else {
    tmpvar_38 = 1.0;
  };
  tmpvar_5.y = tmpvar_38;
  tmpvar_1.w = 1.0;
  tmpvar_2 = (tmpvar_1 * tmpvar_6);
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = tmpvar_12;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_COLOR0 = vColor;
  xlv_TEXCOORD5 = tmpvar_2;
  xlv_COLOR1 = vColor1;
  xlv_COLOR2 = vColor2;
  xlv_COLOR3 = tmpvar_4;
  xlv_COLOR4 = tmpvar_5;
}

