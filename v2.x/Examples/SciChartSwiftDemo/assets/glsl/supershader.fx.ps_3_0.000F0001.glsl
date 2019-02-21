precision highp float;
struct MaterialInfo {
  highp vec4 m_DiffuseColor;
  highp vec4 m_SpecularColor;
  highp vec2 m_SpecularPowerBumpiness;
};
uniform highp vec3 CameraPosition;
uniform highp vec4 AmbientLightColor;
uniform MaterialInfo Material;
uniform highp mat4 Light0;
uniform sampler2D DiffuseTexture;
uniform sampler2D NormalTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec4 spec_1;
  highp vec4 diffuseTextureColor_2;
  highp vec4 baseColor_3;
  highp vec3 wsNormal_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD3);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(((tmpvar_6.yzx * tmpvar_5.zxy) - (tmpvar_6.zxy * tmpvar_5.yzx)));
  highp mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_6.x;
  tmpvar_8[0].y = tmpvar_7.x;
  tmpvar_8[0].z = tmpvar_5.x;
  tmpvar_8[1].x = tmpvar_6.y;
  tmpvar_8[1].y = tmpvar_7.y;
  tmpvar_8[1].z = tmpvar_5.y;
  tmpvar_8[2].x = tmpvar_6.z;
  tmpvar_8[2].y = tmpvar_7.z;
  tmpvar_8[2].z = tmpvar_5.z;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (DiffuseTexture, xlv_TEXCOORD0.xy);
  diffuseTextureColor_2 = tmpvar_9;
  baseColor_3 = (Material.m_DiffuseColor * diffuseTextureColor_2);
  baseColor_3 = (baseColor_3 * xlv_COLOR0);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (NormalTexture, xlv_TEXCOORD0.xy);
  highp vec4 _color_11;
  _color_11 = tmpvar_10;
  highp float tmpvar_12;
  tmpvar_12 = (_color_11.x * _color_11.w);
  highp vec3 tmpvar_13;
  tmpvar_13.x = tmpvar_12;
  tmpvar_13.y = _color_11.y;
  tmpvar_13.z = sqrt((1.0 - clamp (
    ((tmpvar_12 * tmpvar_12) - (_color_11.y * _color_11.y))
  , 0.0, 1.0)));
  wsNormal_4 = ((mix (vec3(0.5, 0.5, 1.0), tmpvar_13, Material.m_SpecularPowerBumpiness.yyy) * 2.0) - 1.0);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize((wsNormal_4 * tmpvar_8));
  wsNormal_4 = tmpvar_14;
  spec_1.xyz = Material.m_SpecularColor.xyz;
  spec_1.w = Material.m_SpecularPowerBumpiness.x;
  highp vec4 finalColor_15;
  highp vec4 tmpvar_16;
  tmpvar_16 = (baseColor_3 * AmbientLightColor);
  highp vec4 v_17;
  v_17.x = Light0[0].y;
  v_17.y = Light0[1].y;
  v_17.z = Light0[2].y;
  v_17.w = Light0[3].y;
  highp vec4 v_18;
  v_18.x = Light0[0].x;
  v_18.y = Light0[1].x;
  v_18.z = Light0[2].x;
  v_18.w = Light0[3].x;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(-(v_18.xyz));
  finalColor_15.xyz = (tmpvar_16 + ((
    (baseColor_3 * max (dot (tmpvar_14, tmpvar_19), 0.0))
   + 
    (spec_1 * pow (clamp (dot (
      (tmpvar_19 - (2.0 * (dot (tmpvar_14, tmpvar_19) * tmpvar_14)))
    , 
      -(normalize(normalize((CameraPosition - xlv_TEXCOORD1.xyz))))
    ), 0.0, 1.0), spec_1.w))
  ) * v_17)).xyz;
  finalColor_15.w = tmpvar_16.w;
  gl_FragData[0] = finalColor_15;
}

