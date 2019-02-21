precision highp float;
uniform sampler2D DiffuseTexture;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (DiffuseTexture, xlv_TEXCOORD0);
  highp vec4 tmpvar_2;
  tmpvar_2 = (xlv_COLOR0 * tmpvar_1);
  gl_FragData[0] = tmpvar_2;
}

