#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_texture2DLodEXT(lowp sampler2D sampler, highp vec2 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return texture2DLodEXT(sampler, coord, lod);
#else
	return texture2D(sampler, coord, lod);
#endif
}

precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform highp vec4 PackedFloatParams;
uniform sampler2D HeightMapTexture;
uniform MaterialInfo Material;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
void main ()
{
  highp vec4 diffuseTextureColor_1;
  highp vec4 baseColor_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = impl_low_texture2DLodEXT (HeightMapTexture, xlv_TEXCOORD0.xy, 0.0);
  highp vec4 rgba_4;
  rgba_4 = tmpvar_3.zyxw;
  highp vec2 tmpvar_5;
  tmpvar_5.y = 0.0;
  tmpvar_5.x = ((dot (rgba_4.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y) + PackedFloatParams.x);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (DiffuseTexture, tmpvar_5);
  diffuseTextureColor_1 = tmpvar_6;
  baseColor_2 = (Material.m_DiffuseColor * diffuseTextureColor_1);
  baseColor_2 = (baseColor_2 * xlv_COLOR0);
  gl_FragData[0] = baseColor_2;
}

