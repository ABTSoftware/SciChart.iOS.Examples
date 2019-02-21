uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
attribute highp vec4 vPosition;
attribute highp vec3 vNormal;
attribute highp vec2 vTexCoord0;
attribute highp vec3 vTangent;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = vPosition.xyz;
  highp vec4 tmpvar_2;
  tmpvar_1.w = 1.0;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vTexCoord0;
  highp mat3 tmpvar_3;
  tmpvar_3[0] = matWorld[0].xyz;
  tmpvar_3[1] = matWorld[1].xyz;
  tmpvar_3[2] = matWorld[2].xyz;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_1 * matWorld);
  xlv_TEXCOORD2 = (vNormal * tmpvar_3);
  xlv_TEXCOORD3 = (vTangent * tmpvar_3);
}

