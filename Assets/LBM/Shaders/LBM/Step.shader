Shader "LBM/Step" {

	Properties {
		_Diffuse1 ("Diffuse Texture 1", 2D) = "" {}
		_Diffuse2 ("Diffuse Texture 2", 2D) = "" {}
		_Diffuse3 ("Diffuse Texture 3", 2D) = "" {}
		_Dx ("dx", float) = 0.001
		_Dy ("dy", float) = 0.001
		_T ("time", float) = 0.0
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _Diffuse1;
	uniform sampler2D _Diffuse2;
	uniform sampler2D _Diffuse3;
	uniform float _Dx;
	uniform float _Dy;
	uniform float _T;
	
	float4 step1(v2f_img IN) : SV_Target {
		float4 col = float4(1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0, 1.0);
		if(_T > 0.) {
			float2 uv = IN.uv;
			float f1 = tex2D(_Diffuse1, uv - float2(_Dx,   0)).r;
			float f2 = tex2D(_Diffuse1, uv - float2(_Dx, _Dy)).g;
			float f3 = tex2D(_Diffuse1, uv - float2(  0, _Dy)).b;
			col.rgb = float3(f1, f2, f3);
		}
		return col;
	}
	
	float4 step2(v2f_img IN) : SV_Target {
		float4 col = float4(1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0, 1.0);
		if(_T > 0.) {
			float2 uv = IN.uv;
			float f4 = tex2D(_Diffuse2, uv - float2(-_Dx,  _Dy)).r;
			float f5 = tex2D(_Diffuse2, uv - float2(-_Dx,    0)).g;
			float f6 = tex2D(_Diffuse2, uv - float2(-_Dx, -_Dy)).b;
			col.rgb = float3(f4, f5, f6);
		}
		return col;
	}
	
	float4 step3(v2f_img IN) : SV_Target {
		float4 col = float4(1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0, 1.0);
		if(_T > 0.) {
			float2 uv = IN.uv;
			float f7 = tex2D(_Diffuse3, uv - float2(   0, -_Dy)).r;
			float f8 = tex2D(_Diffuse3, uv - float2( _Dx, -_Dy)).g;
			float f9 = tex2D(_Diffuse3, uv - float2(   0,    0)).b;
			col.rgb = float3(f7, f8, f9);
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
			#pragma fragment step1
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment step2
			ENDCG
		}
		
		Pass {
			Fog { Mode Off }
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert_img
			#pragma fragment step3
			ENDCG
		}
	
	} 
	
}
