// ============================================================================
// #region Information

#define PLUGIN_VERSION "1.0"
public Plugin myinfo = 
{
	name = "[L4D2] Aim Down Sight",
	description = "Aim Down Sight for L4D2",
	author = "lqthanh",
	version = PLUGIN_VERSION,
	url = ""
};

// #endregion
// ============================================================================

// ============================================================================
// #region Imports and Defines

#pragma semicolon 1
#pragma newdecls optional

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <dhooks>
#include <left4dhooks>

#define DEFAULT_ATTACK2_TIME 	0.7
#define SCAR_WORLD_MODEL 		"models/w_models/weapons/w_desert_rifle.mdl"

// #endregion
// ============================================================================

// ============================================================================
// #region Variables

int EntStore[2049];
bool bPass;

KeyValues
	hWeaponData = null,
	hActivityList = null;

Handle
	hHook_SelectWeightedSequence = null,
	hHook_SendWeaponAnim = null,
	hWeaponHolster = null,
	hGetWeaponInfoByID = null;

int
	iOS,
	g_scar_precache_index,
	g_Offset_BrustAttackTime;

Handle
	g_SDKCall_PrimaryAttack,
	g_SDKCall_GetRateOfFire,
	g_SDKCall_CanAttack;

DynamicHook
	g_DynamicHook_ItemPostFrame;

StringMap
	g_WeaponHookAdsFixIds;

enum struct PlayerData
{
	bool bZoom;
	int onbutton;
	bool pendingDisableAdsFix;
	bool pendingDisableAdsBySecondary;
	float primaryattacktime;

	float cycleTime;

	char weaponClass[48];
	bool attrValid;
}
PlayerData
	player[MAXPLAYERS + 1];

ConVar
	cvar_ads_debug,
	cvar_ads_key,
	cvar_ads_cycletime_mul,
	cvar_ads_cycletime_scar,
	cvar_ads_attribute_mul;
enum struct GlobalConVar
{
	bool ads_debug;
	int ads_key;
	float ads_cycletime_mul;
	float ads_cycletime_scar;
	float ads_attribute_mul;
}
GlobalConVar
	cvar;

L4D2FloatWeaponAttributes
	WP_ATTRS[] =
{
	L4D2FWA_MaxSpread
	//  L4D2FWA_SpreadPerShot
	// ,L4D2FWA_MaxSpread
	// ,L4D2FWA_MinDuckingSpread
	// ,L4D2FWA_MinStandingSpread
	// ,L4D2FWA_MinInAirSpread
	// ,L4D2FWA_MaxMovementSpread
	// ,L4D2FWA_VerticalPunch
	// ,L4D2FWA_HorizontalPunch
	// ,L4D2FWA_PelletScatterPitch
	// ,L4D2FWA_PelletScatterYaw
};

float
	g_SavedAttributes[sizeof(WP_ATTRS)];

bool
	g_bAttributeApplied;

// int currentActivity[MAXPLAYERS + 1];

// #endregion
// ============================================================================

// ============================================================================
// #region Start

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion engine = GetEngineVersion();
	if( engine != Engine_Left4Dead2 )
	{
		strcopy(error, err_max, "Plugin only supports Left 4 Dead 2.");
		return APLRes_SilentFailure;
	}
	
	return APLRes_Success;
}

public void OnPluginStart()
{
	LoadGameData();
	LoadActivityList();
	LoadWeaponData();
	LoadConVars();
	HookEvents();

	g_WeaponHookAdsFixIds = new StringMap();
}

public void OnMapStart()
{
	g_scar_precache_index = PrecacheModel(SCAR_WORLD_MODEL);
}

public void OnClientConnected(int client)
{
	if( IsFakeClient(client) )
		return;

	player[client].bZoom						= false;
	player[client].pendingDisableAdsFix			= false;
	player[client].pendingDisableAdsBySecondary = false;
	player[client].primaryattacktime			= 0.0;

	player[client].cycleTime					= 0.0;

	player[client].weaponClass[0]				= '\0';
	player[client].attrValid					= false;
}

public void OnClientPutInServer(int client)
{
	if( IsFakeClient(client) )
		return;
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (!IsValidEntityIndex(entity))
		return;
	
	if (classname[0] == 'w' 
		&& StrContains(classname, "weapon_") == 0 
		&& (StrContains(classname, "pistol") != -1
		|| StrContains(classname, "shotgun") != -1
		|| StrContains(classname, "smg") != -1
		|| StrContains(classname, "sniper") != -1
		|| StrContains(classname, "rifle") != -1
		|| StrContains(classname, "grenade_launcher") != -1)
		&& StrContains(classname, "spawn") == -1
	)
	{
		DHookEntity(hHook_SelectWeightedSequence, false, entity, _, DH_OnSelectWeightedSequence);
		DHookEntity(hWeaponHolster, true, entity, _, DH_OnGunHolsterPost);
		SDKHook(entity, SDKHook_ReloadPost, OnCustomWeaponReload);
		EntStore[entity] = 0;
	}

	switch (classname[0])
    {
        case 'w':
        {
            if (strncmp(classname, "weapon_spawn", 12, false) == 0)
                RequestFrame(OnWeaponNextFrame_weapon_spawn, EntIndexToEntRef(entity));
            if (strncmp(classname, "weapon_pistol", 13, false) == 0) //weapon_pistol, weapon_pistol_spawn
                RequestFrame(OnWeaponNextFrame_weapon_pistol, EntIndexToEntRef(entity));
        }
    }
}

void OnWeaponNextFrame_weapon_spawn(int weapon)
{
    weapon = EntRefToEntIndex(weapon);
    if( weapon == INVALID_ENT_REFERENCE ) return;

    int m_weaponID = GetEntProp(weapon, Prop_Send, "m_weaponID");

    if (m_weaponID == 1 ) //1=pistol
    {
        SDKHook(weapon, SDKHook_Use, OnPistolUse); // don't use SDKHook_UsePost
    }
}

void OnWeaponNextFrame_weapon_pistol(int weapon)
{
    weapon = EntRefToEntIndex(weapon);
    if( weapon == INVALID_ENT_REFERENCE ) return;

    SDKHook(weapon, SDKHook_Use, OnPistolUse); // don't use  SDKHook_UsePost
}

Action OnPistolUse(int weapon, int activator, int client, UseType type, float value) 
{
    if (client <= 0 || client > MaxClients || !IsClientInGame(client)) return Plugin_Continue;

    int secondary_weapon = GetPlayerWeaponSlot(client, L4D_WEAPON_SLOT_SECONDARY);
    if(secondary_weapon <= MaxClients) return Plugin_Continue;

    static char classname[32];
    GetEntityClassname(secondary_weapon, classname, sizeof(classname));
    if (strcmp(classname, "weapon_pistol") != 0) return Plugin_Continue;
    if (GetEntProp(secondary_weapon, Prop_Send, "m_isDualWielding") > 0) return Plugin_Continue;

	player[client].bZoom = false;
	ToggleAdsFix(client, secondary_weapon, false);

    return Plugin_Continue;
}

// #endregion
// ============================================================================

// ============================================================================
// #region Loading Data

void LoadGameData()
{
	GameData gamedata = LoadGameConfigFile("l4d2_aim_down_sight");
	if (!gamedata)
		SetFailState("Can't load gamedata \"l4d2_aim_down_sight.txt\" or not found");
	
	iOS = gamedata.GetOffset("Os");
	
	// Setup DHooks - Use manual offset instead of conf
	hHook_SelectWeightedSequence = DHookCreate(208 - iOS, HookType_Entity, ReturnType_Int, ThisPointer_CBaseEntity);
	if (!hHook_SelectWeightedSequence)
		SetFailState("Failed to create DHook: SelectWeightedSequence");
	DHookAddParam(hHook_SelectWeightedSequence, HookParamType_Int);
	
	hHook_SendWeaponAnim = DHookCreate(252 - iOS, HookType_Entity, ReturnType_Int, ThisPointer_CBaseEntity);
	if (!hHook_SendWeaponAnim)
		SetFailState("Failed to create DHook: SendWeaponAnim");
	DHookAddParam(hHook_SendWeaponAnim, HookParamType_Int);
	
	hWeaponHolster = DHookCreate(266 - iOS, HookType_Entity, ReturnType_Void, ThisPointer_CBaseEntity);
	if (!hWeaponHolster)
		SetFailState("Failed to create DHook: Weapon Holster");
	DHookAddParam(hWeaponHolster, HookParamType_CBaseEntity);

	char func[256];
	FormatEx(func, sizeof(func), "CTerrorGun::PrimaryAttack");
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, func);
	if( !(g_SDKCall_PrimaryAttack = EndPrepSDKCall()) )
		SetFailState("failed to start sdkcall \"%s\"", func);

	FormatEx(func, sizeof(func), "CTerrorGun::GetRateOfFire");
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, func);
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_Plain);
	if ( !(g_SDKCall_GetRateOfFire = EndPrepSDKCall()) )
		SetFailState("failed to start sdkcall \"%s\"", func);

	FormatEx(func, sizeof(func), "CTerrorPlayer::CanAttack");
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Virtual, func);
	PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
	if( !(g_SDKCall_CanAttack = EndPrepSDKCall()) )
		SetFailState("failed to start sdkcall \"%s\"", func);

	FormatEx(func, sizeof(func), "CTerrorGun::ItemPostFrame");
	g_DynamicHook_ItemPostFrame = DynamicHook.FromConf(gamedata, func);
	if( !g_DynamicHook_ItemPostFrame )
		SetFailState("Failed to start dynamic hook about \"%s\".", func);

	g_Offset_BrustAttackTime = gamedata.GetOffset("ScarBrustTime");
	
	// Setup SDK Call
	StartPrepSDKCall(SDKCall_Static);
	PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "GetWeaponInfo");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	hGetWeaponInfoByID = EndPrepSDKCall();
	if (!hGetWeaponInfoByID)
		SetFailState("Can't find signature \"GetWeaponInfo\".");
	PrintToServer("[ADS] SDK Calls setup complete");
	
	delete gamedata;
}

void LoadActivityList()
{
	hActivityList = new KeyValues("");
	char buffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, buffer, sizeof(buffer), "data/left4dhooks.l4d2.cfg");
	PrintToServer("[ADS] Loading activity list from: %s", buffer);
	if (!hActivityList.ImportFromFile(buffer))
	{
		LogError("[ADS] WARNING: Failed to load activity list from %s", buffer);
		PrintToServer("[ADS] WARNING: Activity list not loaded - custom animations will not work");
		PrintToServer("[ADS] Plugin will still work with basic ADS functionality");
	}
	else
	{
		PrintToServer("[ADS] Activity list loaded successfully");
	}
}

void LoadWeaponData()
{
	delete hWeaponData;
	hWeaponData = new KeyValues("");
	char buffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, buffer, sizeof(buffer), "data/l4d2_aim_down_sight.txt");
	
	if (!hWeaponData.ImportFromFile(buffer))
	{
		LogError("[ADS] Failed to load weapon data from %s", buffer);
	}
}

// Cvars
void LoadConVars()
{
	// Create ConVars
	cvar_ads_debug = 			CreateConVar("ads_debug", "0", "Enable debug messages for ADS plugin");
	cvar_ads_key = 				CreateConVar("ads_key", "0", "Key to activate ADS. 0 = Zoom key (MOUSE 3), 1 = Walk key (SHIFT), 2 = Duck key (CTRL)");
	cvar_ads_cycletime_mul = 	CreateConVar("ads_cycletime_mul", "1.1", "ADS cycle-time multiplier. > 1.0 makes ADS slower, 1.0 keeps default.", FCVAR_NONE, true, 1.0);
	cvar_ads_cycletime_scar = 	CreateConVar("ads_cycletime_scar", "0.12", "Override cycle time for SCAR");
	cvar_ads_attribute_mul = 		CreateConVar("ads_attribute_mul", "0.5", "Bullet spread multiplier while ADS is active. 1.0 = unchanged, 0.0 = perfect accuracy.", FCVAR_NONE, true, 0.0, true, 1.0);
	cvar_ads_debug.AddChangeHook(OnConVarChanged);
	cvar_ads_key.AddChangeHook(OnConVarChanged);
	cvar_ads_cycletime_mul.AddChangeHook(OnConVarChanged);
	cvar_ads_cycletime_scar.AddChangeHook(OnConVarChanged);
	cvar_ads_attribute_mul.AddChangeHook(OnConVarChanged);
	GetConVars();
	AutoExecConfig(true, "l4d2_aim_down_sight");
}

void GetConVars()
{
	cvar.ads_debug = cvar_ads_debug.BoolValue;
	cvar.ads_key = cvar_ads_key.IntValue;
	cvar.ads_cycletime_mul = cvar_ads_cycletime_mul.FloatValue;
	cvar.ads_cycletime_scar = cvar_ads_cycletime_scar.FloatValue;
	cvar.ads_attribute_mul = cvar_ads_attribute_mul.FloatValue;
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetConVars();
}

public void OnConfigsExecuted()
{
	GetConVars();
}

// Events
void HookEvents()
{
	HookEvent("weapon_zoom", Event_WeaponZoom, EventHookMode_Post);
	HookEvent("weapon_drop", Event_WeaponDrop, EventHookMode_Post);
	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
}

void Event_WeaponZoom(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client <= 0)
		return;
	
	bool zoomed = GetEntProp(client, Prop_Send, "m_iFOV") != 0;
	if (zoomed)
	{
		ClearInspectHelpingHand(GetPlayerWeapon(client));
	}
}

void Event_WeaponDrop(Event event, const char[] name, bool dontBroadcast)
{
	int propid = event.GetInt("propid");
	EntStore[propid] = 0;
	int owner = GetClientOfUserId(event.GetInt("userid"));
	if (owner > 0)
	{
		ToggleAdsFix(owner, propid, false);
	}
}

void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	for(int i = 0; i <= MaxClients; i++)
	{
		player[i].primaryattacktime		= 0.0;
	}
}

// Librarys
public void OnAllPluginsLoaded()
{

}

public void OnLibraryAdded(const char[] name)
{

}

public void OnLibraryRemoved(const char[] name)
{

}

// #endregion
// ============================================================================

// ============================================================================
// #region sdktools_hooks

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if (!IsClientInGame(client) || GetClientTeam(client) != 2 || IsFakeClient(client))
		return Plugin_Continue;

	int activeWeapon = GetPlayerWeapon(client);

	if( player[client].pendingDisableAdsFix )
	{
		if( activeWeapon > 0 && IsValidEntity(activeWeapon) )
		{
			SetupZoom(client, activeWeapon, false);
		}
		player[client].pendingDisableAdsFix = false;
	}

	// if (cvar.ads_debug)
	// {
	// 	int viewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
	// 	if (viewModel > 0)
	// 	{
	// 		int layerSequence = GetEntProp(viewModel, Prop_Send, "m_nLayerSequence");
	// 		char activityName[128];
			
	// 		// Get real activity name from activity ID
	// 		GetActivityName(currentActivity[client], activityName, sizeof(activityName));
			
	// 		PrintToServer("[ADS DEBUG] Client %N - Activity: %s (%d), m_nLayerSequence: %d, ADS: %s", 
	// 			client, activityName, currentActivity[client], layerSequence, player[client].bZoom ? "ON" : "OFF");
	// 	}
	// }
	
	// Determine which button to check based on ads_key
	int adsButton;
	char keyName[16];
	switch (cvar.ads_key)
	{
		case 1: // SHIFT key
		{
			adsButton = IN_SPEED;
			Format(keyName, sizeof(keyName), "SHIFT");
		}
		case 2: // CTRL key
		{
			adsButton = IN_DUCK;
			Format(keyName, sizeof(keyName), "CTRL");
		}
		default: // Zoom key (0 or any other value)
		{
			adsButton = IN_ZOOM;
			Format(keyName, sizeof(keyName), "ZOOM");
		}
	}
	
	if (buttons & adsButton)
	{
		if (buttons & (IN_ATTACK|IN_ATTACK2|IN_RELOAD)) return Plugin_Continue;
		if (GetEntProp(activeWeapon, Prop_Send, "m_bInReload") != 0) return Plugin_Continue;
		float currentTime = GetGameTime();
		if (currentTime < player[client].primaryattacktime) return Plugin_Continue;

		if (!(player[client].onbutton & adsButton))
		{
			player[client].onbutton |= adsButton;
			// Allow ADS if: not a sniper
			if (activeWeapon != -1 && !CanZoom(activeWeapon))
			{
				ClearInspectHelpingHand(activeWeapon);
				SetupZoom(client, activeWeapon, !player[client].bZoom);
			}
		}
	}
	else if (player[client].onbutton & adsButton)
	{
		player[client].onbutton &= ~adsButton;
	}
	
	return Plugin_Continue;
}

public void OnPlayerRunCmdPost(int client, int buttons)
{

}

// #endregion
// ============================================================================

// ============================================================================
// #region dhooks

// Hook: SelectWeightedSequence
public MRESReturn DH_OnSelectWeightedSequence(int weapon, Handle hReturn, Handle hParams)
{
	if (bPass)
		return MRES_Ignored;
	
	int activity = DHookGetParam(hParams, 1);
	int originalActivity = activity;
	int sequence = -1;
	int owner = GetWeaponOwner(weapon);
	
	switch (activity)
	{
		case 193, 1264, 1403: // ACT_VM_RELOAD
		{
			if (GetWeaponClip(weapon) == 0)
				activity = 1269;
			
			if (owner > 0 && player[owner].bZoom)
			{
				SetWeaponHelpingHandState(weapon, 6);
				activity = 1877; // ACT_PRIMARY_VM_RELOAD
			}
		}
		case 1250, 1254: // ACT_VM_MELEE
		{
			if (owner > 0 && player[owner].bZoom)
			{
				SetWeaponHelpingHandState(weapon, 6);
				activity = 1876; // ACT_PRIMARY_VM_SECONDARYATTACK
			}
		}
		case 1252: // ACT_VM_PRIMARYATTACK_LAYER
		{
			if (owner > 0)
			{
				if (GetWeaponClip(weapon) > 0)
				{
					if (player[owner].bZoom)
					{
						SetWeaponHelpingHandState(weapon, 6);
						activity = 1875; // ACT_PRIMARY_VM_PRIMARYATTACK
					}
				}
				else
				{
					activity = player[owner].bZoom ? 1878 : 194; // ACT_PRIMARY_VM_DRYFIRE : ACT_VM_DRYFIRE
				}
			}
		}
		case 1276: // ACT_VM_DEPLOY
		{
			if (!EntStore[weapon])
			{
				if (GetWeaponClip(weapon) > 0)
				{
					activity = 181; // ACT_VM_DRAW
					EntStore[weapon] = 1;
				}
			}
			if (owner > 0)
				player[owner].bZoom = false;
		}
	}
	
	// if (cvar.ads_debug)
	// {
	// 	// Track activity for owner
	// 	if (owner > 0 && owner <= MaxClients)
	// 		currentActivity[owner] = activity;
	// }
	
	// Try custom animation first
	sequence = GetCustomWeaponAnim(weapon, activity);
	if (sequence != -1)
	{
		DHookSetReturn(hReturn, sequence);
		return MRES_Supercede;
	}
	
	// If activity changed, try to find sequence
	if (activity != originalActivity)
	{
		bPass = true;
		sequence = SelectWeightedSequence(weapon, activity);
		bPass = false;
		
		if (sequence != -1)
		{
			DHookSetReturn(hReturn, sequence);
			return MRES_Supercede;
		}
	}
	
	return MRES_Ignored;
}

MRESReturn DhookCallback_ItemPostFrame(int weapon)
{
	int client = GetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity");
	if( client < 1 || client > MaxClients || !IsClientInGame(client) || IsFakeClient(client) )
		return MRES_Ignored;

	if( GetEntProp(weapon, Prop_Send, "m_iWorldModelIndex") == g_scar_precache_index )
	{
		for(int i = 0; i < 3; i++)
		{
			SetEntData(weapon, g_Offset_BrustAttackTime + (4 * i), 0);
		}
	}

	int clip             = GetEntProp(weapon, Prop_Send, "m_iClip1");
	float currenttime    = GetGameTime();

	SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", currenttime + 100);

	static int button;
	button = GetClientButtons(client);
	// seondary first
	if( (button & IN_ATTACK2) && CanAttack(client) )
	{
		player[client].pendingDisableAdsFix = true;
		player[client].pendingDisableAdsBySecondary = true;
		return MRES_Ignored; // ignore in_attack and in_reload when pushing.
	}

	if( (button & IN_ATTACK) && CanAttack(client, clip) )
	{
		if(currenttime > player[client].primaryattacktime)
		{
			SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", currenttime);
			ApplyAdsAttributes(client);
			SDKCall(g_SDKCall_PrimaryAttack, weapon);
			RestoreAdsAttributes(client);
			SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", currenttime + 100.0);
			player[client].primaryattacktime = currenttime + player[client].cycleTime;
		}
		return MRES_Ignored; // ignore IN_RELOAD when pushing attack button.
	}

	int reserverammo = L4D_GetReserveAmmo(client, weapon);
	
	if((button & IN_RELOAD) || (clip == 0 && (reserverammo > 0 || (StrContains(player[client].weaponClass, "pistol", false) != -1))))
	{
		player[client].pendingDisableAdsFix = true;
		return MRES_Ignored;
	}

	return MRES_Ignored;
}

// Hook: Weapon Holster
public MRESReturn DH_OnGunHolsterPost(int weapon)
{
	int owner = GetWeaponOwner(weapon);
	if (owner > 0 && player[owner].bZoom)
	{
		SetupZoom(owner, weapon, false);
	}
	return MRES_Ignored;
}

// #endregion
// ============================================================================

// ============================================================================
// #region sdkhooks

// Hook: Custom Weapon Reload - Inspect weapon when reload with full clip
public Action OnCustomWeaponReload(int weapon)
{
	int owner = GetWeaponOwner(weapon);
	if (owner <= 0 || owner > MaxClients || !IsClientInGame(owner))
		return Plugin_Continue;
	
	// Only inspect when:
	// 1. Clip is full
	// 2. Not in ADS mode (bZoom is false)
	// 3. Weapon is ready (can fire soon)
	if (GetWeaponClip(weapon) >= GetWeaponGunClipSize(weapon) && !player[owner].bZoom)
	{
		float nextAttack = GetEntDataFloat(weapon, FindSendPropInfo("CBaseCombatWeapon", "m_flNextPrimaryAttack"));
		float gameTime = GetGameTime();
		
		// Check if weapon is idle (ready to fire within 1 second)
		if (gameTime + 1.0 >= nextAttack)
		{
			// Check if player pressed reload button
			int buttons = GetClientButtons(owner);
			if (buttons & IN_RELOAD)
			{
				// Play inspect animation (ACT_VM_FIDGET = 184)
				SendWeaponAnim(weapon, 184);
				// Hide the crosshair for the whole inspect: the engine only lets a shove
				// (ACT_VM_MELEE) replace the playing view-model layer while it is hidden.
				// ads_v1.982 gets this for free by parking m_helpingHandState on 7 until
				// hide_effects_until expires; without it the fidget swallows the shove.
				SetWeaponHelpingHandState(weapon, 7);
				return Plugin_Handled;
			}
		}
	}
	
	return Plugin_Continue;
}

// #endregion
// ============================================================================

// ============================================================================
// #region Helper ADS

int SelectWeightedSequence(int entity, int activity)
{
	static Handle hCall = null;
	if (hCall == null)
	{
		StartPrepSDKCall(SDKCall_Entity);
		PrepSDKCall_SetVirtual(208 - iOS);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
		hCall = EndPrepSDKCall();
	}
	return SDKCall(hCall, entity, activity);
}

bool SendWeaponAnim(int weapon, int activity)
{
	static Handle hCall = null;
	if (hCall == null)
	{
		StartPrepSDKCall(SDKCall_Entity);
		PrepSDKCall_SetVirtual(252 - iOS);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
		hCall = EndPrepSDKCall();
	}
	return SDKCall(hCall, weapon, activity);
}

int GetWeaponGunClipSize(int weapon)
{
	static Handle hCall = null;
	if (hCall == null)
	{
		StartPrepSDKCall(SDKCall_Entity);
		PrepSDKCall_SetVirtual(324 - iOS);
		PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
		hCall = EndPrepSDKCall();
	}
	return SDKCall(hCall, weapon);
}

int GetCustomWeaponAnim(int weapon, int activity)
{
	char classname[64];
	GetEntityClassname(weapon, classname, sizeof(classname));
	
	hWeaponData.Rewind();
	if (!hWeaponData.JumpToKey(classname))
		return -1;
	
	if (!hWeaponData.JumpToKey("Animation"))
		return -1;
	
	char activityName[64];
	if (hActivityList.GotoFirstSubKey(false))
	{
		do
		{
			if (activity == hActivityList.GetNum(NULL_STRING, 0))
			{
				hActivityList.GetSectionName(activityName, sizeof(activityName));
				break;
			}
		}
		while (hActivityList.GotoNextKey(false));
		hActivityList.GoBack();
	}
	
	if (activityName[0] == 0)
		return -1;
	
	if (!hWeaponData.JumpToKey(activityName))
		return -1;
	
	int sequence = hWeaponData.GetNum(NULL_STRING, -1);
	if (sequence >= 0)
		return sequence;
	
	// Random from multiple sequences
	if (hWeaponData.GotoFirstSubKey(false))
	{
		ArrayList list = new ArrayList();
		do
		{
			list.Push(hWeaponData.GetNum(NULL_STRING, 0));
		}
		while (hWeaponData.GotoNextKey(false));
		
		sequence = list.Get(GetRandomInt(0, list.Length - 1));
		delete list;
		return sequence;
	}
	
	return -1;
}

void SetupZoom(int client, int weapon, bool zoom)
{
	int targetActivity = zoom ? 1873 : 183; // ACT_PRIMARY_VM_IDLE : ACT_VM_IDLE
	int sequence = SelectWeightedSequence(weapon, targetActivity);
	
	if (sequence == -1)
	{
		return;
	}
	
	player[client].bZoom = zoom;
	ToggleAdsFix(client, weapon, zoom);
	
	int transitionActivity = zoom ? 1879 : 1881; // ACT_PRIMARY_VM_IDLE_TO_LOWERED : ACT_PRIMARY_VM_LOWERED_TO_IDLE
	SendWeaponAnim(weapon, transitionActivity);
	
	int viewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
	SetEntProp(viewModel, Prop_Send, "m_nSequence", sequence);
	SetWeaponHelpingHandState(weapon, zoom ? 6 : 0);
}

bool CanZoom(int weapon)
{
	char classname[64];
	GetEntityClassname(weapon, classname, sizeof(classname));
	return (StrContains(classname[7], "sniper", false) != -1 || 
	        StrContains(classname[7], "hunting", false) != -1 || 
	        StrContains(classname[13], "sg552", false) != -1);
}

int GetPlayerWeapon(int client)
{
	return GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
}

int GetWeaponOwner(int weapon)
{
	return GetEntPropEnt(weapon, Prop_Data, "m_hOwner");
}

int GetWeaponClip(int weapon)
{
	int clip = GetEntProp(weapon, Prop_Data, "m_iClip1");
	return (clip == 254) ? 0 : clip;
}

void SetWeaponHelpingHandState(int weapon, int state)
{
	SetEntProp(weapon, Prop_Send, "m_helpingHandState", state);
}

// Undoes the state 7 that OnCustomWeaponReload parks on the weapon for an inspect, and
// drops the fidget off the view-model layer. State 7 doubles as the "inspecting" flag,
// so no per-player bookkeeping is needed: 7 is only ever set here and ADS uses 6.
// Only needed where no new weapon anim is played - anything that does play one (shove,
// attack, reload, deploy) already resets both on its own.
void ClearInspectHelpingHand(int weapon)
{
	if (weapon < 1 || !IsValidEntity(weapon))
		return;

	if (GetEntProp(weapon, Prop_Send, "m_helpingHandState") != 7)
		return;

	SetWeaponHelpingHandState(weapon, 0);
	if (HasEntProp(weapon, Prop_Send, "m_helpingHandTarget"))
		SetEntProp(weapon, Prop_Send, "m_helpingHandTarget", -1);

	int owner = GetWeaponOwner(weapon);
	if (owner < 1 || owner > MaxClients || !IsClientInGame(owner))
		return;

	int viewModel = GetEntPropEnt(owner, Prop_Send, "m_hViewModel");
	if (viewModel < 1 || !IsValidEntity(viewModel))
		return;

	// Same cancel as ads_v1.982's SetViewAnimation(viewModel, -1, 0, Time): the fidget
	// rides on m_nLayerSequence, so dropping the layer leaves the base idle playing.
	SetEntProp(viewModel, Prop_Send, "m_nLayerSequence", -1);
	SetEntProp(viewModel, Prop_Send, "m_nLayer", 0);
	SetEntPropFloat(viewModel, Prop_Send, "m_flLayerStartTime", GetGameTime());
}

// #endregion
// ============================================================================

// ============================================================================
// #region Helper ADS Fix

bool CanAttack(int client, int clip = -1)
{
	if (clip == 0)
	{
		return false;
	}

	if( !SDKCall(g_SDKCall_CanAttack, client) )
		return false;
	
	return true;
}

void LoadPlayerWeaponAttributes(int client, int weapon)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client))
		return;
	
	if (weapon < 1 || !IsValidEntity(weapon))
		return;
	
	// Get weapon classname
	char classname[64];
	GetEntityClassname(weapon, classname, sizeof(classname));
	strcopy(player[client].weaponClass, sizeof(player[].weaponClass), classname);
	player[client].attrValid = L4D2_IsValidWeapon(classname);

	float cycleTime = SDKCall(g_SDKCall_GetRateOfFire, weapon);

	if (cvar.ads_cycletime_scar > 0.0 && GetEntProp(weapon, Prop_Send, "m_iWorldModelIndex") == g_scar_precache_index) cycleTime = cvar.ads_cycletime_scar;
	if (cvar.ads_cycletime_mul > 1.0) cycleTime *= cvar.ads_cycletime_mul;

	player[client].cycleTime = cycleTime;
	float currentTime = GetGameTime();
	player[client].primaryattacktime = currentTime + cycleTime;
}

// Scales down recoil / spread / pellet scatter for exactly one shot.
// Safe despite the weapon-info database being global: the override window is the single
// SDKCall below, inside this client's own ItemPostFrame, and the game re-reads these
// fields at fire time. Values are read right before writing so we never fight another
// plugin (or a weapon_reparse) with a stale cached original.
void ApplyAdsAttributes(int client)
{
	g_bAttributeApplied	= false;

	if (!player[client].attrValid)
		return;

	char classname[48];
	strcopy(classname, sizeof(classname), player[client].weaponClass);

	if (cvar.ads_attribute_mul != 1.0)
	{
		for (int i = 0; i < sizeof(WP_ATTRS); i++)
		{
			g_SavedAttributes[i] = L4D2_GetFloatWeaponAttribute(classname, WP_ATTRS[i]);
			L4D2_SetFloatWeaponAttribute(classname, WP_ATTRS[i], g_SavedAttributes[i] * cvar.ads_attribute_mul);
		}
		g_bAttributeApplied = true;
	}
}

void RestoreAdsAttributes(int client)
{
	if (!g_bAttributeApplied) return;

	char classname[48];
	strcopy(classname, sizeof(classname), player[client].weaponClass);

	if (g_bAttributeApplied)
	{
		for (int i = 0; i < sizeof(WP_ATTRS); i++)
			L4D2_SetFloatWeaponAttribute(classname, WP_ATTRS[i], g_SavedAttributes[i]);
		g_bAttributeApplied = false;
	}
}

void ToggleAdsFix(int client, int weapon, bool enable)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client))
		return;
	
	if (weapon < 1 || !IsValidEntity(weapon))
		return;
	
	SetEntProp(client, Prop_Data, "m_bPredictWeapons", enable ? 0 : 1);
	
	if (enable)
	{
		LoadPlayerWeaponAttributes(client, weapon);
		HookWeaponAdsFix(weapon);
	}
	else
	{
		float currentTime = GetGameTime();
		if (player[client].pendingDisableAdsBySecondary)
		{
			player[client].pendingDisableAdsBySecondary = false;
			SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", currentTime + DEFAULT_ATTACK2_TIME);
		}
		else
		{
			SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", currentTime);
		}
		player[client].cycleTime = 0.0;
		UnHookWeaponAdsFix(weapon);
	}
}

void HookWeaponAdsFix(int weapon)
{
	if (weapon < 1 || !IsValidEntity(weapon))
		return;
	
	char key[16];
	IntToString(weapon, key, sizeof(key));
	
	// Check if already hooked
	int dummy;
	if (g_WeaponHookAdsFixIds.GetValue(key, dummy))
		return;
	
	// Hook and store hookid
	int hookid = g_DynamicHook_ItemPostFrame.HookEntity(Hook_Post, weapon, DhookCallback_ItemPostFrame);
	g_WeaponHookAdsFixIds.SetValue(key, hookid);
}

void UnHookWeaponAdsFix(int weapon)
{
	if (weapon < 1 || !IsValidEntity(weapon))
		return;
	
	char key[16];
	IntToString(weapon, key, sizeof(key));
	
	int hookid;
	if (g_WeaponHookAdsFixIds.GetValue(key, hookid))
	{
		// Unhook and remove from map
		DynamicHook.RemoveHook(hookid);
		g_WeaponHookAdsFixIds.Remove(key);
	}
}

// #endregion
// ============================================================================

// ============================================================================
// #region Helper Common

bool IsValidEntityIndex(int entity)
{
    return (MaxClients+1 <= entity <= GetMaxEntities());
}

// #endregion
// ============================================================================

// ============================================================================
// #region Debug

// void GetActivityName(int activity, char[] buffer, int maxlen)
// {
// 	if (hActivityList == null)
// 	{
// 		Format(buffer, maxlen, "UNKNOWN");
// 		return;
// 	}
	
// 	hActivityList.Rewind();
// 	if (hActivityList.GotoFirstSubKey(false))
// 	{
// 		do
// 		{
// 			if (activity == hActivityList.GetNum(NULL_STRING, 0))
// 			{
// 				hActivityList.GetSectionName(buffer, maxlen);
// 				hActivityList.Rewind();
// 				return;
// 			}
// 		}
// 		while (hActivityList.GotoNextKey(false));
// 	}
	
// 	hActivityList.Rewind();
// 	Format(buffer, maxlen, "UNKNOWN_%d", activity);
// }

// #endregion
// ============================================================================
