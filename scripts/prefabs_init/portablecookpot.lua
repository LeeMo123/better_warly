-- require("hook/stewer")
-- local containers = require("containers")

-- containers.params.portablecookpot = GLOBAL.deepcopy(containers.params.cookpot)

-- containers.params.portablecookpot.widget.buttoninfo.validfn = function(inst)
--     local items = inst.replica.container:GetItems()
--     return inst.replica.container ~= nil and #items >= 3
-- end

-- 厨师锅调整
-- 且具备保鲜能力与冰箱相同
AddPrefabPostInit("portablecookpot", function(inst)
    inst:AddTag("fridge") --保鲜0.5倍
    inst:AddTag("nocool") --没有冷冻的效果

    if not TheWorld.ismastersim then
        return inst
    end
    
end)

-- 烹饪时间加快35%(原为20%)
GLOBAL.TUNING.PORTABLE_COOK_POT_TIME_MULTIPLIER = 0.65