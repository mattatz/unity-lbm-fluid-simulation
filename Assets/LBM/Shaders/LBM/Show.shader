Shader "LBM/Show" {

	Properties {
		_Diffuse1 ("Diffuse Texture", 2D) = "" {}
		_Diffuse2 ("Diffuse Texture", 2D) = "" {}
		_Diffuse3 ("Diffuse Texture", 2D) = "" {}
		_Mask ("Mask Texture", 2D) = "" {}
		_Dx ("dx", float) = 0.001
		_Dy ("dy", float) = 0.001
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _Diffuse1;
	uniform sampler2D _Diffuse2;
	uniform sampler2D _Diffuse3;
	uniform sampler2D _Mask;
	uniform float _Dx;
	uniform float _Dy;
	
	void velocity (float4 v1, float4 v2, float4 v3, out float u, out float v) {
		u = (v1.r + v1.g + v3.g) - (v2.r + v2.g + v2.b);
		v = (v1.g + v1.b + v2.r) - (v2.b + v3.r + v3.g);
	}
	
	float4 frag(v2f_img IN) : SV_Target {
		float2 uv = IN.uv;
		float4 v1 = tex2D(_Diffuse1, uv);
		float4 v2 = tex2D(_Diffuse2, uv);
		float4 v3 = tex2D(_Diffuse3, uv);
		float ux, uy;
		velocity(v1, v2, v3, ux, uy);
		
		/*
		float uW, vW, uE, vE, uN, vN, uS, vS;
		
		v1 = tex2D(_Diffuse1, uv + float2( _Dx,    0));
		v2 = tex2D(_Diffuse2, uv + float2( _Dx,    0));
		v3 = tex2D(_Diffuse3, uv + float2( _Dx,    0));
		velocity(v1, v2, v3, uE, vE);
		
		v1 = tex2D(_Diffuse1, uv + float2(-_Dx,    0));
		v2 = tex2D(_Diffuse2, uv + float2(-_Dx,    0));
		v3 = tex2D(_Diffuse3, uv + float2(-_Dx,    0));
		velocity(v1, v2, v3, uW, vW);
	
		v1 = tex2D(_Diffuse1, uv + float2(   0, -_Dy));
		v2 = tex2D(_Diffuse2, uv + float2(   0, -_Dy));
		v3 = tex2D(_Diffuse3, uv + float2(   0, -_Dy));
		velocity(v1, v2, v3, uN, vN);
	
		v1 = tex2D(_Diffuse1, uv + float2(   0,  _Dy));
		v2 = tex2D(_Diffuse2, uv + float2(   0,  _Dy));
		v3 = tex2D(_Diffuse3, uv + float2(   0,  _Dy));
		velocity(v1, v2, v3, uS, vS);
		float m = abs(10.0 * ((vE - vW) - (uN - uS)));
		*/
		
		float s = (abs(ux) + abs(uy)) * 5;
		return float4(s, s, s, 1.);
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
