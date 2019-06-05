#ifndef SAMPLE08LIB_INCLUDED
#define SAMPLE08LIB_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"

struct v2f
{
    float4 vertex  : SV_POSITION;
    float3 vertexW : TEXCOORD0;
    float3 normal  : TEXCOORD1;
};

float4 _MainColor;
float  _PointLightRange;

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
    // return fixed4(_WorldSpaceLightPos0.xyz, 1);

    float3 normal = normalize(i.normal);
    float3 light  = _WorldSpaceLightPos0.w == 0 ?
                    _WorldSpaceLightPos0.xyz :
                    _WorldSpaceLightPos0.xyz - i.vertexW;

    float range   = _PointLightRange;
    float llength = length(light);
          light   = normalize(light);

    float attenuation = saturate(lerp(1, 0, llength / range));

          attenuation = 1 / (1 + llength * llength);

          attenuation = saturate(lerp(1, 0, llength / range));
          attenuation = attenuation * attenuation;

    float  diffuse = saturate(dot(normal, light));
    float3 ambient = ShadeSH9(half4(normal, 1));

    fixed4 color = diffuse * _MainColor * _LightColor0 * attenuation;
           color.rgb += ambient * _MainColor;

    return color;
}

#endif // SAMPLE08LIB_INCLUDED