using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class DuckSettings : ScriptableObject {
	public float MoveHorVelocityMax = 8f;
	public float MoveHorAccelerationGround = 32f;
	public float MoveHorAccelerationAir = 8f;
	public float MoveHorAccelerationIdleMult = 2f;
	public float MoveVerMax = 60f;
	public float Gravity = 20f;
	public float GravityLong = 0f;
	public float JumpVelocity = 6f;
	public float DoubleJumpVelocity = 4f;
	public float DoubleJumpHorAcceleration = 4f;
	public float LongJumpTime = 0.2f;
	public float MoveVerDive = 15f;
	public float MoveVerMaxDiveMult = 3f;
	public float DiveLockTime = 1f;
	public float DiveEnterTime = 0.1f;

	[Range(1f, 10f)]
	public float FallVelocity = 4f;

	[Range(0.5f, 1.5f)]
	public float Scale = 0.7f;

	[Range(0.1f, 1f)]
	public float MoveHorAccelerationKickedMult = 0.3f;

	public float VelocityOnDiveLanding {
		get { return JumpVelocity*0.5f; }
	}

	public float GetMoveVerMax(bool dive) {
		return dive ? MoveVerMax*MoveVerMaxDiveMult : MoveVerMax;
	}
}

