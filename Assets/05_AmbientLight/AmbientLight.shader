Shader "Sample/AmbientLight"
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
            // Lithting.cgincをインクルードすることで光の色情報などを取得できる
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
                float3 normal = normalize(i.normal);
                float3 light  = normalize(_WorldSpaceLightPos0.xyz);

                float  diffuse = saturate(dot(normal, light));
                // Unityから環境光を参照する方法として、unity_AmbientSkyがあります
                // 設定した環境光をfloat4の色情報として取得します。
                float4 ambient = unity_AmbientSky;

                // 最終的な出力として拡散反射の色＋環境光を反射した色になります
                return diffuse * _MainColor * _LightColor0
                     + ambient * _MainColor;

                // もう一つ環境光を参照する方法として、ShadeSH9関数を使う方法があります。
                // 引数は法線でhalf4またはfloat4で指定します、戻り値はfloat3型なので注意が必要です。
                // 基本的にはShadeSH9関数を推奨する
                // 
                // float3 ambient = ShadeSH9(half4(normal, 1));
                // 
                // fixed4 color = diffuse * _MainColor * _LightColor0;
                //        color.rgb += ambient * _MainColor;
                // 
                // return color;
            }

            ENDCG
        }
    }
}