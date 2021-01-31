using System;
using UnityEngine;

public class PlayerView : MonoBehaviour {

	public AudioSource Audio;
	public Animator Animator;
	public Transform EyeX;
	public Transform EyeNormal;
	public Transform CenteredSprite;
	public Transform InnerSprite;

	public SoundClip SoundLanding;
	public SoundClip SoundSteps;
	public SoundClip SoundJump;
	public SoundClip SoundDoubleJump;
	public SoundClip SoundFly;
	public SoundClip SoundDiveStarted;
	public SoundClip SoundDiveLanding;
	public SoundClip SoundHit;

	public ParticleSystem GroundFx;
	public ParticleSystem JumpCircleFx;

	[Range(-1, 1)]
	public int MoveDirection;

	[Range(0f, 1f)]
	public float EyePower;

	[Range(0.5f, 2f)]
	public float Scale = 1f;

	public bool Flying;
	public bool Shooting;
	public bool Carrying;
	public bool Grounded = true;
	public float DiveEnterProgress;
	public bool Dive;

	[NonSerialized]
	public float WingsBlending;
	[NonSerialized]
	public float ShootBlending;
	[NonSerialized]
	public float CarrierBlending;

	private float _diveStartTween;
	private float _diveParticles;
	private float _diveEyePower;
	private int _lookDirection = 1;

	void Awake() {
		if (JumpCircleFx == null) {
			JumpCircleFx = GameObject.Find("JumpCircleFx").GetComponent<ParticleSystem>();
		}

		if (GroundFx == null) {
			GroundFx = GameObject.Find("GroundFx").GetComponent<ParticleSystem>();
		}
	}

	private void ConnectPlayerData(PlayerData playerData) {
		var playerIndex = playerData.index;
		foreach (var sprite in GetComponentsInChildren<MeshRenderer>()) {
			sprite.sortingOrder += 10*playerIndex;
		}
	}

	public void PlayLandingEffect(Vector2 velocity) {
		if (velocity.y < -2f) {
			PlaySound(SoundLanding);
		}

		var count = (int) (40*Mathf.Abs(velocity.y/10f));
		if (count > 0) {
			GroundFx.transform.localPosition = transform.localPosition;
			GroundFx.Emit(count);
		}
	}

	public void PlayStep() {
		if (Grounded) {
			PlaySound(SoundSteps);
			EmitParticles(GroundFx, 2, FootCenterPosition);
		}
	}
	
	public void PlayDoubleJump(Vector2 velocity) {
		Animator.SetTrigger("DoubleJump");
		PlaySound(SoundDoubleJump);
		JumpCircleFx.transform.localPosition = FootCenterPosition;
		JumpCircleFx.transform.eulerAngles = new Vector3(90f + GetVelocityAngle(velocity), 90f, 0f);
		JumpCircleFx.Emit(1);
	}

	public Vector2 FootCenterPosition {
		get { return InnerSprite.position; }
	}

	private void PlaySound(SoundClip clip, float volume = 1f, float panOffset = 0f, float pitchOffset = 0f) {
		clip.PlayAtSource(Audio, volume, panOffset, pitchOffset);
	}

	private void EmitParticles(ParticleSystem ps, int count, Vector2 position) {
		if (count > 0) {
			ps.transform.localPosition = position;
			ps.Emit(count);
		}
	}

	private static float GetVelocityAngle(Vector2 velocity) {
		var a = Vector2.Angle(Vector2.up, velocity);
		a = velocity.x >= 0f ? a : -a;
		return a;
	}
	
	public void PlayWing() {
		if(Flying && WingsBlending > 0f) {
			PlaySound(SoundFly, WingsBlending);
		}
	}

	public void PlayJump() {
		PlaySound(SoundJump);
	}

	void PlayFlySound() {
		PlayWing();
	}

	void PlayStepSound() {
		PlayStep();
	}





	/////////////////////////////////
	/// ////////////////////////////
	/// 


	void LateUpdate() {
		if (!_visible) {
			return;
		}
		var dt = Time.deltaTime;
		SetRunning(MoveDirection);
		UpdateBlending(dt);
		UpdateScale(dt);
		UpdateDive(dt);
		UpdateEye();
	}

	private void UpdateEye() {
		var pwr = Mathf.Clamp01(_diveEyePower + EyePower);
		var sc = EyeNormal.localScale;
		sc.x = sc.y = 1f + pwr*0.4f;
		EyeNormal.localScale = sc;
		EyeNormal.gameObject.GetComponent<Renderer>().enabled = pwr < 1f;
		EyeX.gameObject.GetComponent<Renderer>().enabled = pwr >= 1f;
	}

	private void SetRunning(int direction) {
		var running = direction != 0;
		Animator.SetBool("running", running);
		if (running) {
			//var angles = transform.eulerAngles;
			//angles.y = direction < 0 ? 180f : 0f;
			//transform.eulerAngles = angles;
			_lookDirection = direction;
		}
	}
	
	public void SetJumpState(int state) {
		Animator.SetInteger("jumpState", state);
	}

	private void UpdateBlending(float dt) {

		if (Flying && WingsBlending <= 0f) {
			Animator.Play("fly");
		}
		if (TweenHelper.Tween01(Flying, ref WingsBlending, dt*8f)) {
			Animator.SetLayerWeight(1, WingsBlending);
		}

		if (Shooting && ShootBlending <= 0f) {
			Animator.Play("shooting");
		}
		if (TweenHelper.Tween01(Shooting, ref ShootBlending, dt*8f)) {
			Animator.SetLayerWeight(2, ShootBlending);
		}

		if (Carrying && CarrierBlending <= 0f) {
			Animator.Play("carrier");
		}
		if (TweenHelper.Tween01(Carrying, ref CarrierBlending, dt*8f)) {
			Animator.SetLayerWeight(3, CarrierBlending);
		}
	}

	
	private float squeeze;
	private float pulsed;


	private void UpdateScale(float dt) {
		if(squeeze > 0f)
		{
			squeeze -= dt*3.25f;
			if (squeeze < 0f) {
				squeeze = 0f;
			}
		}
			
		if(pulsed > 0f)
		{
			pulsed -= dt*3.25f;
			if (pulsed < 0f) {
				pulsed = 0f;
			}
		}

		var quadTween = 0f;
		float squeezeFactor = -0.4f*(Mathf.Sin(-Mathf.PI*2f*squeeze))*squeeze;
		float pulseFactor = 0.15f*(Mathf.Sin(-Mathf.PI*2f*pulsed))*pulsed;
		float resultScale = 1f + 2f*pulseFactor + 2f*0.2f*quadTween;

		var scale = CenteredSprite.localScale;
		scale.x = resultScale - squeezeFactor;
		scale.y = resultScale + squeezeFactor;
		CenteredSprite.localScale = scale;

		scale = transform.localScale;
		scale.x = Scale*_lookDirection;
		scale.y = Scale;
		transform.localScale = scale;
	}

	public void PlaySqueeze() {
		squeeze = 1f;
	}

	public void PlayPulse() {
		pulsed = 1f;
	}

	public void PlayDivingStart() {
		PlaySound(SoundDiveStarted);
		_diveStartTween = 1f;
		_diveParticles = 0f;
	}

	void UpdateDive(float dt) {
		var enterProgress = DiveEnterProgress;
		_diveEyePower = Dive ? 0.9f : 0.9f*enterProgress;

		TweenHelper.Tween01(false, ref _diveStartTween, dt*4f);

		
		var sc = CenteredSprite.localScale;
		var angles = CenteredSprite.eulerAngles;

		var startScaling = 0.4f*Ease.quadraticOut(enterProgress);
		sc.x *= 1f + startScaling;
		sc.y *= 1f - startScaling;

		if (Dive) {
			var diveScaleFactor = 1f - _diveStartTween;
			sc.y *= 1f + 0.5f*diveScaleFactor - startScaling;
			sc.x *= 1f - 0.25f*diveScaleFactor + startScaling;
		}

		angles.z = _diveStartTween*360f;

		CenteredSprite.localScale = sc;
		CenteredSprite.eulerAngles = angles;
	}

	public void PlayHitEffect(int amount) {
		PlaySqueeze();
		PlaySound(SoundHit);
		// particles
	}

	private bool _visible = true;

	public bool Visible {
		get {
			return _visible;
		}
		set {
			_visible = value;
			CenteredSprite.gameObject.SetActive(value);
		}
	}
}
