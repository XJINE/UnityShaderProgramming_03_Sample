#ifndef SAMPLE11PLIB_INCLUDED
#define SAMPLE11PLIB_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

struct v2f
{
    float4 vertex  : SV_POSITION;
    float3 vertexW : TEXCOORD0;
    float4 color   : TEXCOORD1;
};

float4 _MainColor;
float4 _SpecularColor;
float  _Shiness;

v2f vert(appdata_base v)
{
    v2f o;

    o.vertex  = UnityObjectToClipPos(v.vertex);
    o.vertexW = mul(unity_ObjectToWorld, v.vertex);

    float3 normal  = normalize(UnityObjectToWorldNormal(v.normal));
    float3 light   = normalize(_WorldSpaceLightPos0.w == 0 ?
                               _WorldSpaceLightPos0.xyz :
                               _WorldSpaceLightPos0.xyz - o.vertexW);
    float3 view    = normalize(_WorldSpaceCameraPos - o.vertexW);
    float3 rflt    = normalize(reflect(-light, normal));

    float  diffuse  = saturate(dot(normal, light));
    float  specular = pow(saturate(dot(view, rflt)), _Shiness);
    float3 ambient  = ShadeSH9(half4(normal, 1));

    o.color = diffuse * _MainColor * _LightColor0
            + specular * _SpecularColor * _LightColor0;

    o.color.rgb += ambient * _MainColor;

    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    UNITY_LIGHT_ATTENUATION(attenuation, i, i.vertexW)
    return i.color * attenuation;
}

#endif // SAMPLE11PLIB_INCLUDED