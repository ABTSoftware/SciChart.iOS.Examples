precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform highp vec4 AmbientLightColor;
uniform MaterialInfo Material;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  highp vec4 diffuseTextureColor_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (DiffuseTexture, xlv_TEXCOORD0.xy);
  diffuseTextureColor_1 = tmpvar_2;
  highp vec4 finalColor_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = ((Material.m_DiffuseColor * diffuseTextureColor_1) * AmbientLightColor);
  finalColor_3.xyz = tmpvar_4.xyz;
  finalColor_3.w = tmpvar_4.w;
  gl_FragData[0] = finalColor_3;
}

