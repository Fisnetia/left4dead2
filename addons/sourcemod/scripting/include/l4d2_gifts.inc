#if defined _l4d2_gifts_included_
 #endinput
#endif
#define _l4d2_gifts_included_

#define L4D2_GIFT_STANDARD	1
#define L4D2_GIFT_SPECIAL	2

/**
 * Spawn a gift at the position of an entity.
 *
 * @param entity		Entity index to spawn the gift on (a client, or any
 *						entity such as a witch).
 * @param type			L4D2_GIFT_STANDARD (1) or L4D2_GIFT_SPECIAL (2).
 *
 * @return				True if a gift was spawned, false otherwise.
 * @error				Invalid entity index or invalid gift type.
 */
native bool L4D2_Gifts_DropGift(int entity, int type = L4D2_GIFT_STANDARD);

public SharedPlugin __pl_l4d2_gifts =
{
	name = "l4d2_gifts",
	file = "l4d2_gifts.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_l4d2_gifts_SetNTVOptional()
{
	MarkNativeAsOptional("L4D2_Gifts_DropGift");
}
#endif
