Shader "Unlit/PhongShader"
{
    Properties
    {
        _Color  ("Color", Color) = (1,1,1,0)
        _MainTex ("Texture", 2D) = "white" {}
        _Gloss ("Gloss", Float) = 1
        _DiffuseStep ("DiffusetStep", Float) = .1       
        _SpecularStep ("SpecularStep", Float) = .01

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
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4  vertex_color : COLOR;
                
                float uv1 : TEXCOORD1;
            };

            struct vertexOutput
            {
                float2 clipSpace : TEXCOORD0;
                // UNITY_FOG_COORDS(1)
                float3 normal : TEXCOORD1;
                float3 world_pos :  TEXCOORD2 ;
                float4 vertex : SV_POSITION;
            };

            float4 _Color;
            float _Gloss;
            sampler2D _MainTex;
            float _DiffuseStep;
            float4 _MainTex_ST;
            float _SpecularStep;

            vertexOutput vert (appdata v)
            {
                vertexOutput o;
                o.clipSpace = v.uv;
                o.normal = v.normal;
                o.world_pos = mul( unity_ObjectToWorld, v.vertex);                                     
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.clipSpace = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (vertexOutput i) : SV_Target
            {
                // sample the texture
                // float3  dir_light  =  float3(1 , 1 , 1);
                //Lighting
                // float3  light_color = float3( .9 , .8 , .76);   now let's use the scences color using of the libraries Autolight or Light
                float3 normals = normalize(i.normal);
                float3  light_color = _LightColor0;
                float3 direction_of_light = _WorldSpaceLightPos0; 
                float3  ambiant_color = float3(.1,.1,.1);
                float3  light_fall_off = dot( normalize(direction_of_light) , normals);
                // to  handle the normal negative values     
                // light_fall_off = (light_fall_off + 1)/2;
                light_fall_off = max(light_fall_off, 0 );
                light_fall_off = step(_DiffuseStep , light_fall_off ) ;
                float3 direct_diffuse_light = light_fall_off * light_color.rgb;
                float3  diffuse_light = direct_diffuse_light + ambiant_color;

                float3 cam_dir  = normalize(_WorldSpaceCameraPos -   i.world_pos);
                float3 cam_refelect = reflect(-cam_dir ,normals);
                float3 specular_falloff = max( 0, dot ( cam_refelect , direction_of_light)) ;
                specular_falloff = pow (specular_falloff ,  _Gloss);
                specular_falloff = step(_SpecularStep , specular_falloff ) ;
                float3 direc_specular = specular_falloff  * light_color;
                return float4( diffuse_light *  _Color.rgb +  direc_specular,0);                         

                
                //Extra testings for visualising the normal maps and uv coordinates 
                // fixed4 col = tex2D(_MainTex, i.clipSpace);
                // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);
                // return float4(i.clipSpace.xxx,0);
                // return float4(i.clipSpace.xxx,0);

            }
            ENDCG
        }
    }
}
