// =======================================================================
// #region Information

/*========================================================================
==========================================================================

					P	E	R	K	M	O	D	2
					-----------------------------
						by tPoncho, aka tP

				   I owe a great deal of thanks to:

							Skorpion1976
							  Uyukio
							spiderlemur
								olj
							grandwazir

						and a special thanks to
							AtomicStryker

			and to everyone else in the Sourcemod community
					for feedback and support! ^^

- version 1.0:
		Initial release
- version 1.0.1:
		Changed code for Blind Luck with Doku's
- version 1.0.2:
		Attempted fix for outrageous health values for survivors.
		Fix for Double Tap not working on team switches.
- version 1.1:
		Replaced Speed Demon with Grasshopper.
		Included CVars to disable perks.
		Fix for various tank perks either not applying or applying too
			many times (double the trouble health multiplier).
		Added more info to perk CVars for min and max values allowed.
		Added in a CVar to disable plugin adjustments to survivor crawling.
		Changing teams to survivors should grant perks.
- version 1.1.1:
		Fixed Martial Artist not resetting fatigue.
		Removed	debug messages (oops!)
- version 1.2:
		New perk for Boomers - Motion Sickness, boosts movement speed and
			lets you run while vomiting.
		Reinstated Speed Demon (for hunters).
		Nerfed Metabolic Boost default value from 1.5 to 1.4.
		Nerfed Tongue Twister default values slightly (pull speed 1.75->1.5,
			shoot speed	1.75->1.5, range 1.75 unchanged).
		Unbreakable now gives bonus buffer on being revived.
		Hopefully fixed problem with unbreakable not applying sometimes.
		Hopefully fixed problem with second tank not spawning with Double
			Trouble.
		Minor fixes for (mostly) harmless server errors
- version 1.3:
		Double Trouble tanks can no longer be frustrated as long as	both
			are alive (band-aid solution to the disappearing-tank-when-both-
			tanks-are-alive-and-one-gets-frustrated problem).
		Pack Rat now gives ammo based on max ammo values set by the server
			instead of absolute values.
		Nerfed Dead Wreckening default value
			(damage multiplier 1.0 -> 0.5).
		Added in an option for players to pick random perks.
		Added in a CVar to force random perks on players every roundstart.
		Revised the show-menu code slightly to always show the initial
			"customize/playNOW!" menu on roundstarts.
		Revised some code so that disabling a perk that changes ConVars
			will make the plugin stop modifying those ConVars.
		Added in ConVars to selectively disable ConVar modifying for the
			perks Helping Hand and Blind Luck.
		Renamed	ConVar "l4d_perkmod_spirit_crawling" to
			"l4d_perkmod_spirit_enable_convarchanges" to keep the naming
			system consistent with the other new ConVar-change-permission
			ConVars.
- version 1.4:
		Revised Spirit so that self-reviving doesn't reset black-and-
			white health (thanks to AtomicStryker!). Self-reviving through
			Spirit won't increase the revive count towards black-and-white
			health,	however.
		Reduced default Spirit cooldown values
			(versus and survival 210s -> 150s, campaign 540s -> 240s).
		Bots now receive random perks. The pool of perks that bots can choose
			from can be adjusted with "l4d_perkmod_bot_<type> <range>".
			General format is "1,2,3,4,5", "3,2,5", etc.
		Added CVars to disable entire perk trees, which will stop all perks
			under that tree from working, and also hide	the perk tree from
			player menus.
		Revised perk code so that non-CVar-adjusting perks will also cease
			functioning if disabled in general.
		Fixed some code that was causing CVar-adjusting perks to adjust CVars
			even when disabled in game modes other than campaign.
		Added CVar to disable the player's option to randomize their perks
			("l4d_perkmod_randomperks_enable")
		Added missing code to when a player selects "Play NOW!" on the
			initial perk menu, which wasn't applying some perk benefits
			(thanks again, AtomicStryker!)
		Added an OnPluginEnd function.
- version 1.4.1:
		Fixed problems with never-ending music.
		Merged Speed Demon with Old School. Reduced Speed Demon to 1.4x and
			Old School to 3/6/12. CVar names are unchanged.
		Seemed to be some problems with damage adds. Fixed.
- version 1.4.2:
		Fixed PKT errors showing up on clients' console.
- version 2.0.0a:
		Support for L4D2.
		Pack Rat works with L4D2 guns.
- version 2.0.1a:
		Newer, shinier version for L4D2!
		Reorganized Survivor perks into three categories.
		Rebalanced Survivor perk values.
		Martial Artist (remake): now increases melee attack speed.
		Efficient Killer (remake): now deals a flat +50% damage bonus to all damage.
		Modified Pack Rat to also work with grenade launchers.
		Updated Pyrotechnician to include vomit jars.
		Updated Chem Reliant to include adrenaline shots.
		Changed Dead Wreckening to better handle rounding. If rounding error
			can occur (say it calculates 1.5 damage), then it will randomly
			choose either the higher or the lower (1 or 2).
		Fixed an issue with Spirit firing on tank deaths - no, Valve,
			tank deaths do NOT count as being incapped! ^^
		Adrenal Glands no longer increases rock travel speed.
		Spirit no longer allows crawling.
		Added some code so some perks should recognize when a survivor is being
			disabled by a charger (ie., spirit).
		Removed Old School and Speed Demon perks.
		Converted a few perks that reduce cooldowns to not use CVars. Some
			perks still use CVars - namely, Helping Hand (revive time),
			Tongue Twister (everything about it), Drag and Drop (manual
			release, drop-to-ground/recovery time)
		Rewrote some class checks to check actual netprop values instead
			of checking model names.
- version 2.0.2a:
		Fixed cooldown-reducing perks; most had stopped working with the last update.
		Twin Spitfire now activates properly for the first attack after spawning.
		After going AFK (in coop), the menu shouldn't reset perks for the player.
		The menu should appear somewhat more consistently.
		Martial Artist (remake): Now allows the player to swing melee weapons twice
			 rapidly in succession, and reduces the maximum shove penalty for any weapon.
		Extreme Conditioning (new): gives a survivor +10% run speed.
- version 2.0.3a:
		Reinstated Speed Demon perk for hunters.
		Fixed Sleight of Hand bug that prevented being able to shoot after reloading.
- version 2.0.4a:
		Added backwards compatibility for L4D1.
		Fixed some major bugs with Spirit. Spirit will no longer attempt to revive a
			player immediately after being incapped, which should increase the reliability
			of the perk functioning, but it means that if the last survivor standing
			gets incapped, even if that survivor or another survivor has spirit, too bad.
		Added some extra checks for Unbreakable to fix some rare abuses.
		Fixed Double Trouble not spawning the second tank.
		Double Trouble no longer stops tanks from becoming frustrated.
- version 2.0.5a:
		Attempted fixes for stability.
- version 2.0.6a:
		Another attempt at fixing stability.
- version 2.0.7a:
		Fixed error messages for Unbreakable and Sleight of Hand.
		Revised Twin Spitfire to be more consistent in giving two shots.
		Increased Helping Hand bonus health from 10 to 15.
		Increased Spirit bonus health from 0 to 10.
		Plugin will now attempt to load values from the .cfg file on round start, in
			addition to loading it on plugin load.
- version 2.0.8a:
		Revised menu code, should properly show a player that a perk is disabled.
		Fixed a bug with Hard to Kill.
- version 2.0.9:
		Added Cavalier perk for Jockeys: gives 60% more health.
		Changed Spirit so that a self-revive counts as a revive - meaning each self-revive
			moves you one step closer to black-and-white health.
		Increased Spirit self-revive health bonus from 10 to 30
		Fixed some bugs with Unbreakable, wasn't giving bonus health buffer on revive or
			after being rescued from the closet.
		Reduced Unbreakable bonus health buffer on revive from 16 to 10 (0.8 -> 0.5 of
			Unbreakable health bonus value).
		Helping Hand now gives bonus health buffer to the reviver as well.
		Reduced Helping Hand bonus buffer from 15 to 10 for versus.
		Lowered Double the Trouble health modifier from 0.6 to 0.45
		Lowered Body Slam minimum pounce damage from 11 to 10
		Lowered Efficient Killer damage bonus from 0.3 to 0.2
		Lowered Grasshopper pounce speed multiplier from 1.3 to 1.2
- version 2.0.10:
		Added Frogger perk for Jockeys: 20% more damage, 30% more leap distance.
		Added Ghost Rider perk for Jockeys: near invisibility.
		Added Speeding Bullet perk for Chargers: charges are 30% faster and longer.
		Modified Scattering Ram to also give 30% more health.
		Revised menu code again, shouldn't display disabled perks.
- version 2.0.11:
		Adrenal Glands now also makes the tank unfrustratable.
		Increased Frogger damage from 0.2 -> 0.35
		Fixed Helping Hand bug that wasn't giving the reviver bonus health buffer.
		Fixed bug/exploit with Chem Reliant/Pyrotechnician/Unbreakable on switching
			from AFK to non-AFK.
		Fixed Pack Rat bug/exploit and updated some old code.
- version 2.0.12:
		The plugin will no longer read from the cfg file on round start,
			was probably causing some buffer overflows...
		Fixed a few minor errors.
- version 2.1.0:
		Twin Spitfire, Adrenal Glands and other cooldown-reducing perks should now
			work properly on Linux servers (nobody told me the offsets were all weird
			between Linux and Windows servers =.=). Still don't have offset numbers for
			L4D1 Linux, so it won't work for L4D1 Linux until I can find those numbers...
		Being rescued from the closet now gives bonus items with the corresponding perks
			(grenades for Pyrotechnician, pills for Chem Reliant).
		Added translations! (basically stole AtomicStryker's work =P)
- version 2.1.1:
		Added Mega Adhesive perk to spitters: slows survivor speed by 50% for up to two seconds
			after leaving spit.
		Added Smoke IT! perk to smokers: can walk while smoking (thanks to Olj for this perk!)
		Added Little Leaguer perk to survivor-tertiary: gives a baseball bat.
		Saying !perks should work more consistently (but perks may still not work properly
			on local servers!)
- version 2.1.2:
		Updated Martial Artist to now give 3 swings instead of 2, and shoving or drawing the
			melee weapon no longer "counts" as a swing.
		Helping Hand should now be properly granting the reviver half the bonus health buffer
			as well (was previously only granting it to the revivee).
- version 2.1.3:
		Double Tap now has a 15% chance per shot that a bullet will not be consumed.
		Rewrote Pack Rat to address multiple bugs.
		Added a CVar "l4d_perkmod_autoshowmenu" to enable or disable automatically showing the
			perks menu on roundstart.
		Updated offsets for ability and attack timers, cooldown-reducing perks (ie. Twin Spitfire)
			and attack speed increase perks (ie. Adrenal Glands) should now work properly.
- version 2.1.4:
		Increased Twin Spitfire delay in-between spits from 2.5s -> 6s.
		Increased Mega-Adhesive slow from 50% -> 60%.
		Updated Pack Rat further, should be less buggy... with any luck.
- version 2.1.5:
		Rewrote some code, Mega Adhesive should no longer interfere with other movement-changing
			infected perks.
		Fixed an exploit with faster reloading for Double Tap.
		Updated Pack Rat again to address more bugs.
- version 2.2.0:
		Double Tap:
			Bonuses are now restricted to semi-automatics (ie. pistols, shotguns, snipers).
			Now has a cvar for increased reload speed (was experimenting around and realized this was overpowered,
				but I left the code in there for people to have fun with it :P l4d_perkmod_doubletap_rate_reload).
			No longer grants a chance to recover bullets (there was no tooltip for this previously, see version 2.1.3).
		Martial Artist:
			Is now a secondary perk.
			Shove penalty reduction is now removed by default (cvar is still there for adjustments).
		Pyrotechnician:
			Now gives a pipe bomb if the player does not carry a grenade for a set period of time. By default
				this is set to 120 seconds (adjust with l4d_perkmod_pyrotechnician_maxticks, disable by setting it to 0).
		Updated offsets for cooldown-reducing infected perks, should be working now (Twin Spitfire, Drag and Drop).
		Added cvars to enable or disable all infected or survivor perks:
			l4d_perkmod_perktree_survivor_enable
			l4d_perkmod_perktree_infected_enable
		Reduced default value for Chem Reliant bonus health buffer from 10 -> 0.
		Reduced default value for Double the Trouble health multiplier from 0.45 -> 0.35.
		Tweaked Spirit, hopefully should be less buggy.
		Fixed major bug with Barf Bagged interacting with bile jars.
		Fixed minor bug with Spitter perks not displaying properly.
		... Lukewarm, untested attempt at fixing rare (but highly game changing!) Smoke IT bug with tanks.
		KNOWN ISSUE: Adrenal glands doesn't work properly for punches.
- version 2.2.1
		Quick hotfix for Extreme Conditioning not applying sometimes.
- version 2.2.2
		Another quick hotfix, this time the ability cooldown perks shouldn't be broken with every patch.

- version 1.0.rw:
		Remove GameMode Tracking.
		Remove SI perks.
		Remove Survivor Primary Double Tap.
		Remove Survivor Tertiary Little Leaguer.
		QOL:
			Fix, Update Menu.
			Added Native Function.

- version 1.1.rw:
		Add Survivor Primary Christmas Gift.
		Add Survivor Secondary Pack Cat.
		Rewrite Survivor Tertiary Pack Rat.

==========================================================================
========================================================================*/

#define PLUGIN_VERSION "1.1.rw"
public Plugin:myinfo=
{
	name="PerkMod Rework",
	author="tPoncho, LQT",
	description="Adds Call Of Duty-style perks for L4D2",
	version=PLUGIN_VERSION,
	url=""
}

// #endregion
// =======================================================================

// =======================================================================
// #region Imports and Defines

#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <dhooks>
#include <left4dhooks>

#undef REQUIRE_PLUGIN
#tryinclude <l4d2_gifts>
#define REQUIRE_PLUGIN

#if !defined _l4d2_gifts_included_
	#define L4D2_GIFT_STANDARD	1
	#define L4D2_GIFT_SPECIAL	2
	native bool L4D2_Gifts_DropGift(int entity, int type = L4D2_GIFT_STANDARD);
#endif

// #endregion
// =======================================================================

// =======================================================================
// #region Variables

//=============================
// Declare Global Variables
//=============================

//init player perk vars
new g_iSur1[MAXPLAYERS+1];	//survivors, primary
new g_iSur2[MAXPLAYERS+1];	//survivors, secondary
new g_iSur3[MAXPLAYERS+1];	//survivors, tertiary
new g_iConfirm[MAXPLAYERS+1];	//check if perks are confirmed, to prevent mid-game changing abuses

//timer perks handle
new Handle:g_hTimerPerks = INVALID_HANDLE;

//SLEIGHT OF HAND PERK
//this keeps track of the default values for
//reload speeds for the different shotgun types
//NOTE: I got these values over testing earlier
//and since it's a waste of processing time to
//retrieve these values constantly, we just use
//the pre-retrieved values
//NOTE: updated for L4D2, pump and chrome have
//identical values
const Float:g_flSoHAutoS = 0.666666;
const Float:g_flSoHAutoI = 0.4;
const Float:g_flSoHAutoE = 0.675;
const Float:g_flSoHSpasS = 0.5;
const Float:g_flSoHSpasI = 0.375;
const Float:g_flSoHSpasE = 0.699999;
const Float:g_flSoHPumpS = 0.5;
const Float:g_flSoHPumpI = 0.5;
const Float:g_flSoHPumpE = 0.6;

//PYROTECHNICIAN PERK
//track how many grenades are carried for pyrotechnician perk
new g_iGren[MAXPLAYERS+1];
//used so functions don't confuse legitimate grenade pickups
//with acquisitions from grenadier perk
new g_iGrenThrow[MAXPLAYERS+1];
//used to track which type of grenade was used;
//1 = pipe, 2 = molotov
new g_iGrenType[MAXPLAYERS+1];
//used to track how many "ticks" have passed
//since we want to give pipe bombs after a given
//number of ticks
new g_iPyroTicks[MAXPLAYERS+1];
new g_iPyroRegisterIndex[MAXPLAYERS+1];
//and this tracks how many have DT
new g_iPyroRegisterCount = 0;

//MARTIAL ARTIST PERK
//similar to Double Tap
new g_iMARegisterIndex[MAXPLAYERS+1];
//and this tracks how many have MA
new g_iMARegisterCount = 0;
//these are similar to those used by Double Tap
new Float:g_flMANextTime[MAXPLAYERS+1];
new g_iMAEntid[MAXPLAYERS+1];
new g_iMAEntid_notmelee[MAXPLAYERS+1];
//this tracks the attack count, similar to twinSF
new g_iMAAttCount[MAXPLAYERS+1];

//SPIRIT PERK
//0 = not incapped
//1 = incapped
new g_iPIncap[MAXPLAYERS+1];
//used to keep track of whether cooldown is in effect
new g_iSpiritCooldown[MAXPLAYERS+1];
new Float:g_flSpiritCooldownEnd[MAXPLAYERS+1];
//used to track the timers themselves
new Handle:g_iSpiritTimer[MAXPLAYERS+1];

//PACK RAT PERK
//prevents perk from applying multiple times within a short interval
//ie. when two related events fire at the same time that both trigger PR
new bool:g_bPRalreadyApplying[MAXPLAYERS+1];

//contains id of target, for given disabler
new g_iMyDisableTarget[MAXPLAYERS+1];
//contains id of disabler, for given survivor
new g_iMyDisabler[MAXPLAYERS+1];


//VARS TO STORE CONVAR VALUES
//declare revive time var
float g_flReviveTime = -1.0;
//survivor_revive_duration, looked up once instead of going
//through FindConVar on every revive
ConVar g_hReviveDuration;
//OFFSETS
new g_iHPBuffO			= -1;
new g_iHPBuffTimeO		= -1;
new g_iRevCountO		= -1;
new g_iMeleeFatigueO	= -1;
new g_iNextPAttO		= -1;
new g_iActiveWO			= -1;
new g_iShotStartDurO	= -1;
new g_iShotInsertDurO	= -1;
new g_iShotEndDurO		= -1;
new g_iPlayRateO		= -1;
new g_iShotRelStateO	= -1;
new g_iNextAttO			= -1;
new g_iTimeIdleO		= -1;
new g_iLaggedMovementO	= -1;
new g_iVMStartTimeO		= -1;
new g_iViewModelO		= -1;
new g_iIncapO			= -1;
//new g_iClipO			= -1;

//these offsets refuse to be searched for (these netprops
//have unique names, but the SENDTABLE names are not unique - 
//usually DT_CountdownTimer, making it impossible to search
//for AFAIK...), so we'll just declare them here and hope
//Valve doesn't change them...

//these offsets are for L4D2, Windows
//-----------------------------
//windows and linux offsets are checked
//during roundstart by comparing an offset
//to known offset numbers

//prevents certain functions from spamming too often
new bool:g_bIsRoundStart	 = false;
new bool:g_bIsLoading		 = false;


//=============================
// Declare Variables Related to
// the Plugin's Own ConVars
//=============================
//first line says the name of the perk
//second line describes how many types there are
//ie:
//"one-size-fits-all" = one variable across all game modes and difficulties
//"versus, non-versus" = one variable for versus games, one for non-versus games
//"normal, hard, expert" = separate variables for normal-versus-survival, advanced and expert


//SUR1 PERKS
//stopping power, damage multiplier
//one-size-fits-all
ConVar g_hStopping_enable;
ConVar g_hStopping_dmgmult;
//associated var
int g_iStopping_enable;
float g_flStopping_dmgmult;

//sleight of hand, reload rate
//one-size-fits-all
ConVar g_hSoH_enable;
ConVar g_hSoH_rate;
//associated var
int g_iSoH_enable;
float g_flSoH_rate;

//pyrotechnician
ConVar g_hPyro_enable;
ConVar g_hPyro_maxticks;
//associated vars
int g_iPyro_enable;
int g_iPyro_maxticks;

//martial artist, movement rate
//campaign, non-campaign
ConVar g_hMA_enable;
ConVar g_hMA_maxpenalty;
//associated var
int g_iMA_enable;
int g_iMA_maxpenalty;

//christmas gift
ConVar g_hChristmas_enable;
//associated var
int g_iChristmas_enable;
//is the l4d2_gifts plugin loaded (it provides L4D2_Gifts_DropGift)
bool g_bAvailable_l4d2_gifts;

//SUR2 PERKS
//unbreakable, bonus hp
//one-size-fits-all
ConVar g_hUnbreak_enable;
ConVar g_hUnbreak_hp;
ConVar g_hUnbreak_hr;
//associated var
int g_iUnbreak_enable;
int g_iUnbreak_hp;
float g_fUnbreak_hr;

//spirit, bonus buffer and cooldown
//campaign, survival, versus
ConVar g_hSpirit_enable;
ConVar g_hSpirit_buff;
ConVar g_hSpirit_cd;
//associated vars
int g_iSpirit_enable;
int g_iSpirit_buff;
int g_iSpirit_cd;

//helping hand, bonus buffer and time multiplier
//versus, non-versus
ConVar g_hHelpHand_enable;
ConVar g_hHelpHand_convar;
ConVar g_hHelpHand_timemult;
ConVar g_hHelpHand_buff;
//associated vars
int g_iHelpHand_enable;
int g_iHelpHand_convar;
float g_flHelpHand_timemult;
int g_iHelpHand_buff;

//pack cat, ammo refill
ConVar g_hPackCat_enable;
ConVar g_hPackCat_ammorefill;
//associated vars
int g_iPackCat_enable;
float g_flPackCat_ammorefill;

//SUR3 PERKS
//pack rat, bonus ammo multiplier
//one-size-fits-all
ConVar g_hPack_enable;
ConVar g_hPack_ammomult;
ConVar g_hPack_extraclip;
//associated var
int g_iPack_enable;
float g_flPack_ammomult;
int g_iPack_extraclip;

//chem reliant, bonus buffer
//one-size-fits-all
ConVar g_hChem_enable;
ConVar g_hChem_buff;
//associated var
int g_iChem_enable;
int g_iChem_buff;

//hard to kill, hp multiplier
//one-size-fits-all
ConVar g_hHard_enable;
ConVar g_hHard_hpmult;
//associated var
int g_iHard_enable;
float g_flHard_hpmult;

//extreme conditioning, movement rate
//campaign, non-campaign
ConVar g_hExtreme_enable;
ConVar g_hExtreme_rate;
//associated var
int g_iExtreme_enable;
float g_flExtreme_rate;


//BOT CONTROLLER VARS
//these track the server's preference
//for what perks bots should use

//survivor
ConVar g_hBot_Sur1;
ConVar g_hBot_Sur2;
ConVar g_hBot_Sur3;
//DEFAULT PERKS
//These vars track the server's
//given default perks, to account
//for disabling perks

//sur1
ConVar g_hSur1_default;
int g_iSur1_default;
//sur2
ConVar g_hSur2_default;
int g_iSur2_default;
//sur3
ConVar g_hSur3_default;
int g_iSur3_default;

//this var keeps track of whether
//to enable Stopping or not, so we don't
//have to do the checks every game frame, or
//every time someone gets hurt

int g_iMA_meta_enable = 1;

//controls whether menu automatically shows
ConVar g_hMenuAutoShow_enable;

// #endregion
// =======================================================================

// =======================================================================
// #region Start

//=============================
// Hooking, Initialize Vars
//=============================

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion engine = GetEngineVersion();
	if( engine != Engine_Left4Dead2 )
	{
		strcopy(error, err_max, "Plugin only supports Left 4 Dead 2.");
		return APLRes_SilentFailure;
	}

	RegPluginLibrary("perkmod2");
	CreateNative("perkmod2_Pyro_OnWeaponFire", Native_Pyro_OnWeaponFire);

	MarkNativeAsOptional("L4D2_Gifts_DropGift");

	return APLRes_Success;
}

public void OnAllPluginsLoaded()
{
	g_bAvailable_l4d2_gifts = LibraryExists("l4d2_gifts");
}

public void OnLibraryAdded(const char[] name)
{
	g_bAvailable_l4d2_gifts = LibraryExists("l4d2_gifts");
}

public void OnLibraryRemoved(const char[] name)
{
	g_bAvailable_l4d2_gifts = LibraryExists("l4d2_gifts");
}

public OnPluginStart()
{
	//Plugin version for online tracking
	CreateConVar("l4d_perkmod_version", PLUGIN_VERSION, "Version of Perkmod2 for L4D2", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	
	//PERK FUNCTIONS
	//anything here that pertains to the actual
	//workings of the perks (ie, events and timers)

	// Player
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_first_spawn", Event_PlayerFirstSpawn);
	HookEvent("player_transitioned", Event_PlayerTransitioned);
	HookEvent("player_connect_full", Event_PConnect);
	HookEvent("player_disconnect", Event_PDisconnect);
	HookEvent("player_death", Event_PlayerDeath);

	// Round
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);

	// Sur1
	// Stopping Power
	HookEvent("player_hurt", Event_PlayerHurtPre, EventHookMode_Pre);
	HookEvent("infected_hurt", Event_InfectedHurtPre, EventHookMode_Pre);
	// Sleight of Hand
	HookEvent("weapon_reload", Event_Reload);
	// Pyrotechnician
	HookEvent("weapon_fire", Event_WeaponFire);

	// Sur2
	// Unbreakable
	HookEvent("heal_success", Event_PlayerHealed);
	HookEvent("survivor_rescued", Event_PlayerRescued);
	// Spirit
	HookEvent("player_team", Event_PlayerTeam);
	HookEvent("player_ledge_grab", Event_LedgeGrab);
	HookEvent("lunge_pounce", Event_PounceLanded);
	HookEvent("pounce_stopped", Event_PounceStop);
	HookEvent("tongue_grab", Event_TongueGrabPre, EventHookMode_Pre);
	HookEvent("tongue_release", Event_TongueRelease);
	HookEvent("tongue_broke_bent", Event_TongueRelease_novictimid);
	HookEvent("tongue_pull_stopped", Event_TongueRelease_newsmokerid);
	HookEvent("choke_end", Event_TongueRelease);
	HookEvent("choke_stopped", Event_TongueRelease_newsmokerid);
	HookEvent("jockey_ride", Event_JockeyRide);
	HookEvent("jockey_ride_end", Event_JockeyRideEnd);
	HookEvent("charger_pummel_start", Event_ChargerPummelStart);
	HookEvent("charger_pummel_end", Event_ChargerPummelEnd);
	// Helping Hand
	HookEvent("revive_begin", Event_ReviveBeginPre, EventHookMode_Pre);
	HookEvent("revive_success", Event_ReviveSuccess);
	// Pack Cat
	HookEvent("witch_killed", Event_WitchKilled);

	// Sur3
	// Pack Rat
	HookEvent("item_pickup", Event_ItemPickup);
	HookEvent("spawner_give_item", Event_ItemPickup);
	HookEvent("ammo_pickup", Event_AmmoPickup);
	HookEvent("receive_upgrade", Event_ReceiveUpgrade);
	// Chem Reliant
	HookEvent("pills_used", Event_PillsUsed, EventHookMode_Pre);
	HookEvent("adrenaline_used", Event_PillsUsed, EventHookMode_Pre);
	// Hard To Kill
	HookEvent("player_incapacitated", Event_Incap);

	RegConsoleCmd("sm_perks", MenuOpen_OnSay);
	RegConsoleCmd("sm_p", MenuOpen_OnSay);
	RegConsoleCmd("sm_perks_team", MenuTeam_OnSay);
	RegConsoleCmd("sm_o", MenuTeam_OnSay);

	//debug
	//RegConsoleCmd("say", Debug_OnSay);
	//RegConsoleCmd("say_team", Debug_OnSay);

	//init vars
	g_hReviveDuration	=	FindConVar("survivor_revive_duration");
	g_flReviveTime		=	g_hReviveDuration.FloatValue;

	//get offsets
	g_iHPBuffO			=	FindSendPropInfo("CTerrorPlayer","m_healthBuffer");
	g_iHPBuffTimeO		=	FindSendPropInfo("CTerrorPlayer","m_healthBufferTime");
	g_iRevCountO		=	FindSendPropInfo("CTerrorPlayer","m_currentReviveCount");
	g_iMeleeFatigueO	=	FindSendPropInfo("CTerrorPlayer","m_iShovePenalty");
	g_iNextPAttO		=	FindSendPropInfo("CBaseCombatWeapon","m_flNextPrimaryAttack");
	g_iActiveWO			=	FindSendPropInfo("CBaseCombatCharacter","m_hActiveWeapon");
	g_iShotStartDurO	=	FindSendPropInfo("CBaseShotgun","m_reloadStartDuration");
	g_iShotInsertDurO	=	FindSendPropInfo("CBaseShotgun","m_reloadInsertDuration");
	g_iShotEndDurO		=	FindSendPropInfo("CBaseShotgun","m_reloadEndDuration");
	g_iPlayRateO		=	FindSendPropInfo("CBaseCombatWeapon","m_flPlaybackRate");
	g_iShotRelStateO	=	FindSendPropInfo("CBaseShotgun","m_reloadState");
	g_iNextAttO			=	FindSendPropInfo("CTerrorPlayer","m_flNextAttack");
	g_iTimeIdleO		=	FindSendPropInfo("CTerrorGun","m_flTimeWeaponIdle");
	g_iLaggedMovementO	=	FindSendPropInfo("CTerrorPlayer","m_flLaggedMovementValue");
	g_iVMStartTimeO		=	FindSendPropInfo("CTerrorViewModel","m_flLayerStartTime");
	g_iViewModelO		=	FindSendPropInfo("CTerrorPlayer","m_hViewModel");
	g_iIncapO			=	FindSendPropInfo("CTerrorPlayer","m_isIncapacitated");
	//g_iClipO			=	FindSendPropInfo("CTerrorGun","m_iClip1");

	//CREATE AND INITIALIZE CONVARS
	//everything related to the convars that adjust
	//certain values for the perks
	CreateConvars();

	//finally, run a command to exec the .cfg file
	//to load the server's preferences for these cvars
	AutoExecConfig(true , "perkmod2");

	//and load translations
	LoadTranslations("plugin.perkmod");
}

// #endregion
// =======================================================================

// =======================================================================
// #region Convar Creation

//just to give me a bit less of a headache,
//all convar creation is called here
void CreateConvars()
{
	//SURVIVOR
	//stopping power
	g_hStopping_dmgmult = CreateConVar(
		"l4d_perkmod_stoppingpower_damagemultiplier" ,
		"0.25" ,
		"Stopping Power perk: Bonus damage multiplier, ADDED to base damage" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.05, true, 1.0 );

	g_hStopping_enable = CreateConVar(
		"l4d_perkmod_stoppingpower_enable" ,
		"1" ,
		"Stopping Power perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//sleight of hand
	g_hSoH_rate = CreateConVar(
		"l4d_perkmod_sleightofhand_rate" ,
		"0.5714" ,
		"Sleight of Hand perk: The interval incurred by reloading is multiplied by this value" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.02, true, 0.9 );

	g_hSoH_enable = CreateConVar(
		"l4d_perkmod_sleightofhand_enable" ,
		"1" ,
		"Sleight of Hand perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//pyrotechnician
	g_hPyro_maxticks = CreateConVar(
		"l4d_perkmod_pyrotechnician_maxticks" ,
		"60" ,
		"Pyrotechnician perk: The number of ticks (a tick is 2s) before giving a survivor a pipe bomb, ie. 60 ticks = 120 seconds. 0 disables this feature." ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 300.0 );

	g_hPyro_enable = CreateConVar(
		"l4d_perkmod_pyrotechnician_enable" ,
		"1" ,
		"Pyrotechnician perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//martial artist
	g_hMA_maxpenalty = CreateConVar(
		"l4d_perkmod_martialartist_maximumpenalty" ,
		"4" ,
		"Martial Artist perk: The maximum shove penalty applied to survivors, where 6 is the maximum shove penalty (~1.5s)" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 6.0 );

	g_hMA_enable = CreateConVar(
		"l4d_perkmod_martialartist_enable" ,
		"1" ,
		"Martial Artist perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//christmas gift
	g_hChristmas_enable = CreateConVar(
		"l4d_perkmod_christmasgift_enable" ,
		"1" ,
		"Christmas Gift perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//unbreakable
	g_hUnbreak_hp = CreateConVar(
		"l4d_perkmod_unbreakable_bonushealth" ,
		"20" ,
		"Unbreakable perk: Bonus health given for Unbreakable; this value is also given as bonus health buffer on being revived" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 1.0, true, 100.0 );

	g_hUnbreak_hr = CreateConVar(
		"l4d_perkmod_unbreakable_healrate" ,
		"0.8" ,
		"Unbreakable perk: The rate at which health is restored" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.8, true, 1.0 );

	g_hUnbreak_enable = CreateConVar(
		"l4d_perkmod_unbreakable_enable" ,
		"1" ,
		"Unbreakable perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//spirit
	g_hSpirit_buff = CreateConVar(
		"l4d_perkmod_spirit_bonusbuffer" ,
		"10" ,
		"Spirit perk: Bonus health buffer on self-revive" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 170.0 );

	g_hSpirit_cd = CreateConVar(
		"l4d_perkmod_spirit_cooldown" ,
		"60" ,
		"Spirit perk: Cooldown for self-reviving in seconds, campaign" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 1.0, true, 1800.0 );

	g_hSpirit_enable = CreateConVar(
		"l4d_perkmod_spirit_enable" ,
		"1" ,
		"Spirit perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//helping hand
	g_hHelpHand_timemult = CreateConVar(
		"l4d_perkmod_helpinghand_timemultiplier" ,
		"0.6" ,
		"Helping Hand perk: Time multiplier to revive others with Helping Hand" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.01, true, 1.0 );

	g_hHelpHand_buff = CreateConVar(
		"l4d_perkmod_helpinghand_bonusbuffer" ,
		"15" ,
		"Helping Hand perk: Bonus health buffer given to allies after reviving them, campaign/survival" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 1.0, true, 170.0 );

	g_hHelpHand_enable = CreateConVar(
		"l4d_perkmod_helpinghand_enable" ,
		"1" ,
		"Helping Hand perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled (NOTE: This perk normally adjusts the survivor_revive_duration ConVar; disabling this perk will stop the plugin from adjusting this ConVar)" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	g_hHelpHand_convar = CreateConVar(
		"l4d_perkmod_helpinghand_enable_convarchanges" ,
		"1" ,
		"Helping Hand perk: This perk normally adjusts the survivor_revive_duration ConVar; setting this to 0 will stop the plugin from adjusting this ConVar" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//pack cat
	g_hPackCat_ammorefill = CreateConVar(
		"l4d_perkmod_packcat_ammorefill" ,
		"0.04" ,
		"Pack Cat perk: Special Infected refill this amount of ammo" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.01, true, 0.25 );

	g_hPackCat_enable = CreateConVar(
		"l4d_perkmod_packcat_enable" ,
		"1" ,
		"Pack Cat perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//pack rat
	g_hPack_ammomult = CreateConVar(
		"l4d_perkmod_packrat_ammomultiplier" ,
		"0.25" ,
		"Pack Rat perk: Bonus ammo capacity, ADDED to base capacity" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.01, true, 1.0 );

	g_hPack_extraclip = CreateConVar(
		"l4d_perkmod_packrat_extraclip" ,
		"1" ,
		"Pack Rat perk: Bonus extra clips" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 1.0, true, 5.0 );

	g_hPack_enable = CreateConVar(
		"l4d_perkmod_packrat_enable" ,
		"1" ,
		"Pack Rat perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//chem reliant
	g_hChem_buff = CreateConVar(
		"l4d_perkmod_chemreliant_bonusbuffer" ,
		"0" ,
		"Chem Reliant perk: Bonus health buffer given when taking pills" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 150.0 );

	g_hChem_enable = CreateConVar(
		"l4d_perkmod_chemreliant_enable" ,
		"1" ,
		"Chem Reliant perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//hard to kill
	g_hHard_hpmult = CreateConVar(
		"l4d_perkmod_hardtokill_healthmultiplier" ,
		"0.5" ,
		"Hard to Kill perk: Bonus incap health multiplier, product is ADDED to base incap health" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.01, true, 3.0 );

	g_hHard_enable = CreateConVar(
		"l4d_perkmod_hardtokill_enable" ,
		"1" ,
		"Hard to Kill perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//extreme conditioning
	g_hExtreme_rate = CreateConVar(
		"l4d_perkmod_extremeconditioning_rate" ,
		"1.1" ,
		"Extreme Conditioning perk: Survivor movement is multiplied by this value" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 1.0, true, 1.5 );

	g_hExtreme_enable = CreateConVar(
		"l4d_perkmod_extremeconditioning_enable" ,
		"1" ,
		"Extreme Conditioning perk: Allows the perk to be chosen by players in campaign, 0=disabled, 1=enabled" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//MISC
	//bot preferences for perks
	g_hBot_Sur1 = CreateConVar(
		"l4d_perkmod_bot_survivor1" ,
		"1,2" ,
		"Bot preferences for Survivor 1 perks: 1 = stopping power, 2 = sleight of hand" ,
		FCVAR_SPONLY|FCVAR_NOTIFY );

	g_hBot_Sur2 = CreateConVar(
		"l4d_perkmod_bot_survivor2" ,
		"1,2,3" ,
		"Bot preferences for Survivor 2 perks: 1 = unbreakable, 2 = spirit, 3 = helping hand" ,
		FCVAR_SPONLY|FCVAR_NOTIFY );

	g_hBot_Sur3 = CreateConVar(
		"l4d_perkmod_bot_survivor3" ,
		"1,3" ,
		"Bot preferences for Survivor 3 perks: 1 = pack rat, 3 = hard to kill" ,
		FCVAR_SPONLY|FCVAR_NOTIFY );

	//default perks
	g_hSur1_default = CreateConVar(
		"l4d_perkmod_default_survivor1" ,
		"1" ,
		"Default selected perk for Survivor, Primary: 1 = stopping power, 2 = sleight of hand, 3 = pyrotechnician, 4 = martial artist, 5 = christmas gift" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 1.0, true, 5.0 );

	g_hSur2_default = CreateConVar(
		"l4d_perkmod_default_survivor2" ,
		"1" ,
		"Default selected perk for Survivor, Secondary: 1 = unbreakable, 2 = spirit, 3 = helping hand, 4 = pack cat" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 1.0, true, 4.0 );

	g_hSur3_default = CreateConVar(
		"l4d_perkmod_default_survivor3" ,
		"1" ,
		"Default selected perk for Survivor, Tertiary: 1 = pack rat, 2 = chem reliant, 3 = hard to kill" ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 1.0, true, 3.0 );

	//misc game convars
	g_hMenuAutoShow_enable = CreateConVar(
		"l4d_perkmod_autoshowmenu" ,
		"1" ,
		"If set to 1, the perks menu will automatically be shown at the start of every round." ,
		FCVAR_SPONLY|FCVAR_NOTIFY , true, 0.0, true, 1.0 );

	//every convar whose value is cached in a global refreshes
	//that global through one and the same callback
	g_hStopping_dmgmult.AddChangeHook(ConVarChanged);
	g_hStopping_enable.AddChangeHook(ConVarChanged);
	g_hSoH_rate.AddChangeHook(ConVarChanged);
	g_hSoH_enable.AddChangeHook(ConVarChanged);
	g_hPyro_maxticks.AddChangeHook(ConVarChanged);
	g_hPyro_enable.AddChangeHook(ConVarChanged);
	g_hMA_maxpenalty.AddChangeHook(ConVarChanged);
	g_hMA_enable.AddChangeHook(ConVarChanged);
	g_hChristmas_enable.AddChangeHook(ConVarChanged);
	g_hUnbreak_hp.AddChangeHook(ConVarChanged);
	g_hUnbreak_hr.AddChangeHook(ConVarChanged);
	g_hUnbreak_enable.AddChangeHook(ConVarChanged);
	g_hSpirit_buff.AddChangeHook(ConVarChanged);
	g_hSpirit_cd.AddChangeHook(ConVarChanged);
	g_hSpirit_enable.AddChangeHook(ConVarChanged);
	g_hHelpHand_timemult.AddChangeHook(ConVarChanged);
	g_hHelpHand_buff.AddChangeHook(ConVarChanged);
	g_hHelpHand_enable.AddChangeHook(ConVarChanged);
	g_hHelpHand_convar.AddChangeHook(ConVarChanged);
	g_hPackCat_ammorefill.AddChangeHook(ConVarChanged);
	g_hPackCat_enable.AddChangeHook(ConVarChanged);
	g_hPack_ammomult.AddChangeHook(ConVarChanged);
	g_hPack_extraclip.AddChangeHook(ConVarChanged);
	g_hPack_enable.AddChangeHook(ConVarChanged);
	g_hChem_buff.AddChangeHook(ConVarChanged);
	g_hChem_enable.AddChangeHook(ConVarChanged);
	g_hHard_hpmult.AddChangeHook(ConVarChanged);
	g_hHard_enable.AddChangeHook(ConVarChanged);
	g_hExtreme_rate.AddChangeHook(ConVarChanged);
	g_hExtreme_enable.AddChangeHook(ConVarChanged);
	g_hSur1_default.AddChangeHook(ConVarChanged);
	g_hSur2_default.AddChangeHook(ConVarChanged);
	g_hSur3_default.AddChangeHook(ConVarChanged);

	//start out in sync with the convar defaults; OnConfigsExecuted
	//syncs again once perkmod2.cfg and the server's cfgs have run
	GetCvars();
}

//=============================
// ConVar Changes
//=============================

//the convars are read constantly (some of them on every game frame),
//so their values are cached in globals instead of being fetched each time
void GetCvars()
{
	//sur1
	g_flStopping_dmgmult	=	g_hStopping_dmgmult.FloatValue;
	g_iStopping_enable		=	g_hStopping_enable.IntValue;
	g_flSoH_rate			=	g_hSoH_rate.FloatValue;
	g_iSoH_enable			=	g_hSoH_enable.IntValue;
	g_iPyro_maxticks		=	g_hPyro_maxticks.IntValue;
	g_iPyro_enable			=	g_hPyro_enable.IntValue;
	g_iMA_maxpenalty		=	g_hMA_maxpenalty.IntValue;
	g_iMA_enable			=	g_hMA_enable.IntValue;
	g_iChristmas_enable		=	g_hChristmas_enable.IntValue;

	//sur2
	g_iUnbreak_hp			=	g_hUnbreak_hp.IntValue;
	g_fUnbreak_hr			=	g_hUnbreak_hr.FloatValue;
	g_iUnbreak_enable		=	g_hUnbreak_enable.IntValue;
	g_iSpirit_buff			=	g_hSpirit_buff.IntValue;
	g_iSpirit_cd			=	g_hSpirit_cd.IntValue;
	g_iSpirit_enable		=	g_hSpirit_enable.IntValue;
	g_flHelpHand_timemult	=	g_hHelpHand_timemult.FloatValue;
	g_iHelpHand_buff		=	g_hHelpHand_buff.IntValue;
	g_iHelpHand_enable		=	g_hHelpHand_enable.IntValue;
	g_iHelpHand_convar		=	g_hHelpHand_convar.IntValue;
	g_flPackCat_ammorefill	=	g_hPackCat_ammorefill.FloatValue;
	g_iPackCat_enable		=	g_hPackCat_enable.IntValue;

	//sur3
	g_flPack_ammomult		=	g_hPack_ammomult.FloatValue;
	g_iPack_extraclip		=	g_hPack_extraclip.IntValue;
	g_iPack_enable			=	g_hPack_enable.IntValue;
	g_iChem_buff			=	g_hChem_buff.IntValue;
	g_iChem_enable			=	g_hChem_enable.IntValue;
	g_flHard_hpmult			=	g_hHard_hpmult.FloatValue;
	g_iHard_enable			=	g_hHard_enable.IntValue;
	g_flExtreme_rate		=	g_hExtreme_rate.FloatValue;
	g_iExtreme_enable		=	g_hExtreme_enable.IntValue;

	//default perks
	g_iSur1_default			=	g_hSur1_default.IntValue;
	g_iSur2_default			=	g_hSur2_default.IntValue;
	g_iSur3_default			=	g_hSur3_default.IntValue;
}

public void OnConfigsExecuted()
{
	GetCvars();
}

//the values are clamped by the convar bounds themselves, so all that's
//left to do here is to refresh the cache and to re-apply the perks that
//hand values out to players (movement speed and shove penalty)
public void ConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetCvars();

	if (convar == g_hMA_maxpenalty
		|| convar == g_hMA_enable)
	{
		MA_RunChecks();
		MA_Rebuild();
	}
	else if (convar == g_hExtreme_rate
		|| convar == g_hExtreme_enable)
		Extreme_Rebuild();
}

// #endregion
// =======================================================================



// =======================================================================
// #region Events

//====================================================
//====================================================
//					P	E	R	K	S
//====================================================
//====================================================



//=============================
// Events Directly related to perks
//=============================

//** a very important event! =P
public Event_PlayerSpawn (Handle:event, const String:name[], bool:dontBroadcast)
{
	//stop if game hasn't finished loading
	if (g_bIsLoading == true
		|| g_bIsRoundStart == true)
		return;

	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));

	//show the perk menu if their perks are unconfirmed
	if (IsClientInGame(iCid)==true
		&& IsFakeClient(iCid)==false
		&& g_iConfirm[iCid]==0)
		CreateTimer(3.0,Timer_ShowTopMenu,iCid);

	SetEntDataFloat(iCid,g_iLaggedMovementO, 1.0 ,true);

	new iTeam = GetClientTeam(iCid);

	//check survivors for max health
	//they probably don't have any confirmed perks
	//since they just spawned, so set max to 100
	if (iTeam == 2)
	{
		if ( GetEntProp(iCid,Prop_Data,"m_iHealth") > 100 )
			SetEntProp(iCid,Prop_Data,"m_iHealth", 100 );

		//set survivor bot's perks
		if (IsFakeClient(iCid)==true)
		{
			g_iConfirm[iCid]=1;
			g_iSur1[iCid] = Bot_Sur1_PickRandom();
			g_iSur2[iCid] = Bot_Sur2_PickRandom();
			g_iSur3[iCid] = Bot_Sur3_PickRandom();

			//----DEBUG----
			//PrintToChatAll("\x03survivor bot 1: \x01%i\x03, 2:\x01%i",g_iSur1[iCid],g_iSur2[iCid]);
		}

		//----DEBUG----
		//PrintToChatAll("\x03spawned survivor \x01%i\x03 health \x01%i", iCid, GetEntProp(iCid,Prop_Data,"m_iHealth") );

		return;
	}

	if (iTeam == 3)
	{
		g_iConfirm[iCid] = 0;
		return;
	}
}

//call menu on first spawn, otherwise set default values for bots
public Event_PlayerFirstSpawn (Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_bIsLoading == true || g_bIsRoundStart == true) return;

	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;

	if (GetClientTeam(iCid) == 3) return;

	if (g_iConfirm[iCid]==0 && IsFakeClient(iCid)==false)
	{
		CreateTimer(3.0,Timer_ShowTopMenu,iCid);
		PrintToChat(iCid,"\x03[SM] %t", "MessageChatWelcome");
	}
}

//sets confirm to 0 and redisplays perks menu
public Event_PlayerTransitioned (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;
	//reset their confirm perks var
	//and show the menu
	g_iConfirm[iCid]=0;
	/*CreateTimer(1.0,Timer_ShowTopMenu,iCid);
	//since we just changed maps
	//reset everything for the spirit cooldown timer
	if (g_iSpiritTimer[iCid]!=INVALID_HANDLE)
	{
		KillTimer(g_iSpiritTimer[iCid]);
		g_iSpiritTimer[iCid]=INVALID_HANDLE;
	}*/
}

//set default perks for connecting players
public Event_PConnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	//stop if game is loading
	if (g_bIsLoading == true
		|| g_bIsRoundStart == true)
		return;

	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;

	//if any of the perks are set to 0, set default values
	if (g_iSur1[iCid]==0)
		g_iSur1[iCid] = g_iSur1_default;
	if (g_iSur2[iCid]==0)
		g_iSur2[iCid] = g_iSur2_default;
	if (g_iSur3[iCid]==0)
		g_iSur3[iCid] = g_iSur3_default;
	g_iConfirm[iCid]=0;
	g_iMyDisabler[iCid] = -1;
	g_iMyDisableTarget[iCid] = -1;
	g_iPIncap[iCid]=0;
	g_iSpiritCooldown[iCid]=0;
	g_flSpiritCooldownEnd[iCid]=0.0;
	g_iGren[iCid]=0;
	g_iGrenThrow[iCid]=0;
	g_iGrenType[iCid]=0;
	g_iPyroTicks[iCid]=0;

}

//reset perk values when disconnected
//closes timer for spirit cooldown
//and rebuilds DT registry
public Event_PDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_bIsLoading == true
		|| g_bIsRoundStart == true)
		return;

	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;
	g_iSur1[iCid]=0;
	g_iSur2[iCid]=0;
	g_iSur3[iCid]=0;
	g_iConfirm[iCid]=0;
	g_iGren[iCid]=0;
	g_iGrenThrow[iCid]=0;
	g_iGrenType[iCid]=0;
	g_iPyroTicks[iCid]=0;
	g_iMyDisabler[iCid] = -1;
	g_iMyDisableTarget[iCid] = -1;
	g_iPIncap[iCid]=0;
	g_iSpiritCooldown[iCid]=0;
	g_flSpiritCooldownEnd[iCid]=0.0;

	if (g_iSpiritTimer[iCid]!=INVALID_HANDLE)
	{
		KillTimer(g_iSpiritTimer[iCid]);
		g_iSpiritTimer[iCid]=INVALID_HANDLE;
	}
	RebuildAll();
}

//resets some temp vars related to perks
public Event_PlayerDeath (Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_bIsLoading == true
		|| g_bIsRoundStart == true)
		return;

	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;
	//reset vars related to spirit perk
	g_iMyDisabler[iCid] = -1;
	g_iMyDisableTarget[iCid] = -1;
	g_iPIncap[iCid]=0;
	g_iSpiritCooldown[iCid]=0;
	g_flSpiritCooldownEnd[iCid]=0.0;
	//and also close the spirit cooldown timer
	//and nullify the var pointing to it
	if (g_iSpiritTimer[iCid]!=INVALID_HANDLE)
	{
		KillTimer(g_iSpiritTimer[iCid]);
		g_iSpiritTimer[iCid]=INVALID_HANDLE;
	}

	//rebuild registries for martial artist
	RebuildAll();

	//and while we're at it, the player just died so reset pyro's tick count
	g_iPyroTicks[iCid] = 0;

	//reset movement rate from martial artist
	SetEntDataFloat(iCid,g_iLaggedMovementO, 1.0 ,true);


	//----DEBUG----
	//PrintToChatAll("\x03end death routine for \x01%i",iCid);

	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (attacker == 0) return;
	if (attacker != iCid && GetClientTeam(iCid) == 3)
	{
		ChristmasGift_OnInfectedKilled(iCid, attacker);
		PC_GiveFullAmmo(attacker);
	}
}

//checks to show perks menu on roundstart
//and resets various vars to default
public Event_RoundStart (Handle:event, const String:name[], bool:dontBroadcast)
{
	//tell plugin to not run this function repeatedly until we're done
	if (g_bIsRoundStart == true)
		return;
	else
		g_bIsRoundStart = true;

	//AutoExecConfig(false , "perkmod");

	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		//----DEBUG----
		//PrintToChatAll("\x03-cycle %i",iI);

		//reset vars related to spirit perk
		g_iPIncap[iI]=0;
		g_iSpiritCooldown[iI]=0;
		g_flSpiritCooldownEnd[iI]=0.0;
		//reset var related to pack rat perk
		g_bPRalreadyApplying[iI] = false;
		//reset var related to various hunter/smoker perks
		g_iMyDisabler[iI] = -1;
		g_iMyDisableTarget[iI] = -1;

		//reset var pointing to client's spirit timer
		//and close the timer handle
		if (g_iSpiritTimer[iI]!=INVALID_HANDLE)
		{
			KillTimer(g_iSpiritTimer[iI]);
			g_iSpiritTimer[iI]=INVALID_HANDLE;
		}

		//before we run any functions on players
		//check if the game has any players to prevent
		//stupid error messages cropping up on the server
		if (IsServerProcessing()==false)
			continue;

		//only run these commands if player is in-game
		if (IsClientInGame(iI)==true)
		{
			//reset run speeds for martial artist
			SetEntityMoveType(iI, MOVETYPE_CUSTOM);
			SetEntDataFloat(iI,g_iLaggedMovementO, 1.0 ,true);

			if (IsFakeClient(iI)==true) continue;
			//show the perk menu if their perks are unconfirmed
			if (g_iConfirm[iI]==0)
				CreateTimer(3.0,Timer_ShowTopMenu,iI);
		}

	}

	//reset tongue vars

	//reset tank attack intervals
	//and rock throw force

	//finally, clear DT and MA registry
	ClearAll();
	//recalculate DT and stopping power
	//permissions on game frame
	RunChecksAll();

	//start global timer that
	//forces bots to have some perks
	//among other things
	if (g_hTimerPerks != INVALID_HANDLE)
	{
		KillTimer(g_hTimerPerks);
		g_hTimerPerks = INVALID_HANDLE;
	}
	g_hTimerPerks = CreateTimer(2.0,TimerPerks,0,TIMER_REPEAT);

	//finally, tell plugin that loading is over and that roundstart can run again
	g_bIsRoundStart = false;
	g_bIsLoading = false;

	//----DEBUG----
	//PrintToChatAll("\x03-end round start routine");
}

//resets everyone's confirm values on round end, mainly for survival and campaign
public Event_RoundEnd (Handle:event, const String:name[], bool:dontBroadcast)
{
	//----DEBUG----
	//PrintToChatAll("round end detected");

	ClearAll();

	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		g_iConfirm[iI]=0;
	}

	if (g_hTimerPerks != INVALID_HANDLE)
	{
		KillTimer(g_hTimerPerks);
		g_hTimerPerks = INVALID_HANDLE;
	}

	//tells plugin we're about to start loading
	g_bIsLoading = true;
}

//this trigger only runs on players, not common infected
public Action:Event_PlayerHurtPre (Handle:event, const String:name[], bool:dontBroadcast)
{
	int iAttacker=GetClientOfUserId(GetEventInt(event,"attacker"));
	int iVictim=GetClientOfUserId(GetEventInt(event,"userid"));

	if (IsInvalidClient(iAttacker)) return Plugin_Continue;
	if (IsInvalidClient(iVictim)) return Plugin_Continue;

	if (IsEnable_SurvivorPrimary_StoppingPower()
		&& IsClientConfirm(iAttacker)
		&& IsClientSelect_SurvivorPrimary_StoppingPower(iAttacker))
	{
		//the bonus damage is written straight into m_iHealth, which bypasses
		//the game's own damage handling - so it must only ever hit non-survivors.
		//with friendly fire on, applying it to a teammate can drop their health
		//to 0 or below, and the game then kills them outright instead of
		//putting them into the incapacitated state
		if (GetClientTeam(iAttacker)==2
			&& GetClientTeam(iVictim)!=2)
		{
			int hp = GetEntProp(iVictim,Prop_Data,"m_iHealth");
			if (hp<=1)
				return Plugin_Continue;

			int dmg_health=GetEventInt(event,"dmg_health");
			int damage_add = RoundToNearest(dmg_health * g_flStopping_dmgmult);

			//and for the same reason the victim is never taken below 1hp:
			//the kill has to come from the game, not from this write
			if (damage_add >= hp)
				damage_add = hp-1;

			SetEntProp(iVictim,Prop_Data,"m_iHealth", hp - damage_add);
		}
	}

	return Plugin_Continue;
}

//against common infected
public Event_InfectedHurtPre (Handle:event, const String:name[], bool:dontBroadcast)
{
	int iAttacker=GetClientOfUserId(GetEventInt(event,"attacker"));
	if (IsInvalidClient(iAttacker)) return;

	if (IsEnable_SurvivorPrimary_StoppingPower()
		&& IsClientConfirm(iAttacker)
		&& IsClientSelect_SurvivorPrimary_StoppingPower(iAttacker))
	{
		if (GetClientTeam(iAttacker)==2)
		{
			int target=GetEventInt(event,"entityid");
			char target_classname[32];
			GetEntityClassname(target, target_classname, sizeof(target_classname));
			if (strcmp(target_classname, "infected") != 0 && strcmp(target_classname, "witch") != 0) return;

			int damage=GetEventInt(event,"amount");
			int damage_add = RoundToNearest(damage * g_flStopping_dmgmult);
			int hp = GetEntProp(target,Prop_Data,"m_iHealth");
			SetEntProp(target,Prop_Data,"m_iHealth", hp - damage_add);
		}
	}
}

//on reload
public Event_Reload (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0)
		return;

	SoH_OnReload(iCid);
}

//on weapon fire
public Event_WeaponFire (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0)
		return;

	decl String:stWpn[24];
	GetEventString(event,"weapon",stWpn,24);

	Pyro_OnWeaponFire(iCid,stWpn);
}

//called when player is healed
public Event_PlayerHealed (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"subject"));
	if (iCid==0 || g_iConfirm[iCid]==0) return;

	Unbreakable_OnHeal(iCid);
}

//called when survivor spawns from closet
public Event_PlayerRescued (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"victim"));
	if (iCid==0 || g_iConfirm[iCid]==0)
		return;

	//reset vars related to spirit perk
	g_iMyDisabler[iCid] = -1;
	g_iPIncap[iCid]=0;
	g_iSpiritCooldown[iCid]=0;
	//rebuilds pyrotechnician registry
	CreateTimer(0.3,Delayed_Rebuild,0);

	//checks for unbreakable health bonus
	Unbreakable_OnRescue(iCid);
	//check for pyrotechnician bonus grenade
	Event_Confirm_Grenadier (iCid);
	//check for chem reliant bonus pills
	Event_Confirm_ChemReliant(iCid);
}

//called on a player changing teams
//and rebuilds DT registry (and MA as well)
public Event_PlayerTeam (Handle:event, const String:name[], bool:dontBroadcast)
{
	//----DEBUG----
	//PrintToChatAll("\x03change team detected");

	if (g_bIsLoading == true
		|| g_bIsRoundStart == true)
		return;

	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0
		|| IsValidEntity(iCid)==false
		|| IsClientInGame(iCid)==false) return;

	//reset vars related to spirit perk
	g_iPIncap[iCid]=0;
	g_iSpiritCooldown[iCid]=0;
	//reset var related to various hunter/smoker perks
	g_iMyDisabler[iCid] = -1;
	g_iMyDisableTarget[iCid] = -1;

	//reset var pointing to client's spirit timer
	//and close the timer handle
	if (g_iSpiritTimer[iCid]!=INVALID_HANDLE)
	{
		KillTimer(g_iSpiritTimer[iCid]);
		g_iSpiritTimer[iCid]=INVALID_HANDLE;
	}

	//reset runspeed
	SetEntDataFloat(iCid,g_iLaggedMovementO, 1.0 ,true);

	//rebuild MA and DT registries
	CreateTimer(0.3,Delayed_Rebuild,0);

	//only allow changes of perks if team change was
	//to or from the infected team (implying it's versus)
	if (GetEventInt(event,"team")==3
		|| GetEventInt(event,"oldteam")==3)
	{
		g_iConfirm[iCid]=0;
		CreateTimer(1.0,Timer_ShowTopMenu,iCid);
		//apply perks if changing into survivors
		CreateTimer(0.3,Delayed_PerkChecks,iCid);
	}

	//----DEBUG----
	//PrintToChatAll("\x03-end change team routine");
}

//detects when a person is hanging from a ledge
public Event_LedgeGrab (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));

	if (iCid==0) return;

	//----DEBUG----
	//PrintToChatAll("\x03spirit ledge grab detected, client: \x01%i",iCid);

	g_iPIncap[iCid]=1;
	g_iMyDisabler[iCid] = 0;
}

public Event_PounceLanded (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iAtt=GetClientOfUserId(GetEventInt(event,"userid"));
	new iVic=GetClientOfUserId(GetEventInt(event,"victim"));

	if (iVic==0 || iAtt==0) return;

	//----DEBUG----
	//PrintToChatAll("\x03pounce land detected, client: \x01%i\x03, victim: \x01%i",iAtt,iVic);

	//spirit victim state is disabled by hunter
	g_iMyDisabler[iVic] = iAtt;
	//+Inf, attacker is disabling someone
	g_iMyDisableTarget[iAtt] = iVic;
}

public Event_PounceStop (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iAtt=GetClientOfUserId(GetEventInt(event,"userid"));
	new iVic=GetClientOfUserId(GetEventInt(event,"victim"));

	if (iVic==0 || iAtt==0) return;

	//----DEBUG----
	//PrintToChatAll("\x03pounce stop detected, attacker: \x01%i\x03, victim: \x01%i",iAtt,iVic);

	//victim is no longer disabled
	g_iMyDisabler[iVic] = -1;
	//+Inf, attacker no longer disabling
	g_iMyDisableTarget[iAtt] = -1;
}

public Action:Event_TongueGrabPre (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	new iVic = GetClientOfUserId(GetEventInt(event,"victim"));
	if (iCid==0) return Plugin_Continue;

	//spirit perk, tell plugin player is disabled by smoker
	g_iMyDisabler[iVic] = iCid;
	//+Inf, tell plugin attacker is disabling
	g_iMyDisableTarget[iCid] = iVic;

	return Plugin_Continue;
}

public Event_TongueRelease (Handle:event, const String:name[], bool:dontBroadcast)
{
	//+Inf, tell plugin attacker is no longer disabling
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid!=0) g_iMyDisableTarget[iCid] = -1;
	//tell plugin player is free
	new iVic=GetClientOfUserId(GetEventInt(event,"victim"));
	if (iVic!=0) g_iMyDisabler[iVic] = -1;
}

public Event_TongueRelease_novictimid (Handle:event, const String:name[], bool:dontBroadcast)
{
	//+Inf, tell plugin attacker is no longer disabling
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid!=0) g_iMyDisableTarget[iCid] = -1;
	//tell plugin player is free
	//new iVic=GetClientOfUserId(GetEventInt(event,"victim"));
	//if (iVic!=0) g_iMyDisabler[iVic] = -1;
}

public Event_TongueRelease_newsmokerid (Handle:event, const String:name[], bool:dontBroadcast)
{
	//+Inf, tell plugin attacker is no longer disabling
	new iCid=GetClientOfUserId(GetEventInt(event,"smoker"));
	if (iCid!=0) g_iMyDisableTarget[iCid] = -1;
	//tell plugin player is free
	new iVic=GetClientOfUserId(GetEventInt(event,"victim"));
	if (iVic!=0) g_iMyDisabler[iVic] = -1;
}

public Event_JockeyRide (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iAtt=GetClientOfUserId(GetEventInt(event,"userid"));
	new iVic=GetClientOfUserId(GetEventInt(event,"victim"));

	if (iVic==0 || iAtt==0) return;

	//----DEBUG----
	//PrintToChatAll("\x03ride start detected, client: \x01%i\x03, victim: \x01%i",iAtt,iVic);

	//spirit victim state is disabled
	g_iMyDisabler[iVic] = iAtt;
	//+Inf, attacker is disabling someone
	g_iMyDisableTarget[iAtt] = iVic;
}

public Event_JockeyRideEnd (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iAtt=GetClientOfUserId(GetEventInt(event,"userid"));
	new iVic=GetClientOfUserId(GetEventInt(event,"victim"));

	if (iVic==0 || iAtt==0) return;

	//----DEBUG----
	//PrintToChatAll("\x03ride end detected, attacker: \x01%i\x03, victim: \x01%i",iAtt,iVic);

	//victim is no longer disabled
	g_iMyDisabler[iVic] = -1;
	//+Inf, attacker no longer disabling
	g_iMyDisableTarget[iAtt] = -1;

	//since ride like the wind changes the survivor's speeds,
	//reapply extreme conditioning if necessary
	CreateTimer(0.3,Delayed_Rebuild,0);
}

public Event_ChargerPummelStart (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iAtt=GetClientOfUserId(GetEventInt(event,"userid"));
	new iVic=GetClientOfUserId(GetEventInt(event,"victim"));

	if (iVic==0 || iAtt==0) return;

	//----DEBUG----
	//PrintToChatAll("\x03ride start detected, client: \x01%i\x03, victim: \x01%i",iAtt,iVic);

	//spirit victim state is disabled
	g_iMyDisabler[iVic] = iAtt;
	//+Inf, attacker is disabling someone
	g_iMyDisableTarget[iAtt] = iVic;
}

public Event_ChargerPummelEnd (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iAtt=GetClientOfUserId(GetEventInt(event,"userid"));
	new iVic=GetClientOfUserId(GetEventInt(event,"victim"));

	if (iVic==0 || iAtt==0) return;

	//----DEBUG----
	//PrintToChatAll("\x03ride end detected, attacker: \x01%i\x03, victim: \x01%i",iAtt,iVic);

	//victim is no longer disabled
	g_iMyDisabler[iVic] = -1;
	//+Inf, attacker no longer disabling
	g_iMyDisableTarget[iAtt] = -1;
}

//on revive begin
public Action:Event_ReviveBeginPre (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));

	if (iCid==0) return Plugin_Continue;

	HelpHand_OnReviveBegin (iCid);

	return Plugin_Continue;
}

//on revive end
public Event_ReviveSuccess (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	new iSub=GetClientOfUserId(GetEventInt(event,"subject"));

	if (iCid==0 || iSub==0) return;

	new iLedge=GetEventInt(event,"ledge_hang");
	//player is labelled as no longer incapped
	g_iPIncap[iSub]=0;

	Unbreakable_OnRevive(iSub, iLedge);
	HelpHand_OnReviveSuccess(iCid,iSub,iLedge);
}

public Event_WitchKilled (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;

	ChristmasGift_OnWitchKilled(GetEventInt(event,"witchid"));
	PC_GiveFullAmmo(iCid);
}

//if item that was picked up is a grenade type, set carried amount in var
public Event_ItemPickup (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;

	new String:stWpn[24];
	GetEventString(event,"item",stWpn,24);

	//check for grenadier perk
	Pyro_Pickup(iCid,stWpn);

	//check for pack rat perk
	if (IsPrimaryWeapon(stWpn)) PR_GiveFullAmmo(iCid);
}

//on ammo pickup, check if pack rat is in effect
public Event_AmmoPickup (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;

	PR_GiveFullAmmo(iCid);
}

public Event_ReceiveUpgrade (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));
	if (iCid==0) return;

	char upgrade[128];
	GetEventString(event,"upgrade",upgrade,128);

	// == (INCENDIARY_AMMO or EXPLOSIVE_AMMO)
	if (!StrEqual(upgrade,"LASER_SIGHT",false)) PR_GiveFullAmmo(iCid, g_iPack_extraclip);
}

//on drug use
public Action:Event_PillsUsed (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"subject"));
	if (iCid==0) return Plugin_Continue;

	Chem_OnDrugUsed(iCid);

	return Plugin_Continue;
}

public Event_Incap (Handle:event, const String:name[], bool:dontBroadcast)
{
	new iCid=GetClientOfUserId(GetEventInt(event,"userid"));

	if (iCid==0) return;

	if (GetClientTeam(iCid) == 2
		&& GetEntData(iCid,g_iIncapO) != 0 )
		g_iPIncap[iCid]=1;

	HardToKill_OnIncap(iCid);
}

//on game frame
public OnGameFrame()
{
	//if frames aren't being processed,
	//don't bother - otherwise we get LAG
	//or even disconnects on map changes, etc...
	
	if (IsServerProcessing()==false
		|| g_bIsLoading == true
		|| g_bIsRoundStart == true)
		return;

	MA_OnGameFrame();
}

//as round end function above
public OnMapEnd()
{
	//----DEBUG----
	//PrintToChatAll("map end detected");

	ClearAll();

	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		g_iConfirm[iI]=0;
	}

	if (g_hTimerPerks != INVALID_HANDLE)
	{
		KillTimer(g_hTimerPerks);
		g_hTimerPerks = INVALID_HANDLE;
	}

	//tells plugin we're about to start loading
	g_bIsLoading = true;
}

//called when plugin is unloaded
//reset all the convars that had permission to run
public OnPluginEnd()
{
	g_bIsRoundStart = true;
	g_bIsLoading = true;

	//----DEBUG----
	//PrintToChatAll("\x03begin pluginend routine");

	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		//reset var pointing to client's spirit timer
		//and close the timer handle
		if (g_iSpiritTimer[iI]!=INVALID_HANDLE)
		{
			KillTimer(g_iSpiritTimer[iI]);
			g_iSpiritTimer[iI]=INVALID_HANDLE;
		}

		//before we run any functions on players
		//check if the game has any players to prevent
		//stupid error messages cropping up on the server
		if (IsServerProcessing()==false)
			continue;

		//only run these commands if player is in-game
		if (IsClientInGame(iI)==true)
		{
			//reset run speeds for martial artist
			SetEntDataFloat(iI,g_iLaggedMovementO, 1.0 ,true);
		}

	}

	//reset tongue vars

	//finally, clear DT and MA registry
	ClearAll();

	if (g_hTimerPerks != INVALID_HANDLE)
		KillTimer(g_hTimerPerks);
	g_hTimerPerks = INVALID_HANDLE;

	g_bIsRoundStart = false;
	g_bIsLoading = false;

	//----DEBUG----
	//PrintToChatAll("\x03-end pluginend routine");
}

//Anything that uses a global timer for periodic
//checks is also called here; current functions called here:
//Sur2: Spirit
//Sur1: Pyrotechnician
//NOTE: called every 2 seconds
public Action:TimerPerks (Handle:timer, any:data)
{
	//if (IsServerProcessing()==false)
	//{
		//KillTimer(timer);
		//g_hTimerPerks = INVALID_HANDLE;
		//return Plugin_Stop;
	//}

	Spirit_Timer();
	Pyro_Timer();
	ShowPerkCooldownHint();

	return Plugin_Continue;
}

ShowPerkCooldownHint()
{
	if (IsServerProcessing()==false)
		return;

	for (new iCid=1 ; iCid<=MaxClients ; iCid++)
	{
		if (IsClientInGame(iCid)==false
			|| IsPlayerAlive(iCid)==false
			|| GetClientTeam(iCid)!=2
			|| IsFakeClient(iCid)==true
			|| g_iConfirm[iCid]==0)
		{
			continue;
		}

		new iPyroRemain=0;
		new iSpiritRemain=0;

		if (g_iPyro_enable==1
			&& g_iPyro_maxticks > 0
			&& g_iSur1[iCid]==3)
		{
			new iAmmoO=FindDataMapInfo(iCid,"m_iAmmo");
			new bool:bHasGrenade = false;
			if (iAmmoO != -1
				&& (GetEntData(iCid, iAmmoO + 48) > 0
					|| GetEntData(iCid, iAmmoO + 52) > 0
					|| GetEntData(iCid, iAmmoO + 56) > 0))
			{
				bHasGrenade = true;
			}

			if (bHasGrenade == false)
			{
				iPyroRemain = (g_iPyro_maxticks - g_iPyroTicks[iCid]) * 2;
				if (iPyroRemain < 0)
					iPyroRemain = 0;
			}
		}

		if (g_iSpirit_enable==1
			&& g_iSur2[iCid]==2
			&& g_iSpiritCooldown[iCid]==1)
		{
			new Float:flRemain = g_flSpiritCooldownEnd[iCid] - GetGameTime();
			if (flRemain > 0.0)
				iSpiritRemain = RoundToCeil(flRemain);
		}

		if (iPyroRemain > 0 && iSpiritRemain > 0)
			PrintHintText(iCid, "Pyrotechnician CD: %is | Spirit CD: %is", iPyroRemain, iSpiritRemain);
		else if (iPyroRemain > 0)
			PrintHintText(iCid, "Pyrotechnician CD: %is", iPyroRemain);
		else if (iSpiritRemain > 0)
			PrintHintText(iCid, "Spirit CD: %is", iSpiritRemain);
	}
}

//on drying from slime, remove hud changes
RunChecksAll ()
{
	if (g_bIsLoading == true
		|| g_bIsRoundStart == true)
		return;

	MA_RunChecks();
}

public Action:Delayed_Rebuild (Handle:timer, any:data)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
		return Plugin_Continue;

	RebuildAll();

	return Plugin_Stop;
}

RebuildAll ()
{
	MA_Rebuild();
	Extreme_Rebuild();
	Pyro_Rebuild();
}

//RebuildAll and ClearAll are only called on round starts,
//round ends, and plugin end, so yeah (important for Pyro's tick counter)
ClearAll ()
{
	MA_Clear();
	Extreme_Rebuild();
	Pyro_Clear(true);
}

//delayed perk checks
public Action:Delayed_PerkChecks (Handle:timer, any:iCid)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
		return Plugin_Stop;

	if (IsClientConnected(iCid)==false
		|| IsClientInGame(iCid)==false
		|| GetClientTeam(iCid)!=2)
		return Plugin_Stop;

	Event_Confirm_Unbreakable(iCid);
	Event_Confirm_Grenadier(iCid);
	Event_Confirm_ChemReliant(iCid);

	return Plugin_Stop;
}

//delayed show menu to prevent weird not-showing on
//campaign round restarts...
//... since 1.3, also checks if force random perks server
//setting is on; if so, then assigns perks instead
public Action:Timer_ShowTopMenu (Handle:timer, any:iCid)
{
	KillTimer(timer);
	if (IsServerProcessing()==false
		|| IsClientInGame(iCid)==false
		|| IsFakeClient(iCid)==true
		|| g_bIsLoading == true)
		return Plugin_Stop;

	if (!g_hMenuAutoShow_enable.BoolValue)
		return Plugin_Stop;

	//----DEBUG----
	//PrintToChatAll("\x03showing menu to \x01%i",iCid);

	new iT = GetClientTeam(iCid);

	//don't show the menu to infected
	if (iT == 3)
	{
		g_iConfirm[iCid] = 0;
		return Plugin_Stop;
	}

	if (iT==2)
		SendPanelToClient(Menu_Initial(iCid),iCid,Menu_ChooseInit,MENU_TIME_FOREVER);

	return Plugin_Stop;
}

//assigns random perks
AssignRandomPerks (iCid)
{
	//don't do anything if
	//the client id is whacked
	//or if confirm perks is set
	if (iCid > MaxClients
		|| iCid <= 0
		|| g_iConfirm[iCid]==1)
		return;

	//we track which perks are randomizable
	//in this array
	new iPerkType[10];
	//and keep track of which perk we're on
	decl iPerkCount;


	//SUR1 PERK
	//---------
	iPerkCount=0;

	//1 stopping power
	if (g_iStopping_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=1;
	}

	//2 sleight of hand
	if (g_iSoH_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=2;
	}

	//3 pyrotechnician
	if (g_iPyro_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=3;
	}

	//4 martial artist
	if (g_iMA_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=4;
	}

	//5 christmas gift
	if (g_iChristmas_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=5;
	}

	//randomize a perk
	if (iPerkCount>0)
		g_iSur1[iCid] = iPerkType[ GetRandomInt(1,iPerkCount) ];


	//SUR2 PERK
	//---------
	iPerkCount=0;

	//1 unbreakable
	if (g_iUnbreak_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=1;
	}

	//2 spirit
	if (g_iSpirit_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=2;
	}

	//3 helping hand
	if (g_iHelpHand_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=3;
	}

	//4 pack cat
	if (g_iPackCat_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=4;
	}

	//randomize a perk
	if (iPerkCount>0)
		g_iSur2[iCid] = iPerkType[ GetRandomInt(1,iPerkCount) ];


	//SUR3 PERK
	//------------------

	iPerkCount=0;

	//1 pack rat
	if (g_iPack_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=1;
	}

	//2 chem reliant
	if (g_iChem_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=2;
	}

	//3 hard to kill
	if (g_iHard_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=3;
	}

	//4 extreme conditioning
	if (g_iExtreme_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=4;
	}

	//randomize a perk
	if (iPerkCount>0)
		g_iSur3[iCid] = iPerkType[ GetRandomInt(1,iPerkCount) ];


	//finally, confirm perks
	//and run the necessary functions
	//as if the player had confirmed
	//their perks through the traditional way
	g_iConfirm[iCid]=1;
	Event_Confirm_Unbreakable(iCid);
	Event_Confirm_Grenadier(iCid);
	Event_Confirm_ChemReliant(iCid);
	Event_Confirm_MA(iCid);
	Extreme_Rebuild();

	//lastly, show a panel to the player
	//showing what perks they were given
	SendPanelToClient(Menu_ShowChoices(iCid),iCid,Menu_DoNothing,15);

}

//picks a random perk for bots
Bot_Sur1_PickRandom ()
{
	new iPerkType[12];
	new iPerkCount=0;

	decl String:stPerk[24];
	if (g_hBot_Sur1 != INVALID_HANDLE)
		g_hBot_Sur1.GetString(stPerk, sizeof(stPerk));
	else
		stPerk = "1,2";

	//stopping power
	if (StrContains(stPerk,"1",false) != -1
		&& g_iStopping_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=1;
	}

	//sleight of hand
	if (StrContains(stPerk,"2",false) != -1
		&& g_iSoH_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=2;
	}

	//randomize
	if (iPerkCount>0)
		return iPerkType[ GetRandomInt(1,iPerkCount) ];
	else
		return 0;
}

Bot_Sur2_PickRandom ()
{
	new iPerkType[12];
	new iPerkCount=0;

	decl String:stPerk[24];
	if (g_hBot_Sur2 != INVALID_HANDLE)
		g_hBot_Sur2.GetString(stPerk, sizeof(stPerk));
	else
		stPerk = "1,2,3";

	//unbreakable
	if (StrContains(stPerk,"1",false) != -1
		&& g_iUnbreak_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=1;
	}

	//spirit
	if (StrContains(stPerk,"2",false) != -1
		&& g_iSpirit_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=2;
	}

	//helping hand
	if (StrContains(stPerk,"3",false) != -1
		&& g_iHelpHand_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=3;
	}

	//randomize
	if (iPerkCount>0)
		return iPerkType[ GetRandomInt(1,iPerkCount) ];
	else
		return 0;
}

Bot_Sur3_PickRandom ()
{
	new iPerkType[12];
	new iPerkCount=0;

	decl String:stPerk[24];
	if (g_hBot_Sur3 != INVALID_HANDLE)
		g_hBot_Sur3.GetString(stPerk, sizeof(stPerk));
	else
		stPerk = "1,3";

	//pack rat
	if (StrContains(stPerk,"1",false) != -1
		&& g_iPack_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=1;
	}

	//hard to kill
	if (StrContains(stPerk,"3",false) != -1
		&& g_iHard_enable==1)
	{
		iPerkCount++;
		iPerkType[iPerkCount]=3;
	}

	//randomize
	if (iPerkCount>0)
		return iPerkType[ GetRandomInt(1,iPerkCount) ];
	else
		return 0;
}

// #endregion
// =======================================================================

// =======================================================================
// #region Ability Functions

//=============================
// Sur1: Stopping Power
//=============================

//==================================
// Sur1: Sleight of Hand
//=================================

//on the start of a reload
SoH_OnReload (iCid)
{
	//check if perk is disabled
	if (g_iSoH_enable==0)
		return;

	new iSur1 = g_iSur1[iCid];
	if (iSur1 == 2
		&& g_iConfirm[iCid]==1
		&& GetClientTeam(iCid)==2)
	{
		//----DEBUG----
		//PrintToChatAll("\x03SoH client \x01%i\x03; start of reload detected",iCid );

		new iEntid = GetEntDataEnt2(iCid,g_iActiveWO);
		if (IsValidEntity(iEntid)==false) return;

		decl String:stClass[32];
		GetEntityNetClass(iEntid,stClass,32);

		new Float:flRate = g_flSoH_rate;

		//----DEBUG----
		//PrintToChatAll("\x03-class of gun: \x01%s",stClass );

		//for non-shotguns
		if (StrContains(stClass,"shotgun",false) == -1)
		{
			SoH_MagStart(iEntid,iCid, flRate);
			return;
		}

		//shotguns are a bit trickier since the game
		//tracks per shell inserted - and there's TWO
		//different shotguns with different values =.=
		else if (StrContains(stClass,"autoshotgun",false) != -1)
		{
			//crate a pack to send clientid and gunid through to the timer
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, iCid);
			WritePackCell(hPack, iEntid);
			WritePackFloat(hPack, flRate);

			CreateTimer(0.1,SoH_AutoshotgunStart,hPack);
			return;
		}

		else if (StrContains(stClass,"shotgun_spas",false) != -1)
		{
			//crate a pack to send clientid and gunid through to the timer
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, iCid);
			WritePackCell(hPack, iEntid);
			WritePackFloat(hPack, flRate);

			CreateTimer(0.1,SoH_SpasShotgunStart,hPack);
			return;
		}

		else if (StrContains(stClass,"pumpshotgun",false) != -1
			|| StrContains(stClass,"shotgun_chrome",false) != -1)
		{
			//crate a pack to send clientid and gunid through to the timer
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack, iCid);
			WritePackCell(hPack, iEntid);
			WritePackFloat(hPack, flRate);

			CreateTimer(0.1,SoH_PumpshotgunStart,hPack);
			return;
		}
	}
}

//called for mag loaders
SoH_MagStart (iEntid, iCid, Float:flRate)
{
	//----DEBUG----
	//PrintToChatAll("\x05-magazine loader detected,\x03 gametime \x01%f", GetGameTime());

	new Float:flGameTime = GetGameTime();
	new Float:flNextTime_ret = GetEntDataFloat(iEntid,g_iNextPAttO);

	//----DEBUG----
	/*PrintToChatAll("\x03- pre, gametime \x01%f\x03, retrieved nextattack\x01 %i %f\x03, retrieved time idle \x01%i %f",
		flGameTime,
		g_iNextAttO,
		GetEntDataFloat(iCid,g_iNextAttO),
		g_iTimeIdleO,
		GetEntDataFloat(iEntid,g_iTimeIdleO)
		);*/

	//this is a calculation of when the next primary attack
	//will be after applying sleight of hand values
	//NOTE: at this point, only calculate the interval itself,
	//without the actual game engine time factored in
	new Float:flNextTime_calc = ( flNextTime_ret - flGameTime ) * flRate ;

	//we change the playback rate of the gun
	//just so the player can "see" the gun reloading faster
	SetEntDataFloat(iEntid, g_iPlayRateO, 1.0/flRate, true);

	//create a timer to reset the playrate after
	//time equal to the modified attack interval
	CreateTimer( flNextTime_calc, SoH_MagEnd, iEntid);

	//experiment to remove double-playback bug
	new Handle:hPack = CreateDataPack();
	WritePackCell(hPack, iCid);
	//this calculates the equivalent time for the reload to end
	//if the survivor didn't have the SoH perk
	new Float:flStartTime_calc = flGameTime - ( flNextTime_ret - flGameTime ) * ( 1 - flRate ) ;
	WritePackFloat(hPack, flStartTime_calc);
	//now we create the timer that will prevent the annoying double playback
	if ( (flNextTime_calc - 0.4) > 0 )
		CreateTimer( flNextTime_calc - 0.4 , SoH_MagEnd2, hPack);

	//and finally we set the end reload time into the gun
	//so the player can actually shoot with it at the end
	flNextTime_calc += flGameTime;
	SetEntDataFloat(iEntid, g_iTimeIdleO, flNextTime_calc, true);
	SetEntDataFloat(iEntid, g_iNextPAttO, flNextTime_calc, true);
	SetEntDataFloat(iCid, g_iNextAttO, flNextTime_calc, true);

	//----DEBUG----
	/*PrintToChatAll("\x03- post, calculated nextattack \x01%f\x03, gametime \x01%f\x03, retrieved nextattack\x01 %i %f\x03, retrieved time idle \x01%i %f",
		flNextTime_calc,
		flGameTime,
		g_iNextAttO,
		GetEntDataFloat(iCid,g_iNextAttO),
		g_iTimeIdleO,
		GetEntDataFloat(iEntid,g_iTimeIdleO)
		);*/
}

//called for autoshotguns
public Action:SoH_AutoshotgunStart (Handle:timer, Handle:hPack)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
		return Plugin_Stop;

	ResetPack(hPack);
	new iCid = ReadPackCell(hPack);
	new iEntid = ReadPackCell(hPack);
	new Float:flRate = ReadPackFloat(hPack);
	CloseHandle(hPack);
	hPack = CreateDataPack();
	WritePackCell(hPack, iCid);
	WritePackCell(hPack, iEntid);

	if (iCid <= 0
		|| iEntid <= 0
		|| IsValidEntity(iCid)==false
		|| IsValidEntity(iEntid)==false
		|| IsClientInGame(iCid)==false)
		return Plugin_Stop;

	//----DEBUG----
	/*PrintToChatAll("\x03-autoshotgun detected, iEntid \x01%i\x03, startO \x01%i\x03, insertO \x01%i\x03, endO \x01%i",
		iEntid,
		g_iShotStartDurO,
		g_iShotInsertDurO,
		g_iShotEndDurO
		);
	PrintToChatAll("\x03- pre mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHAutoS,
		g_flSoHAutoI,
		g_flSoHAutoE
		);*/
				
	//then we set the new times in the gun
	SetEntDataFloat(iEntid,	g_iShotStartDurO,	g_flSoHAutoS*flRate,	true);
	SetEntDataFloat(iEntid,	g_iShotInsertDurO,	g_flSoHAutoI*flRate,	true);
	SetEntDataFloat(iEntid,	g_iShotEndDurO,		g_flSoHAutoE*flRate,	true);

	//we change the playback rate of the gun
	//just so the player can "see" the gun reloading faster
	SetEntDataFloat(iEntid, g_iPlayRateO, 1.0/flRate, true);

	//and then call a timer to periodically check whether the
	//gun is still reloading or not to reset the animation
	//but first check the reload state; if it's 2, then it
	//needs a pump/cock before it can shoot again, and thus
	//needs more time
		CreateTimer(0.3,SoH_ShotgunEnd,hPack,TIMER_REPEAT);

	//----DEBUG----
	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHAutoS,
		g_flSoHAutoI,
		g_flSoHAutoE
		);*/

	return Plugin_Stop;
}

public Action:SoH_SpasShotgunStart (Handle:timer, Handle:hPack)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
		return Plugin_Stop;

	ResetPack(hPack);
	new iCid = ReadPackCell(hPack);
	new iEntid = ReadPackCell(hPack);
	new Float:flRate = ReadPackFloat(hPack);
	CloseHandle(hPack);
	hPack = CreateDataPack();
	WritePackCell(hPack, iCid);
	WritePackCell(hPack, iEntid);

	if (iCid <= 0
		|| iEntid <= 0
		|| IsValidEntity(iCid)==false
		|| IsValidEntity(iEntid)==false
		|| IsClientInGame(iCid)==false)
		return Plugin_Stop;

	//----DEBUG----
	/*PrintToChatAll("\x03-autoshotgun detected, iEntid \x01%i\x03, startO \x01%i\x03, insertO \x01%i\x03, endO \x01%i",
		iEntid,
		g_iShotStartDurO,
		g_iShotInsertDurO,
		g_iShotEndDurO
		);
	PrintToChatAll("\x03- pre mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHSpasS,
		g_flSoHSpasI,
		g_flSoHSpasE
		);*/
				
	//then we set the new times in the gun
	SetEntDataFloat(iEntid,	g_iShotStartDurO,	g_flSoHSpasS*flRate,	true);
	SetEntDataFloat(iEntid,	g_iShotInsertDurO,	g_flSoHSpasI*flRate,	true);
	SetEntDataFloat(iEntid,	g_iShotEndDurO,		g_flSoHSpasE*flRate,	true);

	//we change the playback rate of the gun
	//just so the player can "see" the gun reloading faster
	SetEntDataFloat(iEntid, g_iPlayRateO, 1.0/flRate, true);

	//and then call a timer to periodically check whether the
	//gun is still reloading or not to reset the animation
	//but first check the reload state; if it's 2, then it
	//needs a pump/cock before it can shoot again, and thus
	//needs more time
	CreateTimer(0.3,SoH_ShotgunEnd,hPack,TIMER_REPEAT);

	//----DEBUG----
	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHSpasS,
		g_flSoHSpasI,
		g_flSoHSpasE
		);*/

	return Plugin_Stop;
}

//called for pump shotguns
public Action:SoH_PumpshotgunStart (Handle:timer, Handle:hPack)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
		return Plugin_Stop;

	ResetPack(hPack);
	new iCid = ReadPackCell(hPack);
	new iEntid = ReadPackCell(hPack);
	new Float:flRate = ReadPackFloat(hPack);
	CloseHandle(hPack);
	hPack = CreateDataPack();
	WritePackCell(hPack, iCid);
	WritePackCell(hPack, iEntid);

	if (iCid <= 0
		|| iEntid <= 0
		|| IsValidEntity(iCid)==false
		|| IsValidEntity(iEntid)==false
		|| IsClientInGame(iCid)==false)
		return Plugin_Stop;

	//----DEBUG----
	/*PrintToChatAll("\x03-pumpshotgun detected, iEntid \x01%i\x03, startO \x01%i\x03, insertO \x01%i\x03, endO \x01%i",
		iEntid,
		g_iShotStartDurO,
		g_iShotInsertDurO,
		g_iShotEndDurO
		);
	PrintToChatAll("\x03- pre mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHPumpS,
		g_flSoHPumpI,
		g_flSoHPumpE
		);*/

	//then we set the new times in the gun
	SetEntDataFloat(iEntid,	g_iShotStartDurO,	g_flSoHPumpS*flRate,	true);
	SetEntDataFloat(iEntid,	g_iShotInsertDurO,	g_flSoHPumpI*flRate,	true);
	SetEntDataFloat(iEntid,	g_iShotEndDurO,		g_flSoHPumpE*flRate,	true);

	//we change the playback rate of the gun
	//just so the player can "see" the gun reloading faster
	SetEntDataFloat(iEntid, g_iPlayRateO, 1.0/flRate, true);

	//and then call a timer to periodically check whether the
	//gun is still reloading or not to reset the animation
		CreateTimer(0.3,SoH_ShotgunEnd,hPack,TIMER_REPEAT);

	//----DEBUG----
	/*PrintToChatAll("\x03- after mod, start \x01%f\x03, insert \x01%f\x03, end \x01%f",
		g_flSoHPumpS,
		g_flSoHPumpI,
		g_flSoHPumpE
		);*/

	return Plugin_Stop;
}

//this resets the playback rate on non-shotguns
public Action:SoH_MagEnd (Handle:timer, any:iEntid)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
		return Plugin_Stop;

	//----DEBUG----
	//PrintToChatAll("\x03SoH reset playback, magazine loader");

	if (iEntid <= 0
		|| IsValidEntity(iEntid)==false)
		return Plugin_Stop;

	SetEntDataFloat(iEntid, g_iPlayRateO, 1.0, true);

	return Plugin_Stop;
}

public Action:SoH_MagEnd2 (Handle:timer, Handle:hPack)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
	{
		CloseHandle(hPack);
		return Plugin_Stop;
	}

	//----DEBUG----
	//PrintToChatAll("\x03SoH reset playback, magazine loader");

	ResetPack(hPack);
	new iCid = ReadPackCell(hPack);
	new Float:flStartTime_calc = ReadPackFloat(hPack);
	CloseHandle(hPack);

	if (iCid <= 0
		|| IsValidEntity(iCid)==false
		|| IsClientInGame(iCid)==false)
		return Plugin_Stop;

	//experimental, remove annoying double-playback
	new iVMid = GetEntDataEnt2(iCid,g_iViewModelO);
	SetEntDataFloat(iVMid, g_iVMStartTimeO, flStartTime_calc, true);

	//----DEBUG----
	//PrintToChatAll("\x03- end SoH mag loader, icid \x01%i\x03 starttime \x01%f\x03 gametime \x01%f", iCid, flStartTime_calc, GetGameTime());

	return Plugin_Stop;
}

public Action:SoH_ShotgunEnd (Handle:timer, Handle:hPack)
{
	//----DEBUG----
	//PrintToChatAll("\x03-autoshotgun tick");

	ResetPack(hPack);
	new iCid = ReadPackCell(hPack);
	new iEntid = ReadPackCell(hPack);

	if (IsServerProcessing()==false
		|| iCid <= 0
		|| iEntid <= 0
		|| IsValidEntity(iCid)==false
		|| IsValidEntity(iEntid)==false
		|| IsClientInGame(iCid)==false)
	{
		KillTimer(timer);
		return Plugin_Stop;
	}

	if (GetEntData(iEntid,g_iShotRelStateO)==0)
	{
		//----DEBUG----
		//PrintToChatAll("\x03-shotgun end reload detected");

		SetEntDataFloat(iEntid, g_iPlayRateO, 1.0, true);

		//new iCid=GetEntPropEnt(iEntid,Prop_Data,"m_hOwner");
		new Float:flTime=GetGameTime()+0.2;
		SetEntDataFloat(iCid,	g_iNextAttO,	flTime,	true);
		SetEntDataFloat(iEntid,	g_iTimeIdleO,	flTime,	true);
		SetEntDataFloat(iEntid,	g_iNextPAttO,	flTime,	true);

		KillTimer(timer);
		CloseHandle(hPack);
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

//since cocking requires more time, this function does
//exactly as the above, except it adds slightly more time
public Action:SoH_ShotgunEndCock (Handle:timer, any:hPack)
{
	//----DEBUG----
	//PrintToChatAll("\x03-autoshotgun tick");

	ResetPack(hPack);
	new iCid = ReadPackCell(hPack);
	new iEntid = ReadPackCell(hPack);

	if (IsServerProcessing()==false
		|| iCid <= 0
		|| iEntid <= 0
		|| IsValidEntity(iCid)==false
		|| IsValidEntity(iEntid)==false
		|| IsClientInGame(iCid)==false)
	{
		KillTimer(timer);
		return Plugin_Stop;
	}

	if (GetEntData(iEntid,g_iShotRelStateO)==0)
	{
		//----DEBUG----
		//PrintToChatAll("\x03-shotgun end reload + cock detected");

		SetEntDataFloat(iEntid, g_iPlayRateO, 1.0, true);

		//new iCid=GetEntPropEnt(iEntid,Prop_Data,"m_hOwner");
		new Float:flTime= GetGameTime() + 1.0;
		SetEntDataFloat(iCid,	g_iNextAttO,	flTime,	true);
		SetEntDataFloat(iEntid,	g_iTimeIdleO,	flTime,	true);
		SetEntDataFloat(iEntid,	g_iNextPAttO,	flTime,	true);

		KillTimer(timer);
		CloseHandle(hPack);
		return Plugin_Stop;
	}

	return Plugin_Continue;
}



//=============================
// Sur1: Pyrotechnician
//=============================

//on pickup
Pyro_Pickup(iCid, String:stWpn[])
{
	if (IsEnable_SurvivorPrimary_Pyrotechnician()
		&& IsClientConfirm(iCid)
		&& IsClientSelect_SurvivorPrimary_Pyrotechnician(iCid))
	{
		//only bother with checks if they aren't throwing
		if (g_iGrenThrow[iCid]==0)
		{
			//check if the weapon is a grenade type
			if (StrEqual(stWpn,"pipe_bomb",false)==true
				|| StrEqual(stWpn,"molotov",false)==true
				|| StrEqual(stWpn,"vomitjar",false)==true)
			{
				decl String:stWpn2[24];
				if (stWpn[0]=='p')
					stWpn2="pipe bomb";
				else if (stWpn[0]=='v')
					stWpn2="vomit jar";
				else
					stWpn2="molotov";
				//if so, then check if either 0 or 2 are being carried
				//if true, then act normally and give player 2 grenades
				if (g_iGren[iCid]==0
					|| g_iGren[iCid]==2)
				{
					g_iGren[iCid]=2;
					PrintHintText(iCid,"Pyrotechnician: %t", "PyroMessageHintGrenadierCarry", g_iGren[iCid], stWpn2);
				}
				//otherwise, only give them one and tell them to
				//throw the grenade before picking up another one;
				//this is to prevent abuses with throwing infinite nades
				else
				{
					g_iGren[iCid]=1;
					PrintHintText(iCid,"%t", "PyroMessageHintGrenadierCantTake2Grenades", stWpn2);
				}
			}
		}
		//if they are in the middle of throwing, then reset the var
		else if (g_iGrenThrow[iCid]==1)
			g_iGrenThrow[iCid]=0;
	}
}

//called when tossing
Pyro_OnWeaponFire(iCid, String:stWpn[])
{
	//check if perk is enabled
	if (g_iPyro_enable==0)
		return;

	if (g_iConfirm[iCid]==0
		|| g_iSur1[iCid]!=3) return;

	//----DEBUG----
	//PrintToChatAll("\x03 weapon fired: \x01%s", st_wpn);

	new bool:bPipe=StrEqual(stWpn,"pipe_bomb",false);
	new bool:bMol=StrEqual(stWpn,"molotov",false);
	new bool:bVomit=StrEqual(stWpn,"vomitjar",false);
	if (bPipe || bMol || bVomit)
	{
		g_iGren[iCid]--;		//reduce count by 1
		decl String:stWpn2[24];

		if (g_iGren[iCid]>0)		//do they still have grenades left?
		{
			if (bPipe==true)
			{
				g_iGrenType[iCid]=1;
				stWpn2="pipe bomb";
			}
			else if (bMol==true)
			{
				g_iGrenType[iCid]=2;
				stWpn2="molotov";
			}
			else
			{
				g_iGrenType[iCid]=3;
				stWpn2="vomit jar";
			}

			PrintHintText(iCid,"Pyrotechnician: %t", "PyroMessageHintGrenadierCounter", g_iGren[iCid], stWpn2);
			CreateTimer(2.0,Grenadier_DelayedGive,iCid);
		}
	}
}

//gives the grenade a few seconds later 
//(L4D takes a while to remove the grenade from inventory after it's been thrown)
public Action:Grenadier_DelayedGive (Handle:timer,any:iCid)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
		return Plugin_Stop;

	if (iCid==0
		|| g_iConfirm[iCid]==0
		|| g_iSur1[iCid]!=3)
		return Plugin_Continue;

	new iflags=GetCommandFlags("give");
	new String:st_give[24];

	if (g_iGrenType[iCid]==1)
		st_give="give pipe_bomb";
	else if (g_iGrenType[iCid]==2)
		st_give="give molotov";
	else
		st_give="give vomitjar";

	g_iGrenType[iCid]=0;
	g_iGrenThrow[iCid]=1;	//client now considered to be "in the middle of throwing"
	SetCommandFlags("give", iflags & ~FCVAR_CHEAT);
	FakeClientCommand(iCid,st_give);
	SetCommandFlags("give", iflags);

	return Plugin_Stop;
}


//called on roundstarts or on confirming perks
//gives a pipe bomb to the player
Event_Confirm_Grenadier (iCid)
{
	if (iCid==0
		|| GetClientTeam(iCid)!=2
		|| IsPlayerAlive(iCid)==false
		|| g_iConfirm[iCid]==0
		|| g_iSur1[iCid]!=3)
		return;

	//check if perk is enabled
	if (g_iPyro_enable==0)
		return;

	//reset grenade count on player
	g_iGren[iCid]=0;

	new iflags=GetCommandFlags("give");
	new String:st_give[24];


	new iI=GetRandomInt(0,2);
	if (iI==0)
		st_give="give pipe_bomb";
	else if (iI==1)
		st_give="give molotov";
	else if (iI==2)
		st_give="give vomitjar";

	SetCommandFlags("give", iflags & ~FCVAR_CHEAT);
	FakeClientCommand(iCid,st_give);
	SetCommandFlags("give", iflags);

	g_iPyroTicks[iCid] = 0;
	g_iPyroRegisterCount++;
	g_iPyroRegisterIndex[g_iPyroRegisterCount]=iCid;

	return;
}

//called every 2 seconds from global timer
//checks for ammo and adds to the player's "ticker"
//for every 2s tick that they don't have any grenades
Pyro_Timer()
{
	decl iCid;
	decl iTicks;

	//check if perk is enabled
	if (g_iPyro_maxticks == 0 || g_iPyro_enable==0)
		return;

	//or if no one has DT, don't bother either
	if (g_iPyroRegisterCount==0)
		return;

	//theoretically, to get on the DT registry
	//all the necessary checks would have already
	//been run, so we don't bother with any checks here
	for (new iI=1; iI<=g_iPyroRegisterCount; iI++)
	{
		//PRE-CHECKS: RETRIEVE VARS
		//-------------------------

		iCid = g_iPyroRegisterIndex[iI];
		iTicks = g_iPyroTicks[iI];
		//stop on this client
		//when the next client id is null
		if (iCid <= 0
			|| IsValidEntity(iCid)==false)
			return;

		//----DEBUG----
		//PrintToChatAll("\x03Pyro tick \x01%i\x03 for \x01%i", iTicks, iCid);

		//now we check if enough ticks have elapsed
		//to give the survivor their pipe bomb
		if (iTicks >= g_iPyro_maxticks)
		{
			new iflags=GetCommandFlags("give");
			SetCommandFlags("give", iflags & ~FCVAR_CHEAT);

			// give random grenade type
			new iRandomGrenType=GetRandomInt(0,2);
			if (iRandomGrenType==0)
				FakeClientCommand(iCid, "give pipe_bomb");
			else if (iRandomGrenType==1)
				FakeClientCommand(iCid, "give molotov");
			else if (iRandomGrenType==2)
				FakeClientCommand(iCid, "give vomitjar");
			
			SetCommandFlags("give", iflags);

			g_iPyroTicks[iCid] = 0;

			//----DEBUG----
			//PrintToChatAll("\x03- max ticks reached, gave pipe bomb and resetting", g_iPyroTicks[iCid], iCid);

			continue;
		}

		new iAmmoO=FindDataMapInfo(iCid,"m_iAmmo");

		//+48 = pipe bombs
		//+52 = molotovs
		//+56 = bile jars
		if (GetEntData(iCid, iAmmoO + 48) > 0
			|| GetEntData(iCid, iAmmoO + 52) > 0
			|| GetEntData(iCid, iAmmoO + 56) > 0)
		{
			g_iPyroTicks[iCid] = 0;

			continue;
		}

		g_iPyroTicks[iCid]++;
	}
}

//called whenever the registry needs to be rebuilt
//to cull any players who have left or died, etc.
//(called on: player death, player disconnect,
//closet rescue, change teams)
Pyro_Rebuild ()
{
	//clears all DT-related vars
	Pyro_Clear(false);

	//if the server's not running or
	//is in the middle of loading, stop
	if (IsServerProcessing()==false)
		return;

	//----DEBUG----
	//PrintToChatAll("\x03double tap rebuilding registry");

	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		if (IsClientInGame(iI)==true
			&& IsPlayerAlive(iI)==true
			&& g_iSur1[iI]==3
			&& g_iConfirm[iI]==1
			&& GetClientTeam(iI)==2)
		{
			g_iPyroRegisterCount++;
			g_iPyroRegisterIndex[g_iPyroRegisterCount]=iI;

			//----DEBUG----
			//PrintToChatAll("\x03-registering \x01%i",iI);
		}
	}
}

//called to clear out DT registry
//(called on: round start, round end, map end)
//the boolean is to only reset the tick counter per player
//if we are at the round start, because we don't want late
//comers to the game to mess up other people's Pyro tickers
Pyro_Clear (bool:bRoundStart)
{
	g_iPyroRegisterCount=0;
	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		g_iPyroRegisterIndex[iI]= -1;
		if (bRoundStart == true)
			g_iPyroTicks[iI] = 0;
	}
}

//=============================
// Sur1: Martial Artist
//=============================

MA_RunChecks ()
{
	if (g_iMA_enable==1)
		g_iMA_meta_enable=1;
	else
		g_iMA_meta_enable=0;
}

//called on confirming perks
//adds player to registry of MA users
//and sets movement speed
Event_Confirm_MA (iCid)
{
	if (g_iMARegisterCount<0)
		g_iMARegisterCount=0;

	//check if perk is enabled
	if (g_iMA_enable==0)
		return;

	if (IsClientInGame(iCid)==true
		&& IsPlayerAlive(iCid)==true
		&& g_iSur1[iCid]==4
		&& g_iConfirm[iCid]==1
		&& GetClientTeam(iCid)==2)
	{
		g_iMARegisterCount++;
		g_iMARegisterIndex[g_iMARegisterCount]=iCid;

		//----DEBUG----
		//PrintToChatAll("\x03martial artist on confirm, registering \x01%i",iCid);
	}	
}

//called whenever the registry needs to be rebuilt
//to cull any players who have left or died, etc.
//resets survivor's speeds and reassigns speed boost
//(called on: player death, player disconnect,
//closet rescue, change teams, convar change)
MA_Rebuild ()
{
	//clears all DT-related vars
	MA_Clear();

	//if the server's not running or
	//is in the middle of loading, stop
	if (IsServerProcessing()==false)
		return;

	//check if perk is enabled
	if (g_iMA_enable==0)
		return;

	//----DEBUG----
	//PrintToChatAll("\x03martial artist rebuilding registry");

	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		if (IsClientInGame(iI)==true
			&& IsPlayerAlive(iI)==true
			&& g_iSur1[iI]==4
			&& g_iConfirm[iI]==1
			&& GetClientTeam(iI)==2)
		{
			g_iMARegisterCount++;
			g_iMARegisterIndex[g_iMARegisterCount]=iI;

			//----DEBUG----
			//PrintToChatAll("\x03-registering \x01%i",iI);
		}
	}
}

//called to clear out registry
//and reset movement speeds
//(called on: round start, round end, map end)
MA_Clear ()
{
	g_iMARegisterCount=0;
	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		g_iMARegisterIndex[iI]= -1;
	}
}

MA_OnGameFrame()
{
	//stop if MA is disabled in any way
	if (g_iMA_meta_enable==0)
		return 0;

	//or if no one has DT, don't bother either
	if (g_iMARegisterCount==0)
		return 0;

	decl iCid;
	//this tracks the player's ability id
	decl iEntid;
	//this tracks the calculated next attack
	decl Float:flNextTime_calc;
	//this, on the other hand, tracks the current next attack
	decl Float:flNextTime_ret;
	//and this tracks the game time
	new Float:flGameTime=GetGameTime();

	for (new iI=1; iI<=g_iMARegisterCount; iI++)
	{
		//PRE-CHECKS 1: RETRIEVE VARS
		//---------------------------

		iCid = g_iMARegisterIndex[iI];
		//stop on this client
		//when the next client id is null
		if (iCid <= 0) return 0;
		//skip this client if they're disabled, or, you know, dead
		//if (g_iMyDisabler[iCid] != -1) continue;
		//if (IsPlayerAlive(iCid)==false) continue;

		//we have to adjust numbers on the gun, not the player
		//so we get the active weapon id here
		iEntid = GetEntDataEnt2(iCid,g_iActiveWO);
		//if the retrieved gun id is -1, then...
		//wtf mate? just move on
		if (iEntid == -1) continue;
		//and here is the retrieved next attack time
		flNextTime_ret = GetEntDataFloat(iEntid,g_iNextPAttO);

		//----DEBUG----
		//PrintToChat(iCid,"\x03shove penalty \x01%i\x03, max penalty \x01%i",GetEntData(iCid,g_iMeleeFatigueO), g_iMA_maxpenalty);

		//PRE-CHECKS 2: MOD SHOVE FATIGUE
		//-------------------------------
		if ( GetEntData(iCid,g_iMeleeFatigueO) > g_iMA_maxpenalty )
		{
			SetEntData(iCid, g_iMeleeFatigueO, g_iMA_maxpenalty);
		}

		//CHECK 1: IS PLAYER USING A KNOWN NON-MELEE WEAPON?
		//--------------------------------------------------
		//as the title states... to conserve processing power,
		//if the player's holding a gun for a prolonged time
		//then we want to be able to track that kind of state
		//and not bother with any checks
		//checks: weapon is non-melee weapon
		//actions: do nothing
		if (iEntid == g_iMAEntid_notmelee[iCid])
		{
			//----DEBUG----
			//PrintToChatAll("\x03MA client \x01%i\x03; non melee weapon, ignoring",iCid );

			g_iMAAttCount[iCid] = 0;
			continue;
		}



		//PRE CHECK 1.5
		//-------------
		new iMAEntid = g_iMAEntid[iCid];
		new iMAAttCount = g_iMAAttCount[iCid];

		//CHECK 1.5: THE PLAYER HASN'T SWUNG HIS WEAPON FOR A WHILE
		//-------------------------------------------------------
		//in this case, if the player made 1 swing of his 2 strikes,
		//and then paused long enough, we should reset his strike count
		//so his next attack will allow him to strike twice
		//checks: is the delay between attacks greater than 0.8s?
		//actions: set attack count to 0, and CONTINUE CHECKS
		if (iMAEntid == iEntid
			&& iMAAttCount != 0
			&& (flGameTime - flNextTime_ret) > 0.8)
		{
			//----DEBUG----
			//PrintToChatAll("\x03MA client \x01%i\x03; hasn't swung weapon",iCid );

			g_iMAAttCount[iCid] = 0;
		}



		//PRE CHECK 2
		//-----------
		new Float:flMANextTime = g_flMANextTime[iCid];

		//CHECK 2: BEFORE ADJUSTED ATT IS MADE
		//------------------------------------
		//since this will probably be the case most of
		//the time, we run this first
		//checks: weapon is unchanged; time of shot has not passed
		//actions: do nothing
		if (iMAEntid == iEntid
			&& flMANextTime >= flNextTime_ret)
		{
			//----DEBUG----
			//PrintToChatAll("\x03DT client \x01%i\x03; before shot made",iCid );

			continue;
		}



		//CHECK 3: AFTER ADJUSTED ATT IS MADE
		//------------------------------------
		//at this point, either a gun was swapped, or
		//the attack time needs to be adjusted
		//checks: stored gun id same as retrieved gun id,
		// and retrieved next attack time is after stored value
		//actions: adjusts next attack time
		if (iMAEntid == iEntid
			&& flMANextTime < flNextTime_ret)
		{
			//----DEBUG----
			//PrintToChatAll("\x03DT after adjusted shot\n-pre, client \x01%i\x03; entid \x01%i\x03; enginetime\x01 %f\x03; NextTime_orig \x01 %f\x03; interval \x01%f",iCid,iEntid,flGameTime,flNextTime_ret, flNextTime_ret-flGameTime );
			//new Float:flNextTime_retSA = GetEntDataFloat(iEntid,g_iNextSAttO);
			//PrintToChatAll("\x05DT\x03 enginetime\x01 %f\x03; nextPA \x01%f\x03; PAinterval \x01%f\x03\n nextSA \x01%f\x03 SAinterval \x01%f", flGameTime, flNextTime_ret, flNextTime_ret-flGameTime, flNextTime_retSA, flNextTime_retSA-flGameTime );



			//> CHECK FOR SHOVES/WEAPON DRAWS
			//-------------------------------
			new Float:flInterval = flNextTime_ret-flGameTime;
			if (flInterval > 0.7331
				&& flInterval < 0.7335)
			{
				//----DEBUG----
				//PrintToChatAll("\x05DT\x03 shove inferred");

				g_flMANextTime[iCid] = flNextTime_ret;
				continue;
			}
			if (flInterval < 0.534)
			{
				//----DEBUG----
				//PrintToChatAll("\x05DT\x03 weapon draw inferred");

				g_flMANextTime[iCid] = flNextTime_ret;
				continue;
			}


			g_iMAAttCount[iCid]++;
			if (g_iMAAttCount[iCid]>2)
				g_iMAAttCount[iCid]=0;
			iMAAttCount = g_iMAAttCount[iCid];

			//> MOD ATTACK
			//------------
			if (iMAAttCount == 1
				|| iMAAttCount == 2)
			{
				//this is a calculation of when the next primary attack
				//will be after applying double tap values
				//flNextTime_calc = ( flNextTime_ret - flGameTime ) * g_flMA_attrate + flGameTime;
				flNextTime_calc = flGameTime + 0.3 ;

				//then we store the value
				g_flMANextTime[iCid] = flNextTime_calc;

				//and finally adjust the value in the gun
				SetEntDataFloat(iEntid, g_iNextPAttO, flNextTime_calc, true);

				//----DEBUG----
				//PrintToChatAll("\x03-post, NextTime_calc \x01 %f\x03; new interval \x01%f",GetEntDataFloat(iEntid,g_iNextPAttO), GetEntDataFloat(iEntid,g_iNextPAttO)-flGameTime );

				continue;
			}

			//> DON'T MOD ATTACK
			//------------------
			if (g_iMAAttCount[iCid]==0)
			{
				g_flMANextTime[iCid] = flNextTime_ret;
				continue;
			}
		}



		//CHECK 4: CHECK THE WEAPON
		//-------------------------
		//lastly, at this point we need to check if we are, in fact,
		//using a melee weapon =P we check if the current weapon is
		//the same one stored in memory; if it is, move on;
		//otherwise, check if it's a melee weapon - if it is,
		//store and continue; else, continue.
		//checks: if the active weapon is a melee weapon
		//actions: store the weapon's entid into either
		// the known-melee or known-non-melee variable

		//----DEBUG----
		//PrintToChatAll("\x03DT client \x01%i\x03; weapon switch inferred",iCid );

		//check if the weapon is a melee
		decl String:stName[32];
		GetEntityNetClass(iEntid,stName,32);
		if (StrEqual(stName,"CTerrorMeleeWeapon",false)==true)
		{
			//if yes, then store in known-melee var
			g_iMAEntid[iCid]=iEntid;
			g_flMANextTime[iCid]=flNextTime_ret;
			continue;
		}
		else
		{
			//if no, then store in known-non-melee var
			g_iMAEntid_notmelee[iCid]=iEntid;
			continue;
		}
	}

	return 0;
}

//=============================
// Sur2: Unbreakable
//=============================

//on heal;
Unbreakable_OnHeal (iCid)
{
	//check if perk is enabled
	if (g_iUnbreak_enable==0)
		return;

	if (g_iSur2[iCid]==1)
	{
		CreateTimer(0.5,Unbreakable_Delayed_Heal,iCid);

		//run a check to see if for whatever reason
		//the player's health is above 200
		//since 200 is the clamped maximum for unbreakable
		//in which case we set their health to 200
		if (GetEntProp(iCid,Prop_Data,"m_iHealth") > 200)
			CreateTimer(0.5,Unbreakable_Delayed_SetHigh,iCid);
	}
}

//called when player confirms his choices;
//gives 30 hp (to bring hp to 130, assuming survivor
//wasn't stupid and got himself hurt before confirming perks)
Event_Confirm_Unbreakable (iCid)
{
	new iHP=GetEntProp(iCid,Prop_Data,"m_iHealth");
	if (iCid==0 || g_iConfirm[iCid]==0) return;
	new TC=GetClientTeam(iCid);

	//check if perk is enabled
	if (g_iUnbreak_enable==0)
	{
		//if not, check if hp is higher than it should be
		if (iHP>100
			&& TC==2)
		{
			//if it IS higher, reduce hp to 100
			//otherwise, no way to know whether previous owner
			//had unbreakable, so give the incoming player
			//the benefit of doubt
			CreateTimer(0.5,Unbreakable_Delayed_SetLow,iCid);
		}
		return;
	}

	//if we've gotten up to this point, the perk is enabled
	if (g_iSur2[iCid]==1
		&& TC==2)
	{
		if (iHP>100
			&& iHP < (100+g_iUnbreak_hp) )
			CreateTimer(0.5,Unbreakable_Delayed_Max,iCid);
		else if (iHP<=100)
			CreateTimer(0.5,Unbreakable_Delayed_Normal,iCid);

		//run a check to see if for whatever reason
		//the player's health is above 200
		//since 200 is the clamped maximum for unbreakable
		//in which case we set their health to 200
		if (GetEntProp(iCid,Prop_Data,"m_iHealth") > 200)
			CreateTimer(0.5,Unbreakable_Delayed_SetHigh,iCid);
	}
	//if not, check if hp is higher than it should be
	else if (g_iSur2[iCid]!=1
		&& iHP>100
		&& TC==2)
	{
		//if it IS higher, reduce hp to 100
		//otherwise, no way to know whether previous owner
		//had unbreakable, so give the incoming player
		//the benefit of doubt
		CreateTimer(0.5,Unbreakable_Delayed_SetLow,iCid);
	}
}

//on rescue; gives 50% of bonus hp
Unbreakable_OnRescue (iCid)
{
	if (g_iSur2[iCid]==1)
	{
		//check if perk is enabled
		if (g_iUnbreak_enable==0)
			return;

		CreateTimer(0.5,Unbreakable_Delayed_Rescue,iCid);

		//run a check to see if for whatever reason
		//the player's health is above 200
		//since 200 is the clamped maximum for unbreakable
		//in which case we set their health to 200
		if (GetEntProp(iCid,Prop_Data,"m_iHealth") > 200)
			CreateTimer(0.5,Unbreakable_Delayed_SetHigh,iCid);
	}
}

//on revive; gives 50% of bonus hp in temp hp
Unbreakable_OnRevive (iSub, iLedge)
{
	//check for unbreakable for the subject
	//only fires if they were NOT hanging from a ledge
	if (g_iSur2[iSub]==1
		&& g_iConfirm[iSub]==1
		&& iLedge == 0)
	{
		//check if perk is enabled
		if (g_iUnbreak_enable==1)
		{
			SetEntDataFloat(iSub,g_iHPBuffO, GetEntDataFloat(iSub,g_iHPBuffO)+(g_iUnbreak_hp/2) ,true);
		}
	}
}

//these timer functions apply health bonuses
//after a delay, hopefully to avoid bugs
public Action:Unbreakable_Delayed_Max (Handle:timer, any:iCid)
{
	if (IsServerProcessing()==true
		&& IsValidEntity(iCid)==true
		&& IsClientInGame(iCid)==true)
		SetEntProp(iCid,Prop_Data,"m_iHealth", 100+g_iUnbreak_hp );

	KillTimer(timer);
	return Plugin_Stop;
}

public Action:Unbreakable_Delayed_Normal (Handle:timer, any:iCid)
{
	if (IsServerProcessing()==true
		&& IsValidEntity(iCid)==true
		&& IsClientInGame(iCid)==true)
	{
		SetEntProp(iCid,Prop_Data,"m_iHealth", GetEntProp(iCid,Prop_Data,"m_iHealth")+g_iUnbreak_hp );

		if (GetEntProp(iCid,Prop_Data,"m_iHealth") > (100+g_iUnbreak_hp) )
			SetEntProp(iCid,Prop_Data,"m_iHealth", 100+g_iUnbreak_hp );
	}

	KillTimer(timer);
	return Plugin_Stop;
}

public Action:Unbreakable_Delayed_Heal (Handle:timer, any:iCid)
{
	if (IsServerProcessing()==true
		&& IsValidEntity(iCid)==true
		&& IsClientInGame(iCid)==true)
	{
		SetEntProp(iCid,Prop_Data,"m_iHealth", GetEntProp(iCid,Prop_Data,"m_iHealth") + (g_iUnbreak_hp*g_fUnbreak_hr) );

		if (GetEntProp(iCid,Prop_Data,"m_iHealth") > (100+g_iUnbreak_hp) )
			SetEntProp(iCid,Prop_Data,"m_iHealth", 100+g_iUnbreak_hp );
	}

	KillTimer(timer);
	return Plugin_Stop;
}

public Action:Unbreakable_Delayed_Rescue (Handle:timer, any:iCid)
{
	if (IsServerProcessing()==true
		&& IsValidEntity(iCid)==true
		&& IsClientInGame(iCid)==true)
	{
		SetEntProp(iCid,Prop_Data,"m_iHealth", GetEntProp(iCid,Prop_Data,"m_iHealth") + (g_iUnbreak_hp/2) );

		if (GetEntProp(iCid,Prop_Data,"m_iHealth") > (100+g_iUnbreak_hp) )
			SetEntProp(iCid,Prop_Data,"m_iHealth", 100+g_iUnbreak_hp );
	}

	KillTimer(timer);
	return Plugin_Stop;
}

public Action:Unbreakable_Delayed_SetHigh (Handle:timer, any:iCid)
{
	if (IsServerProcessing()==true
		&& IsValidEntity(iCid)==true
		&& IsClientInGame(iCid)==true)
		SetEntProp(iCid,Prop_Data,"m_iHealth", 200 );

	KillTimer(timer);
	return Plugin_Stop;
}

public Action:Unbreakable_Delayed_SetLow (Handle:timer, any:iCid)
{
	if (IsServerProcessing()==true
		&& IsValidEntity(iCid)==true
		&& IsClientInGame(iCid)==true)
		SetEntProp(iCid,Prop_Data,"m_iHealth", 100 );

	KillTimer(timer);
	return Plugin_Stop;
}



//=============================
// Sur2: Spirit
//=============================

//called by global timer "TimerPerks"
//periodically runs checks to see if anyone should self-revive
//since sometimes self-revive won't fire if someone's being disabled
//by, say, a hunter
Spirit_Timer ()
{
	//check if perk is enabled
	if (g_iSpirit_enable==0)
		return;

	//this var counts how many people are incapped
	//but for the first part, it checks whether anyone has spirit
	new iCount=0;

	//preliminary check; if no one has
	//the spirit perk, this function will return
	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		if (g_iSur2[iI]==2)
		{
			iCount++;
			break;
		}
	}
	if (iCount<=0) return;
	else iCount=0;

	//----DEBUG----
	//PrintToChatAll("\x03spirit timer check");

	//this array will hold client ids
	//for the possible candidates for self-revives
	new iCid[18];

	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		//fill array with whoever's incapped
		if (IsClientInGame(iI)==true
			&& GetClientTeam(iI)==2
			&& GetEntData(iI,g_iIncapO) != 0 )
		{
			iCount++;
			iCid[iCount]=iI;

			//----DEBUG----
			//PrintToChatAll("\x03-incap registering \x01%i",iI);
		}
	}

	//if the first two client ids are null, or
	//if the count was zero OR one, return
	//since someone can't self-revive if they're
	//the only ones incapped!
	if (iCount<=1
		|| iCid[1]<=0
		|| iCid[2]<=0)
		return;

	//----DEBUG----
	//PrintToChatAll("\x03-beginning self-revive checks, iCount=\x01%i",iCount);

	//now we check for someone to revive
	//and we only revive one person at a time
	for (new iI=1 ; iI<=iCount ; iI++)
	{
		//----DEBUG----
		//PrintToChatAll("\x03- iledge value \x01%i",GetEntData(iCid[iI],g_iLedgeO));

		//client ids are stored incrementally (X in 1, Y in 2, Z in 3,...)
		//in the array iCid[], and iI increases per tick, hence this mess =P
		//in short, here we use iCid[iI], NOT iI!
		if (g_iConfirm[iCid[iI]]==1
			&& g_iSur2[iCid[iI]]==2
			&& g_iMyDisabler[iCid[iI]] == -1
			&& g_iSpiritCooldown[iCid[iI]]==0
			&& IsClientInGame(iCid[iI])==true
			&& IsPlayerAlive(iCid[iI])==true
			&& GetClientTeam(iCid[iI])==2)
		{
			//----DEBUG----
			//PrintToChatAll("\x03-reviving \x01%i",iCid[iI]);

			//retrieve revive count
			new iRevCount_ret = GetEntData(iCid[iI], g_iRevCountO, 1);

			//create a data pack to pass down info
			//so we effectively only execute spirit's state changes
			//if we detect that the self-revive did in fact execute
			new Handle:hPack = CreateDataPack();
			WritePackCell(hPack,iCid[iI]);
			WritePackCell(hPack,iRevCount_ret);

			//here we give health through the console command
			//which is used to revive the player (no other way
			//I know of, setting the m_isIncapacitated in
			//CTerrorPlayer revives them but they can't move!)
			new iflags=GetCommandFlags("give");
			SetCommandFlags("give", iflags & ~FCVAR_CHEAT);
			FakeClientCommand(iCid[iI],"give health");
			SetCommandFlags("give", iflags);

			//and remove their health here (since "give health" gives them 100!)
			CreateTimer(0.5,Spirit_ChangeHP,hPack);

			//here we check if there's anyone else with
			//the spirit perk who's also incapped, so we
			//know if we should continue allowing crawling

			//first, check if crawling adjustments are allowed
			//if not, then just break right away
			/*if (g_iSpirit_crawling==0
				|| g_iSpirit_enable==0)
				break;

			new iCrawlClient=-1;
			for (new iI2=1 ; iI2<=MaxClients ; iI2++)
			{
				if (g_iConfirm[iI2]==0) continue;
				if (g_iSur1[iI2]==3
					&& g_iPIncap[iI2]!=0)
				{
					iCrawlClient=iI2;
					break;
				}
			}
			if (iCrawlClient>0)
				SetConVarInt(FindConVar("survivor_allow_crawling"),1,false,false);
			else
				SetConVarInt(FindConVar("survivor_allow_crawling"),0,false,false);*/

			//finally, since spirit fired, break the loop
			//since we only want one person to self-revive at a time
			return;
		}
	}
	return;
}

//cooldown timer
public Action:Spirit_CooldownTimer (Handle:timer, any:iCid)
{
	KillTimer(timer);
	g_iSpiritTimer[iCid]=INVALID_HANDLE;
	g_flSpiritCooldownEnd[iCid]=0.0;
	//if the cooldown's been turned off,
	//that means a new round has started
	//and we can skip everything here
	
	//if (IsServerProcessing()==false
		//|| g_iSpiritCooldown[iCid]==0)
		//return Plugin_Stop;

	if (g_iSpiritCooldown[iCid]==0)
		return Plugin_Stop;

	g_iSpiritCooldown[iCid]=0;
	g_flSpiritCooldownEnd[iCid]=0.0;

	//and this sends the client a hint message
	if (IsClientInGame(iCid)==true
		&& IsPlayerAlive(iCid)==true
		&& GetClientTeam(iCid)==2
		&& IsFakeClient(iCid)==false)
		PrintHintText(iCid,"%t", "SpiritMessageHintTimerFinished");

	return Plugin_Stop;
}

//timer for removing hp
//(like juggernaut, removing it too quickly
//confuses the game and doesn't remove it =/)
public Action:Spirit_ChangeHP (Handle:timer, any:hPack)
{
	//----DEBUG----
	//PrintToChatAll("\x05spirit\x03 init changehp");

	//retrieve vars from pack
	ResetPack(hPack);
	new iCid = ReadPackCell(hPack);
	new iRevCount_ret = ReadPackCell(hPack);
	CloseHandle(hPack);

	//only execute spirit functions after checks pass
	if (IsServerProcessing()==true
		&& IsClientInGame(iCid) == true
		&& GetEntData(iCid,g_iIncapO) == 0
		&& IsPlayerAlive(iCid)==true
		&& GetClientTeam(iCid)==2)
	{
		//----DEBUG----
		//PrintToChatAll("\x05spirit\x03 checks passed");

		//set revive count after self-revive
		SetEntData(iCid, g_iRevCountO, iRevCount_ret+1, 1);
		if (iRevCount_ret+1 >= 2)
		{
			//borrowed from Crimson Fox's Black and White Defib code
			SetEntProp(iCid, Prop_Send, "m_isGoingToDie", 1);

			CreateTimer(1.0, Spirit_Warning1, iCid);
			CreateTimer(1.5, Spirit_Warning1, iCid);
			CreateTimer(2.0, Spirit_Warning1, iCid);
			CreateTimer(2.5, Spirit_Warning1, iCid);
		}
		//and we give them bonus health buffer here
		SetEntDataFloat(iCid,g_iHPBuffO, GetEntDataFloat(iCid,g_iHPBuffO)+g_iSpirit_buff ,true);
		//set their health back to 1
		SetEntityHealth(iCid,1);

		//get the proper cd number for the game mode
		new iTime;
			iTime=g_iSpirit_cd;

		//spirit-specific functions
		g_iSpiritTimer[iCid]=CreateTimer(iTime*1.0,Spirit_CooldownTimer,iCid);
		g_iPIncap[iCid]=0;
		g_iSpiritCooldown[iCid]=1;
		g_flSpiritCooldownEnd[iCid]=GetGameTime() + (iTime*1.0);

		//show a message if it's not a bot
		if (iRevCount_ret+1 >= 2)
			PrintHintText(iCid, "%t", "SpiritMessageHintBWWarning");
		else
			PrintHintText(iCid,"Spirit: %t!", "SpiritMessageHintSuccess");
	}

	//always destroy the timer, since it's possible spirit may not have executed
	KillTimer(timer);
	return Plugin_Stop;
}

public Action:Spirit_Warning1(Handle:timer, any:iCid)
{
	PrintToChat(iCid,"\x01***** \x03%t \x01*****", "SpiritMessageHintBWWarning");

	KillTimer(timer);
	return Plugin_Stop;
}



//=============================
// Sur2: Helping Hand
//=============================

//fired before reviving begins,reduces revive time
HelpHand_OnReviveBegin (iCid)
{
	//check if cvar changes are allowed
	//for this perk; if not, then stop
	if (g_iHelpHand_convar==0)
		return 0;

	//check if perk is enabled
	if (g_iHelpHand_enable==0)
		return 0;

	//----DEBUG----
	//PrintToChatAll("\x03revive begin detected, reviver: \x01%i\x03, subject: \x01%i",iCid,iSub);

	//check for helping hand
	if (g_iSur2[iCid]==3
		&& g_iConfirm[iCid]==1)
	{
		//----DEBUG----
		//PrintToChatAll("\x03-perk present, setting revive time to \x01%f",g_flReviveTime/2);

		g_hReviveDuration.FloatValue = g_flReviveTime * g_flHelpHand_timemult;
		return 0;
	}

	//otherwise, reset the revive duration
	else
	{
		//----DEBUG----
		//PrintToChatAll("\x03-no perk, attempting to reset revive time to \x01%f",g_flReviveTime);

		g_hReviveDuration.FloatValue = g_flReviveTime;
		return 0;
	}
}

HelpHand_OnReviveSuccess (iCid, iSub, iLedge)
{
	//----DEBUG----
	//PrintToChatAll("\x05helphand\x03 reviver: \x01%i\x03, subject: \x01%i",iCid,iSub);

	//then check for helping hand
	if (g_iSur2[iCid]==3 && g_iConfirm[iCid]==1 && g_iHelpHand_enable==1)
	{
		switch (iLedge)
		{
		case 1:
			{
				g_iMyDisabler[iSub] = -1;

				//----DEBUG----
				//PrintToChatAll("\x03-ledge hang save detected");
			}
		case 0:
			{
				//----DEBUG----
				//PrintToChatAll("\x03-m_healthBuffer offset: \x01%i",iHPBuffO);
				//PrintToChatAll("\x03-client \x01%i\x03 value at offset: \x01%f",iSub,GetEntDataFloat(iSub,g_iHPBuffO));

				decl iBuff;
					iBuff=g_iHelpHand_buff;

				SetEntDataFloat(iSub,g_iHPBuffO, GetEntDataFloat(iSub,g_iHPBuffO)+iBuff ,true);

				CreateTimer(0.5, HelpHand_Delayed, iCid);

				//----DEBUG----
				//PrintToChatAll("\x03-value at offset, post-mod: \x01%f",GetEntDataFloat(iSub,g_iHPBuffO));

				new String:st_name[24];
				GetClientName(iSub,st_name,24);
				PrintHintText(iCid,"Helping Hand: %t!", "HelpingHandMessageHintDonor", st_name);
				GetClientName(iCid,st_name,24);
				PrintHintText(iSub,"Helping Hand: %t!", "HelpingHandMessageHintReceiver", st_name);
			}
		}
	}

	//----DEBUG----
	//PrintToChatAll("\x03-revive end, attempting to reset revive time to \x01%f",g_flReviveTime);

	//only adjust the convar if
	//convar changes are allowed
	//for this perk
	if (g_iHelpHand_convar==1 && g_iHelpHand_enable==1)
		g_hReviveDuration.FloatValue = g_flReviveTime;

	//and then check if we need to continue allowing crawling
	//by running checks through everyone...
	//...but first, check if spirit convar changes are allowed
	/*if (g_iSpirit_crawling==1 && g_iSpirit_enable==1)
	{
		new iCrawlClient=-1;
		for (new iI2=1 ; iI2<=MaxClients ; iI2++)
		{
			if (g_iConfirm[iI2]==0) continue;
			if (g_iSur2[iI2]==2
				&& g_iPIncap[iI2]!=0)
			{
				iCrawlClient=iI2;
				break;
			}
		}
		if (iCrawlClient>0)
			SetConVarInt(FindConVar("survivor_allow_crawling"),1,false,false);
		else
			SetConVarInt(FindConVar("survivor_allow_crawling"),0,false,false);
	}*/

	return 0;
}

public Action:HelpHand_Delayed (Handle:timer, any:iCid)
{
	if (IsServerProcessing()==true
		&& IsValidEntity(iCid)==true
		&& IsClientInGame(iCid)==true
		&& GetClientTeam(iCid)==2)
	{
		//----DEBUG----
		//PrintToChatAll("\x05helphand\x03 attempting to give reviver bonus to \x01%i",iCid);
		//new g_iHPBuffTimeO;
		//g_iHPBuffTimeO = FindSendPropInfo("CTerrorPlayer","m_healthBufferTime");
		//PrintToChatAll("\x03- health buffer time \x01%i %f",g_iHPBuffTimeO, GetEntDataFloat(iCid,g_iHPBuffTimeO));

		decl iBuff;
			iBuff=g_iHelpHand_buff;

		//SetEntProp(iCid,Prop_Data,"m_iHealth", GetEntProp(iCid,Prop_Data,"m_iHealth")+ iBuff/3 );

		SetEntDataFloat(iCid, g_iHPBuffTimeO, GetGameTime(), true);
		new Float:flBuff_ret = GetEntDataFloat(iCid,g_iHPBuffO);
		if (flBuff_ret <= 0)
			flBuff_ret = 0.0;
		SetEntDataFloat(iCid, g_iHPBuffO, flBuff_ret + iBuff/2 , true);
	}

	KillTimer(timer);
	return Plugin_Stop;
}

//=============================
// Sur2: Pack Cat
//=============================

//gives full ammo
PC_GiveFullAmmo(int client)
{
	if (IsEnable_SurvivorSecondary_PackCat()
		&& IsClientConfirm(client)
		&& IsClientSelect_SurvivorSecondary_PackCat(client))
	{
		int weapon = GetPlayerWeaponSlot(client, L4D_WEAPON_SLOT_PRIMARY);
		if( weapon != -1 )
		{
			int ammoType = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");
			int maxAmmoCarry = AmmoDef.MaxCarry(ammoType);
			if (maxAmmoCarry <= 0) return;

			int refill = RoundToNearest(maxAmmoCarry * g_flPackCat_ammorefill);
			if (IsEnable_SurvivorTertiary_PackRat()
				&& IsClientConfirm(client)
				&& IsClientSelect_SurvivorTertiary_PackRat(client))
				refill = RoundToNearest(refill * (1 + g_flPack_ammomult));
			int currentReserve = L4D_GetReserveAmmo(client, weapon);
			L4D_SetReserveAmmo(client, weapon, currentReserve + refill);
		}
	}
}

//=============================
// Sur3: Pack Rat
//=============================

//gives full ammo
PR_GiveFullAmmo(int client, int extraClip = 0)
{
	if (IsEnable_SurvivorTertiary_PackRat()
		&& IsClientConfirm(client)
		&& IsClientSelect_SurvivorTertiary_PackRat(client))
	{
		int weapon = GetPlayerWeaponSlot(client, L4D_WEAPON_SLOT_PRIMARY);
		if( weapon != -1 )
		{
			int ammoType = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");
			int maxAmmoCarry = AmmoDef.MaxCarry(ammoType);
			if (maxAmmoCarry <= 0) return;

			char class[56];
			GetEdictClassname(weapon, class, sizeof(class));
			int clipSize = L4D2_GetIntWeaponAttribute(class, L4D2IWA_ClipSize);
			int clipCurrent = GetEntProp(weapon, Prop_Send, "m_iClip1");
			int clipMissing = clipSize - clipCurrent;

			int refill = RoundToNearest(maxAmmoCarry * (1 + g_flPack_ammomult)) + (extraClip * clipSize) + clipMissing;
			L4D_SetReserveAmmo(client, weapon, refill);
		}
	}
}

//=============================
// Sur3: Chem Reliant
//=============================

//on drug used
Chem_OnDrugUsed (iCid)
{
	//check if perk is enabled
	if (g_iChem_enable==0)
		return 0;

	//----DEBUG----
	//PrintToChatAll("\x03Pill user: \x01%i", iCid);

	if (g_iSur3[iCid]==2
		&& g_iConfirm[iCid]==1)
	{
		new Float:flBuff=GetEntDataFloat(iCid,g_iHPBuffO);
		new iHP=GetEntProp(iCid,Prop_Data,"m_iHealth");
		
		//so we need to test the maxbound for
		//how much health buffer we can give
		//which can vary depending on whether
		//they have unbreakable or not

		//CASE 1: HAS UNBREAKABLE
		if (g_iSur2[iCid]==1 && g_iUnbreak_enable==1)
		{
			//CASE 1A:
			//combined health + chem reliant < max health possible
			if (flBuff + iHP + g_iChem_buff < 100 + g_iUnbreak_hp)
				//this is the easiest, just give them chem reliant bonus
				SetEntDataFloat(iCid,g_iHPBuffO, flBuff+g_iChem_buff ,true);

			//CASE 1B:
			//combined health + chem reliant > max health possible
			else
				//this is a bit trickier, give them the difference
				//between the max health possible and their current health
				SetEntDataFloat(iCid,g_iHPBuffO, (100.0+g_iUnbreak_hp)-iHP ,true);
		}
		//CASE 2: DOES NOT HAVE UNBREAKABLE
		else
		{
			//CASE 1A:
			//combined health + chem reliant < max health possible
			if (flBuff + iHP + g_iChem_buff < 100)
				//this is the easiest, just give them chem reliant bonus
				SetEntDataFloat(iCid,g_iHPBuffO, flBuff+g_iChem_buff ,true);

			//CASE 1B:
			//combined health + chem reliant > max health possible
			else
				//this is a bit trickier, give them the difference
				//between the max health possible and their current health
				SetEntDataFloat(iCid,g_iHPBuffO, 100.0-iHP ,true);
		}
	}
	return 0;
}

//called on roundstart or on confirming perks,
//gives pills off the start
Event_Confirm_ChemReliant (iCid)
{
	if (iCid==0
		|| GetClientTeam(iCid)!=2
		|| IsPlayerAlive(iCid)==false
		|| g_iConfirm[iCid]==0
		|| g_iSur3[iCid]!=2)
		return;

	//check if perk is enabled
	if (g_iChem_enable==0)
		return;

	new iflags=GetCommandFlags("give");
	SetCommandFlags("give", iflags & ~FCVAR_CHEAT);
	if (GetRandomInt(0,1)==1)
		FakeClientCommand(iCid,"give pain_pills");
	else
		FakeClientCommand(iCid,"give adrenaline");
	SetCommandFlags("give", iflags);

	return;
}



//=============================
// Sur3: Hard to Kill
//=============================

HardToKill_OnIncap (iCid)
{
	if (GetClientTeam(iCid)!=2
		|| g_iConfirm[iCid]==0
		|| GetClientTeam(iCid)!=2)
		return;

	if (g_iHard_enable==0)
		return;

	if (g_iSur3[iCid]==3)
	{
		//new iHP=GetEntProp(iCid,Prop_Data,"m_iHealth");

		//----DEBUG----
		//PrintToChatAll("\x03hard to kill fire, client \x01%i\x03, health \x01%i",iCid,iHP);

		//SetEntProp(iCid,Prop_Data,"m_iHealth", iHP + RoundToNearest(iHP*g_flHard_hpmult) );
		//SetEntDataFloat(iCid,g_iHPBuffO, flHPBuff+300 ,true);
		CreateTimer(0.5,HardToKill_Delayed,iCid);

		//----DEBUG----
		//PrintToChatAll("\x03-postfire values, health \x01%i",GetEntProp(iCid,Prop_Data,"m_iHealth"));
	}
}

public Action:HardToKill_Delayed (Handle:timer, any:iCid)
{
	if (IsServerProcessing()==true
		&& IsValidEntity(iCid)==true
		&& IsClientInGame(iCid)==true
		&& GetClientTeam(iCid)==2)
	{
		new iHP=GetEntProp(iCid,Prop_Data,"m_iHealth");

		SetEntProp(iCid,Prop_Data,"m_iHealth", iHP + RoundToNearest(iHP*g_flHard_hpmult) );

		iHP = RoundToNearest( 300*(g_flHard_hpmult+1) );
		if (GetEntProp(iCid,Prop_Data,"m_iHealth") > iHP)
			SetEntProp(iCid,Prop_Data,"m_iHealth", iHP);
	}

	KillTimer(timer);
	return Plugin_Stop;
}

//=============================
// Sur3: Extreme Conditioning
//=============================

Extreme_Rebuild ()
{
	//if the server's not running or
	//is in the middle of loading, stop
	if (IsServerProcessing()==false)
		return;

	//check if perk is enabled
	if (g_iExtreme_enable==0)
		return;

	//----DEBUG----
	//PrintToChatAll("\x03extreme cond rebuilding");

	for (new iI=1 ; iI<=MaxClients ; iI++)
	{
		if (IsClientInGame(iI)==true
			&& IsPlayerAlive(iI)==true
			&& g_iSur3[iI]==4
			&& g_iConfirm[iI]==1
			&& GetClientTeam(iI)==2)
		{
			if (g_iSur3[iI]==4
				&& g_iConfirm[iI]==1)
				SetEntDataFloat(iI,g_iLaggedMovementO, 1.0*g_flExtreme_rate ,true);
			else
				SetEntDataFloat(iI,g_iLaggedMovementO, 1.0 ,true);

			//----DEBUG----
			//PrintToChatAll("\x03-registering \x01%i",iI);
		}
	}
}

//===========================
// CHRISTMAS GIFT
//===========================

void ChristmasGift_OnInfectedKilled(int victim, int attacker)
{
	if (!g_bAvailable_l4d2_gifts) return;

	if (victim == attacker) return;
	if (!IsClientInGame(victim) || GetClientTeam(victim) != 3) return;

	if (GetEntProp(victim, Prop_Send, "m_zombieClass") == 8)
	{
		if (!IsExist_SurvivorPrimary_ChristmasGift()) return;

		L4D2_Gifts_DropGift(victim, L4D2_GIFT_SPECIAL);
	}
	else
	{
		if (IsInvalidClient(attacker)) return;
		if (GetClientTeam(attacker) != 2) return;
		if (!IsEnable_SurvivorPrimary_ChristmasGift()) return;
		if (!IsClientConfirm(attacker)) return;
		if (!IsClientSelect_SurvivorPrimary_ChristmasGift(attacker)) return;

		L4D2_Gifts_DropGift(victim, L4D2_GIFT_STANDARD);
	}
}

void ChristmasGift_OnWitchKilled(int witch)
{
	if (!g_bAvailable_l4d2_gifts) return;

	if (witch <= 0 || !IsValidEntity(witch)) return;
	if (!IsExist_SurvivorPrimary_ChristmasGift()) return;

	L4D2_Gifts_DropGift(witch, L4D2_GIFT_SPECIAL);
}

// #endregion
// =======================================================================

// =======================================================================
// #region Menu

//====================================================
//====================================================
//					M	E	N	U
//====================================================
//====================================================

//======================================
//	CHAT CHECK, TOP MENU, SELECT SUBMENU
//======================================

//check chat
public Action:MenuOpen_OnSay(iCid, args)
{
	new iT = GetClientTeam(iCid);

	//don't show the menu to infected
	if (iT == 3)
	{
		g_iConfirm[iCid] = 0;
		return Plugin_Handled;
	}

	if (g_iConfirm[iCid]==0)
	{
		if (iT==2)
			SendPanelToClient(Menu_Initial(iCid),iCid,Menu_ChooseInit,MENU_TIME_FOREVER);
		else if (iT==3)
			g_iConfirm[iCid] = 1;
		return Plugin_Handled;
	}

	if (iT==2)
		SendPanelToClient(Menu_ShowChoices(iCid),iCid,Menu_DoNothing,15);

	return Plugin_Handled;
}

//build initial menu
public Handle:Menu_Initial (iCid)
{
	new Handle:menu = CreatePanel();
	decl String:stPanel[128];
	SetPanelTitle(menu, "tPoncho's Perkmod");

	DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);

	Format(stPanel, 128, "%t", "MenuInitialDescriptionCustom");
	DrawPanelText(menu, stPanel);
	Format(stPanel, 128, "%t", "MenuInitialPanelCustom");
	DrawPanelItem(menu, stPanel);

	//random perks
	Format(stPanel, 128, "%t", "MenuInitialDescriptionRandom");
	DrawPanelText(menu, stPanel);
	Format(stPanel, 128, "%t", "MenuInitialPanelRandom");
	DrawPanelItem(menu, stPanel);

	Format(stPanel, 128, "%t", "MenuInitialDescriptionAuto");
	DrawPanelText(menu, stPanel);
	Format(stPanel, 128, "%t", "MenuInitialPanelAuto");
	DrawPanelItem(menu, stPanel);

	return menu;
}

public Menu_ChooseInit (Handle:topmenu, MenuAction:action, param1, param2)
{
	if (topmenu!=INVALID_HANDLE) CloseHandle(topmenu);
	if (action==MenuAction_Select)
	{
		switch(param2)
		{
			case 6:
				SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
			case 7:
				{
					AssignRandomPerks(param1);
					PrintHintText(param1,"Perkmod: %t", "MessageHintThanksForChoosing");
				}
			case 8:
				{
					g_iConfirm[param1]=1;
					Event_Confirm_Unbreakable(param1);
					Event_Confirm_Grenadier(param1);
					Event_Confirm_ChemReliant(param1);
					Event_Confirm_MA(param1);
					Extreme_Rebuild();
					PrintHintText(param1,"Perkmod: %t", "MessageHintThanksForChoosing");
				}
			default:
				{
					if (IsClientInGame(param1)==true)
						SendPanelToClient(Menu_Initial(param1),param1,Menu_ChooseInit,MENU_TIME_FOREVER);
				}
		}
	}
	else
	{
		if (IsClientInGame(param1)==true)
			SendPanelToClient(Menu_Initial(param1),param1,Menu_ChooseInit,MENU_TIME_FOREVER);
	}
}

//build top menu
public Handle:Menu_Top (iCid)
{
	new Handle:menu = CreatePanel();
	decl String:st_perk[32];
	decl String:st_display[MAXPLAYERS+1];

	Format(st_display, 64, "%t", "MenuTopDescription");	
	DrawPanelText(menu, st_display);

	//set name for sur1 perk
	if (g_iSur1[iCid]==1 && g_iStopping_enable==1)
		st_perk="Stopping Power";
	else if (g_iSur1[iCid]==2 && g_iSoH_enable==1)
		st_perk="Sleight of Hand";
	else if (g_iSur1[iCid]==3 && g_iPyro_enable==1)
		st_perk="Pyrotechnician";
	else if (g_iSur1[iCid]==4 && g_iMA_enable==1)
		st_perk="Martial Artist";
	else if (g_iSur1[iCid]==5 && g_iChristmas_enable==1)
		st_perk="Christmas Gift";
	else
		st_perk="Not set";

	Format(st_display,64,"Survivor - Primary (%s)",st_perk);
	DrawPanelItem(menu,st_display);


	//set name for sur2 perk
	if (g_iSur2[iCid]==1 && g_iUnbreak_enable==1)
		st_perk="Unbreakable";
	else if (g_iSur2[iCid]==2 && g_iSpirit_enable==1)
		st_perk="Spirit";
	else if (g_iSur2[iCid]==3 && g_iHelpHand_enable==1)
		st_perk="Helping Hand";
	else if (g_iSur2[iCid]==4 && g_iPackCat_enable==1)
		st_perk="Pack Cat";
	else
		st_perk="Not set";

	Format(st_display,64,"Survivor - Secondary (%s)", st_perk);
	DrawPanelItem(menu,st_display);

	//set name for sur3 perk
	if (g_iSur3[iCid]==1 && g_iPack_enable==1)
		st_perk="Pack Rat";
	else if (g_iSur3[iCid]==2 && g_iChem_enable==1)
		st_perk="Chem Reliant";
	else if (g_iSur3[iCid]==3 && g_iHard_enable==1)
		st_perk="Hard to Kill";
	else if (g_iSur3[iCid]==4 && g_iExtreme_enable==1)
		st_perk="Extreme Conditioning";
	else
		st_perk="Not set";

	Format(st_display,64,"Survivor - Tertiary (%s)", st_perk);
	DrawPanelItem(menu,st_display);

	DrawPanelItem(menu,st_display, ITEMDRAW_NOTEXT);
	DrawPanelItem(menu,st_display, ITEMDRAW_NOTEXT);
	DrawPanelItem(menu,st_display, ITEMDRAW_NOTEXT);
	DrawPanelItem(menu,st_display, ITEMDRAW_NOTEXT);
	Format(st_display, 64, "%t", "MenuTopDoneDescription");	
	DrawPanelText(menu, st_display);
	Format(st_display, 64, "%t", "MenuTopDonePanel");	
	DrawPanelItem(menu, st_display);
	return menu;
}

//choose a submenu from top perk menu
public Menu_ChooseSubMenu (Handle:topmenu, MenuAction:action, param1, param2)
{
	if (topmenu!=INVALID_HANDLE) CloseHandle(topmenu);
	if (action==MenuAction_Select)
	{
		switch(param2)
		{
			case 1:
				SendPanelToClient(Menu_Sur1Perk(param1),param1,Menu_ChooseSur1Perk,MENU_TIME_FOREVER);
			case 2:
				SendPanelToClient(Menu_Sur2Perk(param1),param1,Menu_ChooseSur2Perk,MENU_TIME_FOREVER);
			case 3:
				SendPanelToClient(Menu_Sur3Perk(param1),param1,Menu_ChooseSur3Perk,MENU_TIME_FOREVER);
			case 8:
				SendPanelToClient(Menu_Confirm(param1),param1,Menu_ChooseConfirm,MENU_TIME_FOREVER);
			default:
				{
					if (IsClientInGame(param1)==true)
						SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
				}
		}
	}

	else
	{
		if (IsClientInGame(param1)==true)
			SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
	}
}


//menu for confirming perk choices
public Handle:Menu_Confirm (iCid)
{
	new Handle:menu = CreatePanel();
	decl String:panel[128];
	Format(panel, 128, "%t", "MenuConfirmConfirmDescription");	
	DrawPanelText(menu, panel);
	Format(panel, 128, "%t", "MenuConfirmConfirmPanel");
	DrawPanelItem(menu,panel);
	Format(panel, 128, "%t", "MenuConfirmCancelDescription");
	DrawPanelText(menu,panel);
	Format(panel, 128, "%t", "MenuConfirmCancelPanel");
	DrawPanelItem(menu,panel);
	return menu;
}

//confirm
public Menu_ChooseConfirm (Handle:topmenu, MenuAction:action, param1, param2)
{
	if (topmenu!=INVALID_HANDLE) CloseHandle(topmenu);
	if (action==MenuAction_Select)
	{
		switch(param2)
		{
			case 1:
			{
				g_iConfirm[param1]=1;
				PrintToChat(param1,"\x03[SM] %t", "MessageChatConfirmed");
				Event_Confirm_Unbreakable(param1);
				Event_Confirm_Grenadier(param1);
				Event_Confirm_ChemReliant(param1);
				Event_Confirm_MA(param1);
				Extreme_Rebuild();
			}
			case 2:
				SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
			default:
			{
				if (IsClientInGame(param1)==true)
					SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
			}
		}
	}

	else
		SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
}

//do nothing
//for displaying perk choices after confirming
public Menu_DoNothing (Handle:topmenu, MenuAction:action, param1, param2)
{}

public Action:MenuTeam_OnSay(iCid, args)
{
	new iT = GetClientTeam(iCid);
	if (iT != 2)
	{
		PrintToChat(iCid, "\x03[SM] This team command is only available for survivors.");
		return Plugin_Handled;
	}

	SendPanelToClient(Menu_Team(iCid), iCid, Menu_DoNothing, 30);
	return Plugin_Handled;
}

public Handle:Menu_Team(iCid)
{
	new Handle:menu = CreatePanel();
	new String:line[256];
	new String:name[64];
	new String:primary[32];
	new String:secondary[32];
	new String:tertiary[32];
	new String:mark[8];

	SetPanelTitle(menu, "Team Perk Status:");

	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || GetClientTeam(i) != 2 || i == iCid)
			continue;

		GetClientName(i, name, sizeof(name));
		if (g_iConfirm[i] == 1)
			Format(mark, sizeof(mark), "■");
		else
			Format(mark, sizeof(mark), "□");

		GetSur1Name(i, primary, sizeof(primary));
		GetSur2Name(i, secondary, sizeof(secondary));
		GetSur3Name(i, tertiary, sizeof(tertiary));

		Format(line, sizeof(line), "%s | %s | %s | %s | %s", name, mark, primary, secondary, tertiary);
		DrawPanelItem(menu, line);
	}

	return menu;
}

stock void GetSur1Name(int iCid, char[] buffer, int maxlength)
{
	if (g_iSur1[iCid] == 1 && g_iStopping_enable == 1)
		strcopy(buffer, maxlength, "Stopping Power");
	else if (g_iSur1[iCid] == 2 && g_iSoH_enable == 1)
		strcopy(buffer, maxlength, "Sleight of Hand");
	else if (g_iSur1[iCid] == 3 && g_iPyro_enable == 1)
		strcopy(buffer, maxlength, "Pyrotechnician");
	else if (g_iSur1[iCid] == 4 && g_iMA_enable == 1)
		strcopy(buffer, maxlength, "Martial Artist");
	else if (g_iSur1[iCid] == 5 && g_iChristmas_enable == 1)
		strcopy(buffer, maxlength, "Christmas Gift");
	else
		strcopy(buffer, maxlength, "Not set");
}

stock void GetSur2Name(int iCid, char[] buffer, int maxlength)
{
	if (g_iSur2[iCid] == 1 && g_iUnbreak_enable == 1)
		strcopy(buffer, maxlength, "Unbreakable");
	else if (g_iSur2[iCid] == 2 && g_iSpirit_enable == 1)
		strcopy(buffer, maxlength, "Spirit");
	else if (g_iSur2[iCid] == 3 && g_iHelpHand_enable == 1)
		strcopy(buffer, maxlength, "Helping Hand");
	else if (g_iSur2[iCid] == 4 && g_iPackCat_enable == 1)
		strcopy(buffer, maxlength, "Pack Cat");
	else
		strcopy(buffer, maxlength, "Not set");
}

stock void GetSur3Name(int iCid, char[] buffer, int maxlength)
{
	if (g_iSur3[iCid] == 1 && g_iPack_enable == 1)
		strcopy(buffer, maxlength, "Pack Rat");
	else if (g_iSur3[iCid] == 2 && g_iChem_enable == 1)
		strcopy(buffer, maxlength, "Chem Reliant");
	else if (g_iSur3[iCid] == 3 && g_iHard_enable == 1)
		strcopy(buffer, maxlength, "Hard to Kill");
	else if (g_iSur3[iCid] == 4 && g_iExtreme_enable == 1)
		strcopy(buffer, maxlength, "Extreme Conditioning");
	else
		strcopy(buffer, maxlength, "Not set");
}

//shows perk choices
public Handle:Menu_ShowChoices (iCid)
{
	new Handle:menu=CreatePanel();
	SetPanelTitle(menu,"tPoncho's Perkmod");
	decl String:st_perk[128];
	decl iPerk;

	//show sur1 perk
	iPerk = g_iSur1[iCid];
	if (iPerk == 1 && g_iStopping_enable==1)
		Format(st_perk,128,"Stopping Power (%t)",  "StoppingPowerDescriptionPanel", RoundToNearest(g_flStopping_dmgmult*100));
	else if (iPerk == 2 && g_iSoH_enable==1)
		Format(st_perk,128,"Sleight of Hand (%t)", "SleighOfHandDescriptionPanel", RoundToNearest(100 * ((1/g_flSoH_rate)-1) ) ) ;
	else if (iPerk == 3 && g_iPyro_enable==1)
		Format(st_perk,128,"Pyrotechnician (%t)", "PyroDescriptionPanel", g_iPyro_maxticks*2 );
	else if (iPerk == 4 && g_iMA_enable==1)
	{
		if (g_iMA_maxpenalty < 6)
			Format(st_perk,128,"Martial Artist (%t)", "MartialArtistDescriptionPanel1");
		else
			Format(st_perk,128,"Martial Artist (%t)", "MartialArtistDescriptionPanel");
	}
	else if (iPerk == 5 && g_iChristmas_enable==1)
		Format(st_perk,128,"Christmas Gift (%t)", "ChristmasGiftDescriptionPanel");
	else
		Format(st_perk,128,"%t", "NotSet");

	DrawPanelItem(menu,"Survivor, primary:");
	DrawPanelText(menu,st_perk);

	//show sur2 perk
	iPerk = g_iSur2[iCid];
	if (iPerk == 1 && g_iUnbreak_enable==1)
		Format(st_perk,128,"Unbreakable (%t)", "UnbreakableDescriptionPanel", g_iUnbreak_hp);
	else if (iPerk == 2 && g_iSpirit_enable==1)
	{
		decl iTime;
			iTime=g_iSpirit_cd;
		Format(st_perk,128,"Spirit (%t)", "SpiritDescriptionPanel", g_iSpirit_buff, iTime );
	}
	else if (iPerk == 3 && g_iHelpHand_enable==1)
	{
		decl iBuff;
			iBuff=g_iHelpHand_buff;
		if (g_iHelpHand_convar==1)
			Format(st_perk,128,"Helping Hand (%t)", "HelpingHandDescriptionPanel2", iBuff);
		else
			Format(st_perk,128,"Helping Hand (%t)", "HelpingHandDescriptionPanel", iBuff);
	}
	else if (iPerk == 4 && g_iPackCat_enable==1)
		Format(st_perk,128,"Pack Cat (%t)", "PackCatDescriptionPanel", RoundToNearest(g_flPackCat_ammorefill*100));
	else
		Format(st_perk,128,"%t", "NotSet");

	DrawPanelItem(menu,"Survivor, secondary:");
	DrawPanelText(menu,st_perk);

	//show sur3 perk
	iPerk = g_iSur3[iCid];
	if (iPerk == 1 && g_iPack_enable==1)
		Format(st_perk,128,"Pack Rat (%t)", "PackRatDescriptionPanel", RoundToNearest(g_flPack_ammomult*100) );
	else if (iPerk == 2 && g_iChem_enable==1)
		Format(st_perk,128,"Chem Reliant (%t)", "ChemReliantDescriptionPanel", g_iChem_buff);
	else if (iPerk == 3 && g_iHard_enable==1)
		Format(st_perk,128,"Hard to Kill (%t)", "HardToKillDescriptionPanel");
	else if (iPerk == 4 && g_iExtreme_enable==1)
		Format(st_perk,128,"Extreme Conditioning (%t)", "ExtremeConditioningDescriptionPanel", RoundToNearest(g_flExtreme_rate*100-100));
	else
		Format(st_perk,128,"%t", "NotSet");

	DrawPanelItem(menu,"Survivor, tertiary:");
	DrawPanelText(menu,st_perk);

	return menu;
}

//=============================
//	SUR1 PERK CHOICE
//=============================

//build menu for Sur1 Perks
public Handle:Menu_Sur1Perk (client)
{
	new Handle:menu = CreatePanel();
	SetPanelTitle(menu, "tPoncho's Perkmod - Survivor: Primary");
	decl String:st_display[MAXPLAYERS+1];
	decl String:st_current[10];

	//set name for perk 1
	if (g_iStopping_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur1[client])
		{
			case 1: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Stopping Power %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "StoppingPowerDescriptionPanel", RoundToNearest(g_flStopping_dmgmult*100) );
		DrawPanelText(menu,st_display);
	}

	//set name for perk 2
	if (g_iSoH_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur1[client])
		{
			case 2: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Sleight of Hand %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "SleighOfHandDescriptionPanel", RoundToNearest(100 * ((1/g_flSoH_rate)-1) ) );
		DrawPanelText(menu,st_display);
	}

	//set name for perk 3
	if (g_iPyro_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur1[client])
		{
			case 3: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Pyrotechnician %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "PyroDescriptionPanel1");
		DrawPanelText(menu, st_display);
		Format(st_display,64,"%t", "PyroDescriptionPanel2", g_iPyro_maxticks*2 );
		DrawPanelText(menu, st_display);
	}

	//set name for perk 4
	if (g_iMA_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur1[client])
		{
			case 4: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Martial Artist %s",st_current);
		DrawPanelItem(menu, st_display);
		if (g_iMA_maxpenalty <6)
		{
			Format(st_display,64,"%t", "MartialArtistDescriptionPanel1");
			DrawPanelText(menu, st_display);
		}
		else
		{
			Format(st_display,64,"%t", "MartialArtistDescriptionPanel");
			DrawPanelText(menu, st_display);
		}
	}

	//set name for perk 5
	if (g_iChristmas_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur1[client])
		{
			case 5: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Christmas Gift %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "ChristmasGiftDescriptionPanel");
		DrawPanelText(menu, st_display);
	}

	return menu;
}

//setting Sur1 perk and returning to top menu
public Menu_ChooseSur1Perk (Handle:menu, MenuAction:action, param1, param2)
{
	if (menu!=INVALID_HANDLE) CloseHandle(menu);
	if (action==MenuAction_Select)
	{
		switch(param2)
		{
			//stopping power
			case 1:
				g_iSur1[param1]=1;
			//sleight of hand
			case 2:
				g_iSur1[param1]=2;
			//pyrotechnician
			case 3:
				g_iSur1[param1]=3;
			//martial artist
			case 4:
				g_iSur1[param1]=4;
				//christmas gift
				case 5:
					g_iSur1[param1]=5;
		}
	}

	if (IsClientInGame(param1)==true)
		SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
}



//=============================
//	SUR2 CHOICE
//=============================

//build menu for Sur2 Perks
public Handle:Menu_Sur2Perk (client)
{
	new Handle:menu = CreatePanel();
	SetPanelTitle(menu, "tPoncho's Perkmod - Survivor: Secondary");
	decl String:st_display[MAXPLAYERS+1];
	decl String:st_current[10];

	//set name for perk 1
	if (g_iUnbreak_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur2[client])
		{
			case 1: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Unbreakable %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "UnbreakableDescriptionPanel", g_iUnbreak_hp );
		DrawPanelText(menu,st_display);
	}

	//set name for perk 2
	if (g_iSpirit_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur2[client])
		{
			case 2: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Spirit %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "SpiritDescriptionPanel1");
		DrawPanelText(menu,st_display);
		Format(st_display,64,"%t", "SpiritDescriptionPanel2", g_iSpirit_buff, g_iSpirit_cd );
		DrawPanelText(menu,st_display);
	}

	//set name for perk 3
	if (g_iHelpHand_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur2[client])
		{
			case 3: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Helping Hand %s",st_current);
		DrawPanelItem(menu,st_display);

		decl iBuff;
			iBuff=g_iHelpHand_buff;

		if (g_iHelpHand_convar==1)
		{
			Format(st_display,64,"%t", "HelpingHandDescriptionPanel2", iBuff);
			DrawPanelText(menu,st_display);
		}
		else
		{
			Format(st_display,64,"%t", "HelpingHandDescriptionPanel", iBuff);
			DrawPanelText(menu,st_display);
		}
	}

	//set name for perk 4
	if (g_iPackCat_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur2[client])
		{
			case 4: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Pack Cat %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "PackCatDescriptionPanel", RoundToNearest(g_flPackCat_ammorefill*100));
		DrawPanelText(menu,st_display);
	}

	return menu;
}

//setting Sur2 perk and returning to top menu
public Menu_ChooseSur2Perk (Handle:menu, MenuAction:action, param1, param2)
{
	if (menu!=INVALID_HANDLE) CloseHandle(menu);
	if (action==MenuAction_Select)
	{
		switch(param2)
		{
			//unbreakable
			case 1:
				g_iSur2[param1]=1;
			//spirit
			case 2:
				g_iSur2[param1]=2;
			//helping hand
			case 3:
				g_iSur2[param1]=3;
				//pack cat
				case 4:
					g_iSur2[param1]=4;
		}
	}

	if (IsClientInGame(param1)==true)
		SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
}



//=============================
//	SUR3 CHOICE
//=============================

//build menu for Sur3 Perks
public Handle:Menu_Sur3Perk (client)
{
	new Handle:menu = CreatePanel();
	SetPanelTitle(menu, "tPoncho's Perkmod - Survivor: Tertiary");
	decl String:st_display[MAXPLAYERS+1];
	decl String:st_current[10];

	//set name for perk 1
	if (g_iPack_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur3[client])
		{
			case 1: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Pack Rat %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "PackRatDescriptionPanel", RoundToNearest(g_flPack_ammomult*100) );
		DrawPanelText(menu,st_display);
	}

	//set name for perk 2
	if (g_iChem_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur3[client])
		{
			case 2: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Chem Reliant %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "ChemReliantDescriptionPanel", g_iChem_buff);
		DrawPanelText(menu,st_display);
	}

	//set name for perk 3
	if (g_iHard_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur3[client])
		{
			case 3: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Hard to Kill %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "HardToKillDescriptionPanel");
		DrawPanelText(menu,st_display);
	}

	//set name for perk 4
	if (g_iExtreme_enable==0)
	{
		DrawPanelItem(menu,"disabled", ITEMDRAW_NOTEXT);
	}
	else
	{
		switch (g_iSur3[client])
		{
			case 4: st_current="(CURRENT)";
			default: st_current="";
		}
		Format(st_display,64,"Extreme Conditioning %s",st_current);
		DrawPanelItem(menu,st_display);
		Format(st_display,64,"%t", "ExtremeConditioningDescriptionPanel", RoundToNearest(100*g_flExtreme_rate-100) );
		DrawPanelText(menu,st_display);
	}

	return menu;
}

//setting Sur3 perk and returning to top menu
public Menu_ChooseSur3Perk (Handle:menu, MenuAction:action, param1, param2)
{
	if (menu!=INVALID_HANDLE) CloseHandle(menu);
	if (action==MenuAction_Select)
	{
		switch(param2)
		{
			//pack rat
			case 1:
				g_iSur3[param1]=1;
			//chem reliant
			case 2:
				g_iSur3[param1]=2;
			//hard to kill
			case 3:
				g_iSur3[param1]=3;
			//extreme cond
			case 4:
				g_iSur3[param1]=4;
		}
	}

	if (IsClientInGame(param1)==true)
		SendPanelToClient(Menu_Top(param1),param1,Menu_ChooseSubMenu,MENU_TIME_FOREVER);
}


// #endregion
// =======================================================================

// =======================================================================
// #region Debug

//=============================
//	DEBUG
//=============================

/*
public Action:Debug_OnSay(iCid, args)
{
	if (args<1) return Plugin_Continue;
	decl String:st_chat[32];
	GetCmdArg(1,st_chat,32);

	if (StrEqual(st_chat,"debug reset perks",false)==true)
	{
		g_iConfirm[iCid]=0;
		PrintToChat(iCid,"\x03[SM] [DEBUG] g_iConfirm has been reset to 0");
		RebuildAll();
		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug spirit reset",false)==true)
	{
		PrintToChat(iCid,"\x03[SM] [DEBUG] spirit cooldown reset");
		g_iSpiritCooldown[iCid]=0;
		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug death",false)==true)
	{
		new iDeathTimeO=FindSendPropInfo("CTerrorPlayer","m_flDeathTime");
		PrintToChat(iCid,"\x03[SM] [DEBUG] m_fldeathtime offset \x01%i\x03", iDeathTimeO);
		PrintToChat(iCid,"\x03[SM] [DEBUG] -value at offset: \x01%f", GetEntDataFloat(iCid,iDeathTimeO));
		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug client",false)==true)
	{
		PrintToChat(iCid,"\x03[SM] [DEBUG] you are client: \x01%i", iCid);
		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug anim",false)==true)
	{
		PrintToChat(iCid,"\x03[SM] [DEBUG] creating timer, client \x01%i\x03, gunid \x01%i",iCid,GetEntDataEnt2(iCid,g_iActiveWO));
		CreateTimer(0.2,Debug_AnimTimer,iCid,TIMER_REPEAT);

		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug frustration",false)==true)
	{
		PrintToChat(iCid,"\x03[SM] [DEBUG] retrieving frustration values");
		new iOffs=FindSendPropInfo("Tank","m_frustration");
		PrintToChat(iCid,"\x03- offset \x01%i",iOffs);
		PrintToChat(iCid,"\x03- value at offset \x01%i", GetEntData(iCid,iOffs) );

		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug stamina",false)==true)
	{
		PrintToChat(iCid,"\x03[SM] [DEBUG] creating timer, client \x01%i\x03",iCid);
		CreateTimer(0.2,Debug_StaminaTimer,iCid,TIMER_REPEAT);

		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug maxclients",false)==true)
	{
		PrintToChat(iCid,"\x03[SM] [DEBUG] maxclients = \x01%i",MaxClients);

		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug ammo2",false)==true)
	{
		//new iAmmoO=FindDataMapInfo(iCid,"m_iAmmo");
		new iEntid = GetEntDataEnt2(iCid,g_iActiveWO);
		new iPrimO = FindSendPropInfo("CTerrorGun","m_iExtraPrimaryAmmo");
		//PrintToChatAll("\x03[SM] [DEBUG] Ammo Counts, offset \x01%i",iAmmoO);
		//for (new i=0; i<=31; i++)
		//{
			//PrintToChatAll("\x03%i: iCid\x01 %i\x03 gun\x01 %i",i,GetEntData(iCid,iAmmoO),GetEntData(iEntid,iAmmoO));
		//}
		PrintToChatAll("\x03[SM] [DEBUG] extra primary ammo, offset \x01%i\x03 value \x01%i",iPrimO,GetEntData(iEntid,iPrimO));
	}

	if (StrEqual(st_chat,"debug ammo",false)==true)
	{
		new iAmmoO=FindDataMapInfo(iCid,"m_iAmmo");
		PrintToChatAll("\x03[SM] [DEBUG] Ammo Counts, offset \x01%i",iAmmoO);
		for (new i=0; i<=47; i++)
			PrintToChatAll("\x03%i: iCid\x01 %i\x03",i,GetEntData(iCid,iAmmoO+i));
	}

	if (StrEqual(st_chat,"debug shotgunanim",false)==true)
	{
		PrintToChat(iCid,"\x03[SM] [DEBUG] retrieving shotgun reload anim values");
		new iEntid = GetEntDataEnt2(iCid,g_iActiveWO);
		decl iOffs;
			
		iOffs=FindSendPropInfo("CBaseShotgun","m_reloadStartDuration");
		PrintToChat(iCid,"\x03- start, offset \x01%i",iOffs);
		PrintToChat(iCid,"\x03-- value at offset \x01%f", GetEntDataFloat(iEntid,iOffs) );

		iOffs=FindSendPropInfo("CBaseShotgun","m_reloadInsertDuration");
		PrintToChat(iCid,"\x03- insert, offset \x01%i",iOffs);
		PrintToChat(iCid,"\x03-- value at offset \x01%f", GetEntDataFloat(iEntid,iOffs) );

		iOffs=FindSendPropInfo("CBaseShotgun","m_reloadEndDuration");
		PrintToChat(iCid,"\x03- end, offset \x01%i",iOffs);
		PrintToChat(iCid,"\x03-- value at offset \x01%f", GetEntDataFloat(iEntid,iOffs) );

		return Plugin_Continue;
	}

	if (StrEqual(st_chat,"debug fatigue",false)==true)
	{
		PrintToChat(iCid,"\x03[SM] [DEBUG] shove penalty \x01%i\x03",GetEntData(iCid,g_iMeleeFatigueO));

		return Plugin_Continue;
	}

	return Plugin_Continue;
}

public Action:Debug_AnimTimer (Handle:timer, any:iCid)
{
	new iGun = GetEntDataEnt2(iCid,g_iActiveWO);

	new iAnimTimeO = FindSendPropInfo("CTerrorGun","m_flAnimTime");
	PrintToChat(iCid,"\x03 m_flAnimTime \x01%i",iAnimTimeO);
	PrintToChat(iCid,"\x03 - value \x01%f", GetEntDataFloat(iGun,iAnimTimeO));

	new iSimTimeO = FindSendPropInfo("CTerrorGun","m_flSimulationTime");
	PrintToChat(iCid,"\x03 m_flSimulationTime \x01%i",iSimTimeO);
	PrintToChat(iCid,"\x03 - value \x01%f", GetEntDataFloat(iGun,iSimTimeO));

	new iSequenceO = FindSendPropInfo("CTerrorGun","m_nSequence");
	PrintToChat(iCid,"\x03 m_nSequence \x01%i",iSequenceO);
	PrintToChat(iCid,"\x03 - value \x01%i", GetEntData(iGun,iSequenceO));
}

public Action:Debug_StaminaTimer (Handle:timer, any:iCid)
{
	new iStaminaO = FindSendPropInfo("CTerrorPlayer","m_flStamina");
	PrintToChat(iCid,"\x03 m_flStamina \x01%i",iStaminaO);
	PrintToChat(iCid,"\x03 - value \x01%f", GetEntDataFloat(iCid,iStaminaO));
}*/

// #endregion
// =======================================================================

// =======================================================================
// #region Helpers

bool IsEnable_SurvivorPrimary_StoppingPower()
{
	return g_iStopping_enable==1;
}

bool IsEnable_SurvivorPrimary_Pyrotechnician()
{
	return g_iPyro_enable==1;
}

bool IsEnable_SurvivorPrimary_ChristmasGift()
{
	return g_iChristmas_enable==1;
}

bool IsEnable_SurvivorSecondary_PackCat()
{
	return g_iPackCat_enable==1;
}

bool IsEnable_SurvivorTertiary_PackRat()
{
	return g_iPack_enable==1;
}

bool IsClientConfirm(int client)
{
	return g_iConfirm[client]==1;
}

bool IsClientSelect_SurvivorPrimary_StoppingPower(int client)
{
	return g_iSur1[client]==1;
}

bool IsClientSelect_SurvivorPrimary_Pyrotechnician(int client)
{
	return g_iSur1[client]==3;
}

bool IsClientSelect_SurvivorPrimary_ChristmasGift(int client)
{
	return g_iSur1[client]==5;
}

bool IsClientSelect_SurvivorSecondary_PackCat(int client)
{
	return g_iSur2[client]==4;
}

bool IsClientSelect_SurvivorTertiary_PackRat(int client)
{
	return g_iSur3[client]==1;
}

bool IsExist_SurvivorPrimary_ChristmasGift()
{
	if (!IsEnable_SurvivorPrimary_ChristmasGift()) return false;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i)
			&& GetClientTeam(i)==2
			&& IsClientConfirm(i)
			&& IsClientSelect_SurvivorPrimary_ChristmasGift(i)) return true;
	}

	return false;
}

// Check method
bool IsPrimaryWeapon(char[] classname)
{
	return StrContains(classname, "spawn") == -1
		&& (StrContains(classname, "shotgun") != -1
		|| StrContains(classname, "smg") != -1
		|| StrContains(classname, "sniper") != -1
		|| StrContains(classname, "rifle") != -1
		|| StrContains(classname, "grenade_launcher") != -1);
}

bool IsInvalidClient (int client)
{
	return (!client || client > MaxClients || !IsClientInGame(client));
}

// #endregion
// =======================================================================

// =======================================================================
// #region Native

any Native_Pyro_OnWeaponFire(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	char weapon[24]; GetNativeString(2, weapon, sizeof(weapon));

	Pyro_OnWeaponFire(client, weapon);

	return 0;
}

// #endregion
// =======================================================================
