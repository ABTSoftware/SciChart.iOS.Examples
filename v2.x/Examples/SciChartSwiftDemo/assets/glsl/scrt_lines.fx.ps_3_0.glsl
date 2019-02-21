precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform MaterialInfo Material;
varying highp vec4 xlv_COLOR0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (xlv_COLOR0 * Material.m_DiffuseColor);
  gl_FragData[0] = tmpvar_1;
}

