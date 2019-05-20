﻿Shader "Sample/Sample16"
{
    Properties
    {
        [NoScaleOffset] _MainTex      ("Texture",    2D) = "white" {}
        [NoScaleOffset] _OcclusionTex ("Occulusion", 2D) = "white" {}
        _MainColor     ("Main Color",     Color) = (1, 1, 1, 1)
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _Metallic      ("Metallic",  Range(0, 1.0)) = 0
        _Roughness     ("Roughness", Range(0, 1.0)) = 0
        _Fresnel       ("Fresnel",   Range(0, 1.0)) = 0
        _Occlusion     ("Occlusion", Range(0, 5.0)) = 0
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

            #include "Sample16Lib.cginc"

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

            #include "Sample16Lib.cginc"

            ENDCG
        }
    }
}