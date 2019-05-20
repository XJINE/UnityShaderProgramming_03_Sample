Shader "Sample/Sample12"
{
    Properties
    {
        _MainColor     ("Main Color",     Color) = (1, 1, 1, 1)
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _Shiness       ("Shiness", Range(0, 150)) = 0
        _Fresnel       ("Fresnel", Range(0, 1.0)) = 0
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

            #include "Sample12Lib.cginc"

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

            #pragma multi_compile_fwdadd
            #pragma vertex   vert
            #pragma fragment frag

            #include "Sample12Lib.cginc"

            ENDCG
        }
    }
}