Shader "Unlit/HealthBar"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _Health ("Health", Range(0,1)) = .5
        _Bordersize ("Bordersize" ,  Float) =1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Que" = "Transparent" } // first opaque objects then transparents should be rendered 
        LOD 100

        Pass
        {
            Zwrite off //  if not done this might cause other make other objects  visible too
            Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

            #include "UnityCG.cginc"

            struct meshdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Health;
            float _Bordersize;

            float InverseLerp(float a , float b , float t )
            {
                return (t-a)/(b-a);
            }
            
            v2f vert (meshdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // o.uv = v.uv*2-1;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float distance_ = distance( i.uv*float2(8,1) , float2(clamp (i.uv.x * 8 , .5 , 7.5),.5)) *2 -1; /* the float2 part determines the location of
                                                                                                                        the corrrespondent point on the line */
                clip(-distance_ );
                float border_mask = (distance_ +_Bordersize);
                float pd = fwidth (border_mask);//partial derivative 
                border_mask = saturate(border_mask/ pd); // or length (ddx(border_mask),ddy(border_mask) );
                border_mask = 1 - border_mask;
                
                
                // return float4(fwidth (distance_).xxx,1 );
                // border_mask = step (0, - border_mask );
                 
                fixed4 col = tex2D(_MainTex, float2(_Health,i.uv.y));
                float3 colorsA = float3(1,0,0);
                float3 colorsB = float3(0,1,0); 
                float flash;
                if (_Health < .2) {
                    flash=   cos(4 * _Time.y) * .1 +1;
                }
                else
                {
                     flash =1 ;
                }
                float healthbarMask = i.uv.x < _Health;
                // clip(healthbarMask - .001);
                float t_healthLerp =  saturate( InverseLerp(.2,.8,_Health));
                float3 healthBarColor = lerp(colorsA, colorsB, t_healthLerp);
                float3 bgcolor = float3(0,0,0);
                return float4(col.rgb *healthbarMask  * flash *border_mask , 1);
                
                // float3 maskedColor = lerp (bgcolor,healthBarColor ,  healthbarMask);
                // return float4(maskedColor,healthbarMask);// for alpha bledning and transparency
                // return float4(maskedColor.rgb * healthbarMask, 1);// for colors between red and green

                // return float4(col.rgb,1);
                // return float4(1,0,0,i.uv.x);

                // float distance_ = distance( i.uv , float2(lerp (.2 ,.8 , i.uv.x)  ,.5));
                // return float4(frac(i.uv.x*8) ,i.uv.y, 0,1 ); 
                // return float4(distance_.xxx,1);
                
            }
            ENDCG
        }
    }
}
