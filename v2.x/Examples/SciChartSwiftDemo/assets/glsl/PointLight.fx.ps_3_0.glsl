precision highp float;
uniform highp vec3 CameraPosition;
uniform highp mat4 Light0;
uniform highp mat4 matInvProj;
uniform highp mat4 matInvView;
uniform highp vec4 screenSize;
uniform sampler2D DiffuseTexture;
uniform sampler2D SpecularTexture;
uniform sampler2D NormalTexture;
uniform sampler2D DepthTexture;
varying highp vec4 xlv_TEXCOORD5;
void main ()
{
  highp vec2 _screenUV_1;
  _screenUV_1 = (xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w);
  highp vec4 result_2;
  highp float fDepth_3;
  highp vec4 pixelNormal_4;
  highp vec2 BaseTexCoord_5;
  highp vec4 tmpvar_6;
  highp vec4 tmpvar_7;
  highp vec3 tmpvar_8;
  BaseTexCoord_5.x = _screenUV_1.x;
  BaseTexCoord_5.y = -(_screenUV_1.y);
  BaseTexCoord_5 = ((BaseTexCoord_5 + 1.0) * 0.5);
  BaseTexCoord_5 = (BaseTexCoord_5 + screenSize.zw);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (DiffuseTexture, BaseTexCoord_5);
  tmpvar_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (SpecularTexture, BaseTexCoord_5);
  tmpvar_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (NormalTexture, BaseTexCoord_5);
  pixelNormal_4 = tmpvar_11;
  highp vec3 n_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = ((pixelNormal_4.xyz * vec3(3.5554, 3.5554, 0.0)) + vec3(-1.7777, -1.7777, 1.0));
  highp float tmpvar_14;
  tmpvar_14 = (2.0 / dot (tmpvar_13, tmpvar_13));
  n_12.xy = (tmpvar_14 * tmpvar_13.xy);
  n_12.z = (tmpvar_14 - 1.0);
  pixelNormal_4.xyz = normalize(n_12);
  highp mat3 tmpvar_15;
  tmpvar_15[0] = matInvView[0].xyz;
  tmpvar_15[1] = matInvView[1].xyz;
  tmpvar_15[2] = matInvView[2].xyz;
  tmpvar_8 = (pixelNormal_4.xyz * tmpvar_15);
  lowp float tmpvar_16;
  tmpvar_16 = texture2D (DepthTexture, BaseTexCoord_5).x;
  fDepth_3 = tmpvar_16;
  highp vec4 worldPosition_17;
  if ((fDepth_3 == 0.0)) {
    discard;
  };
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xy = _screenUV_1;
  tmpvar_18.z = fDepth_3;
  worldPosition_17 = ((tmpvar_18 * matInvProj) * matInvView);
  worldPosition_17 = (worldPosition_17 / worldPosition_17.w);
  tmpvar_7.w = (tmpvar_7.w * 1024.0);
  result_2.w = 1.0;
  highp float attenuation_19;
  highp vec4 v_20;
  v_20.x = Light0[0].x;
  v_20.y = Light0[1].x;
  v_20.z = Light0[2].x;
  v_20.w = Light0[3].x;
  highp vec4 v_21;
  v_21.x = Light0[0].y;
  v_21.y = Light0[1].y;
  v_21.z = Light0[2].y;
  v_21.w = Light0[3].y;
  highp vec4 v_22;
  v_22.x = Light0[0].z;
  v_22.y = Light0[1].z;
  v_22.z = Light0[2].z;
  v_22.w = Light0[3].z;
  highp vec3 tmpvar_23;
  tmpvar_23 = (v_20.xyz - worldPosition_17.xyz);
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize(tmpvar_23);
  attenuation_19 = (clamp ((1.0 - 
    (sqrt(dot (tmpvar_23, tmpvar_23)) * v_22.y)
  ), 0.0, 1.0) * v_21.w);
  result_2.xyz = (((
    (attenuation_19 * tmpvar_6)
   * vec4(
    max (dot (tmpvar_8, tmpvar_24), 0.0)
  )) + (
    (attenuation_19 * tmpvar_7)
   * 
    pow (clamp (dot ((tmpvar_24 - 
      (2.0 * (dot (tmpvar_8, tmpvar_24) * tmpvar_8))
    ), -(
      normalize(normalize((CameraPosition - worldPosition_17.xyz)))
    )), 0.0, 1.0), tmpvar_7.w)
  )) * v_21).xyz;
  if ((tmpvar_7.w == 0.0)) {
    result_2.xyz = vec3(0.0, 0.0, 0.0);
  };
  gl_FragData[0] = result_2;
}

