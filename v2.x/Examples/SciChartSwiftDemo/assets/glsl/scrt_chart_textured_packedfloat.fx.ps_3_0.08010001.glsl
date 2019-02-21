#extension GL_EXT_shader_texture_lod : enable
#extension GL_OES_standard_derivatives : enable
lowp vec4 impl_low_texture2DLodEXT(lowp sampler2D sampler, highp vec2 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return texture2DLodEXT(sampler, coord, lod);
#else
	return texture2D(sampler, coord, lod);
#endif
}

precision highp float;
struct sGradientParams {
  highp vec4 YMinMaxFactor;
  highp vec4 XMinMaxFactor;
  highp vec4 ZMinMaxFactor;
};
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
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform highp vec3 CameraPosition;
uniform sGradientParams GradientMinMax;
uniform sampler2D CellInfoTexture;
uniform sGridParams GridParams;
uniform highp vec4 AmbientLightColor;
uniform MaterialInfo Material;
uniform highp mat4 Light0;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp float xlv_TEXCOORD6;
varying highp vec4 xlv_COLOR4;
varying highp vec2 xlv_COLOR5;
void main ()
{
  highp vec3 wsPosition_1;
  highp vec4 diffuseTextureColor_2;
  highp vec4 baseColor_3;
  highp vec4 finalColor_4;
  highp vec2 x_5;
  x_5 = (vec2(0.5, 0.5) - abs((xlv_TEXCOORD0.xy - vec2(0.5, 0.5))));
  bvec2 tmpvar_6;
  tmpvar_6 = lessThan (x_5, vec2(0.0, 0.0));
  if (any(tmpvar_6)) {
    discard;
  };
  highp vec2 tmpvar_7;
  tmpvar_7.y = 0.0;
  tmpvar_7.x = ((xlv_TEXCOORD6 - GradientMinMax.YMinMaxFactor.x) / (GradientMinMax.YMinMaxFactor.y - GradientMinMax.YMinMaxFactor.x));
  highp vec2 tmpvar_8;
  tmpvar_8 = mix (xlv_TEXCOORD0.xy, tmpvar_7, GridParams.Params.xx);
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD2);
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize((CameraPosition - xlv_TEXCOORD1.xyz));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (DiffuseTexture, tmpvar_8);
  diffuseTextureColor_2 = tmpvar_11;
  baseColor_3 = (Material.m_DiffuseColor * diffuseTextureColor_2);
  finalColor_4 = baseColor_3;
  wsPosition_1.xz = xlv_TEXCOORD1.xz;
  wsPosition_1.y = xlv_TEXCOORD6;
  highp vec3 tmpvar_12;
  highp vec3 fH_13;
  fH_13 = ((wsPosition_1 + GridParams.ContourOffset.xyz) * GridParams.ContourScale.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = (GridParams.ContourThickness.xyz * 0.5);
  highp vec3 tmpvar_15;
  tmpvar_15 = (abs(dFdx(fH_13)) + abs(dFdy(fH_13)));
  highp vec3 tmpvar_16;
  tmpvar_16 = clamp ((abs(
    fract(fH_13)
  ) / (tmpvar_15 * tmpvar_14)), 0.0, 1.0);
  highp vec3 tmpvar_17;
  tmpvar_17 = clamp (((1.0 - 
    abs(fract(fH_13))
  ) / (tmpvar_15 * tmpvar_14)), 0.0, 1.0);
  tmpvar_12 = ((tmpvar_17 * (tmpvar_17 * 
    (3.0 - (2.0 * tmpvar_17))
  )) * (tmpvar_16 * (tmpvar_16 * 
    (3.0 - (2.0 * tmpvar_16))
  )));
  lowp vec4 tmpvar_18;
  tmpvar_18 = impl_low_texture2DLodEXT (CellInfoTexture, xlv_TEXCOORD0.zw, 0.0);
  highp vec4 tmpvar_19;
  tmpvar_19 = tmpvar_18;
  bvec4 tmpvar_20;
  tmpvar_20 = bvec4(tmpvar_19);
  bool tmpvar_21;
  tmpvar_21 = any(tmpvar_20);
  highp vec4 tmpvar_22;
  if (tmpvar_21) {
    tmpvar_22 = tmpvar_19;
  } else {
    tmpvar_22 = baseColor_3;
  };
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = Material.m_SpecularColor.xyz;
  tmpvar_23.w = Material.m_SpecularPowerBumpiness.x;
  highp vec4 finalColor_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_22 * AmbientLightColor);
  highp vec4 v_26;
  v_26.x = Light0[0].y;
  v_26.y = Light0[1].y;
  v_26.z = Light0[2].y;
  v_26.w = Light0[3].y;
  highp vec4 v_27;
  v_27.x = Light0[0].x;
  v_27.y = Light0[1].x;
  v_27.z = Light0[2].x;
  v_27.w = Light0[3].x;
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize(-(v_27.xyz));
  finalColor_24.xyz = (tmpvar_25 + ((
    (tmpvar_22 * max (dot (tmpvar_9, tmpvar_28), 0.0))
   + 
    (tmpvar_23 * pow (clamp (dot (
      (tmpvar_28 - (2.0 * (dot (tmpvar_9, tmpvar_28) * tmpvar_9)))
    , 
      -(normalize(tmpvar_10))
    ), 0.0, 1.0), tmpvar_23.w))
  ) * v_26)).xyz;
  finalColor_24.w = tmpvar_25.w;
  finalColor_4 = (((1.0 - GridParams.Lighting.x) * tmpvar_22) + (GridParams.Lighting.x * clamp (finalColor_24, 0.0, 1.0)));
  finalColor_4 = (finalColor_4 * GridParams.Params.y);
  highp vec4 tmpvar_29;
  tmpvar_29 = mix (mix (mix (finalColor_4, GridParams.ContourColorX, vec4(
    (GridParams.ContourColorX.w * (1.0 - tmpvar_12.x))
  )), GridParams.ContourColorZ, vec4((GridParams.ContourColorZ.w * 
    (1.0 - tmpvar_12.z)
  ))), GridParams.ContourColorY, vec4((GridParams.ContourColorY.w * (1.0 - tmpvar_12.y))));
  finalColor_4.xyz = tmpvar_29.xyz;
  finalColor_4.w = (tmpvar_29.w * (baseColor_3.w * Material.m_DiffuseColor.w));
  highp vec4 tmpvar_30;
  tmpvar_30.xyz = finalColor_4.xyz;
  tmpvar_30.w = GridParams.Params.y;
  bvec4 tmpvar_31;
  tmpvar_31 = bvec4(tmpvar_30);
  bool tmpvar_32;
  tmpvar_32 = any(tmpvar_31);
  highp float tmpvar_33;
  if (tmpvar_32) {
    tmpvar_33 = (finalColor_4.w - 0.00390625);
  } else {
    tmpvar_33 = -1.0;
  };
  if ((tmpvar_33 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_34;
  tmpvar_34 = lessThan (xlv_COLOR4, vec4(0.0, 0.0, 0.0, 0.0));
  if (any(tmpvar_34)) {
    discard;
  };
  bvec2 tmpvar_35;
  tmpvar_35 = lessThan (xlv_COLOR5, vec2(0.0, 0.0));
  if (any(tmpvar_35)) {
    discard;
  };
  gl_FragData[0] = finalColor_4;
}

