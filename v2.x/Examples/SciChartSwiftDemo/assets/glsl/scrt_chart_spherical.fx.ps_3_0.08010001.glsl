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
  highp vec4 diffuseTextureColor_1;
  highp vec4 baseColor_2;
  highp vec4 finalColor_3;
  highp vec2 x_4;
  x_4 = (vec2(0.5, 0.5) - abs((xlv_TEXCOORD0.xy - vec2(0.5, 0.5))));
  bvec2 tmpvar_5;
  tmpvar_5 = lessThan (x_4, vec2(0.0, 0.0));
  if (any(tmpvar_5)) {
    discard;
  };
  highp float fAzimuthalWeight_6;
  highp float fSampleCoord_7;
  highp vec3 tmpvar_8;
  tmpvar_8.x = GradientMinMax.XMinMaxFactor.x;
  tmpvar_8.y = GradientMinMax.YMinMaxFactor.x;
  tmpvar_8.z = GradientMinMax.ZMinMaxFactor.x;
  highp vec3 tmpvar_9;
  tmpvar_9.x = GradientMinMax.XMinMaxFactor.y;
  tmpvar_9.y = GradientMinMax.YMinMaxFactor.y;
  tmpvar_9.z = GradientMinMax.ZMinMaxFactor.y;
  highp vec3 tmpvar_10;
  tmpvar_10.x = GradientMinMax.XMinMaxFactor.z;
  tmpvar_10.y = GradientMinMax.YMinMaxFactor.z;
  tmpvar_10.z = GradientMinMax.ZMinMaxFactor.z;
  highp float tmpvar_11;
  tmpvar_11 = GradientMinMax.YMinMaxFactor.w;
  highp float tmpvar_12;
  tmpvar_12 = GradientMinMax.ZMinMaxFactor.w;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_8, tmpvar_8);
  fSampleCoord_7 = (dot (clamp (
    ((xlv_TEXCOORD1.xyz - tmpvar_8) / (tmpvar_9 - tmpvar_8))
  , 0.0, 1.0), tmpvar_10) + (clamp (
    ((dot (xlv_TEXCOORD1.xyz, xlv_TEXCOORD1.xyz) - tmpvar_13) / (dot (tmpvar_9, tmpvar_9) - tmpvar_13))
  , 0.0, 1.0) * GradientMinMax.XMinMaxFactor.w));
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(xlv_TEXCOORD1.xyz);
  highp vec3 tmpvar_15;
  tmpvar_15.y = 0.0;
  tmpvar_15.xz = tmpvar_14.xz;
  fAzimuthalWeight_6 = ((normalize(tmpvar_15).x + 1.0) / 4.0);
  if ((tmpvar_14.z < 0.0)) {
    fAzimuthalWeight_6 = (1.0 - fAzimuthalWeight_6);
  };
  fSampleCoord_7 = (fSampleCoord_7 + (fAzimuthalWeight_6 * tmpvar_11));
  fSampleCoord_7 = (fSampleCoord_7 + ((
    (tmpvar_14.y + 1.0)
   / 2.0) * tmpvar_12));
  highp float tmpvar_16;
  tmpvar_16 = clamp (fSampleCoord_7, 0.0, 1.0);
  fSampleCoord_7 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.y = 0.0;
  tmpvar_17.x = tmpvar_16;
  highp vec2 tmpvar_18;
  tmpvar_18 = mix (xlv_TEXCOORD0.xy, tmpvar_17, GridParams.Params.xx);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (DiffuseTexture, tmpvar_18);
  diffuseTextureColor_1 = tmpvar_19;
  baseColor_2 = (Material.m_DiffuseColor * diffuseTextureColor_1);
  highp vec2 tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD0.xy;
  highp vec3 tmpvar_21;
  tmpvar_21.x = tmpvar_20.x;
  tmpvar_21.y = xlv_TEXCOORD6;
  tmpvar_21.z = tmpvar_20.y;
  highp vec3 tmpvar_22;
  highp vec3 fH_23;
  fH_23 = ((tmpvar_21 + GridParams.ContourOffset.xyz) * GridParams.ContourScale.xyz);
  highp vec3 tmpvar_24;
  tmpvar_24 = (GridParams.ContourThickness.xyz * 0.5);
  highp vec3 tmpvar_25;
  tmpvar_25 = (abs(dFdx(fH_23)) + abs(dFdy(fH_23)));
  highp vec3 tmpvar_26;
  tmpvar_26 = clamp ((abs(
    fract(fH_23)
  ) / (tmpvar_25 * tmpvar_24)), 0.0, 1.0);
  highp vec3 tmpvar_27;
  tmpvar_27 = clamp (((1.0 - 
    abs(fract(fH_23))
  ) / (tmpvar_25 * tmpvar_24)), 0.0, 1.0);
  tmpvar_22 = ((tmpvar_27 * (tmpvar_27 * 
    (3.0 - (2.0 * tmpvar_27))
  )) * (tmpvar_26 * (tmpvar_26 * 
    (3.0 - (2.0 * tmpvar_26))
  )));
  finalColor_3 = (baseColor_2 * GridParams.Params.y);
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_texture2DLodEXT (CellInfoTexture, xlv_TEXCOORD0.zw, 0.0);
  highp vec4 tmpvar_29;
  tmpvar_29 = tmpvar_28;
  bvec4 tmpvar_30;
  tmpvar_30 = bvec4(tmpvar_29);
  bool tmpvar_31;
  tmpvar_31 = any(tmpvar_30);
  highp vec4 tmpvar_32;
  if (tmpvar_31) {
    tmpvar_32 = tmpvar_29;
  } else {
    tmpvar_32 = finalColor_3;
  };
  highp vec4 tmpvar_33;
  tmpvar_33 = mix (mix (mix (tmpvar_32, GridParams.ContourColorX, vec4(
    (GridParams.ContourColorX.w * (1.0 - tmpvar_22.x))
  )), GridParams.ContourColorZ, vec4((GridParams.ContourColorZ.w * 
    (1.0 - tmpvar_22.z)
  ))), GridParams.ContourColorY, vec4((GridParams.ContourColorY.w * (1.0 - tmpvar_22.y))));
  finalColor_3.xyz = tmpvar_33.xyz;
  finalColor_3.w = (tmpvar_33.w * (baseColor_2.w * Material.m_DiffuseColor.w));
  highp vec4 tmpvar_34;
  tmpvar_34.xyz = finalColor_3.xyz;
  tmpvar_34.w = GridParams.Params.y;
  bvec4 tmpvar_35;
  tmpvar_35 = bvec4(tmpvar_34);
  bool tmpvar_36;
  tmpvar_36 = any(tmpvar_35);
  highp float tmpvar_37;
  if (tmpvar_36) {
    tmpvar_37 = (finalColor_3.w - 0.00390625);
  } else {
    tmpvar_37 = -1.0;
  };
  if ((tmpvar_37 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_38;
  tmpvar_38 = lessThan (xlv_COLOR4, vec4(0.0, 0.0, 0.0, 0.0));
  if (any(tmpvar_38)) {
    discard;
  };
  bvec2 tmpvar_39;
  tmpvar_39 = lessThan (xlv_COLOR5, vec2(0.0, 0.0));
  if (any(tmpvar_39)) {
    discard;
  };
  gl_FragData[0] = finalColor_3;
}

