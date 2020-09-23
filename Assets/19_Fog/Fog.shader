Shader "Sample/Fog"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1, 0, 0, 1)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex   vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;

                UNITY_FOG_COORDS(1)
            };

            float4 _MainColor;

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);

                UNITY_TRANSFER_FOG(o, o.vertex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = _MainColor;

                UNITY_APPLY_FOG(i.fogCoord, color);

                return color;
            }

            ENDCG
        }
    }
}