#include <amxmodx>
#include <reapi>
#include <fakemeta>
#include <xs>

#define rg_get_user_team(%0) get_member(%0, m_iTeam)

new Float:g_flBlindTime[MAX_PLAYERS + 1];
new g_iLerpMsec[MAX_PLAYERS + 1];

enum STAB_INFO {
	Float:S_DISTANCE,
	S_BACKTRACK,
	S_HIT,
	bool:S_FLASHED,
	S_TYPESTAB
}

new g_szHitgroup[8][] = {
	"Body",
	"Head",
	"Chest",
	"Stomach",
	"Left hand",
	"Right hand",
	"Left leg",
	"Right leg"
};

new g_szTypegroup[6][] = {
	"stabbed",
	"flashstabbed",
	"backstabbed",
	"hardstabbed",
	"airstabbed",
	"duckstabbed"
};

public plugin_init() {
	register_plugin("Knife stab info", "1.0.0", "OpenHNS"); // Kilabeez, WessTorn

	RegisterHookChain(RG_PlayerBlind, "rgPlayerBlind");
	RegisterHookChain(RG_CBasePlayer_TraceAttack, "rgTraceAttack");

	register_forward(FM_CmdStart, "fwdCmdStart");
}

public client_disconnected(id) {
	g_flBlindTime[id] = 0.0;
	g_iLerpMsec[id] = 0;
}

public rgPlayerBlind(id, inflictor, attacker, Float:fadeTime, Float:fadeHold, alpha) {
	if(fadeHold >= 1.0 && fadeTime > 6.0 && alpha == 255) 
		g_flBlindTime[id] = get_gametime() + fadeHold;
}

public rgTraceAttack(id, attacker, Float:flDamage, Float:vecDir[3], tracehandle) {
	if(rg_get_user_team(id) == rg_get_user_team(attacker) || get_user_weapon(attacker) != CSW_KNIFE || rg_get_user_godmode(id))
		return;

	new eInfo[STAB_INFO];
	eInfo[S_DISTANCE] = get_distance_un(attacker, vecDir);
	eInfo[S_BACKTRACK] = get_backtracked(attacker);
	eInfo[S_HIT] = get_tr2(tracehandle, TR_iHitgroup);
	eInfo[S_FLASHED] = get_gametime() <= g_flBlindTime[attacker] ? true : false;
	eInfo[S_TYPESTAB] = get_type_stab(attacker, flDamage, eInfo[S_DISTANCE], eInfo[S_FLASHED]);

	if(eInfo[S_FLASHED] || eInfo[S_DISTANCE] >= 30.0) {
		new players[MAX_PLAYERS], pnum;
		get_players(players, pnum);
		for(new i; i < pnum; i++) {
			if(players[i] != id && players[i] != attacker)
				if (eInfo[S_BACKTRACK] > 10)
					client_print_color(players[i], print_team_blue, "^3%n^1 %s ^3%n^1 (dist: ^3%.2f^1 hit: ^3%s^1 btk: ^3%d^1 ms)", attacker, g_szTypegroup[eInfo[S_TYPESTAB]], id, eInfo[S_DISTANCE], g_szHitgroup[eInfo[S_HIT]], eInfo[S_BACKTRACK]);
				else
					client_print_color(players[i], print_team_blue, "^3%n^1 %s ^3%n^1 (dist: ^3%.2f^1 hit: ^3%s^1)", attacker, g_szTypegroup[eInfo[S_TYPESTAB]], id, eInfo[S_DISTANCE], g_szHitgroup[eInfo[S_HIT]]);
		}
	}

	if (eInfo[S_BACKTRACK] > 10)
		client_print_color(id, print_team_blue, "^3%n^1 %s ^3you^1. (dist: ^3%.2f^1 hit: ^3%s^1 btk: ^3%d^1 ms)", attacker, g_szTypegroup[eInfo[S_TYPESTAB]], eInfo[S_DISTANCE], g_szHitgroup[eInfo[S_HIT]], eInfo[S_BACKTRACK]);
	else
		client_print_color(id, print_team_blue, "^3%n^1 %s ^3you^1. (dist: ^3%.2f^1 hit: ^3%s^1)", attacker, g_szTypegroup[eInfo[S_TYPESTAB]], eInfo[S_DISTANCE], g_szHitgroup[eInfo[S_HIT]]);
	
	client_print_color(attacker, print_team_blue, "^3You^1 %s ^3%n^1 (dist: ^3%.2f^1 hit: ^3%s^1)", g_szTypegroup[eInfo[S_TYPESTAB]], id, eInfo[S_DISTANCE], g_szHitgroup[eInfo[S_HIT]]);
}

stock rg_get_user_godmode(id) {
	new Float:val;
	val = get_entvar(id, var_takedamage);

	return (val == DAMAGE_NO);
}

public fwdCmdStart(id, ucmd)
	g_iLerpMsec[id] = get_ucmd(ucmd, ucmd_lerp_msec);

stock Float:get_distance_un(id, Float:vecDir[3]) {
	new Float:flStart[3], Float:flEnd[3];

	get_entvar(id, var_origin, flStart);
	get_entvar(id, var_view_ofs, flEnd);

	xs_vec_add(flEnd, flStart, flStart);
	xs_vec_copy(flStart, flEnd);
	xs_vec_add_scaled(flEnd, vecDir, 32.0, flEnd);

	new Float:flFraction, iTrace;

	engfunc(EngFunc_TraceHull, flStart, flEnd, DONT_IGNORE_MONSTERS, 3, id, iTrace);

	get_tr2(iTrace, TR_vecEndPos, flEnd);
	get_tr2(iTrace, TR_flFraction, flFraction);

	return flFraction == 1.0 ? 0.0 : get_distance_f(flStart, flEnd);
}

stock get_backtracked(id) {
	new iPing, iLoss;
	get_user_ping(id, iPing, iLoss);

	return iPing + g_iLerpMsec[id];
}

stock get_type_stab(id, Float:flDamage, Float:flDistance, bool:Flashed) {
	if (Flashed)
		return 1;
	else if(flDamage == 195.0) 
		return 2;
	else if(flDistance >= 30.0) 
		return 3;
	else if(!(get_entvar(id, var_flags) & FL_ONGROUND)) 
		return 4;
	else if(get_entvar(id, var_button) & IN_DUCK) 
		return 5;
	else
		return 0;
}
