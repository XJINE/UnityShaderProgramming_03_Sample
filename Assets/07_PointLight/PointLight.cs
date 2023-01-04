using UnityEngine;

[ExecuteAlways]
public class PointLight : MonoBehaviour
{
    // こっちの方がいいかも
    Light _light = default;

    private void Start()
    {
        _light = FindObjectOfType<Light>();
    }

    private void Update()
    {
        if (_light && _light.type == LightType.Point)
        {
            // 点光源のrangeをシェーダ上で使うために、グローバルな関数として
            // すべてのシェーダに共通のパラメータとして与えている。
            Shader.SetGlobalFloat("_PointLightRange", _light.range);

            // Unityには、_LightPositionRange や _unity_4LightAtten0 といった一見すると、点光源のパラメータ
            // を取得できるような組み込み変数も用意されています。ただし、これらは特定のタイミングでしか
            // 参照できないのでここでは活用できません。
        }
    }

    //void Update()
    //{
    //    Light light = GameObject.FindObjectOfType<Light>();

    //    if (light && light.type == LightType.Point)
    //    {
    //        // 点光源のrangeをシェーダ上で使うために、グローバルな関数として
    //        // すべてのシェーダに共通のパラメータとして与えている。
    //        Shader.SetGlobalFloat("_PointLightRange", light.range);

    //        // Unityには、_LightPositionRange や _unity_4LightAtten0 といった一見すると、点光源のパラメータ
    //        // を取得できるような組み込み変数も用意されています。ただし、これらは特定のタイミングでしか
    //        // 参照できないのでここでは活用できません。
    //    }
    //}
}