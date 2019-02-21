#include <metal_stdlib>
#pragma clang diagnostic ignored "-Wparentheses-equality"
using namespace metal;
struct MaterialInfo {
  float4 m_DiffuseColor;
  float4 m_SpecularColor;
  float2 m_SpecularPowerBumpiness;
};
struct xlatMtlShaderInput {
  float4 xlv_TEXCOORD0;
  float4 xlv_COLOR0;
};
struct xlatMtlShaderOutput { 
  half4 gl_FragData_0;
};
struct xlatMtlShaderUniform {
  MaterialInfo Material;
};
fragment xlatMtlShaderOutput scrt_sprites2d_fx_ps (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]]
  ,   texture2d<float> DiffuseTexture [[texture(0)]], sampler _mtlsmp_DiffuseTexture [[sampler(0)]])
{
  xlatMtlShaderOutput _mtl_o;
  half4 baseColor_1 = 0;
  half4 tmpvar_2 = 0;
  tmpvar_2 = half4(DiffuseTexture.sample(_mtlsmp_DiffuseTexture, (float2)(_mtl_i.xlv_TEXCOORD0.xy)));
  baseColor_1 = ((half4)(_mtl_u.Material.m_DiffuseColor) * tmpvar_2);
  baseColor_1 = ((half4)((float4)(baseColor_1) * _mtl_i.xlv_COLOR0));
  _mtl_o.gl_FragData_0 = ( half4 )  baseColor_1;
  return _mtl_o;
}

