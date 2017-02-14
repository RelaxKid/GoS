--No easter eggs here
--Credits to Noddy for the damage calculations (minikappa)
if GetObjectName(GetMyHero()) ~= "Tristana" then return end
require("OpenPredict")
local TristanaMenu = Menu("RK'S Tristana", "RK'S Tristana")
TristanaMenu:SubMenu("Combo", "Combo")
TristanaMenu.Combo:Boolean("Q", "Use Q", true)
TristanaMenu.Combo:Boolean("E", "Use E", true)
TristanaMenu.Combo:Boolean("R", "Use R", true)
TristanaMenu.Combo:Boolean("RE", "Use R + E if E Kills", true)
TristanaMenu.Combo:Boolean("KSR", "Killsteal with R", false)
OnTick(function (myHero) 
local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()
if IOW:Mode() == "Combo" then
if TristanaMenu.Combo.Q:Value() then
	if CanUseSpell(myHero, _Q) == READY and ValidTarget(target,GetRange(myHero)) and IsTargetable(target) then
		CastSpell(_Q)
	end
end
if TristanaMenu.Combo.E:Value() then
	if CanUseSpell(myHero, _E) == READY and ValidTarget(target,GetRange(myHero)) and IsTargetable(target)then
		CastTargetSpell(target, _E)
	end
end
if TristanaMenu.Combo.R:Value() then
	if CanUseSpell(myHero,_R) == READY and ValidTarget(target,GetCastRange(myHero,_R)) and GetCurrentHP(target) < CalcDamage(myHero, target, 0, 225 + 100*GetCastLevel(myHero,_R) + GetBonusAP(myHero)) then
		CastTargetSpell(target,_R)
	end	
end
end
if TristanaMenu.Combo.KSR:Value() then
	if CanUseSpell(myHero, _R) == READY and ValidTarget(target,GetCastRange(myHero, _R)) and GetCurrentHP(target) < CalcDamage(myHero, target, 0, 225 + 100*GetCastLevel(myHero,_R) + GetBonusAP(myHero)) then
		CastTargetSpell(target, _R)
	end
end
if TristanaMenu.Combo.RE:Value() then
for _, enemy in pairs(GetEnemyHeroes()) do
	if GotBuff(enemy,"tristanaechargesound") == 1 then
		eDMG = CalcDamage(myHero, enemy, (10*GetCastLevel(myHero,_E)+52+((0.18*(GetCastLevel(myHero,_E))+0.38)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.6*GetBonusAP(myHero))) + ((GotBuff(enemy,"tristanaechargesound")-1)*(3*GetCastLevel(myHero,_E)+22+((0.049*(GetCastLevel(myHero,_E))+0.120)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.15*GetBonusAP(myHero)))), 0 ) - GetHPRegen(enemy)*4
elseif GotBuff(enemy,"tristanaechargesound") == 0 then
eDMG = 0
end
	if CanUseSpell(myHero, _R) == READY and ValidTarget(enemy,GetCastRange(myHero, _R)) then
		rDMG = CalcDamage(myHero, enemy, 0, 100*GetCastLevel(myHero,_R)+ 225 + (GetBonusAP(myHero)))
			if GetCurrentHP(enemy) < rDMG+eDMG then
				CastTargetSpell(enemy, _R)
			end
	end
end
end
end)
PrintChat('<font color = \"#aa00ff\">RK Tristana</font> </font> <font color = \"#0094ff\"> Loaded </font>')
PrintChat('<font color = \"#ff3feb\"> By RelaxKid </font>')
