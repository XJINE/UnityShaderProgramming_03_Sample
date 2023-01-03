Shader "Sample/HalfLambert"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM

            #pragma vertex   vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            float4 _MainColor;

            v2f vert(appdata_base v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Lambertシェーディングでは、環境光を考慮しないなので影が著しく黒くなる
                // その問題を解決する方法としてHalf-Lambertシェーディングがあります。
                // 環境光のパラメータは持ちませんが、影になる部分をわずかに明るくします

                float3 normal = normalize(i.normal);
                float3 light  = normalize(_WorldSpaceLightPos0.xyz);

                float diffuse = saturate(dot(normal, light));
                // cosθの値に0.5を乗算して0.5を足して2乗して影を明るくしている。
                      diffuse = pow(diffuse * 0.5 + 0.5, 2);

                return diffuse * _MainColor * _LightColor0;
            }

            ENDCG
        }
    }
}