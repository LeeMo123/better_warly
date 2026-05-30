
-----------------------------------------------------------------------
-- 蓝带鱼增加防电
AddPrefabPostInit("buff_moistureimmunity", function(inst)
    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)
        return inst
    end
    local debuff = inst.components.debuff
    if debuff then
        local _onattachedfn = debuff.onattachedfn
        debuff.onattachedfn = function (inst, target)
            _onattachedfn(inst, target)
                
            target:AddTag("isinsulated")
        end

        local _ondetachedfn = debuff.ondetachedfn
        debuff.ondetachedfn = function (inst, target)
            _ondetachedfn(inst, target)

            target:RemoveTag("isinsulated")
        end
    end
end)

-----------------------------------------------------------------------
-- 部分食物属性重写

local foods = require ("preparedfoods")
local warly_foods = require("preparedfoods_warly")

-- 蒸树枝
-- foods.beefalofeed.test = function(cooker, names, tags) return names.twigs and names.twigs >= 3 end

-- 蓬松土豆
warly_foods.potatosouffle.hunger = 60
warly_foods.potatosouffle.health = 37.5
warly_foods.potatosouffle.sanity = 37.5

-- 恐怖国王饼
warly_foods.nightmarepie.test = function(cooker, names, tags) return names.nightmarefuel and names.nightmarefuel >= 3 end
local _oneatenfn = warly_foods.nightmarepie.oneatenfn
warly_foods.nightmarepie.oneatenfn = function(inst, eater)
    if eater:HasTag("player") then
        _oneatenfn(inst, eater)
    else
        if eater.components.health ~= nil then
            eater.components.health:DoDelta(-300 - math.random(1, 300))
        end
    end
end

-- 水果派
warly_foods.freshfruitcrepes.test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 1 and names.butter and names.honey end

-- 发光浆果
warly_foods.glowberrymousse.prefabs = { "warly_light_greater" }
warly_foods.glowberrymousse.oneatenfn = function(inst, eater)
    --see wormlight.lua for original code
    if eater.wormlight ~= nil then
        if eater.wormlight.prefab == "warly_light_greater" then
            eater.wormlight.components.spell.lifetime = 0
            eater.wormlight.components.spell:ResumeSpell()
            return
        else
            eater.wormlight.components.spell:OnFinish()
        end
    end

    local light = SpawnPrefab("warly_light_greater")
    light.components.spell:SetTarget(eater)
    if light:IsValid() then
        if light.components.spell.target == nil then
            light:Remove()
        else
            light.components.spell:StartSpell()
        end
    end
end
