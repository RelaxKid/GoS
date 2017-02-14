--y u looking here?
--credits to Noddy,Zwei,Shulepin and Toshibiotro :wub: (dont get mad about order Kappa)
if GetObjectName(GetMyHero()) ~= "Galio" then return end

require("OpenPredict")

local GalioMenu = Menu("RK'S Galio", "RK'S Galio")
GalioMenu:SubMenu("Combo", "Combo")
GalioMenu.Combo:Boolean("Q", "Use Q", true)
GalioMenu.Combo:Boolean("W", "Use W (Buggy ATM)", false)
GalioMenu.Combo:Boolean("E", "Use E", true)
GalioMenu.Combo:Boolean("R", "Use R", true)
GalioMenu.Combo:Slider("RX", "Use R if can hit X", 3, 1, 5, 1)
GalioMenu:Menu("KillSteal", "Kill Steal")
GalioMenu.KillSteal:Boolean("KSQ", "KS With Q", false)
GalioMenu.KillSteal:Boolean("KSE", "KS With E", false)
GalioMenu:Menu("Draws", "Draws")
GalioMenu.Draws:Boolean("DQ", "Draw Q (Green)", true)
GalioMenu.Draws:Boolean("DW", "Draw W (Yellow)", false)
GalioMenu.Draws:Boolean("DE", "Draw E (Blue)", true)
GalioMenu.Draws:Boolean("DR", "Draw R (Red)", true)

local GalioQ = {speed = 1300, radius = 200, range = 900, delay = 0.25}
local GalioE = {speed = 1200, radius = 120, range = 1200, delay = 0.25}
local GalioR = {speed = math.huge, radius = 560, range = 560, delay = 0.25}

local enemyChamps = {}
OnObjectLoad(function(obj)
  if obj and obj.isHero and obj.team ~= myHero.team then
   enemyChamps[obj.networkID] = obj
 end
end)

 function EnemiesAround2(pos, range)
        local c = 0
        if pos == nil then return 0 end
        for k,v in pairs(enemyChamps) do 
        if v and ValidTarget(v) and GetDistanceSqr(pos,GetOrigin(v)) < range*range then
            c = c + 1
        end
        end
        return c
    end

OnTick(function()
	local target = GetCurrentTarget()
	local myHeroPos = GetOrigin(myHero)
	local myHitBox = GetHitBox(myHero)
	local pI = GetPrediction(target, GalioQ)
	local pI = GetPrediction(target, GalioE)

	if target == nil then return end 
	
	if IOW:Mode() == "Combo" then
    if pI and pI.hitChance >= 0.25 and GalioMenu.Combo.Q:Value() and CanUseSpell(myHero, _Q) == READY then
      CastSkillShot(_Q, pI.castPos)
    end
    if pI and pI.hitChance >= 0.25 and GalioMenu.Combo.E:Value() and CanUseSpell(myHero, _E) == READY then
      CastSkillShot(_E, pI.castPos)
    end

    if CanUseSpell(myHero,_R) == READY and ValidTarget(target, 560) and GalioMenu.Combo.R:Value() and EnemiesAround2(myHero.pos,560) >= GalioMenu.Combo.RX:Value() then
      if GetCurrentHP(target) < CalcDamage(myHero,target,0.60*GetBonusAP(myHero))+(125+100*GetCastLevel(myHero,_R)) then
          CastSpell(_R)
        end
      end
    end

    if GalioMenu.KillSteal.KSE:Value() then
	    if pI and pI.hitChance >= 0.25 and GalioMenu.Combo.E:Value() and CanUseSpell(myHero, _E) == READY then
	    	if GetCurrentHP(target) < CalcDamage(myHero,target,0.60*GetBonusAP(myHero))+(15 + 45 * GetCastLevel(myHero,_E)) then 
      CastSkillShot(_E, pI.castPos)
       end 
    end
 end
if GalioMenu.KillSteal.KSQ:Value() then
	    if pI and pI.hitChance >= 0.25 and GalioMenu.Combo.Q:Value() and CanUseSpell(myHero, _Q) == READY then
	    	if GetCurrentHP(target) < CalcDamage(myHero,target,0.60*GetBonusAP(myHero))+(25 + 55 * GetCastLevel(myHero,_Q)) then
      CastSkillShot(_Q, pI.castPos)
       end
    end
 end

 end)
 -- buggy atm till spell.target is fixed
OnProcessSpell(function(unit, spell)
	if unit == target and spell.name:find("") and not spell.name:lower():find("attack") and GalioMenu.Combo.W:Value() and CanUseSpell(myHero,_W) == READY then
		CastTargetSpell(myHero,_W)
	end 
end)

OnDraw(function(myHero)
	if GalioMenu.Draws.DQ:Value() then
		DrawCircle(GetOrigin(myHero),940,0,155,ARGB(255, 8, 178, 102)) --Q
	end
	if GalioMenu.Draws.DE:Value() then
		DrawCircle(GetOrigin(myHero),1200,0,155,ARGB(255, 8, 71, 178)) --E
	end
	if GalioMenu.Draws.DW:Value() then
		DrawCircle(GetOrigin(myHero),800,0,155,ARGB(255, 226, 217, 45)) --W
	end
	if GalioMenu.Draws.DR:Value() then
		DrawCircle(GetOrigin(myHero),560,0,155,ARGB(255, 204, 14, 14)) --R
	end
end)

PrintChat('<font color = \"#aa00ff\">RK Galio</font> </font> <font color = \"#0094ff\"> Loaded </font>')
PrintChat('<font color = \"#ff3feb\">By RelaxKid </font>')
