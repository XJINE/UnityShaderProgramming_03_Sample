#ifndef SAMPLE16LIB_INCLUDED
#define SAMPLE16LIB_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
#include "Assets/Common/BRDF.cginc"

struct v2f
{
    float4 vertex  : SV_POSITION;
    float3 vertexW : TEXCOORD0;
    float3 normal  : TEXCOORD1;
};

float4 _MainColor;
float4 _SpecularColor;
float  _Metallic;
float  _Roughness;
float  _Fresnel;

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
    UNITY_LIGHT_ATTENUATION(attenuation, i, i.vertexW)

    float3 normal = normalize(i.normal);
    float3 light  = normalize(_WorldSpaceLightPos0.w == 0 ?
                              _WorldSpaceLightPos0.xyz :
                              _WorldSpaceLightPos0.xyz - i.vertexW);
    float3 view   = normalize(_WorldSpaceCameraPos - i.vertexW);
    float3 hlf    = normalize(light + view);

    float dotNL = dot(normal, light);
    float dotNV = dot(normal, view);
    float dotNH = dot(normal, hlf);
    float dotVH = dot(view,   hlf);

    float dTerm = dTermBeckmann(dotNH, _Roughness);
    float gTerm = gTermTorrance(dotNL, dotNV, dotNH, dotVH);
    float fTerm = fresnelSchlick(dotNV, _Fresnel);

    float  diffuse  = saturate(dotNL);
    float  specular = saturate(dTerm * gTerm * fTerm / (dotNL * dotNV * 4) * dotNL);
    float3 ambient  = ShadeSH9(half4(normal, 1));

    fixed4 lightColor    = _LightColor0 * attenuation;
    fixed4 diffuseColor  = diffuse * _MainColor * lightColor;
    fixed4 specularColor = specular * _SpecularColor * lightColor;
    fixed4 ambientColor  = fixed4(0 ,0, 0, 1);

    #ifdef UNITY_PASS_FORWARDBASE

    float3 rflt = normalize(reflect(-view, normal));

    fixed4 diffuseColorI = _MainColor;
           diffuseColorI.rgb *= ambient;

    fixed specCubeLevel = UNITY_SPECCUBE_LOD_STEPS * _Roughness;

    fixed4 specularColorI = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, rflt, specCubeLevel);
           specularColorI.rgb = DecodeHDR(specularColorI, unity_SpecCube0_HDR);
           specularColorI.rgb *= _SpecularColor;

    ambientColor = lerp(diffuseColorI, specularColorI, _Metallic);
    ambientColor.rgb += ambient * _SpecularColor * fTerm * (1 - _Roughness);

    #endif // UNITY_PASS_FORWARDBASE

    fixed4 color = lerp(diffuseColor, specularColor, _Metallic) + ambientColor;

    return color;
}

#endif // SAMPLE16LIB_INCLUDED