#include <metal_stdlib>
#pragma clang diagnostic ignored "-Wparentheses-equality"
using namespace metal;
struct xlatMtlShaderInput {
  float4 vPosition [[attribute(0)]];
  float2 vTexCoord0 [[attribute(1)]];
  float4 vColor [[attribute(2)]];
  float4 vTexCoord1 [[attribute(3)]];
};
struct xlatMtlShaderOutput {
  float4 gl_Position [[position]];
  float4 xlv_TEXCOORD0;
  float4 xlv_COLOR0;
};
struct xlatMtlShaderUniform {
  float4x4 matProj;
  float4x4 matWorldView;
  float4x4 TexCoordsSizeMultMap;
};
vertex xlatMtlShaderOutput scrt_sprites2d_fx_10000000_vs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]])
{
  xlatMtlShaderOutput _mtl_o;
  float4 tmpvar_1 = 0;
  float4 tmpvar_2 = 0;
  float4 tmpvar_3 = 0;
  int tmpvar_4 = 0;
  tmpvar_4 = int(_mtl_i.vTexCoord1.x);
  float4 v_5 = 0;
  v_5.x = _mtl_u.TexCoordsSizeMultMap[0][tmpvar_4];
  v_5.y = _mtl_u.TexCoordsSizeMultMap[1][tmpvar_4];
  v_5.z = _mtl_u.TexCoordsSizeMultMap[2][tmpvar_4];
  v_5.w = _mtl_u.TexCoordsSizeMultMap[3][tmpvar_4];
  float4 v_6 = 0;
  v_6.x = _mtl_u.TexCoordsSizeMultMap[0][tmpvar_4];
  v_6.y = _mtl_u.TexCoordsSizeMultMap[1][tmpvar_4];
  v_6.z = _mtl_u.TexCoordsSizeMultMap[2][tmpvar_4];
  v_6.w = _mtl_u.TexCoordsSizeMultMap[3][tmpvar_4];
  float2 tmpvar_7 = 0;
  tmpvar_7 = (v_6.xy * (_mtl_i.vTexCoord0 - _mtl_i.vPosition.xy));
  float4 tmpvar_8 = 0;
  tmpvar_8.zw = float2(0.0, 1.0);
  tmpvar_8.xy = (_mtl_i.vPosition.xy + ((tmpvar_7.x * float2(1.0, 0.0)) + (tmpvar_7.y * float2(0.0, 1.0))));
  float2 tmpvar_9 = 0;
  tmpvar_9.x = v_5.x;
  tmpvar_9.y = (1.0 - v_5.y);
  tmpvar_1.xyz = tmpvar_8.xyz;
  tmpvar_1.w = 1.0;
  tmpvar_2 = (tmpvar_1 * (_mtl_u.matWorldView * _mtl_u.matProj));
  tmpvar_3.zw = float2(0.0, 0.0);
  tmpvar_3.xy = tmpvar_9;
  tmpvar_2.y = -(tmpvar_2.y);
  _mtl_o.gl_Position = tmpvar_2;
  _mtl_o.xlv_TEXCOORD0 = tmpvar_3;
  _mtl_o.xlv_COLOR0 = _mtl_i.vColor;
  return _mtl_o;
}

