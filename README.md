# Stab info / Knife distance
Knife stab info для Hide'n'Seek Counter-Strike 1.6

## Описание

Плагин показывает информацию о стабах игрока, предназначен для Hide'n'Seek мода.
Выводит в чат: Всем: стабы с ослепленным нападающим, "Хард" стабы (Выше 30 юнитов). Атакующим/Жертве: какой стаб, куда стабнули, расстояние стаба.

![stab](https://github.com/OpenHNS/stab_info/assets/63194135/bb17cb6b-8ef8-4670-9e1e-5381342f3e41)

| Сообщение в чате     | Описание |
| :------------------- |  :--------------------------------------------------- |
|  You          | `Имя игрока` Если ударили вы вам напишет `You` |
|  stabbed      | `stabbed` `flashstabbed` `backstabbed` `hardstabbed` `slidestabbed` `airstabbed` `duckstabbed` |
|  Ethan          | `Имя игрока` Если ударили вас вам напишет `You` |
|  dist         | Дистанция удара ножа в юнитах |
|  hit          | `body` `head` `chest` `stomach` `left hand` `right hand` `left leg` `right leg` |

## Требования
- [ReHLDS](https://dev-cs.ru/resources/64/)
- [Amxmodx 1.9.0](https://www.amxmodx.org/downloads-new.php)
- [Reapi (last)](https://dev-cs.ru/resources/73/updates)
- [ReGameDLL (last)](https://dev-cs.ru/resources/67/updates)

## Установка
 
1. Скомпилируйте плагин.

2. Скопируйте скомпилированный файл `.amxx` в директорию: `amxmodx/plugins/`

3. Пропишите `.amxx` в файле `amxmodx/configs/plugins.ini`

4. Перезапустите сервер или поменяйте карту.
