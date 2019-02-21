struct sGridParams {
  highp vec4 ContourScale;
  highp vec4 ContourOffset;
  highp vec4 ContourThickness;
  highp vec4 ContourColorX;
  highp vec4 ContourColorY;
  highp vec4 ContourColorZ;
  highp vec4 Params;
  highp vec4 SurfaceNormal;
};
uniform highp mat4 matProj;
uniform highp mat4 matWorld;
uniform highp mat4 matWorldView;
uniform sGridParams GridParams;
attribute highp vec4 vPosition;
attribute highp vec4 vTexCoord0;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp float xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD7;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1 = vPosition;
  tmpvar_2 = vTexCoord0;
  highp vec4 tmpvar_3;
  highp mat4 tmpvar_4;
  tmpvar_4 = (matWorldView * matProj);
  highp vec3 terrainNormal_5;
  terrainNormal_5 = vec3(0.0, 1.0, 0.0);
  if ((vTexCoord0.x > 0.999)) {
    terrainNormal_5 = vec3(1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.x < 0.001)) {
    terrainNormal_5 = vec3(-1.0, 0.0, 0.0);
  };
  if ((vTexCoord0.y > 0.999)) {
    terrainNormal_5 = vec3(0.0, 0.0, 1.0);
  };
  if ((vTexCoord0.y < 0.001)) {
    terrainNormal_5 = vec3(0.0, 0.0, -1.0);
  };
  highp mat3 tmpvar_6;
  tmpvar_6[0] = matWorld[0].xyz;
  tmpvar_6[1] = matWorld[1].xyz;
  tmpvar_6[2] = matWorld[2].xyz;
  tmpvar_2.xy = mix (vTexCoord0.xy, vTexCoord0.zw, GridParams.Params.ww);
  tmpvar_1.w = 1.0;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.xy = tmpvar_2.xy;
  gl_Position = (tmpvar_1 * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = vPosition;
  xlv_TEXCOORD2 = (terrainNormal_5 * tmpvar_6);
  xlv_TEXCOORD6 = sqrt(dot (vPosition.xyz, vPosition.xyz));
  xlv_TEXCOORD7 = tmpvar_2;
}

