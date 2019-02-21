precision highp float;
uniform sampler2D DiffuseTexture;
uniform sampler2D BrushTexture;
varying highp vec4 xlv_TEXCOORD5;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 finalColor_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (DiffuseTexture, xlv_TEXCOORD0);
  highp vec2 tmpvar_3;
  tmpvar_3 = (0.5 * (xlv_TEXCOORD5.xy + vec2(1.0, 1.0)));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (BrushTexture, tmpvar_3);
  finalColor_1 = ((xlv_COLOR0 * tmpvar_2) * tmpvar_4);
  gl_FragData[0] = finalColor_1;
}

