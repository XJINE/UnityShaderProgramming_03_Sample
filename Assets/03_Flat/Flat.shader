Shader "Sample/Flat"
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

            struct v2f
            {
                                float4 vertex : SV_POSITION;
                // 球面などの法線の補完を任意的に無効化したい場合は、nointerpolation修飾子を使用する
                // この画素単位で法線を補完する手法を「Phong補完」と呼び、
                // この補完を使用したシェーディングを「Phongシェーディング」と呼ぶ。
                // 逆に補完しないシェーディングを「Flatシェーディング」あるいは
                // 「Constantシェーディング」と呼ぶ。
                // ローポリ風の表現をしたい際に使える
                nointerpolation float3 normal : TEXCOORD0;
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
                float3 normal = normalize(i.normal);
                float3 light  = normalize(_WorldSpaceLightPos0.xyz);

                float diffuse = saturate(dot(normal, light));

                return diffuse * _MainColor;
            }

            ENDCG
        }
    }
}