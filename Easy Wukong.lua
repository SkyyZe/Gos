class "MonkeyKing"


function MonkeyKing:_init()
    if MyHero.charName ~= "MonkeyKing" then return end
	require('DamageLib')
	PrintChat("[Easy Wukong] loaded")
	self:LoadSpells()
    self:LoadMenu()
	Callback.Add('Tick', function() self:Tick() end)
    Callback.Add('Draw', function() self:Draw() end)
	
end
	
	function MonkeyKing:LoadSpells()
	        Q = {Range = 300 , Delay = 0.25}
		W = {Range = 175 , Delay = 0.25}
		E = {Range = 625 , Delay = 0.25}
		R = {Range = 162 , Delay = 0.25}
end
	
function MonkeyKing:Menu()
	self.Menu = MenuElement({type = MENU, id = "MonkeyKing", name = "Wukong - The Monkey King", leftIcon="http://img07.deviantart.net/b61a/i/2013/118/7/4/league_of_legends___volcanic_wukong_wallpaper_by_iamsointense-d5lc4bm.jpg"})
	
	self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo"})
        self.Menu.Combo:MenuElement({id = "CombQ", name = "Use Q", value = true})
        self.Menu.Combo:MenuElement({id = "CombW", name = "Use W", value = true})
        self.Menu.Combo:MenuElement({id = "CombE", name = "Use E", value = true})
        self.Menu.Combo:MenuElement({id = "CombR", name = "Use R", value = true})
	self.Menu.Combo:MenuElement({id = "CombMana", name = "Min. Mana to Combo", value = 40, min = 0, max = 100})
	
	self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass"})
	self.Menu.Harass:MenuElement({id = "HarassQ", name = "Use Q", value = true})
	self.Menu.Harass:MenuElement({id = "HarassE", name = "Use E", value = true})
	self.Menu.Harass:MenuElement({id = "HarassMana", name = "Min. Mana", value = 40, min = 0, man = 100})
	
	self.Menu:MenuElement({type = MENU, id = "Farm", name = "LaneClear"})
	self.Menu.Farm:MenuElement({id = "LcE", name = "Use E", value =true})
	self.Menu.Farm:MenuElement({id = "LcQ", name = "Use Q", value =true})
	self.Menu.Farm:MenuElement({id = "lcMana", name = "Min. Mana", value = 40, min = 0, max = 100})
	
	self.Menu:MenuElementn({type = MENU, id = "LastHit", name = "LastHit"})
	self.Menu.LastHit:MenuElement({id = "lhQ", name = "Use Q", value = true})
	self.Menu.LastHit:MenuElement({id = "lhMana", name = "Min. Mana", value = 40, min = 0, max = 100})
	
	self.Menu:MenuElement ({type = MENU, id = "Misc", name = "Misc"})
if myHero:GetSpellData(4).name == "SummonerDot" or myHero:GetSpellData(5).name == "SummonerDot" then
    self.Menu.Misc:MenuElement({id = "IgniteE", name = "Use Ignite", value = true})
end
    self.Menu.Misc:MenuElement({id = "kswithQ", name = "Use Q to ks", value = true})
	self.Menu.Misc:MenuElement({id = "kswithE", name = "Use E to ks", value = true})
	self.Menu.Misc:MenuElement({id = "kswithR", name = "Use R to ks", value = true})
	
	
	self.Menu:MenuElement({type = MENU, id = "Draw", name = "Drawing Settings"})
    self.Menu.Draw:MenuElement({id = "DrawSpells", name = "Draw Only Ready Spells", value = true})
    self.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawTarget", name = "Draw Target", value = true})
		
    PrintChat("[Easy Wukong] Menu Loaded")
end

function MonkeyKing:Tick()
 
    local target = self:GetTarget(R.Range)
 
    self:Misc()

    if self:Mode() == "Combo" then
        self:Combo(target)
    elseif self:Mode() == "Harass" then
        self:Harass(target)
    elseif self:Mode() == "Farm" then
        self:Farm()
    elseif self:Mode() == "LastHit" then
        self:LastHit()
 
    end
end

function MonkeyKing:GetPercentMP(unit)
    return 100 * unit.mana / unit.maxMana
end
 
function MonkeyKing:IsReady(spellSlot)
    return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end
 
function MonkeyKing:CheckMana(spellSlot)
    return myHero:GetSpellData(spellSlot).mana < myHero.mana
end
 
function MonkeyKing:GetRange(spell)
  return myHero:GetSpellData(spell).range
end

function MonkeyKing:CanCast(spellSlot)
    return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end
 
function MonkeyKing:IsValidTarget(obj, spellRange)
    return obj ~= nil and obj.valid and obj.visible and not obj.dead and obj.isTargetable and obj.distance <= spellRange
end

function MonkeyKing:GetTarget(range)
    local target
    for i = 1,Game.HeroCount() do
        local hero = Game.Hero(i)
        if self:IsValidTarget(hero, range) and hero.team ~= myHero.team then
            target = hero
            break
        end
    end
    return target
end

function MonkeyKing:Misc()
     for i = 1,Game.HeroCount() do
        local Enemy = Game.Hero(i)
        if self:IsValidTarget(Enemy, 300) and Enemy.team ~= myHero.team then
            if self.Menu.Misc.kswithQ:Value() then
                if getdmg("Q", Enemy, myHero) > Enemy.health then
                    self:CastQ(Enemy)
                    return;
                end
            end
        end


        if self:IsValidTarget(Enemy, 162) and Enemy.team ~= myHero.team then
            if self.Menu.Misc.kswithR:Value() then
                if getdmg("R", Enemy, myHero) > Enemy.health then
                    self:CastR(Enemy)
                    return;
                end
            end
	end
			
		
	if self:IsValidTarget(Enemy, 625) and Enemy.team ~= myHero.team then
            if self.Menu.Misc.kswithE:Value() then
                if getdmg("E", Enemy, myHero) > Enemy.health then
                    self:CastR(Enemy)
                    return;
                end
            end
        

            if myHero:GetSpellData(5).name == "SummonerDot" and self.Menu.Misc.IgniteE:Value() and self:IsReady(SUMMONER_2) then
                if self:IsValidTarget(Enemy, 600, false, myHero.pos) and Enemy.health + Enemy.hpRegen*2.5 + Enemy.shieldAD < 50 + 20*myHero.levelData.lvl then
                    Control.CastSpell(HK_SUMMONER_2, Enemy)
                    return;
                end
            end

            if myHero:GetSpellData(4).name == "SummonerDot" and self.Menu.Misc.IgniteE:Value() and self:IsReady(SUMMONER_1) then
                if self:IsValidTarget(Enemy, 600, false, myHero.pos) and Enemy.health + Enemy.hpRegen*2.5 + Enemy.shieldAD < 50 + 20*myHero.levelData.lvl then
                    Control.CastSpell(HK_SUMMONER_1, Enemy)
                    return;
                end
            end
        end
    end
end

function MonkeyKing:Harass()
    if (myHero.mana/myHero.maxMana >= self.Menu.Harass.HMana:Value() / 100) then
        local target = self:GetTarget(Q.Range)
        if self.Menu.Harass.HQ:Value() and self:CanCast(_Q) then
            self:CastQ(target)
        end

        local target = self:GetTarget(E.Range)
        if self.Menu.Harass.HE:Value() and self:CanCast(_E) then
            self:CastE(target)
        end
    end
end

function MonkeyKing:Combo(target)
    if (myHero.mana/myHero.maxMana >= self.Menu.Combo.CombMana:Value()/100) then

        if self.Menu.Combo.CombQ:Value() and self:CanCast(_Q) and self:IsValidTarget(target, Q.Range) then
            self:CastQ(target)
 
        elseif self.Menu.Combo.CombR:Value() and self:CanCast(_R) and self:IsValidTarget(target, R.Range) and not self:CanCast(_Q) then
           self:CastR(target)

        elseif self.Menu.Combo.CombE:Value() and self:CanCast(_E) and self:IsValidTarget(target, E.Range) then
            self:CastE(target)
 
        elseif self.Menu.Combo.CombE:Value() and self:CanCast(_W) and self:IsValidTarget(target, W.Range) then
           self:CastW()

 
        end
    end
end

function MonkeyKing:Farm()
    if (myHero.mana/myHero.maxMana >= self.Menu.Farm.lcMana:Value() / 100) then
        local wMinion = self:GetFarmTarget(W.Range)
        if self.Menu.Farm.lcW:Value() and self:CanCast(_W) then
            self:CastW()
        end
    end
end

function MonkeyKing:LastHit()
    if (myHero.mana/myHero.maxMana >= self.Menu.LastHit.lhMana:Value() / 100) then
    	        for _, Minion in pairs(self.GetMinions(200)) do
    	        	if self.Menu.LastHit.lhQ:Value() and getdmg("Q", Minion, myHero) > Minion.health then
                            if self:CanCast(_Q) and self:IsValidTarget(Minion, self:GetRange(_Q), false, myHero.pos) then
                                    self:CastQ()
                            end
                    end
            end
    end 
end

function MonkeyKing:Mode()
    if Orbwalker["Combo"].__active then
        return "Combo"
    elseif Orbwalker["Harass"].__active then
        return "Harass"
    elseif Orbwalker["Farm"].__active then
        return "Farm"
    elseif Orbwalker["LastHit"].__active then
        return "LastHit"
    end
    return ""
end

function MonkeyKing:CastQ(unit)
    Control.CastSpell(HK_Q, unit)
end
 
 
--W CAST
function MonkeyKing:CastW()
    Control.CastSpell(HK_W)
end
 
 
--E CAST
function MonkeyKing:CastE(unit)
    Control.CastSpell(HK_E, unit)
end
 
 
--R CAST
function MonkeyKing:CastR(Rtarget)
    if Rtarget then
        local castPos = Rtarget:GetPrediction(R.Speed, R.Delay)
        Control.CastSpell(HK_R, castPos)
    end
end

function MonkeyKing:Draw()
    if myHero.dead then return end
    if self.Menu.Draw.DrawSpells:Value() then
        if self:IsReady(_Q) and self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos,Q.Range,1,Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_W) and self.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos,W.Range,1,Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_E) and self.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos,E.Range,1,Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos,Q.Range,1,Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos,W.Range,1,Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos,E.Range,1,Draw.Color(255, 255, 255, 255))
        end
    end
end

function OnLoad()
    MonkeyKing()

end

	
	
	
