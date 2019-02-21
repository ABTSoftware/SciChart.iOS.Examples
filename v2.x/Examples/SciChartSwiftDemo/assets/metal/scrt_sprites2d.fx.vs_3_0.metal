#include <metal_stdlib>
#pragma clang diagnostic ignored "-Wparentheses-equality"
using namespace metal;
struct xlatMtlShaderInput {
  float4 vPosition [[attribute(0)]];
  float2 vTexCoord0 [[attribute(1)]];
  float4 vColor [[attribute(2)]];
};
struct xlatMtlShaderOutput {
  float4 gl_Position [[position]];
  float4 xlv_TEXCOORD0;
  float4 xlv_COLOR0;
};
struct xlatMtlShaderUniform {
  float4x4 matProj;
  float4x4 matWorldView;
};
vertex xlatMtlShaderOutput scrt_sprites2d_fx_vs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]])
{
  xlatMtlShaderOutput _mtl_o;
  float4 tmpvar_1 = 0;
  tmpvar_1.xyz = _mtl_i.vPosition.xyz;
  float4 tmpvar_2 = 0;
  float4 tmpvar_3 = 0;
  tmpvar_1.w = 1.0;
  tmpvar_2 = (tmpvar_1 * (_mtl_u.matWorldView * _mtl_u.matProj));
  tmpvar_3.zw = float2(0.0, 0.0);
  tmpvar_3.xy = _mtl_i.vTexCoord0;
  tmpvar_2.y = -(tmpvar_2.y);
  _mtl_o.gl_Position = tmpvar_2;
  _mtl_o.xlv_TEXCOORD0 = tmpvar_3;
  _mtl_o.xlv_COLOR0 = _mtl_i.vColor;
  return _mtl_o;
}

