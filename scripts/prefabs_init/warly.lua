
-- 吃食物时将获得额外收益1.2倍
local function oneat(inst, data)
    local food = data.food
    if food and food.components.edible then
        local hungerbonus = food.components.edible:GetHunger() * TUNING.WARLY_CHANGE.extra_food_benefits
        local sanitybonus = food.components.edible:GetSanity() * TUNING.WARLY_CHANGE.extra_food_benefits
        local healthbonus = food.components.edible:GetHealth() * TUNING.WARLY_CHANGE.extra_food_benefits

        if inst.components.hunger and hungerbonus > 0 then
            inst.components.hunger:DoDelta(hungerbonus)
        end

        if inst.components.sanity and sanitybonus > 0 then
            inst.components.sanity:DoDelta(sanitybonus)
        end

        if inst.components.health and healthbonus > 0 then
            inst.components.health:DoDelta(healthbonus, true, food.prefab)
        end
    end
end

-- 击杀时有概率获得额外凋落物
local function Extraloot(inst, data)
    local target = data.victim
    if target and target.components.lootdropper then
        local ram = math.random()
        if target.prefab == "lightninggoat" and TUNING.WARLY_CHANGE.warly_extra_lightninggoathorn then
            -- print("ram:", ram)
            if ram <= 0.6 then
                if target == inst.components.combat.target then
                    -- print("target:", target)
                    target.components.lootdropper:SpawnLootPrefab("lightninggoathorn")
                end
                return
            end
        end

        local loots = target.components.lootdropper:GenerateLoot()
        local container = inst.components.inventory or inst.components.container
        for i, loot in ipairs(loots) do
            local lootitem = SpawnPrefab(loot)
            if  ram > TUNING.WARLY_CHANGE.warly_butcher and lootitem and lootitem.components and lootitem.components.edible and table.contains(FOODGROUP.OMNI.types, lootitem.components.edible.foodtype) then
                if target == inst.components.combat.target then
                    target.components.lootdropper:SpawnLootPrefab(loot)
                else
                    inst.components.inventory:GiveItem(lootitem, nil, target:GetPosition())
                end
            end
            
            if lootitem then
                lootitem:Remove()
            end
        end
    end
end

-- 厨师使用具有新鲜度或有食用组件的物品有额外攻击力加成
local function GetEquip(inst, data)
    local WARLY_DAMAGE_MULT = 1
    for k, v in pairs(EQUIPSLOTS) do
        local equip = inst.components.inventory:GetEquippedItem(v)
        if equip and equip.components and (equip.components.perishable or equip.components.eater) then
            WARLY_DAMAGE_MULT = WARLY_DAMAGE_MULT + TUNING.WARLY_CHANGE.food_damage_mult
        end
    end
    print("WARLY_DAMAGE_MULT:", WARLY_DAMAGE_MULT)
    inst.components.combat.damagemultiplier = WARLY_DAMAGE_MULT
end

AddPrefabPostInit("warly", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.foodmemory ~= nil then
        -- debuff改成N种不同的食物
        inst.components.foodmemory:SetFoodcount(TUNING.WARLY_CHANGE.food_memory_tweaks)
        -- 沃利食物记忆时间
        inst.components.foodmemory:SetDuration(TUNING.TOTAL_DAY_TIME * TUNING.WARLY_CHANGE.food_memory_duration)
    end

    -- 沃利阵容选择
    if TUNING.WARLY_CHANGE.warly_aligned > 0 then
        -- 月亮阵容
        inst:AddTag("player_lunar_aligned")
        local damagetypebonus = inst:AddComponent("damagetypebonus")
        damagetypebonus:AddBonus("shadow_aligned", inst, TUNING.WARLY_CHANGE.warly_aligned, "warly_allegiance_lunar")
    elseif TUNING.WARLY_CHANGE.warly_aligned < 0 then --math.abs
        -- 暗影阵容
        inst:AddTag("player_shadow_aligned")
        local damagetypebonus = inst:AddComponent("damagetypebonus")
        damagetypebonus:AddBonus("lunar_aligned", inst, math.abs(TUNING.WARLY_CHANGE.warly_aligned),
            "warly_allegiance_shadow")
    end

    -- inst:ListenForEvent("oneat", oneat)
    inst:ListenForEvent("killed", Extraloot)
    inst:ListenForEvent("equip", GetEquip)
    inst:ListenForEvent("unequip", GetEquip)

    -- 香料扩展 -- 保存一下 避免重新计算
    local old_OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if old_OnLoad ~= nil then
            old_OnLoad(inst, data)
        end
        inst.extended = data.extended
    end

    local old_OnSave = inst.OnSave
    inst.OnSave = function(inst, data)
        if old_OnSave ~= nil then
            old_OnSave(inst, data)
        end
        data.extended = inst.extended
    end
end)

-- 厨师袋改成便携式袋
if TUNING.WARLY_CHANGE.portable_chef_pouch then
    modimport("scripts/prefabs_init/spicepack")
end

-- 沃利的特殊料理时长是其他角色的N倍
AddComponentPostInit("debuffable", function(self)
    local O = self.AddDebuff
    self.AddDebuff = function(...)
        local ent = O(...)
        if self.inst.prefab == "warly" then
            local timer = ent and ent.components.timer
            if timer and timer:GetTimeLeft("buffover") and not self.inst.extended then
                print("TimeLeft3", timer:GetTimeLeft("buffover") )
                timer:SetTimeLeft("buffover", timer:GetTimeLeft("buffover") * TUNING.WARLY_CHANGE.longer_buff_time)
                print("TimeLeft4", timer:GetTimeLeft("buffover") )
            end
        end
        return ent
    end
end)