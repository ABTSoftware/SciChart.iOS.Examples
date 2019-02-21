precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform MaterialInfo Material;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
void main ()
{
  highp vec4 diffuseTextureColor_1;
  highp vec4 baseColor_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (DiffuseTexture, xlv_TEXCOORD0.xy);
  diffuseTextureColor_1 = tmpvar_3;
  baseColor_2 = (Material.m_DiffuseColor * diffuseTextureColor_1);
  highp float tmpvar_4;
  tmpvar_4 = clamp (((baseColor_2.w - 0.25) / 0.5), 0.0, 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5.xyz = vec3(1.0, 1.0, 1.0);
  tmpvar_5.w = (tmpvar_4 * (tmpvar_4 * (3.0 - 
    (2.0 * tmpvar_4)
  )));
  baseColor_2 = (tmpvar_5 * xlv_COLOR0);
  gl_FragData[0] = baseColor_2;
}

