Shader "LBM/BounceBack" {

	Properties {
		_Diffuse1 ("Diffuse Texture 1", 2D) = "" {}
		_Diffuse2 ("Diffuse Texture 2", 2D) = "" {}
		_Diffuse3 ("Diffuse Texture 3", 2D) = "" {}
		_Mask ("Mask Texture", 2D) = "black" {}
		_Threshold ("Mask Threshold", float) = 0.1
		_Strongness ("Strongness", float) = 1.1
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _Diffuse1;
	uniform sampler2D _Diffuse2;
	uniform sampler2D _Diffuse3;
	uniform sampler2D _Mask;
	uniform float _Threshold;
	uniform float _Strongness;
	
	// (W, NW, N)
	float4 bounceback1(v2f_img IN) : SV_Target {
		float4 col;
		if(tex2D(_Mask, IN.uv).r > _Threshold) {
			// (E, SE, S) to (W, NW, N)
			float4 v2 = tex2D(_Diffuse2, IN.uv);
			float4 v3 = tex2D(_Diffuse3, IN.uv);
			float f5 = v2.g;
			float f6 = v2.b;
			float f7 = v3.r;
			col = float4(f5, f6, f7, 1.) * _Strongness;
		} else {
			col = tex2D(_Diffuse1, IN.uv);
		}
		return col;
	}
	
	float4 bounceback2(v2f_img IN) : SV_Target {
		float4 col;
		if(tex2D(_Mask, IN.uv).r > _Threshold) {
			float4 v1 = tex2D(_Diffuse1, IN.uv);
			float4 v3 = tex2D(_Diffuse3, IN.uv);
			float f8 = v3.g;
			float f1 = v1.r;
			float f2 = v1.g;
			col = float4(f8, f1, f2, 1.) * _Strongness;
		} else {
			col = tex2D(_Diffuse2, IN.uv);
		}
		return col;
	}
	
	float4 bounceback3(v2f_img IN) : SV_Target {
		float4 col;
		if(tex2D(_Mask, IN.uv).r > _Threshold) {
			float4 v1 = tex2D(_Diffuse1, IN.uv);
			float4 v2 = tex2D(_Diffuse2, IN.uv);
			float4 v3 = tex2D(_Diffuse3, IN.uv);
			float f3 = v1.b;
			float f4 = v2.r;
			col = float4(f3, f4, v3.b, 1.) * _Strongness;
		} else {
			col = tex2D(_Diffuse3, IN.uv);
		}
		return col;
	}
	
	ENDCG
	
	SubShader {
	
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment bounceback1
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment bounceback2
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment bounceback3
			ENDCG
		}
	
	} 
	
}
