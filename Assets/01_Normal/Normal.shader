Shader "Sample/Normal"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex   vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                // 法線はVertexシェーダの入力として、レンダリングパイプラインから受け取ることができる
                // 型はfloat3で、NORMALというキーワードでセマンティクスする。
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                // Flagmentシェーダでも、法線を参照したいためnormalを定義しているが
                // FlagmentシェーダにはNORMALというセマンティクスがないため
                // 任意の値を指定するTEXCOORDを使用している
                float3 normal : TEXCOORD0;
            };

            // 法線情報は、ラスタライズ処理によって補完がなされています。
            // スフィアやバニーなどは本来の法線はピクセルの継ぎ目などで色が変わり角ばった表現になります

            v2f vert(appdata v)
            {
                v2f o;

                // Vertexシェーダの入力はすべてオブジェクト座標です。
                o.vertex = UnityObjectToClipPos(v.vertex);
                // 法線も例外ではないため、ワールド空間の法線に変換している
                // 内部的にはベクトルを変換するベクトルを回転する行列演算を行っている
                o.normal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // i.normal = i.normal / 2 + 0.5;
                // 出力としてRGBをnormalのXYZに置き換えている
                return fixed4(i.normal, 1);
            }

            ENDCG
        }
    }
}