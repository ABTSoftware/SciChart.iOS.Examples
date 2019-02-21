precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform highp vec3 CameraPosition;
uniform MaterialInfo Material;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 diffuseTextureColor_1;
  highp vec4 baseColor_2;
  highp vec4 finalColor_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (DiffuseTexture, xlv_TEXCOORD0.xy);
  diffuseTextureColor_1 = tmpvar_4;
  baseColor_2 = (Material.m_DiffuseColor * diffuseTextureColor_1);
  baseColor_2 = (baseColor_2 * xlv_COLOR0);
  finalColor_3.w = (1.0 - dot (normalize(
    (CameraPosition - xlv_TEXCOORD1.xyz)
  ), normalize(xlv_TEXCOORD2)));
  finalColor_3.xyz = baseColor_2.xyz;
  gl_FragData[0] = finalColor_3;
}

