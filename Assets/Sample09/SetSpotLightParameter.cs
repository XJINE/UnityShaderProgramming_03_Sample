using UnityEngine;

[ExecuteAlways]
public class SetSpotLightParameter : MonoBehaviour
{
    void Update()
    {
        Light light = GameObject.FindObjectOfType<Light>();

        if (light && light.type == LightType.Spot)
        {
            Vector3 direction = (light.transform.rotation * Vector3.forward).normalized;

            Shader.SetGlobalVector("_SpotLightParameter", new Vector4(light.range,
                                                                      light.spotAngle));
            Shader.SetGlobalVector("_SpotLightDirection", new Vector4(direction.x,
                                                                      direction.y,
                                                                      direction.z));
        }
    }
}