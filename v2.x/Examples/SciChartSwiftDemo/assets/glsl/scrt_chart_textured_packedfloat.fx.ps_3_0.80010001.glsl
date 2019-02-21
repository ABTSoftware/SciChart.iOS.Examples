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
};
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform sGradientParams GradientMinMax;
uniform sampler2D CellInfoTexture;
uniform sGridParams GridParams;
uniform MaterialInfo Material;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
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
  tmpvar_7.x = clamp (((xlv_TEXCOORD6 - GradientMinMax.YMinMaxFactor.x) / (GradientMinMax.YMinMaxFactor.y - GradientMinMax.YMinMaxFactor.x)), 0.0, 1.0);
  highp vec2 tmpvar_8;
  tmpvar_8 = mix (xlv_TEXCOORD0.xy, tmpvar_7, GridParams.Params.xx);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (DiffuseTexture, tmpvar_8);
  diffuseTextureColor_2 = tmpvar_9;
  baseColor_3 = (Material.m_DiffuseColor * diffuseTextureColor_2);
  wsPosition_1.xz = xlv_TEXCOORD1.xz;
  wsPosition_1.y = xlv_TEXCOORD6;
  highp vec3 tmpvar_10;
  highp vec3 fH_11;
  fH_11 = ((wsPosition_1 + GridParams.ContourOffset.xyz) * GridParams.ContourScale.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (GridParams.ContourThickness.xyz * 0.5);
  highp vec3 tmpvar_13;
  tmpvar_13 = (abs(dFdx(fH_11)) + abs(dFdy(fH_11)));
  highp vec3 tmpvar_14;
  tmpvar_14 = clamp ((abs(
    fract(fH_11)
  ) / (tmpvar_13 * tmpvar_12)), 0.0, 1.0);
  highp vec3 tmpvar_15;
  tmpvar_15 = clamp (((1.0 - 
    abs(fract(fH_11))
  ) / (tmpvar_13 * tmpvar_12)), 0.0, 1.0);
  tmpvar_10 = ((tmpvar_15 * (tmpvar_15 * 
    (3.0 - (2.0 * tmpvar_15))
  )) * (tmpvar_14 * (tmpvar_14 * 
    (3.0 - (2.0 * tmpvar_14))
  )));
  finalColor_4 = (baseColor_3 * GridParams.Params.y);
  lowp vec4 tmpvar_16;
  tmpvar_16 = impl_low_texture2DLodEXT (CellInfoTexture, xlv_TEXCOORD0.zw, 0.0);
  highp vec4 tmpvar_17;
  tmpvar_17 = tmpvar_16;
  bvec4 tmpvar_18;
  tmpvar_18 = bvec4(tmpvar_17);
  bool tmpvar_19;
  tmpvar_19 = any(tmpvar_18);
  highp vec4 tmpvar_20;
  if (tmpvar_19) {
    tmpvar_20 = tmpvar_17;
  } else {
    tmpvar_20 = finalColor_4;
  };
  highp vec4 tmpvar_21;
  tmpvar_21 = mix (mix (mix (tmpvar_20, GridParams.ContourColorX, vec4(
    (GridParams.ContourColorX.w * (1.0 - tmpvar_10.x))
  )), GridParams.ContourColorZ, vec4((GridParams.ContourColorZ.w * 
    (1.0 - tmpvar_10.z)
  ))), GridParams.ContourColorY, vec4((GridParams.ContourColorY.w * (1.0 - tmpvar_10.y))));
  finalColor_4.xyz = tmpvar_21.xyz;
  finalColor_4.w = (tmpvar_21.w * (baseColor_3.w * Material.m_DiffuseColor.w));
  highp vec4 tmpvar_22;
  tmpvar_22.xyz = finalColor_4.xyz;
  tmpvar_22.w = GridParams.Params.y;
  bvec4 tmpvar_23;
  tmpvar_23 = bvec4(tmpvar_22);
  bool tmpvar_24;
  tmpvar_24 = any(tmpvar_23);
  highp float tmpvar_25;
  if (tmpvar_24) {
    tmpvar_25 = (finalColor_4.w - 0.00390625);
  } else {
    tmpvar_25 = -1.0;
  };
  if ((tmpvar_25 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (xlv_COLOR4, vec4(0.0, 0.0, 0.0, 0.0));
  if (any(tmpvar_26)) {
    discard;
  };
  bvec2 tmpvar_27;
  tmpvar_27 = lessThan (xlv_COLOR5, vec2(0.0, 0.0));
  if (any(tmpvar_27)) {
    discard;
  };
  gl_FragData[0] = finalColor_4;
}

