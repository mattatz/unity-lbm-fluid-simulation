Shader "LBM/Init" {

	CGINCLUDE
	
	#include "UnityCG.cginc"

	float4 frag(v2f_img IN) : SV_Target {
		return float4(0, 0, 0, 1);
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
	
}
