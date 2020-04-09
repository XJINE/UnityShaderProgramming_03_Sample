#ifndef SPOTLIGHT_INCLUDED
#define SPOTLIGHT_INCLUDED

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
    float  angle      = _SpotLightParameter.y;
           angle      = cos(angle / 2 * UNITY_PI / 180);

    float  attenuation = dot(light, -ldirection) > angle ? 1 : 0;
           attenuation *= saturate(lerp(1, 0, llength / range));
           attenuation *= attenuation;

    float  diffuse = saturate(dot(normal, normalize(light)));
    float3 ambient = ShadeSH9(half4(normal, 1));

    fixed4 color = diffuse * _MainColor * _LightColor0 * attenuation;
           color.rgb += ambient * _MainColor;

    return color;
}

#endif // SPOTLIGHT_INCLUDED