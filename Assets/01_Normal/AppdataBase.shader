Shader "Sample/AppdataBase"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex   vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // 法線は-1~1なので正規化を行い0~1の値に正規化している
                // これによってすべての面に色が付く
                return fixed4(i.normal * 0.5 + 0.5, 1);
            }

            ENDCG
        }
    }
}