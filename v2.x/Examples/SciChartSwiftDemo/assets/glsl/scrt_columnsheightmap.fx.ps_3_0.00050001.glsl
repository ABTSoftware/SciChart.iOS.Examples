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
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
void main ()
{
  highp vec4 spec_1;
  highp vec4 diffuseTextureColor_2;
  highp vec4 baseColor_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize(xlv_TEXCOORD2);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (DiffuseTexture, xlv_TEXCOORD0.xy);
  diffuseTextureColor_2 = tmpvar_5;
  baseColor_3 = (Material.m_DiffuseColor * diffuseTextureColor_2);
  spec_1.xyz = Material.m_SpecularColor.xyz;
  spec_1.w = Material.m_SpecularPowerBumpiness.x;
  highp vec4 finalColor_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (baseColor_3 * AmbientLightColor);
  highp vec4 v_8;
  v_8.x = Light0[0].y;
  v_8.y = Light0[1].y;
  v_8.z = Light0[2].y;
  v_8.w = Light0[3].y;
  highp vec4 v_9;
  v_9.x = Light0[0].x;
  v_9.y = Light0[1].x;
  v_9.z = Light0[2].x;
  v_9.w = Light0[3].x;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize(-(v_9.xyz));
  finalColor_6.xyz = (tmpvar_7 + ((
    (baseColor_3 * max (dot (tmpvar_4, tmpvar_10), 0.0))
   + 
    (spec_1 * pow (clamp (dot (
      (tmpvar_10 - (2.0 * (dot (tmpvar_4, tmpvar_10) * tmpvar_4)))
    , 
      -(normalize(normalize((CameraPosition - xlv_TEXCOORD1.xyz))))
    ), 0.0, 1.0), spec_1.w))
  ) * v_8)).xyz;
  finalColor_6.w = tmpvar_7.w;
  gl_FragData[0] = finalColor_6;
}

