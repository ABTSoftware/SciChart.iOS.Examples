precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform MaterialInfo Material;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.xyz = xlv_COLOR0.xyz;
  tmpvar_2.w = (xlv_COLOR0.w * min ((
    abs((0.5 - abs((0.5 - xlv_TEXCOORD0.y))))
   / xlv_TEXCOORD0.x), 1.0));
  tmpvar_1 = (tmpvar_2 * Material.m_DiffuseColor);
  gl_FragData[0] = tmpvar_1;
}

