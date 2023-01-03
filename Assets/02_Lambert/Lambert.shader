Shader "Sample/Lambert"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Pass
        {
            // おおよそ反射光には2パターンあり、「鏡面反射光」と「拡散反射光」があります
            // 「鏡面反射光」金属や鏡のように光を入射角と同じ角度で反射し、わずかに反射方向が変わるものもある
            // 「拡散反射光」物体の表面に光が侵入した際に散乱し、あらゆる方向に均等に放射される

            Tags
            {
                // Tagsを次のように変更すると、フォワードレンダリングに対応するシェーダになります
                // Unity固有のものであり、光源を考慮したレンダリングする最も基本的な実装をする際に設定する
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM

            #pragma vertex   vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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
                // ここではDirectional Lightだけが置かれているので、その光の向き(光線ベクトル)を取得します
                // _WorldSpaceLightPos0.xyzは光線ベクトルを取得しています
                float3 light  = normalize(_WorldSpaceLightPos0.xyz);
                // オブジェクトのピクセルが向いてる法線と光の方向を内積し、そこの光の反射を計算する
                // 単位ベクトルどうしの内積の結果はcosθとなるため、saturateを使用して0以下の値を0にする
                float diffuse = saturate(dot(normal, light));

                return diffuse * _MainColor;
            }

            // このようにLambertの余弦則を使って拡散反射を表現するシェーダを「Lanbartシェーダ」と呼ぶ

            ENDCG
        }
    }
}