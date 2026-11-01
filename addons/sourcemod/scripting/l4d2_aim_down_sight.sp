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
#define ATTRIBUTE_MUL_PATH		"data/l4d2_aim_down_sight/l4d2_aim_down_sight_attribute_mul.txt"

#define WP_ATTR_COUNT			2	// = sizeof(WP_ATTRS)

// ACT_PRIMARY_VM_DRAW .. ACT_PRIMARY_VM_LOWERED_TO_IDLE (ads_1st). The ACT_SECONDARY_VM_*
// block (ads_2nd) mirrors it 1:1, 11 ids higher (see data/left4dhooks.l4d2.cfg).
#define ACT_PRIMARY_VM_FIRST	1871
#define ACT_PRIMARY_VM_LAST		1881
#define ACT_PRIMARY_VM_IDLE		1873
#define ACT_SECONDARY_OFFSET	11

#define AIM_MODE_1ST			0
#define AIM_MODE_2ND			1

// studiohdr_t / mstudio*_t layout (MDL v48/v49), same as ads_v1.987 reads through the engine
#define MDL_NUMLOCALANIM		0xB4
#define MDL_NUMLOCALSEQ			0xBC
#define MDL_NUMBODYPARTS		0xE8
#define MDL_SIZEOF_BODYPART		16
#define MDL_SIZEOF_MODEL		148
#define MDL_SIZEOF_SEQDESC		212
#define MDL_SIZEOF_ANIMDESC		100
#define MDL_SEQ_ANIMINDEXINDEX	0x3C

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

// View model scope bodygroup ("scope_transform" / "scope_variable") plus the custom
// MIXED / IDLE_TO_NEXT activities, which have no fixed id and must be found by name.
enum struct ModelScope
{
	int base;					// bodypart base, m_nBody = sum(part * base)
	int numParts;
	int offOff;					// mixed_off_scope_off
	int offOn;					// mixed_off_scope_on
	int onOff;					// mixed_on_scope_off
	int onOn;					// mixed_on_scope_on
	int fixOffOff;				// part set at once when the flip-open anim starts
	int fixOnOff;				// part set at once when the flip-close anim starts (hip / ads_2nd)
	int fixOnOn;				// part set at once when the flip-close anim starts (ads_1st)
	float offDelay;				// share of the MIXED_OFF anim before the steady part is set
	float onDelay;				// share of the MIXED_ON anim before the steady part is set
	bool magnifier;				// has MIXED_ON and MIXED_OFF animations
	StringMap sequences;		// activity name -> sequence, "<activity>#d" -> duration
}

ArrayList
	g_ModelScopes;				// ModelScope

StringMap
	g_ModelScopeIds;			// view model path -> index in g_ModelScopes, -1 = no scope bodygroup

int
	g_ModelIndexScopeId[4096] = {-2, ...};	// model precache index -> g_ModelScopes index, -2 = not resolved yet

bool
	g_WeaponMixed[2049];		// scope flipped away (mixed on), kept on the weapon like ads_v1.987

enum struct PlayerData
{
	bool bZoom;
	int onbutton;
	bool pendingDisableAdsFix;
	bool pendingDisableAdsBySecondary;
	float primaryattacktime;

	int aimMode;				// AIM_MODE_*, kept across ADS on/off, reset on weapon switch
	bool combinePressed;
	float combinePressTime;

	int scopeWeapon;			// entref of the weapon the scope state below belongs to
	int scopePart;				// bodygroup part we want on the view model
	float scopeDelaySwitch;		// apply scopePart at this time, 0 = nothing pending
	float scopeTransformEnd;	// flip animation end

	float cycleTime;

	char weaponClass[48];
	float attrMul[WP_ATTR_COUNT];	// attribute_mul of weaponClass, cached on ADS enable
}
PlayerData
	player[MAXPLAYERS + 1];

ConVar
	cvar_ads_debug,
	cvar_ads_key,
	cvar_ads_combine_key,
	cvar_ads_combine_hold;
enum struct GlobalConVar
{
	bool ads_debug;
	int ads_key;
	int ads_combine_key;
	float ads_combine_hold;
}
GlobalConVar
	cvar;

// Weapon-info attributes scaled around the ADS shot, with their key names in the attribute_mul config.
// "CycleTime" is handled separately: it scales the plugin's own ADS fire interval.
L4D2FloatWeaponAttributes
	WP_ATTRS[WP_ATTR_COUNT] =
{
	 L4D2FWA_SpreadPerShot
	,L4D2FWA_MaxSpread
};

char
	WP_ATTR_NAMES[WP_ATTR_COUNT][] =
{
	 "SpreadPerShot"
	,"MaxSpread"
};

// Multipliers applied while ADS. 1.0 = untouched.
enum struct AttributeMul
{
	float cycleTime;
	float attr[WP_ATTR_COUNT];

	void Reset()
	{
		this.cycleTime = 1.0;
		for (int i = 0; i < WP_ATTR_COUNT; i++)
			this.attr[i] = 1.0;
	}
}

StringMap
	g_AttributeMulMap;		// weapon classname -> AttributeMul

float
	g_SavedAttributes[WP_ATTR_COUNT];

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
	LoadAttributeMulData();
	LoadConVars();
	HookEvents();

	RegAdminCmd("sm_ads_reload", Cmd_AdsReload, ADMFLAG_CONFIG, "Reload ADS sequence override and attribute multiplier configs");

	g_WeaponHookAdsFixIds = new StringMap();
	g_ModelScopes = new ArrayList(sizeof(ModelScope));
	g_ModelScopeIds = new StringMap();
}

Action Cmd_AdsReload(int client, int args)
{
	LoadWeaponData();
	LoadAttributeMulData();
	ReplyToCommand(client, "[ADS] Configs reloaded (%d weapon attribute entries).", g_AttributeMulMap.Size);
	return Plugin_Handled;
}

public void OnMapStart()
{
	g_scar_precache_index = PrecacheModel(SCAR_WORLD_MODEL);

	// precache indices change per map
	for (int i = 0; i < sizeof(g_ModelIndexScopeId); i++)
		g_ModelIndexScopeId[i] = -2;
}

public void OnClientConnected(int client)
{
	if( IsFakeClient(client) )
		return;

	player[client].bZoom						= false;
	player[client].pendingDisableAdsFix			= false;
	player[client].pendingDisableAdsBySecondary = false;
	player[client].primaryattacktime			= 0.0;

	player[client].aimMode						= AIM_MODE_1ST;
	player[client].combinePressed				= false;
	player[client].combinePressTime				= 0.0;

	player[client].scopeWeapon					= INVALID_ENT_REFERENCE;
	player[client].scopePart					= -1;
	player[client].scopeDelaySwitch				= 0.0;
	player[client].scopeTransformEnd			= 0.0;

	player[client].cycleTime					= 0.0;

	player[client].weaponClass[0]				= '\0';
	for (int i = 0; i < WP_ATTR_COUNT; i++)
		player[client].attrMul[i]				= 1.0;
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

	g_WeaponMixed[entity] = false;

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
	BuildPath(Path_SM, buffer, sizeof(buffer), "data/l4d2_aim_down_sight/l4d2_aim_down_sight_sequence_override.txt");
	
	if (!hWeaponData.ImportFromFile(buffer))
	{
		LogError("[ADS] Failed to load weapon data from %s", buffer);
	}
}

// Missing keys and unlisted weapons = 1.0 (no change).
void LoadAttributeMulData()
{
	if (g_AttributeMulMap == null)
		g_AttributeMulMap = new StringMap();
	else
		g_AttributeMulMap.Clear();

	char buffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, buffer, sizeof(buffer), ATTRIBUTE_MUL_PATH);

	KeyValues kv = new KeyValues("Weapon");
	if (!kv.ImportFromFile(buffer))
	{
		LogError("[ADS] Failed to load attribute multipliers from %s", buffer);
		delete kv;
		return;
	}

	char weaponClass[48], key[32];
	AttributeMul mul;
	if (kv.GotoFirstSubKey())
	{
		do
		{
			kv.GetSectionName(weaponClass, sizeof(weaponClass));
			mul.Reset();

			if (kv.GotoFirstSubKey(false))
			{
				do
				{
					kv.GetSectionName(key, sizeof(key));
					float value = kv.GetFloat(NULL_STRING, 1.0);
					if (value < 0.0 || (value == 0.0 && strcmp(key, "CycleTime", false) == 0))
						LogError("[ADS] %s: invalid value %.3f for \"%s\", ignored", weaponClass, value, key);
					else if (!SetAttributeMul(mul, key, value))
						LogError("[ADS] %s: unknown attribute \"%s\", ignored", weaponClass, key);
				}
				while (kv.GotoNextKey(false));
				kv.GoBack();
			}

			g_AttributeMulMap.SetArray(weaponClass, mul, sizeof(mul));
		}
		while (kv.GotoNextKey());
	}

	delete kv;
}

bool SetAttributeMul(AttributeMul mul, const char[] key, float value)
{
	if (strcmp(key, "CycleTime", false) == 0)
	{
		mul.cycleTime = value;
		return true;
	}

	for (int i = 0; i < WP_ATTR_COUNT; i++)
	{
		if (strcmp(key, WP_ATTR_NAMES[i], false) == 0)
		{
			mul.attr[i] = value;
			return true;
		}
	}

	return false;
}

void GetAttributeMul(const char[] classname, AttributeMul mul)
{
	if (!g_AttributeMulMap.GetArray(classname, mul, sizeof(mul)))
		mul.Reset();
}

// Cvars
void LoadConVars()
{
	// Create ConVars
	cvar_ads_debug = 			CreateConVar("ads_debug", "0", "Enable debug messages for ADS plugin");
	cvar_ads_key = 				CreateConVar("ads_key", "0", "Key to activate ADS. 0 = Zoom key (MOUSE 3), 1 = Walk key (SHIFT), 2 = Duck key (CTRL)");
	cvar_ads_combine_key =		CreateConVar("ads_combine_key", "32", "Button bitmask that switches aim mode (ads_1st <-> ads_2nd) while ADS. 32 = USE (E), 0 = disabled. Model support required.");
	cvar_ads_combine_hold = 	CreateConVar("ads_combine_hold", "0.5", "Holding ads_combine_key this many seconds flips the scope (model support required); a shorter press switches aim mode.", FCVAR_NONE, true, 0.0);
	cvar_ads_debug.AddChangeHook(OnConVarChanged);
	cvar_ads_key.AddChangeHook(OnConVarChanged);
	cvar_ads_combine_key.AddChangeHook(OnConVarChanged);
	cvar_ads_combine_hold.AddChangeHook(OnConVarChanged);
	GetConVars();
	AutoExecConfig(true, "l4d2_aim_down_sight");
}

void GetConVars()
{
	cvar.ads_debug = cvar_ads_debug.BoolValue;
	cvar.ads_key = cvar_ads_key.IntValue;
	cvar.ads_combine_key = cvar_ads_combine_key.IntValue;
	cvar.ads_combine_hold = cvar_ads_combine_hold.FloatValue;
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

	HandleCombineButton(client, buttons, activeWeapon);

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
	if (!IsClientInGame(client) || GetClientTeam(client) != 2 || IsFakeClient(client))
		return;

	// After the ADS toggle of this command, so the scope part follows bZoom on the same tick.
	UpdateScopeBodygroup(client, GetPlayerWeapon(client));
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
			{
				player[owner].bZoom = false;
				player[owner].aimMode = AIM_MODE_1ST;
			}
		}
	}

	// ads_2nd: swap the ads_1st activity (ours or the engine's) for its ACT_SECONDARY_VM_*
	// twin. Falls through to ads_1st when the model has no such sequence.
	if (owner > 0 && player[owner].aimMode == AIM_MODE_2ND
		&& ACT_PRIMARY_VM_FIRST <= activity <= ACT_PRIMARY_VM_LAST)
	{
		sequence = FindWeaponSequence(weapon, activity + ACT_SECONDARY_OFFSET);
		if (sequence != -1)
		{
			DHookSetReturn(hReturn, sequence);
			return MRES_Supercede;
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
	if (owner > 0)
		player[owner].aimMode = AIM_MODE_1ST;
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

// Data-file override first, then the model itself. bPass keeps our own hook out of the lookup.
int FindWeaponSequence(int weapon, int activity)
{
	int sequence = GetCustomWeaponAnim(weapon, activity);
	if (sequence != -1)
		return sequence;

	bPass = true;
	sequence = SelectWeightedSequence(weapon, activity);
	bPass = false;
	return sequence;
}

// Same click/hold split as ads_v1.987's SwitchCombine: a press released before
// ads_combine_hold is a click and switches aim mode; holding that long flips the scope once.
// combinePressTime = 0 marks a press already used by the hold.
void HandleCombineButton(int client, int buttons, int weapon)
{
	if (cvar.ads_combine_key == 0)
		return;

	float currentTime = GetGameTime();
	if (buttons & cvar.ads_combine_key)
	{
		if (!player[client].combinePressed)
		{
			player[client].combinePressed = true;
			player[client].combinePressTime = currentTime;
		}
		else if (player[client].combinePressTime > 0.0
			&& currentTime - player[client].combinePressTime >= cvar.ads_combine_hold)
		{
			player[client].combinePressTime = 0.0;
			HandleScopeFlip(client, weapon);
		}
		return;
	}

	if (!player[client].combinePressed)
		return;
	player[client].combinePressed = false;

	if (player[client].combinePressTime <= 0.0
		|| currentTime - player[client].combinePressTime >= cvar.ads_combine_hold)
		return;

	if (!player[client].bZoom || weapon < 1 || !IsValidEntity(weapon))
		return;

	if (GetEntProp(weapon, Prop_Send, "m_bInReload") != 0)
		return;

	SwitchAimMode(client, weapon);
}

// ads_1st -> ads_2nd -> ads_1st. Only goes to ads_2nd when the model has ACT_SECONDARY_VM_IDLE.
void SwitchAimMode(int client, int weapon)
{
	int mode = AIM_MODE_1ST;
	if (player[client].aimMode == AIM_MODE_1ST
		&& FindWeaponSequence(weapon, ACT_PRIMARY_VM_IDLE + ACT_SECONDARY_OFFSET) != -1)
	{
		mode = AIM_MODE_2ND;
	}

	if (mode == player[client].aimMode)
		return;

	player[client].aimMode = mode;

	// Like SetupZoom: snap the view model onto the new mode's idle. Not under bPass, so
	// DH_OnSelectWeightedSequence remaps ACT_PRIMARY_VM_IDLE for the new mode.
	int sequence = SelectWeightedSequence(weapon, ACT_PRIMARY_VM_IDLE);
	int viewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
	if (sequence != -1 && viewModel > 0)
		SetEntProp(viewModel, Prop_Send, "m_nSequence", sequence);

	if (cvar.ads_debug)
		PrintToServer("[ADS] %N switched aim mode to ads_%s (sequence %d)", client, mode == AIM_MODE_2ND ? "2nd" : "1st", sequence);
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
// #region Helper Scope

// The client's view model if it is showing this weapon (it can lag a tick behind a switch).
int GetWeaponViewModel(int client, int weapon)
{
	if (weapon < 1 || !IsValidEntity(weapon))
		return -1;

	int viewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
	if (viewModel < 1 || !IsValidEntity(viewModel) || GetEntPropEnt(viewModel, Prop_Send, "m_hWeapon") != weapon)
		return -1;

	return viewModel;
}

// ModelScope index for the view model's model, -1 if it has no scope bodygroup.
// Each model file is parsed once per plugin load, the model index lookup once per map.
int GetViewModelScopeId(int viewModel)
{
	int index = GetEntProp(viewModel, Prop_Send, "m_nModelIndex");
	if (index < 0 || index >= sizeof(g_ModelIndexScopeId))
		return -1;

	if (g_ModelIndexScopeId[index] != -2)
		return g_ModelIndexScopeId[index];

	char model[PLATFORM_MAX_PATH];
	GetEntPropString(viewModel, Prop_Data, "m_ModelName", model, sizeof(model));
	if (model[0] == '\0')
		return -1;

	int id;
	if (!g_ModelScopeIds.GetValue(model, id))
	{
		id = LoadModelScope(model);
		g_ModelScopeIds.SetValue(model, id);
	}

	g_ModelIndexScopeId[index] = id;
	return id;
}

int LoadModelScope(const char[] model)
{
	File file = OpenFile(model, "rb", true);
	if (file == null)
		return -1;

	int id = -1;
	ModelScope scope;
	int version = MdlReadInt(file, 4);
	if ((version == 48 || version == 49) && ReadScopeBodygroup(file, scope))
	{
		scope.sequences = new StringMap();
		ReadScopeSequences(file, scope.sequences);

		float duration;
		scope.magnifier = (FindScopeSequence(scope, "ACT_VM_MIXED_ON", duration) != -1 && FindScopeSequence(scope, "ACT_VM_MIXED_OFF", duration) != -1)
			|| (FindScopeSequence(scope, "ACT_PRIMARY_VM_MIXED_ON", duration) != -1 && FindScopeSequence(scope, "ACT_PRIMARY_VM_MIXED_OFF", duration) != -1);

		id = g_ModelScopes.PushArray(scope);
	}
	delete file;

	if (cvar.ads_debug)
		PrintToServer("[ADS] %s: %s", model, id == -1 ? "no scope bodygroup" : (scope.magnifier ? "scope bodygroup + flip anims" : "scope bodygroup"));

	return id;
}

// Port of ads_v1.987's GetBodyGroupScope + SetMixedDelay.
bool ReadScopeBodygroup(File file, ModelScope scope)
{
	int numBodyparts = MdlReadInt(file, MDL_NUMBODYPARTS);
	int bodypartIndex = MdlReadInt(file, MDL_NUMBODYPARTS + 4);

	char name[64];
	for (int b = 0; b < numBodyparts; b++)
	{
		int offset = bodypartIndex + b * MDL_SIZEOF_BODYPART;
		MdlReadString(file, offset + MdlReadInt(file, offset), name, sizeof(name));

		bool transform = StrEqual(name, "scope_transform");
		if (!transform && !StrEqual(name, "scope_variable"))
			continue;

		scope.numParts = MdlReadInt(file, offset + 4);
		scope.base = MdlReadInt(file, offset + 8);
		if (scope.numParts < 2 || scope.base < 1)
			return false;

		int delayCount, delayMax;
		if (transform)
		{
			scope.offOff = 0;
			scope.offOn = 1;
			scope.onOff = 2;
			scope.onOn = 3;
			scope.offDelay = 0.5;
			scope.onDelay = 0.3;
			scope.fixOffOff = scope.offOff;
			scope.fixOnOff = scope.onOff;
			scope.fixOnOn = scope.onOn;
			delayCount = 3;
			delayMax = 1;
		}
		else
		{
			scope.offOff = 0;	// mixed_off_scope_x1
			scope.onOn = 1;		// mixed_on_scope_x4
			scope.offOn = 0;	// mixed_off_scope_x4
			scope.onOff = 1;	// mixed_on_scope_x1
			scope.offDelay = 0.5;
			scope.onDelay = 0.5;
			scope.fixOffOff = scope.onOn;
			scope.fixOnOff = scope.offOff;
			scope.fixOnOn = scope.offOff;
			if (scope.numParts > 3)
			{
				scope.fixOffOff = 2;	// mixed_off_scope_on
				scope.fixOnOff = 3;		// mixed_on_scope_off
				scope.fixOnOn = 3;		// mixed_on_scope_off
			}
			delayCount = 1;
			delayMax = 0;
		}

		// "mixed_off_scope_off_50.smd": the number is the switch point in % of the anim
		int modelIndex = MdlReadInt(file, offset + 12);
		for (int i = 0; i <= delayCount && i < scope.numParts; i++)
		{
			MdlReadString(file, offset + modelIndex + i * MDL_SIZEOF_MODEL, name, sizeof(name));
			for (int c = 0; name[c] != '\0'; c++)
			{
				if (name[c] == '_' && IsCharNumeric(name[c + 1]))
				{
					float delay = StringToInt(name[c + 1]) * 0.01;
					if (i <= delayMax)
						scope.offDelay = delay;
					else
						scope.onDelay = delay;
					break;
				}
			}
		}
		return true;
	}
	return false;
}

// Only the custom activities the engine has no id for: *MIXED_* and *IDLE_TO_NEXT.
void ReadScopeSequences(File file, StringMap sequences)
{
	int animIndex = MdlReadInt(file, MDL_NUMLOCALANIM + 4);
	int numSeq = MdlReadInt(file, MDL_NUMLOCALSEQ);
	int seqIndex = MdlReadInt(file, MDL_NUMLOCALSEQ + 4);

	char activity[64], key[72];
	for (int s = 0; s < numSeq; s++)
	{
		int offset = seqIndex + s * MDL_SIZEOF_SEQDESC;
		MdlReadString(file, offset + MdlReadInt(file, offset + 8), activity, sizeof(activity));
		StrToUpper(activity);

		if (StrContains(activity, "MIXED_") == -1 && StrContains(activity, "IDLE_TO_NEXT") == -1)
			continue;
		if (sequences.ContainsKey(activity))
			continue;

		// duration of the sequence's first animation, like CBaseAnimating::SequenceDuration
		int anim;
		file.Seek(offset + MdlReadInt(file, offset + MDL_SEQ_ANIMINDEXINDEX), SEEK_SET);
		file.ReadInt16(anim);
		int animOffset = animIndex + anim * MDL_SIZEOF_ANIMDESC;
		float fps = view_as<float>(MdlReadInt(file, animOffset + 8));
		int frames = MdlReadInt(file, animOffset + 16);

		sequences.SetValue(activity, s);
		FormatEx(key, sizeof(key), "%s#d", activity);
		sequences.SetValue(key, (frames > 1 && fps > 0.0) ? (frames - 1) / fps : 0.0);
	}
}

int MdlReadInt(File file, int offset)
{
	int value;
	file.Seek(offset, SEEK_SET);
	file.ReadInt32(value);
	return value;
}

void MdlReadString(File file, int offset, char[] buffer, int maxlength)
{
	file.Seek(offset, SEEK_SET);
	file.ReadString(buffer, maxlength, -1);
}

void StrToUpper(char[] buffer)
{
	for (int i = 0; buffer[i] != '\0'; i++)
		buffer[i] = CharToUpper(buffer[i]);
}

// "_LAYER" first, like ads_v1.987's LookupAnimations.
int FindScopeSequence(ModelScope scope, const char[] activity, float &duration)
{
	char key[72];
	int sequence;
	FormatEx(key, sizeof(key), "%s_LAYER", activity);
	if (!scope.sequences.GetValue(key, sequence))
	{
		strcopy(key, sizeof(key), activity);
		if (!scope.sequences.GetValue(key, sequence))
			return -1;
	}

	StrCat(key, sizeof(key), "#d");
	scope.sequences.GetValue(key, duration);
	return sequence;
}

// Current aim mode's anim, then ads_1st, then hip.
int FindFlipSequence(int client, ModelScope scope, bool open, float &duration)
{
	char activity[48];
	char suffix[16];
	strcopy(suffix, sizeof(suffix), open ? "MIXED_OFF" : "MIXED_ON");

	int sequence = -1;
	if (player[client].bZoom)
	{
		if (player[client].aimMode == AIM_MODE_2ND)
		{
			FormatEx(activity, sizeof(activity), "ACT_SECONDARY_VM_%s", suffix);
			sequence = FindScopeSequence(scope, activity, duration);
		}
		if (sequence == -1)
		{
			FormatEx(activity, sizeof(activity), "ACT_PRIMARY_VM_%s", suffix);
			sequence = FindScopeSequence(scope, activity, duration);
		}
	}
	if (sequence == -1)
	{
		FormatEx(activity, sizeof(activity), "ACT_VM_%s", suffix);
		sequence = FindScopeSequence(scope, activity, duration);
	}
	return sequence;
}

// Part the scope rests on outside a flip.
int GetSteadyScopePart(int client, int weapon, ModelScope scope)
{
	if (g_WeaponMixed[weapon])
		return scope.onOff;

	if (player[client].bZoom && player[client].aimMode == AIM_MODE_1ST)
		return scope.offOn;

	return scope.offOff;
}

void SetBodygroupPart(int entity, ModelScope scope, int part)
{
	int body = GetEntProp(entity, Prop_Send, "m_nBody");
	int current = (body / scope.base) % scope.numParts;
	if (current != part)
		SetEntProp(entity, Prop_Send, "m_nBody", body + (part - current) * scope.base);
}

// ads_v1.987 sets the part on both the weapon and the view model.
void SetScopePart(int weapon, int viewModel, ModelScope scope, int part)
{
	SetBodygroupPart(viewModel, scope, part);
	SetBodygroupPart(weapon, scope, part);
}

// Keeps the scope bodygroup on the part for hip / ads_1st / ads_2nd / flipped. A pending
// switch (ADS enter, mid-flip) waits for scopeDelaySwitch; otherwise the part is enforced
// every tick, so an engine reset of m_nBody (deploy) is undone at once.
void UpdateScopeBodygroup(int client, int weapon)
{
	int viewModel = GetWeaponViewModel(client, weapon);
	if (viewModel == -1)
		return;

	int id = GetViewModelScopeId(viewModel);
	if (id < 0)
		return;

	ModelScope scope;
	g_ModelScopes.GetArray(id, scope);

	float currentTime = GetGameTime();
	int ref = EntIndexToEntRef(weapon);
	if (player[client].scopeWeapon != ref)
	{
		player[client].scopeWeapon = ref;
		player[client].scopePart = -1;
		player[client].scopeDelaySwitch = 0.0;
		player[client].scopeTransformEnd = 0.0;
	}

	int target = GetSteadyScopePart(client, weapon, scope);
	if (target != player[client].scopePart)
	{
		if (player[client].scopeDelaySwitch <= 0.0)
		{
			bool enterAds = player[client].bZoom && player[client].scopePart != -1;
			player[client].scopeDelaySwitch = currentTime + (enterAds ? 0.1 : 0.0);
		}
		player[client].scopePart = target;
	}

	if (player[client].scopeDelaySwitch > 0.0)
	{
		if (currentTime < player[client].scopeDelaySwitch)
			return;
		player[client].scopeDelaySwitch = 0.0;
	}

	SetScopePart(weapon, viewModel, scope, target);
}

// Port of ads_v1.987's ScopeTransform. Does nothing while reloading, firing or mid-flip.
void HandleScopeFlip(int client, int weapon)
{
	int viewModel = GetWeaponViewModel(client, weapon);
	if (viewModel == -1)
		return;

	int id = GetViewModelScopeId(viewModel);
	if (id < 0)
		return;

	ModelScope scope;
	g_ModelScopes.GetArray(id, scope);
	if (!scope.magnifier)
		return;

	float currentTime = GetGameTime();
	if (GetEntProp(weapon, Prop_Send, "m_bInReload") != 0 || currentTime < player[client].scopeTransformEnd)
		return;

	// While ADS the plugin parks m_flNextPrimaryAttack far ahead and fires on primaryattacktime.
	float nextAttack = player[client].bZoom ? player[client].primaryattacktime : GetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack");
	if (currentTime < nextAttack)
		return;

	bool open = g_WeaponMixed[weapon];	// flipped away now -> MIXED_OFF brings the scope back
	float duration;
	int sequence = FindFlipSequence(client, scope, open, duration);
	if (sequence == -1)
		return;

	SetEntProp(viewModel, Prop_Send, "m_nLayerSequence", sequence);
	SetEntProp(viewModel, Prop_Send, "m_nLayer", 0);
	SetEntPropFloat(viewModel, Prop_Send, "m_flLayerStartTime", currentTime);

	g_WeaponMixed[weapon] = !open;
	player[client].scopeWeapon = EntIndexToEntRef(weapon);
	player[client].scopeTransformEnd = currentTime + duration;

	// Switch at once to avoid animation issues, then UpdateScopeBodygroup sets the steady
	// part at the point the part name asks for (e.g. _30 = 30% into the anim).
	int part;
	if (open)
		part = scope.fixOffOff;
	else
		part = (player[client].bZoom && player[client].aimMode == AIM_MODE_1ST) ? scope.fixOnOn : scope.fixOnOff;
	SetScopePart(weapon, viewModel, scope, part);
	player[client].scopePart = part;
	player[client].scopeDelaySwitch = currentTime + duration * (open ? scope.offDelay : scope.onDelay);

	// no firing until the flip anim ends
	if (player[client].bZoom)
	{
		if (player[client].primaryattacktime < player[client].scopeTransformEnd)
			player[client].primaryattacktime = player[client].scopeTransformEnd;
	}
	else
	{
		SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", player[client].scopeTransformEnd);
	}

	if (cvar.ads_debug)
		PrintToServer("[ADS] %N flip scope %s (sequence %d, %.2fs)", client, open ? "on" : "off", sequence, duration);

	return;
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

	AttributeMul mul;
	GetAttributeMul(classname, mul);
	for (int i = 0; i < WP_ATTR_COUNT; i++)
		player[client].attrMul[i] = mul.attr[i];

	float cycleTime = 0.0;

	if (GetEntProp(weapon, Prop_Send, "m_iWorldModelIndex") == g_scar_precache_index) 
		cycleTime = mul.cycleTime;
	else
    	cycleTime = view_as<float>(SDKCall(g_SDKCall_GetRateOfFire, weapon)) * mul.cycleTime;

	player[client].cycleTime = cycleTime;
	float currentTime = GetGameTime();
	player[client].primaryattacktime = currentTime + cycleTime;
}

// Scales the weapon's attributes (per the attribute_mul config) for exactly one shot.
// Safe despite the weapon-info database being global: the override window is the single
// SDKCall below, inside this client's own ItemPostFrame, and the game re-reads these
// fields at fire time. Values are read right before writing so we never fight another
// plugin (or a weapon_reparse) with a stale cached original.
void ApplyAdsAttributes(int client)
{
	g_bAttributeApplied	= false;

	for (int i = 0; i < WP_ATTR_COUNT; i++)
	{
		if (player[client].attrMul[i] == 1.0)
			continue;

		g_SavedAttributes[i] = L4D2_GetFloatWeaponAttribute(player[client].weaponClass, WP_ATTRS[i]);
		L4D2_SetFloatWeaponAttribute(player[client].weaponClass, WP_ATTRS[i], g_SavedAttributes[i] * player[client].attrMul[i]);
		g_bAttributeApplied = true;
	}
}

void RestoreAdsAttributes(int client)
{
	if (!g_bAttributeApplied) return;

	for (int i = 0; i < WP_ATTR_COUNT; i++)
	{
		if (player[client].attrMul[i] != 1.0)
			L4D2_SetFloatWeaponAttribute(player[client].weaponClass, WP_ATTRS[i], g_SavedAttributes[i]);
	}

	g_bAttributeApplied = false;
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
