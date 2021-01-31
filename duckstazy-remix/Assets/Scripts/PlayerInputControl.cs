using System.Collections.Generic;
using UnityEngine;

public class PlayerInputControl: PlayerControl {

	protected override void UpdateControl(float dt) {
		base.UpdateControl(dt);
		SetMoveDirection(GetMoveDirection());
		SetShooting(Get(PlayerKeyName.Fire));

		if (GetDown(PlayerKeyName.Fire)) {
			ToggleCarrier();
		}

		SetDiving(Get(PlayerKeyName.Down));
		
		if(GetDown(PlayerKeyName.Up)) {
			Jump();
		}
		else if(GetUp(PlayerKeyName.Up))
		{
			FinishJumping();
		}

		SetFlying(Get(PlayerKeyName.Up));
	}

	private readonly List<KeyCode> _keyCodes = new List<KeyCode> {KeyCode.UpArrow,KeyCode.UpArrow,KeyCode.UpArrow,KeyCode.UpArrow,KeyCode.UpArrow};

	// Use this for initialization
	public void ConnectPlayerData (PlayerData playerData) {
		if(playerData.index == 0)
		{
			_keyCodes[(int)PlayerKeyName.Up] = KeyCode.UpArrow;
			_keyCodes[(int)PlayerKeyName.Down] = KeyCode.DownArrow;
			_keyCodes[(int)PlayerKeyName.Right] = KeyCode.RightArrow;
			_keyCodes[(int)PlayerKeyName.Left] = KeyCode.LeftArrow;
			_keyCodes[(int)PlayerKeyName.Fire] = KeyCode.RightAlt;
		}
		else if(playerData.index == 1)
		{
			_keyCodes[(int)PlayerKeyName.Up] = KeyCode.W;
			_keyCodes[(int)PlayerKeyName.Down] = KeyCode.S;
			_keyCodes[(int)PlayerKeyName.Right] = KeyCode.D;
			_keyCodes[(int)PlayerKeyName.Left] = KeyCode.A;
			_keyCodes[(int)PlayerKeyName.Fire] = KeyCode.LeftAlt;
		}
	}
	
	public bool Get(PlayerKeyName keyName) {
		return Input.GetKey(_keyCodes[(int)keyName]);
	}

	public bool GetDown(PlayerKeyName keyName) {
		return Input.GetKeyDown(_keyCodes[(int)keyName]);
	}

	public bool GetUp(PlayerKeyName keyName) {
		return Input.GetKeyUp(_keyCodes[(int)keyName]);
	}

	public sbyte GetMoveDirection() {
		sbyte dir = 0;
		if (Get(PlayerKeyName.Left)) {
			dir -= 1;
		}
		if (Get(PlayerKeyName.Right)) {
			dir += 1;
		}
		return dir;
	}

	public enum PlayerKeyName {
		Down = 0,
		Up = 1,
		Left = 2, 
		Right = 3,
		Fire = 4
	};
}
