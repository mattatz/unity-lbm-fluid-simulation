
		float2 uv = IN.uv;
		float t1 = 4.0 / 9.0;
		float t2 = 1.0 / 9.0;
		float t3 = 1.0 / 36.0; 
		float c_squ = 1.0 / 3.0;
		
		float4 v1 = tex2D(_Diffuse1, uv);
		float4 v2 = tex2D(_Diffuse2, uv);
		float4 v3 = tex2D(_Diffuse3, uv);
		
		float f1 = v1.r;
		float f2 = v1.g;
		float f3 = v1.b;
				 
		float f4 = v2.r;
		float f5 = v2.g;
		float f6 = v2.b;
				 
		float f7 = v3.r;
		float f8 = v3.g;
		float f9 = v3.b;
		
		if (_T == 0.) {
			f1 = 1. / 9.;
			f2 = 1. / 9.;
			f3 = 1. / 9.;
			f4 = 1. / 9.;
			f5 = 1. / 9.;
			f6 = 1. / 9.;
			f7 = 1. / 9.;
			f8 = 1. / 9.;
			f9 = 1. / 9.;
		};				
		
		float density = f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8 + f9;
		float invDensity = 1./ density;
		float ux = invDensity * (f1 + f2 + f8 - f4 - f5 - f6);
		float uy = invDensity * (f2 + f3 + f4 - f6 - f7 - f8);

		/*
		// if (abs(uv.x - 0.5 / 512.) < 1e-6) {
		if (abs(uv.x - _Dx) < 1e-6) {
			ux = 0.25 * (uv.y - uv.y * uv.y);
			uy = 0.0;
			density = (1. / (1. - ux)) * (f3 + f7 + f9 + 2. * (f4 + f5 + f6) );
			f1 = f5 + (2. / 3.) * density * ux;
			f2 = f6 + 0.5 * (f7 - f3) + 0.5 * density * uy + (1. / 6.) * density * ux;
			f8 = f4 + 0.5 * (f3 - f7) - 0.5 * density * uy + (1. / 6.) * density * ux;
		// } else if (abs(uv.x - ( 1. - 0.5/512. ) )  <  1e-6) {
		} else if (abs(uv.x - (1. - _Dx))  <  1e-6) {
			density = 1.;
			ux = -1. + (1. / density) * (f3 + f7 + f9 + 2. * (f1 + f2 + f8));
			uy = 0.0;
			f5 = f1 - (2. / 3.) * density * ux;
			f6 = f2 + 0.5 * (f3 - f7) - 0.5 * density * uy - (1. / 6.) * density * ux;
			f4 = f8 + 0.5 * (f7 - f3) + 0.5 * density * uy - (1. / 6.) * density * ux;
		};				
		*/
			
		float usqu = ux * ux + uy * uy; // dot(u, u)
		float uc2 = ux + uy; // dot(vec2(1., 1.), u)
		float uc4 = -ux + uy; // dot(vec2(-1., 1.), u)
		float uc6 = -uc2; // dot(vec2(-1., -1.), u)
		float uc8 = -uc4; // dot(vec2(1., -1.), u)
 
