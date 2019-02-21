precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform sampler2D BrushTexture;
uniform MaterialInfo Material;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD5;
void main ()
{
  highp vec4 diffuseTextureColor_1;
  highp vec4 baseColor_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (DiffuseTexture, xlv_TEXCOORD0.xy);
  diffuseTextureColor_1 = tmpvar_3;
  baseColor_2 = (Material.m_DiffuseColor * diffuseTextureColor_1);
  baseColor_2 = (baseColor_2 * xlv_COLOR0);
  highp vec2 tmpvar_4;
  tmpvar_4 = (0.5 * (xlv_TEXCOORD5.xy + vec2(1.0, 1.0)));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (BrushTexture, tmpvar_4);
  highp vec4 tmpvar_6;
  tmpvar_6 = (baseColor_2 * tmpvar_5);
  gl_FragData[0] = tmpvar_6;
}

