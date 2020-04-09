Shader "Sample/Metalness"
{
    Properties
    {
        _MainColor     ("Main Color",     Color) = (1, 1, 1, 1)
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _Metalness     ("Metalness", Range(0, 1.0)) = 0
        _Roughness     ("Roughness", Range(0, 1.0)) = 0
        _Fresnel       ("Fresnel",   Range(0, 1.0)) = 0
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

            #include "Metalness.cginc"

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

            #include "Metalness.cginc"

            ENDCG
        }
    }
}