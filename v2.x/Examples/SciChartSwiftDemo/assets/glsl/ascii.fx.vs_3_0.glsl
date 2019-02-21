uniform highp mat4 matProj;
uniform highp mat4 matWorldView;
uniform highp mat4 TexCoordsPosDeltaMap;
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec2 resTexCoord_3;
  highp int tmpvar_4;
  tmpvar_4 = int(vTexCoord0.x);
  highp int tmpvar_5;
  tmpvar_5 = int(vTexCoord0.y);
  resTexCoord_3.x = ((float(mod (float(tmpvar_4), 16.0))) / 16.0);
  resTexCoord_3.y = (float((tmpvar_4 / 16)) / 16.0);
  highp vec4 v_6;
  v_6.x = TexCoordsPosDeltaMap[0][tmpvar_5];
  v_6.y = TexCoordsPosDeltaMap[1][tmpvar_5];
  v_6.z = TexCoordsPosDeltaMap[2][tmpvar_5];
  v_6.w = TexCoordsPosDeltaMap[3][tmpvar_5];
  resTexCoord_3 = (resTexCoord_3 + (0.0625 * v_6.xy));
  highp vec4 _position_7;
  _position_7.z = vPosition.z;
  highp vec4 v_8;
  v_8.x = TexCoordsPosDeltaMap[0][tmpvar_5];
  v_8.y = TexCoordsPosDeltaMap[1][tmpvar_5];
  v_8.z = TexCoordsPosDeltaMap[2][tmpvar_5];
  v_8.w = TexCoordsPosDeltaMap[3][tmpvar_5];
  _position_7.xy = (vPosition.xy + (vPosition.w * v_8.zw));
  _position_7.w = 1.0;
  tmpvar_1.xyz = _position_7.xyz;
  tmpvar_1.w = 1.0;
  tmpvar_2.zw = vec2(0.0, 0.0);
  tmpvar_2.xy = resTexCoord_3;
  gl_Position = (tmpvar_1 * (matWorldView * matProj));
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = vColor;
}

