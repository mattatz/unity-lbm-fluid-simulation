using UnityEngine;
using System.Collections;

public class LBM : MonoBehaviour {

	[SerializeField] float omega = 1.0f;

	[SerializeField] Shader initShader;
	[SerializeField] Shader compShader;
	[SerializeField] Shader stepShader;
	[SerializeField] Shader copyShader;
	[SerializeField] Shader bounceBackShader;
	[SerializeField] Shader showShader;
	[SerializeField] Shader paintShader;

	Material initMat;
	Material compMat;
	Material stepMat;
	Material copyMat;
	Material bounceBackMat;
	Material paintMat;
	Material showMat;

	RenderTexture rt1;
	RenderTexture rt2;
	RenderTexture rt3;
	RenderTexture rt1c;
	RenderTexture rt2c;
	RenderTexture rt3c;
	RenderTexture rtMask;

	bool isDragging;

	void Start () {
		SetupRTs();
		SetupMats();

		Graphics.Blit(null, rtMask, initMat);
		Graphics.Blit(null, rt1, initMat);
		Graphics.Blit(null, rt2, initMat);
		Graphics.Blit(null, rt3, initMat);
	}
	
	void Update () {

		if(Input.GetMouseButtonDown(0)) {
			isDragging = true;
		} else if(Input.GetMouseButtonUp(0)) {
			Graphics.Blit (null, rtMask, initMat);
			isDragging = false;
		}

		if(isDragging) {
			Graphics.Blit (null, rtMask, initMat);

			Vector3 mousePos = Input.mousePosition;
			float mx = mousePos.x / Screen.width;
			float my = mousePos.y / Screen.height;
			paintMat.SetFloat("_X", mx);
			paintMat.SetFloat("_Y", my);
			Graphics.Blit (null, rtMask, paintMat);
		}

		Graphics.Blit(null, rt1c, compMat, 0);
		Graphics.Blit(null, rt2c, compMat, 1);
		Graphics.Blit(null, rt3c, compMat, 2);

		Graphics.Blit(null, rt1, copyMat, 0);
		Graphics.Blit(null, rt2, copyMat, 1);
		Graphics.Blit(null, rt3, copyMat, 2);

		Graphics.Blit(null, rt1c, bounceBackMat, 0);
		Graphics.Blit(null, rt2c, bounceBackMat, 1);
		Graphics.Blit(null, rt3c, bounceBackMat, 2);

		Graphics.Blit(null, rt1, copyMat, 0);
		Graphics.Blit(null, rt2, copyMat, 1);
		Graphics.Blit(null, rt3, copyMat, 2);

		Graphics.Blit(null, rt1c, stepMat, 0);
		Graphics.Blit(null, rt1, copyMat, 0);

		Graphics.Blit(null, rt2c, stepMat, 1);
		Graphics.Blit(null, rt2, copyMat, 1);

		Graphics.Blit(null, rt3c, stepMat, 2);
		Graphics.Blit(null, rt3, copyMat, 2);

		compMat.SetFloat("_Omega", omega);
		compMat.SetFloat("_T", Time.timeSinceLevelLoad);
		stepMat.SetFloat("_T", Time.timeSinceLevelLoad);
	}

	void OnGUI () {
		if(!Event.current.type.Equals(EventType.Repaint)) return;
	
		var tex = new Texture2D(1, 1);
		tex.SetPixel(0, 0, Color.white);
		Graphics.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), tex, showMat);
	
		int size = 48;
		var r00 = new Rect(0, size * 0, size, size);
		var r01 = new Rect(0, size * 1, size, size);
		var r02 = new Rect(0, size * 2, size, size);
		var r03 = new Rect(0, size * 3, size, size);
		Graphics.DrawTexture(r00, rtMask);
		Graphics.DrawTexture(r01, rt1c);
		Graphics.DrawTexture(r02, rt2c);
		Graphics.DrawTexture(r03, rt3c);
	}

	void OnDestroy () {
		rt1.Release();
		rt2.Release();
		rt3.Release();
		rt1c.Release();
		rt2c.Release();
		rt3c.Release();
		rtMask.Release();
	}

	void SetupRTs () {
		rt1 = CreateRenderTexture(Screen.width, Screen.height);
		rt2 = CreateRenderTexture(Screen.width, Screen.height);
		rt3 = CreateRenderTexture(Screen.width, Screen.height);
		rt1c = CreateRenderTexture(Screen.width, Screen.height);
		rt2c = CreateRenderTexture(Screen.width, Screen.height);
		rt3c = CreateRenderTexture(Screen.width, Screen.height);
		rtMask = CreateRenderTexture(Screen.width, Screen.height);
	}

	void SetupMats () {
		initMat = new Material(initShader);
		copyMat = new Material(copyShader);
		compMat = new Material(compShader);
		stepMat = new Material(stepShader);
		bounceBackMat = new Material(bounceBackShader);
		showMat = new Material(showShader);
		paintMat = new Material(paintShader);

		copyMat.SetTexture("_Diffuse1", rt1c);
		copyMat.SetTexture("_Diffuse2", rt2c);
		copyMat.SetTexture("_Diffuse3", rt3c);

		compMat.SetTexture("_Diffuse1", rt1);
		compMat.SetTexture("_Diffuse2", rt2);
		compMat.SetTexture("_Diffuse3", rt3);
		compMat.SetFloat("_Omega", omega);
		compMat.SetFloat("_Dx", 1f / Screen.width);
		compMat.SetFloat("_Dy", 1f / Screen.height);

		bounceBackMat.SetTexture("_Diffuse1", rt1);
		bounceBackMat.SetTexture("_Diffuse2", rt2);
		bounceBackMat.SetTexture("_Diffuse3", rt3);
		bounceBackMat.SetTexture("_Mask", rtMask);

		stepMat.SetTexture("_Diffuse1", rt1);
		stepMat.SetTexture("_Diffuse2", rt2);
		stepMat.SetTexture("_Diffuse3", rt3);
		stepMat.SetFloat("_Dx", 1f / Screen.width);
		stepMat.SetFloat("_Dy", 1f / Screen.height);

		showMat.SetTexture("_Diffuse1", rt1c);
		showMat.SetTexture("_Diffuse2", rt2c);
		showMat.SetTexture("_Diffuse3", rt3c);
		showMat.SetTexture("_Mask", rtMask);
		showMat.SetFloat("_Dx", 1f / Screen.width);
		showMat.SetFloat("_Dy", 1f / Screen.height);
	}

	RenderTexture CreateRenderTexture (int width, int height) {
		RenderTexture rt = new RenderTexture(width, height, 0);
		rt.format = RenderTextureFormat.ARGBFloat;
		rt.wrapMode = TextureWrapMode.Repeat;
		rt.filterMode = FilterMode.Point;
		rt.Create();
		return rt;
	}

}
