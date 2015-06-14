Shader "LBM/Paint" {

	Properties {
		_X ("X", Float) = 0.5
		_Y ("Y", Float) = 0.5
		_Radius ("Radius", Float) = 0.02
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform float _X;
	uniform float _Y;
	uniform float _Radius;

	float4 frag(v2f_img IN) : SV_Target {
		float2 uv = IN.uv;
		if(distance(uv, float2(_X, _Y)) < _Radius) {
			return float4(1, 0, 0, 1);
		} else {
			return float4(0, 0, 0, 1);
		}
	}
	
	ENDCG
	
	SubShader {
	
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
		
	} 
	
	FallBack "Diffuse"
}
