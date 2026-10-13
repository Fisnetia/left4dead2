#if defined  _perkmod2_included_
 #endinput
#endif
#define _perkmod2_included_

/**
 * Notify perkmod2 that a client fired/used a weapon, so the Pyrotechnician
 * perk can apply its effect.
 *
 * @param client		Client index.
 * @param weapon		Weapon class name without the "weapon_" prefix
 *						(e.g. "pipe_bomb").
 */
native int perkmod2_Pyro_OnWeaponFire(int client, char[] weapon);
