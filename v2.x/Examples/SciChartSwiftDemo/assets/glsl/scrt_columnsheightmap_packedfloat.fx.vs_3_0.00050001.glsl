uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
uniform highp vec4 PackedFloatParams;
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
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_3 * vec2(0.0033, 0.0033)) + vec2(0.5, 0.5));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2DLod (HeightMapTexture, tmpvar_4.xy, 0.0);
  highp float tmpvar_6;
  highp vec4 rgba_7;
  rgba_7 = tmpvar_5.zyxw;
  tmpvar_6 = ((dot (rgba_7.wzyx, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8)) * PackedFloatParams.y) + PackedFloatParams.x);
  tmpvar_1.y = (vPosition.y / matWorld[1].y);
  tmpvar_1.y = (tmpvar_1.y * abs(tmpvar_6));
  tmpvar_1.y = (tmpvar_1.y - (matWorld[1].w / matWorld[1].y));
  tmpvar_1.y = (tmpvar_1.y + ((tmpvar_6 * 0.5) / matWorld[1].y));
  tmpvar_1.w = 1.0;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = vTexCoord0;
  highp mat3 tmpvar_8;
  tmpvar_8[0] = matWorld[0].xyz;
  tmpvar_8[1] = matWorld[1].xyz;
  tmpvar_8[2] = matWorld[2].xyz;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_1 * matWorld);
  xlv_TEXCOORD2 = (vNormal * tmpvar_8);
}

