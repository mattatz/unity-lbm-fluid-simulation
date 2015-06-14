Shader "LBM/Copy" {

	Properties {
		_Diffuse1 ("Diffuse Texture", 2D) = "" {}
		_Diffuse2 ("Diffuse Texture", 2D) = "" {}
		_Diffuse3 ("Diffuse Texture", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _Diffuse1;
	uniform sampler2D _Diffuse2;
	uniform sampler2D _Diffuse3;
	
	float4 copy1(v2f_img IN) : SV_Target {
		return tex2D(_Diffuse1, IN.uv);
	}
	
	float4 copy2(v2f_img IN) : SV_Target {
		return tex2D(_Diffuse2, IN.uv);
	}
	
	float4 copy3(v2f_img IN) : SV_Target {
		return tex2D(_Diffuse3, IN.uv);
	}
	
	ENDCG
	
	SubShader {
	
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment copy1
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment copy2
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment copy3
			ENDCG
		}
		
	} 
	
	FallBack "Diffuse"
}
