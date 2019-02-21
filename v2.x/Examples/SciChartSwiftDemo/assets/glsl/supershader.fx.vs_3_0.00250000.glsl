uniform highp mat4 matView;
uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matBindSkinTransform;
uniform highp mat4 matSkinningTransforms[24];
attribute highp vec4 vPosition;
attribute highp vec4 vBlendIndices;
attribute highp vec4 vBlendWeights;
attribute highp vec3 vNormal;
attribute highp vec2 vTexCoord0;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = vPosition.xyz;
  highp mat4 vMatWorld_2;
  highp vec4 tmpvar_3;
  tmpvar_1.w = 1.0;
  vMatWorld_2 = mat4(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
  vMatWorld_2 = (vMatWorld_2 + (matSkinningTransforms[int(vBlendIndices.x)] * vBlendWeights.x));
  vMatWorld_2 = (vMatWorld_2 + (matSkinningTransforms[int(vBlendIndices.y)] * vBlendWeights.y));
  vMatWorld_2 = (vMatWorld_2 + (matSkinningTransforms[int(vBlendIndices.z)] * vBlendWeights.z));
  vMatWorld_2 = (vMatWorld_2 + (matSkinningTransforms[int(vBlendIndices.w)] * vBlendWeights.w));
  vMatWorld_2 = (vMatWorld_2 * matWorld);
  vMatWorld_2 = (matBindSkinTransform * vMatWorld_2);
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = vTexCoord0;
  highp mat3 tmpvar_4;
  tmpvar_4[0] = vMatWorld_2[0].xyz;
  tmpvar_4[1] = vMatWorld_2[1].xyz;
  tmpvar_4[2] = vMatWorld_2[2].xyz;
  gl_Position = (tmpvar_1 * ((vMatWorld_2 * matView) * matProj));
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_1 * vMatWorld_2);
  xlv_TEXCOORD2 = (vNormal * tmpvar_4);
}

