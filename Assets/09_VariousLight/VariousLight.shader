Shader "Sample/VariousLight"
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

            #include "VariousLight.cginc"

            ENDCG
        }

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            Blend One One

            CGPROGRAM

            // multi_compile_fwdaddは、multi_compile DIRECTIONAL POINT SPOT... のショートカットです
            // これによって各光源に対応するキーワードが有効なシェーダがコンパイルされる
            #pragma multi_compile_fwdadd
            #pragma vertex   vert
            #pragma fragment frag

            #include "VariousLight.cginc"

            ENDCG
        }
    }
}