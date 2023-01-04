#ifndef VARIOUSLIGHT_INCLUDED
#define VARIOUSLIGHT_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"
// UNITY_LIGHT_ATTENUATIONは "AutoLighting.cginc" に定義されています 
#include "AutoLight.cginc"

struct v2f
{
    float4 vertex  : SV_POSITION;
    float3 vertexW : TEXCOORD0;
    float3 normal  : TEXCOORD1;
};

float4 _MainColor;

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
    // multi_compile_fwdaddを使用すると、あらゆる光源はUNITY_LIGHT_ATTENUATIONマクロから簡単に得られるようになる
    // Pointキーワードが有効の時は、点光源からの減衰が与えられる。その他のキーワードも同様に増減が与えられる
    // 第一引数は、マクロ呼び出し側での変数定義は不要です。
    UNITY_LIGHT_ATTENUATION(attenuation, i, i.vertexW)

    float3 normal = normalize(i.normal);
    // _WorldSpaceLightPos0.wを確認すると点光源か平行光源か識別することができる
    // スポットライトを識別する方法が2つある
    // ・UNITY_PASS_FORWARDBASEキーワードのように、Unityに定義されたSPOTやPOINTなどのキーワードの定義を使う
    // ・シェーダバリアントを作るmulti_compile_fwdaddを使う方法
    // 後者を使用するとキーワードが内部で使用され、全ての光源を考慮できる
    // 特に理由がなければ、これを使う
    float3 light  = normalize(_WorldSpaceLightPos0.w == 0 ?
                              _WorldSpaceLightPos0.xyz :
                              _WorldSpaceLightPos0.xyz - i.vertexW);

    float  diffuse = saturate(dot(normal, light));
    float3 ambient = ShadeSH9(half4(normal, 1));

    fixed4 color = diffuse * _MainColor * _LightColor0 * attenuation;
           color.rgb += ambient * _MainColor;

    return color;
}

#endif // VARIOUSLIGHT_INCLUDED