precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform MaterialInfo Material;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  highp vec4 diffuseTextureColor_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (DiffuseTexture, xlv_TEXCOORD0.xy);
  diffuseTextureColor_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (Material.m_DiffuseColor * diffuseTextureColor_1);
  gl_FragData[0] = tmpvar_3;
}

