#include <a_samp>
#pragma tabsize 0
//================================Оружия================================
new Kastet[MAX_PLAYERS];//Безоружный
new Brass_Knuckles[MAX_PLAYERS];//Eanoao
new Golf_Club[MAX_PLAYERS];//Eiiianeay aoaeiea
new Knife[MAX_PLAYERS];//Ii?
new Baseball_Bat[MAX_PLAYERS];//Aeoa
new Shovel[MAX_PLAYERS];//Eiiaoa
new Pool_cue[MAX_PLAYERS];//Eee
new Katana[MAX_PLAYERS];//Eaoaia ia?
new Chainsaw[MAX_PLAYERS];//Aaiciieea
new Purple_Dildo[MAX_PLAYERS];//Aeeai Ne?aiaaue
new White_Dildo[MAX_PLAYERS];//Aea?aoi?
new Long_WhiteDildo[MAX_PLAYERS];//Aeeai aaeue
new White_Dildoo[MAX_PLAYERS];//Aea?aoi? 2
new Flowers[MAX_PLAYERS];//Oaaou
new Can[MAX_PLAYERS];//O?inou
new Grenades[MAX_PLAYERS];//A?aiaoa
new Tear_Gas[MAX_PLAYERS];//A?aiaoa aaciaay
new Molotovs[MAX_PLAYERS];//Iieioia
new Pistol[MAX_PLAYERS];//Aa?aou
new Silenced_Pistol[MAX_PLAYERS];//Aa?aoa n aeooeoaeai
new Deagle[MAX_PLAYERS];//Aana?o eae
new Shotgun[MAX_PLAYERS];//A?iaiaee
new SawnOff_Shotgun[MAX_PLAYERS];//Ia?ac
new Combat_Shotgun[MAX_PLAYERS];//A?iai?ac nei?ino?aeuiue
new Micro_Uzi[MAX_PLAYERS];//OCE
new MP[MAX_PLAYERS];//Ii?eiaea
new AK[MAX_PLAYERS];//Eaeaoieeia
new Mka[MAX_PLAYERS];//I4A1
new Tec[MAX_PLAYERS];//OAE-9
new Rifle[MAX_PLAYERS];//Aeioiaea
new Sniper_Rifle[MAX_PLAYERS];//Niaeia?neay aeioiaea
new R_P_G[MAX_PLAYERS];//I?ioeaioaieiaue A?aiaoii?o
new Missile_Launcher[MAX_PLAYERS];//Aacoea
new Flame_Thrower[MAX_PLAYERS];//Iaiai?o
new Minigun[MAX_PLAYERS];//Ioeai?o
new Sachel_Charges[MAX_PLAYERS];//Ac?uaiaeao
new Detonator[MAX_PLAYERS];//Aaoiiaoi?
new Spray_Paint[MAX_PLAYERS];//Aaeii?ee
new Fire_Extinguisher[MAX_PLAYERS];//Iaiaoooeoaeu
new Camera[MAX_PLAYERS];//Oioiaiia?ao
new Nightvision_Goggles[MAX_PLAYERS];//I?ee ii?iiai aeaaiey
new Thermal_Goggles[MAX_PLAYERS];//I?ee ii?iiai aeaaiey 2
new Parachute[MAX_PLAYERS];//Ia?aooo

forward gac();


stock GivePlayerWeaponLegal(playerid, weaponid, ammo) 
{
    if(IsPlayerConnected(playerid))
    {
        if(weaponid == 1)
        {
            Kastet[playerid]  = 1;
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 2)
        {
            Brass_Knuckles[playerid] += ammo;
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 3)
        {
			Golf_Club[playerid]  = 1;//Eiiianeay aoaeiea
		    GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 4)
        {
			Knife[playerid] = 1;//Ii?
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 5)
        {
			Baseball_Bat[playerid]  = 1;//Aeoa
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 6)
        {
			Shovel[playerid]  = 1;//Eiiaoa
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 7)
        {
			Pool_cue[playerid]  = 1;//Eee
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 8)
        {
			Katana[playerid]  = 1;//Eaoaia ia?
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 9)
        {
			Chainsaw[playerid]  = 1;//Aaiciieea
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 10)
        {
			Purple_Dildo[playerid] = 1;//Aeeai Ne?aiaaue
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 11)
        {
			White_Dildo[playerid]  = 1;//Aea?aoi?
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 12)
        {
			Long_WhiteDildo[playerid]  = 1;//Aeeai aaeue
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 13)
        {
			White_Dildoo[playerid]  = 1;//Aea?aoi? 2
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 14)
        {
			Flowers[playerid]  = 1;//Oaaou
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 15)
        {
			Can[playerid]  = 1;//O?inou
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 16)
        {
			Grenades[playerid] += ammo;//A?aiaoa
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 17)
        {
			Tear_Gas[playerid] += ammo;//A?aiaoa aaciaay
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 18)
        {
			Molotovs[playerid] += ammo;//Iieioia
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
		else if(weaponid == 22)
        {
			Pistol[playerid] += ammo;//Aa?aou
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 23)
        {
			Silenced_Pistol[playerid] += ammo;//Aa?aoa n aeooeoaeai
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 24)
        {
			Deagle[playerid] += ammo;//Aana?o eae
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 25)
        {
			Shotgun[playerid] += ammo;//A?iaiaee
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 26)
        {
			SawnOff_Shotgun[playerid] += ammo;//Ia?ac
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 27)
        {
			Combat_Shotgun[playerid] += ammo;//A?iai?ac nei?ino?aeuiue
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 28)
        {
			Micro_Uzi[playerid] += ammo;//OCE
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 29)
        {
			MP[playerid] += ammo;//Ii?eiaea
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 30)
        {
			AK[playerid] += ammo;//Eaeaoieeia
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 31)
        {
			Mka[playerid] += ammo;//I4A1
		    GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 32)
        {
			Tec[playerid] += ammo;//OAE-9
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 33)
        {
			Rifle[playerid] += ammo;//Aeioiaea
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 34)
        {
			Sniper_Rifle[playerid] += ammo;//Niaeia?neay aeioiaea
		    GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 35)
        {
			R_P_G[playerid] += ammo;//I?ioeaioaieiaue A?aiaoii?o
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 36)
        {
			Missile_Launcher[playerid] += ammo;//Aacoea
		    GivePlayerWeapon(playerid, weaponid, ammo);
		}
        else if(weaponid == 37)
        {
			Flame_Thrower[playerid] += ammo;//Iaiai?o
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 38)
        {
			Minigun[playerid] += ammo;//Ioeai?o
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 39)
        {
			Sachel_Charges[playerid] += ammo;//Ac?uaiaeao
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 40)
        {
			Detonator[playerid] += ammo;//Aaoiiaoi?
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 41)
        {
			Spray_Paint[playerid] += ammo;//Aaeii?ee
		    GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 42)
        {
			Fire_Extinguisher[playerid] += ammo;//Iaiaoooeoaeu
			GivePlayerWeapon(playerid, weaponid, ammo);
		}
        else if(weaponid == 43)
        {
			Camera[playerid] += ammo;//Oioiaiia?ao
		    GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 44)
        {
			Nightvision_Goggles[playerid] += ammo;//I?ee ii?iiai aeaaiey
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 45)
        {
			Thermal_Goggles[playerid] += ammo;//I?ee ii?iiai aeaaiey 2
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
        else if(weaponid == 46)
        {
	        Parachute[playerid] += ammo;//Ia?aooo
			GivePlayerWeapon(playerid, weaponid, ammo);
        }
    }
    return 1;
}

stock ResetPlayerWeaponsLegal(playerid)
{
    if(IsPlayerConnected(playerid))
    {
		gunmassive(playerid);
		ResetPlayerWeapons(playerid);
	}
    return 1;
}

stock gunmassive(playerid)
{
    if(IsPlayerConnected(playerid))
    {
	    Kastet[playerid] = 0;//aaci?o?iue
	    Brass_Knuckles[playerid] = 0;//eanoao
	    Golf_Club[playerid] = 0;//Eiiianeay aoaeiea
	    Knife[playerid] = 0;//Ii?
	    Baseball_Bat[playerid] = 0;//Aeoa
	    Shovel[playerid] = 0;//Eiiaoa
	    Pool_cue[playerid] = 0;//Eee
	    Katana[playerid] = 0;//Eaoaia ia?
	    Chainsaw[playerid] = 0;//Aaiciieea
	    Purple_Dildo[playerid] = 0;//Aeeai Ne?aiaaue
	    White_Dildo[playerid] = 0;//Aea?aoi?
	    Long_WhiteDildo[playerid] = 0;//Aeeai aaeue
	    White_Dildoo[playerid] = 0;//Aea?aoi? 2
	    Flowers[playerid] = 0;//Oaaou
	    Can[playerid] = 0;//O?inou
	    Grenades[playerid] = 0;//A?aiaoa
	    Tear_Gas[playerid] = 0;//A?aiaoa aaciaay
	    Molotovs[playerid] = 0;//Iieioia
	    Pistol[playerid] = 0;//Aa?aou
	    Silenced_Pistol[playerid] = 0;//Aa?aoa n aeooeoaeai
	    Deagle[playerid] = 0;//Aana?o eae
	    Shotgun[playerid] = 0;//A?iaiaee
	    SawnOff_Shotgun[playerid] = 0;//Ia?ac
	    Combat_Shotgun[playerid] = 0;//A?iai?ac nei?ino?aeuiue
	    Micro_Uzi[playerid] = 0;//OCE
	    MP[playerid] = 0;//Ii?eiaea
	    AK[playerid] = 0;//Eaeaoieeia
	    Mka[playerid] = 0;//I4A1
	    Tec[playerid] = 0;//OAE-9
	    Rifle[playerid] = 0;//Aeioiaea
	    Sniper_Rifle[playerid] = 0;//Niaeia?neay aeioiaea
	    R_P_G[playerid] = 0;//I?ioeaioaieiaue A?aiaoii?o
	    Missile_Launcher[playerid] = 0;//Aacoea
	    Flame_Thrower[playerid] = 0;//Iaiai?o
	    Minigun[playerid] = 0;//Ioeai?o
	    Sachel_Charges[playerid] = 0;//Ac?uaiaeao
	    Detonator[playerid] = 0;//Aaoiiaoi?
	    Spray_Paint[playerid] = 0;//Aaeii?ee
	    Fire_Extinguisher[playerid] = 0;//Iaiaoooeoaeu
	    Camera[playerid] = 0;//Oioiaiia?ao
	    Nightvision_Goggles[playerid] = 0;//I?ee ii?iiai aeaaiey
	    Thermal_Goggles[playerid] = 0;//I?ee ii?iiai aeaaiey 2
	    Parachute[playerid] = 0;//Ia?aooo
	}
    return 1;
}

public gac()
{
	CheckCheat();
}

stock CheckCheat()// Проверка чита
{
    for(new i; i<MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
			new string[256];
			new giveplayer[MAX_PLAYER_NAME];
			GetPlayerName(i, giveplayer, sizeof(giveplayer));
            new wid, amm, pch;
            for (new w; w < 13; w++)
            {
			    GetPlayerWeaponData(i, w, wid, amm);
				if(wid == 1 && Kastet[i] != 1) pch = 1;
			 	else if(wid == 2 && Brass_Knuckles[i]!= 1 && w != 0) pch = 2;
				else if(wid == 3 && Golf_Club[i] != 1 && w != 0) pch = 3;
				else if(wid == 4 && Knife[i] != 1 && w != 0) pch = 4;
				else if(wid == 5 && Baseball_Bat[i] != 1 && w != 0) pch = 5;
				else if(wid == 6 && Shovel[i] != 1 && w != 0) pch = 6;
                else if(wid == 7 && Pool_cue[i] != 1 && w != 0) pch = 7;
				else if(wid == 8 && Katana[i] != 1 && w != 0) pch = 8;
				else if(wid == 9 && Chainsaw[i] != 1 && w != 0) pch = 9;
				else if(wid == 10 && Purple_Dildo[i] != 1 && w != 0) pch = 10;
				else if(wid == 11 && White_Dildo[i] != 1 && w != 0) pch = 11;
				else if(wid == 12 && Long_WhiteDildo[i] != 1 && w != 0) pch = 12;
				else if(wid == 13 && White_Dildoo[i] != 1 && w != 0) pch = 13;
				else if(wid == 14 && Flowers[i] != 1 && w != 0) pch = 14;
				else if(wid == 15 && Can[i] != 1 && w != 0) pch = 15;
				else if(wid == 16 && Grenades[i]< amm && w != 0) pch = 16;
				else if(wid == 17 && Tear_Gas[i]< amm && w != 0) pch = 17;
				else if(wid == 18 && Molotovs[i]< amm && w != 0) pch = 18;
				else if(wid == 22 && Pistol[i]< amm && w != 0) pch = 22;
				else if(wid == 23 && Silenced_Pistol[i]< amm && w != 0) pch = 23;
				else if(wid == 24 && Deagle[i]< amm && w != 0) pch = 24;
				else if(wid == 25 && Shotgun[i]< amm && w != 0) pch = 25;
				else if(wid == 26 && SawnOff_Shotgun[i]< amm && w != 0) pch = 26;
				else if(wid == 27 && Combat_Shotgun[i]< amm && w != 0) pch = 27;
				else if(wid == 28 && Micro_Uzi[i]< amm && w != 0) pch = 28;
				else if(wid == 29 && MP[i]< amm && w != 0) pch = 29;
				else if(wid == 30 && AK[i]< amm && w != 0) pch = 30;
				else if(wid == 31 && Mka[i]< amm && w != 0) pch = 31;
				else if(wid == 32 && Tec[i]< amm && w != 0) pch = 32;
				else if(wid == 33 && Rifle[i]< amm && w != 0) pch = 33;
				else if(wid == 34 && Sniper_Rifle[i]< amm && w != 0) pch = 34;
				else if(wid == 35 && R_P_G[i]< amm && w != 0) pch = 35;
				else if(wid == 36 && Missile_Launcher[i]< amm && w != 0) pch = 36;
				else if(wid == 37 && Flame_Thrower[i]< amm && w != 0) pch = 37;
				else if(wid == 38 && Minigun[i]< amm && w != 0) pch = 38;
				else if(wid == 39 && Sachel_Charges[i]< amm && w != 0) pch = 39;
				else if(wid == 40 && Detonator[i]< amm && w != 0) pch = 40;
 				else if(wid == 41 && Spray_Paint[i]< amm && w != 0) pch = 41;
				else if(wid == 42 && Fire_Extinguisher[i]< amm && w != 0) pch = 42;
				else if(wid == 43 && Camera[i]< amm && w != 0) pch = 43;
				else if(wid == 44 && Nightvision_Goggles[i]< amm && w != 0) pch = 44;
				else if(wid == 45 && Thermal_Goggles[i]< amm && w != 0) pch = 45;
			}
			if(pch != 0)
			{
			    ResetPlayerWeaponsLegal(i);
				new wch[40];
				GetWeaponName(pch, wch, 40);
			    format(string, sizeof(string), "[Тест Античита]%s(%d) начитерил оружие: %s", giveplayer, i, wch);
			    WriteRusLog("guncheating.log", string);
				SendClientMessage(i, 0xFF0000AA, "У вас был замечен античит на оружие.");

			}
		}
    }
	return 1;
}

stock WriteRusLog(log[], string[])
{
	new write[256];
	format(write, sizeof(write), "%s\r\n", string);
	new File:hFile = fopen(log, io_append);
	for(new io=0; io<strlen(write); io++) fputchar(hFile, write[io], false);
	fclose(hFile);
}
