using UnityEngine;

[ExecuteAlways]
public class PointLight : MonoBehaviour
{
    void Update()
    {
        Light light = GameObject.FindObjectOfType<Light>();

        if (light && light.type == LightType.Point)
        {
            Shader.SetGlobalFloat("_PointLightRange", light.range);
        }
    }
}