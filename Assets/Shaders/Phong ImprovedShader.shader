Shader "Unlit/Phong ImprovedShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gloss ("Gloss ", FLOAT) = 1.0
        _CubeMap ("Cube Map", CUBE) = "" {}
        _Fresnel ("Fresnel" , Range(0,2))  = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 clipSpace : TEXCOORD0;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float3 wps : TEXCOORD2;
                 float3 viewDir : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Gloss;
            samplerCUBE _CubeMap;
            int _Fresnel;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal= UnityObjectToWorldNormal( v.normal) ;
                o.wps = mul( unity_ObjectToWorld, v.vertex);
                o.clipSpace = TRANSFORM_TEX(v.uv, _MainTex);
                o.viewDir = normalize(UnityWorldSpaceViewDir(o.wps));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normals  = normalize(i.normal);
                float3 viewDirection = normalize(_WorldSpaceCameraPos - i.wps);


                //for handling cube mapping
                float3 reflectionVec = reflect(-viewDirection, normals);
                float4 cubeMapColor = texCUBE(_CubeMap, reflectionVec); // Sample from cube map using reflection vector
                // return float4(cubeMapColor.rgb,1);
                
                float3 direction_of_light = _WorldSpaceLightPos0.xyz;
                float3 lambert = saturate(dot(direction_of_light , normals) );
                float3 diffuseLight = lambert  * _LightColor0.xyz;
                float3 half = normalize( direction_of_light +viewDirection);
                // float3 reflectDirection = reflect(-direction_of_light , normals);// normla phong 
                float3 specularLight = saturate(dot( half, normals)) * (lambert>0); //blinn phing
                float specularexponent = exp2(_Gloss * 11)+1;
                float3 glossiness = pow (specularLight , specularexponent);//* _Gloss for the momentom of energy
                specularLight *= glossiness;
                float3 fesnel = 1 - dot (viewDirection,normals);
                // fixed4 col = tex2D(_MainTex, i.clipSpace);// for textures
                
                return float4(specularLight * diffuseLight + _Fresnel * fesnel,1 );
            }
            ENDCG
        }
    }
}
