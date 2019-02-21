uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
uniform sampler2D HeightMapTexture;
attribute highp vec4 vPosition;
attribute highp vec3 vNormal;
attribute highp vec2 vTexCoord0;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xzw = vPosition.xzw;
  highp vec4 tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = matWorld[0].w;
  tmpvar_3.y = matWorld[2].w;
  highp float tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3 * vec2(0.0033, 0.0033)) + vec2(0.5, 0.5));
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DLod (HeightMapTexture, tmpvar_5.xy, 0.0);
  tmpvar_4 = tmpvar_6.w;
  tmpvar_1.y = (vPosition.y / matWorld[1].y);
  tmpvar_1.y = (tmpvar_1.y * abs(tmpvar_4));
  tmpvar_1.y = (tmpvar_1.y - (matWorld[1].w / matWorld[1].y));
  tmpvar_1.y = (tmpvar_1.y + ((tmpvar_4 * 0.5) / matWorld[1].y));
  tmpvar_1.w = 1.0;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vTexCoord0;
  highp mat3 tmpvar_7;
  tmpvar_7[0] = matWorld[0].xyz;
  tmpvar_7[1] = matWorld[1].xyz;
  tmpvar_7[2] = matWorld[2].xyz;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_1 * matWorld);
  xlv_TEXCOORD2 = (vNormal * tmpvar_7);
}

