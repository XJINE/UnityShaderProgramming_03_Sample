#ifndef SAMPLE09BLIB_INCLUDED
#define SAMPLE09BLIB_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"

struct v2f
{
    float4 vertex  : SV_POSITION;
    float3 vertexW : TEXCOORD0;
    float3 normal  : TEXCOORD1;
};

float4 _MainColor;
float4 _SpotLightParameter;
float4 _SpotLightDirection;

v2f vert(appdata_base v)
{
    v2f o;

    o.vertex  = UnityObjectToClipPos(v.vertex);
    o.vertexW = mul(unity_ObjectToWorld, v.vertex);
    o.normal  = UnityObjectToWorldNormal(v.normal);

    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    float3 normal = normalize(i.normal);
    float3 light  = _WorldSpaceLightPos0.w == 0 ?
                    _WorldSpaceLightPos0.xyz :
                    _WorldSpaceLightPos0.xyz - i.vertexW;

    float3 ldirection = normalize(_SpotLightDirection);
    float  llength    = length(light);
           light      = normalize(light);
    float  range      = _SpotLightParameter.x;
    float  angleO     = _SpotLightParameter.y / 2;
    float  angleI     = angleO * 0.8;
           angleO     = cos(angleO * UNITY_PI / 180);
           angleI     = cos(angleI * UNITY_PI / 180);
    float  angle      = dot(light, -ldirection);

    float  attenuation = angle > angleO ? 1 : 0;
           attenuation *= saturate(lerp(1, 0, llength / range));
           attenuation *= attenuation;
           attenuation *= angle < angleI ?
                         (angle - angleO) / (angleI - angleO) : 1;

    float  diffuse = saturate(dot(normal, normalize(light)));
    float3 ambient = ShadeSH9(half4(normal, 1));

    fixed4 color = diffuse * _MainColor * _LightColor0 * attenuation;
           color.rgb += ambient * _MainColor;

    return color;
}

#endif // SAMPLE09BLIB_INCLUDED