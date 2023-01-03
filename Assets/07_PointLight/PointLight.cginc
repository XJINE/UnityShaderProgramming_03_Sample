#ifndef POINTLIGHT_INCLUDED
#define POINTLIGHT_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"

struct v2f
{
    float4 vertex  : SV_POSITION;
    // ここでは新たにvertexWという変数を構造体の中に定義して
    // ワールド座標を保持させます
    // セマンティクスの重複を避けるために接尾辞の数字を変更しています
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
    // ここでワールド座標に変換している
    o.normal  = UnityObjectToWorldNormal(v.normal);

    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    // return fixed4(_WorldSpaceLightPos0.xyz, 1);

    float3 normal = normalize(i.normal);
    // ここでは平行光源と天光源を区別している
    // _WorldSpaceLightPosが0の場合は、平行光源を表します
    // 点光源の場合、光源ベクトルを任意に算出する必要があります。「光源の座標 - 頂点の座標」によって算出できます
    float3 light  = _WorldSpaceLightPos0.w == 0 ?
                    _WorldSpaceLightPos0.xyz :
                    _WorldSpaceLightPos0.xyz - i.vertexW;
    
    // 

    // 点光源は光源が最も明るく中心から離れるごとに減衰していきます。
    // 普通、光は距離の2乗に反比例して減衰するとされています。他には線形に減衰させたり、
    // 2乗と線形を組み合わせたりします。
    float range   = _PointLightRange;
    float llength = length(light);
          light   = normalize(light);

    // 線形で減衰していく処理
    float attenuation = saturate(lerp(1, 0, llength / range));

    // 2乗に反比例させて減衰させる処理
    // 分母が0にならないように1を足している。それらしい処理になる
          attenuation = 1 / (1 + llength * llength);

    // 照射範囲のrangeを考慮する反比例
          attenuation = saturate(lerp(1, 0, llength / range));
          attenuation = attenuation * attenuation;

    float  diffuse = saturate(dot(normal, light));
    float3 ambient = ShadeSH9(half4(normal, 1));

    fixed4 color = diffuse * _MainColor * _LightColor0 * attenuation;
           color.rgb += ambient * _MainColor;

    return color;
}

#endif // POINTLIGHT_INCLUDED