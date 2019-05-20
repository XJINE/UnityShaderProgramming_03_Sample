Shader "Sample/Sample03B"
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
                float4 color  : TEXCOORD0;
            };

            float4 _MainColor;

            v2f vert(appdata_base v)
            {
                float3 normal = normalize(UnityObjectToWorldNormal(v.normal));
                float3 light  = normalize(_WorldSpaceLightPos0.xyz);

                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color  = saturate(dot(normal, light)) * _MainColor;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return i.color;
            }

            ENDCG
        }
    }
}