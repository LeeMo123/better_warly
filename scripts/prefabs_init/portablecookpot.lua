-- 厨师锅调整

-- 三格便携烹饪锅
-- if TUNING.WARLY_CHANGE.tri_slot_portable_cook_pot then
--     local containers = require("containers")
--     local params = containers.params

--     params.portablecookpot = deepcopy(params.cookpot)

--     local bg_y = 10
--     params.portablecookpot.widget.slotpos = {
--         Vector3(0, 64 + bg_y, 0),
--         Vector3(0, -8 + bg_y, 0),
--         Vector3(0, -80 + bg_y, 0),
--     }

--     params.portablecookpot.widget.animbank = "ui_cookpot_1x3"
--     params.portablecookpot.widget.animbuild = "ui_cookpot_1x3"

--     params.portablecookpot.widget.buttoninfo.position = Vector3(0, -140 + bg_y, 0)
-- end

local containers = require("containers")
local params = containers.params

params.portablecookpot = deepcopy(params.cookpot)

local bg_y = 10
params.portablecookpot.widget.slotpos =         
{
    Vector3(0, 108+30 + bg_y, 0),
    Vector3(0, 36+30 + bg_y, 0),
    Vector3(0, -36+30 + bg_y, 0),
    Vector3(0, -108+30 + bg_y, 0),
    Vector3(0, -180+30 + bg_y, 0),
}

params.portablecookpot.widget.animbank = "ui_cookpot_1x5"
params.portablecookpot.widget.animbuild = "ui_cookpot_1x5"

params.portablecookpot.widget.buttoninfo.position = Vector3(0, -210 + bg_y, 0)

function params.portablecookpot.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and #inst.replica.container:GetItems() >= 4
end

-- 且具备保鲜能力与冰箱相同
AddPrefabPostInit("portablecookpot", function(inst)
    inst:AddTag("fridge") --保鲜0.5倍
    inst:AddTag("nocool") --没有冷冻的效果

    if not TheWorld.ismastersim then
		return inst
	end
    
    -- 烹饪过程添加一个精神效果
    local _onstartcooking = inst.components.stewer.onstartcooking
    inst.components.stewer.onstartcooking = function(inst)
        if not inst.components.sanityaura then
            inst:AddComponent("sanityaura")
        end
        inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL/2

        _onstartcooking(inst)
    end
    -- 烹饪完成移除精神效果
    local _ondonecooking = inst.components.stewer.ondonecooking
    inst.components.stewer.ondonecooking = function(inst)
        if inst.components.sanityaura ~= nil then
            inst:RemoveComponent("sanityaura")
        end
        _ondonecooking(inst)
    end
end)

-- 烹饪时间加快35%(原为20%)
GLOBAL.TUNING.PORTABLE_COOK_POT_TIME_MULTIPLIER = 0.65