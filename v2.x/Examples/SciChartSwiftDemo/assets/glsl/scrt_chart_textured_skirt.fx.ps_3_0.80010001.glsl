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
  highp vec2 tmpvar_6;
  tmpvar_6.y = 0.0;
  tmpvar_6.x = clamp (((xlv_TEXCOORD6 - GradientMinMax.YMinMaxFactor.x) / (GradientMinMax.YMinMaxFactor.y - GradientMinMax.YMinMaxFactor.x)), 0.0, 1.0);
  highp vec2 tmpvar_7;
  tmpvar_7 = mix (xlv_TEXCOORD0.xy, tmpvar_6, GridParams.Params.xx);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD2);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (DiffuseTexture, tmpvar_7);
  diffuseTextureColor_1 = tmpvar_9;
  baseColor_2 = (Material.m_DiffuseColor * diffuseTextureColor_1);
  highp vec4 spec_10;
  spec_10 = Material.m_SpecularColor;
  highp vec4 finalColor_11;
  highp vec4 tmpvar_12;
  tmpvar_12 = (baseColor_2 * AmbientLightColor);
  highp vec4 v_13;
  v_13.x = Light0[0].y;
  v_13.y = Light0[1].y;
  v_13.z = Light0[2].y;
  v_13.w = Light0[3].y;
  highp vec4 v_14;
  v_14.x = Light0[0].x;
  v_14.y = Light0[1].x;
  v_14.z = Light0[2].x;
  v_14.w = Light0[3].x;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize(-(v_14.xyz));
  finalColor_11.xyz = (tmpvar_12 + ((
    (baseColor_2 * max (dot (tmpvar_8, tmpvar_15), 0.0))
   + 
    (spec_10 * pow (clamp (dot (
      (tmpvar_15 - (2.0 * (dot (tmpvar_8, tmpvar_15) * tmpvar_8)))
    , 
      -(normalize(normalize((CameraPosition - xlv_TEXCOORD1.xyz))))
    ), 0.0, 1.0), spec_10.w))
  ) * v_13)).xyz;
  finalColor_11.w = tmpvar_12.w;
  finalColor_3.xyz = ((baseColor_2 * 0.2) + (0.8 * clamp (finalColor_11, 0.0, 1.0))).xyz;
  finalColor_3.w = (baseColor_2.w * Material.m_DiffuseColor.w);
  finalColor_3 = (finalColor_3 * GridParams.Params.y);
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
    tmpvar_20 = finalColor_3;
  };
  finalColor_3 = tmpvar_20;
  highp float x_21;
  x_21 = (tmpvar_20.w - 0.00390625);
  if ((x_21 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_22;
  tmpvar_22 = lessThan (xlv_COLOR4, vec4(0.0, 0.0, 0.0, 0.0));
  if (any(tmpvar_22)) {
    discard;
  };
  bvec2 tmpvar_23;
  tmpvar_23 = lessThan (xlv_COLOR5, vec2(0.0, 0.0));
  if (any(tmpvar_23)) {
    discard;
  };
  gl_FragData[0] = tmpvar_20;
}

