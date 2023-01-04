using UnityEngine;

[ExecuteAlways]
public class SpotLight : MonoBehaviour
{
    // こっちの方がよさげ
    Light _light = default;

    private void Start()
    {
        _light = FindObjectOfType<Light>();
    }

    void Update()
    {
        if (_light && _light.type == LightType.Spot)
        {
            // スポットライトを構成するパラメータは、光の届く範囲を表す range と、
            // スポットライトの大きさを表す angle の2つです
            // unity_SpotDirection などのパラメータは用意されているが、
            // 現在のところこれを参照しても値は常に0になります。
            Vector3 direction = (_light.transform.rotation * Vector3.forward).normalized;

            Shader.SetGlobalVector("_SpotLightParameter", new Vector4(_light.range,
                                                                      _light.spotAngle));
            Shader.SetGlobalVector("_SpotLightDirection", new Vector4(direction.x,
                                                                      direction.y,
                                                                      direction.z));
        }
    }
    //void Update()
    //{
    //    Light light = GameObject.FindObjectOfType<Light>();

    //    if (light && light.type == LightType.Spot)
    //    {
    //        Vector3 direction = (light.transform.rotation * Vector3.forward).normalized;

    //        Shader.SetGlobalVector("_SpotLightParameter", new Vector4(light.range,
    //                                                                  light.spotAngle));
    //        Shader.SetGlobalVector("_SpotLightDirection", new Vector4(direction.x,
    //                                                                  direction.y,
    //                                                                  direction.z));
    //    }
    //}
}