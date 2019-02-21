#extension GL_EXT_shader_texture_lod : enable
#extension GL_OES_standard_derivatives : enable
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
  tmpvar_6.x = ((xlv_TEXCOORD6 - GradientMinMax.YMinMaxFactor.x) / (GradientMinMax.YMinMaxFactor.y - GradientMinMax.YMinMaxFactor.x));
  highp vec2 tmpvar_7;
  tmpvar_7 = mix (xlv_TEXCOORD0.xy, tmpvar_6, GridParams.Params.xx);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD2);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (DiffuseTexture, tmpvar_7);
  diffuseTextureColor_1 = tmpvar_9;
  baseColor_2 = (Material.m_DiffuseColor * diffuseTextureColor_1);
  highp vec4 tmpvar_10;
  tmpvar_10.xyz = Material.m_SpecularColor.xyz;
  tmpvar_10.w = Material.m_SpecularPowerBumpiness.x;
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
    (tmpvar_10 * pow (clamp (dot (
      (tmpvar_15 - (2.0 * (dot (tmpvar_8, tmpvar_15) * tmpvar_8)))
    , 
      -(normalize(normalize((CameraPosition - xlv_TEXCOORD1.xyz))))
    ), 0.0, 1.0), tmpvar_10.w))
  ) * v_13)).xyz;
  finalColor_11.w = tmpvar_12.w;
  finalColor_3.xyz = (((1.0 - GridParams.Lighting.x) * baseColor_2) + (GridParams.Lighting.x * clamp (finalColor_11, 0.0, 1.0))).xyz;
  finalColor_3.w = (baseColor_2.w * Material.m_DiffuseColor.w);
  finalColor_3 = (finalColor_3 * GridParams.Params.y);
  highp float x_16;
  x_16 = (finalColor_3.w - 0.00390625);
  if ((x_16 < 0.0)) {
    discard;
  };
  bvec4 tmpvar_17;
  tmpvar_17 = lessThan (xlv_COLOR4, vec4(0.0, 0.0, 0.0, 0.0));
  if (any(tmpvar_17)) {
    discard;
  };
  bvec2 tmpvar_18;
  tmpvar_18 = lessThan (xlv_COLOR5, vec2(0.0, 0.0));
  if (any(tmpvar_18)) {
    discard;
  };
  gl_FragData[0] = finalColor_3;
}

