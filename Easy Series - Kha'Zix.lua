require("OpenPredict")
local KhaZixMenu = MenuConfig("KhaZix", "KhaZix") 
KhaZixMenu:SubMenu("Combo", "Combo")
KhaZixMenu.Combo:Boolean("Q", "Use Q", true)
KhaZixMenu.Combo:Boolean("W", "Use W", true)
KhaZixMenu.Combo:Boolean("E", "Use E", true)
KhaZixMenu.Combo:Boolean("R", "Use R", true)
KhaZixMenu.Combo:Boolean("KSQ", "Killsteal with Q", true) 
KhaZixMenu.Combo:Boolean("KSW", "Killsteal with W", true)
KhaZixMenu.Combo:Slider("RM", "R only when enemy more than", 3, 1, 5, 1)

local KhaZixW = {delay = .5, range = 1000, width = 250, speed = 828.5}
local KhaZixE = {delay = .5, range = 900, width = 300, speed = 1300}

OnTick(function () 
 local target = GetCurrentTarget()     
 if IOW:Mode() == "Combo" then
            if KhaZixMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 375) then 
              CastTargetSpell(target , _Q)
            end
            if KhaZixMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 1000) then 
            local WPred = GetPrediction(target,KhaZixW)
                if WPred.hitChance > 0.2 and not WPred:mCollision(1) then 
     CastSkillShot(_W,WPred.castPos)
                end
            end 
            if KhaZixMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 900) then
            local EPred = GetPrediction(target,KhaZixE)
                if EPred.hitChance > 0.2 then 
     CastSkillShot(_E,EPred.castPos)
                 end
            end
            if Ready(_R) and EnemiesAround(myHero, 200) >= KhaZixMenu.Combo.RM:Value() and KhaZixMenu.Combo.R:Value() then
              CastSpell(_R)
          end
      end
 
 for _, enemy in pairs(GetEnemyHeroes()) do
            if KhaZixMenu.Combo.Q:Value() and KhaZixMenu.Combo.KSQ:Value() and Ready(_Q) and ValidTarget(enemy, 375) then
				if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 45 + 25 * GetCastLevel(myHero,_Q) + GetBonusDmg(myHero) * 1.2, 0) then
					CastTargetSpell(enemy , _Q)    
				end
			end
        if KhaZixMenu.Combo.W:Value() and KhaZixMenu.Combo.KSW:Value() and Ready(_W) and ValidTarget(enemy, 1000) then
            if GetCurrentHP(enemy) < CalcDamage(myHero, enemy, 0, 80 + 30 * GetCastLevel(myHero,_W) + GetBonusDmg(myHero) * 1.0, 0) then
                CastSkillShot(enemy , _W)   				
          end
      end
   end 
end) 

print("Kha'Zix loaded")
