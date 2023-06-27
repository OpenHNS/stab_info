# Stab info / Knife distance
Knife stab info for Hide'n'Seek Counter-Strike 1.6

## Description

This plugin displays stab info for the Hide'n'Seek mod.
Outputs to the chat: All: stubs with a blinded attacker, "Hard" stubs (above 30 units). Attacker/Survivor: what stab, where stabbed, distance of stab.

![stab](https://github.com/OpenHNS/stab_info/assets/63194135/bb17cb6b-8ef8-4670-9e1e-5381342f3e41)

| chat message | description
| :------------------- | :--------------------------------------------------- |
| You | Player name If you hit you it will say `You` |
| stabbed | `flashstabbed` `backstabbed` `hardstabbed` `slidestabbed` `airstabbed` `duckstabbed` |
| Ethan | `player name` If you are hit you will be written `You` |
| dist | distance of knife hit in units |
| hit | `body` `head` `chest` `stomach` `left hand` `right hand` `left leg` |

## Requirements ##
- [ReHLDS](https://dev-cs.ru/resources/64/)
- [Amxmodx 1.9.0](https://www.amxmodx.org/downloads-new.php)
- [Reapi (last)](https://dev-cs.ru/resources/73/updates)
- [ReGameDLL (last)](https://dev-cs.ru/resources/67/updates)

## Setup
 
1. Compile the plugin.

2. Copy compiled file `.amxx` to directory: `amxmodx/plugins/`.

3. Write `.amxx` in file `amxmodx/configs/plugins.ini`.

4. Restart the server or change the map.
