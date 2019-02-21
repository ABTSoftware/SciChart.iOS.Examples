uniform highp mat4 matView;
uniform highp mat4 matProj;
uniform highp mat4 matWorldView;
uniform highp mat4 TexCoordsSizeMultMap;
attribute highp vec4 vPosition;
attribute highp vec2 vTexCoord0;
attribute highp vec4 vColor;
attribute highp vec4 vColor1;
attribute highp vec4 vColor2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD5;
varying highp vec4 xlv_COLOR1;
varying highp vec4 xlv_COLOR2;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 _pos_4;
  _pos_4.w = vPosition.w;
  highp vec3 tmpvar_5;
  tmpvar_5.x = matView[0].x;
  tmpvar_5.y = matView[0].y;
  tmpvar_5.z = matView[0].z;
  highp vec3 tmpvar_6;
  tmpvar_6.x = matView[1].x;
  tmpvar_6.y = matView[1].y;
  tmpvar_6.z = matView[1].z;
  highp int tmpvar_7;
  tmpvar_7 = int(vTexCoord0.x);
  highp vec4 v_8;
  v_8.x = TexCoordsSizeMultMap[0][tmpvar_7];
  v_8.y = TexCoordsSizeMultMap[1][tmpvar_7];
  v_8.z = TexCoordsSizeMultMap[2][tmpvar_7];
  v_8.w = TexCoordsSizeMultMap[3][tmpvar_7];
  highp vec4 v_9;
  v_9.x = TexCoordsSizeMultMap[0][tmpvar_7];
  v_9.y = TexCoordsSizeMultMap[1][tmpvar_7];
  v_9.z = TexCoordsSizeMultMap[2][tmpvar_7];
  v_9.w = TexCoordsSizeMultMap[3][tmpvar_7];
  highp vec2 tmpvar_10;
  tmpvar_10 = (v_9.zw * vTexCoord0.y);
  _pos_4.xyz = (vPosition.xyz + ((tmpvar_10.x * tmpvar_5) + (tmpvar_10.y * 
    -(tmpvar_6)
  )));
  tmpvar_1.xyz = _pos_4.xyz;
  tmpvar_1.w = 1.0;
  tmpvar_2 = (tmpvar_1 * (matWorldView * matProj));
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = v_8.xy;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_COLOR0 = vColor;
  xlv_TEXCOORD5 = tmpvar_2;
  xlv_COLOR1 = vColor1;
  xlv_COLOR2 = vColor2;
}

