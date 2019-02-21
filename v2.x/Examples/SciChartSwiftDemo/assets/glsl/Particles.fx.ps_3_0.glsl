precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform sampler2D DepthTexture;
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
  highp float fBufferDepth_4;
  highp vec4 ScreenCoord_5;
  ScreenCoord_5 = (((xlv_TEXCOORD5 / xlv_TEXCOORD5.w) * vec4(0.5, -0.5, 0.0, 1.0)) + vec4(0.5, 0.5, 0.0, 0.0));
  lowp float tmpvar_6;
  tmpvar_6 = texture2D (DepthTexture, ScreenCoord_5.xy).w;
  fBufferDepth_4 = tmpvar_6;
  if (((fBufferDepth_4 != 0.0) && (fBufferDepth_4 < xlv_TEXCOORD5.z))) {
    discard;
  };
  gl_FragData[0] = baseColor_2;
}

