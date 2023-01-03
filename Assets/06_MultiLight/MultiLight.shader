Shader "Sample/MultiLight"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        // このパスは1つ目の光源で行われるPass
        // 基本的に一つの光源にひとつのPass
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
                float3 normal = normalize(i.normal);
                float3 light  = normalize(_WorldSpaceLightPos0.xyz);

                float  diffuse = saturate(dot(normal, light));
                // 最初に行われるPassでのみ環境光を加算する
                // そのため環境光のためのPassは存在しない
                float3 ambient = ShadeSH9(half4(normal, 1));

                fixed4 color = diffuse * _MainColor * _LightColor0;
                       color.rgb += ambient * _MainColor;

                return color;
            }

            ENDCG
        }

        // このパスは2つ目以降の光源がある際に行われるPass
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            // 光は当てた分だけ明るくなるのでBlendは加算にする
            Blend One One

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
                float3 normal = normalize(i.normal);
                float3 light  = normalize(_WorldSpaceLightPos0.xyz);

                float  diffuse = saturate(dot(normal, light));
                // float3 ambient = ShadeSH9(half4(normal, 1));

                fixed4 color = diffuse * _MainColor * _LightColor0;
                // color.rgb += ambient * _MainColor;

                return color;
            }

            ENDCG
        }
    }
}