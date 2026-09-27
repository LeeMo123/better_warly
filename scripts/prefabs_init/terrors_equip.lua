-- 两个克眼装备吃怪物鞑靼有双倍回复的效果
local terrors_equis = {"eyemaskhat", "shieldofterror"}

local function oneatfn(inst, food)
    local ismonstertartare = food.prefab == "monstertartare" and 2 or 1
    local health = math.abs(food.components.edible:GetHealth(inst)) * inst.components.eater.healthabsorption
    local hunger = math.abs(food.components.edible:GetHunger(inst)) * inst.components.eater.hungerabsorption
    inst.components.armor:Repair((health + hunger) * ismonstertartare)

    -- print("ismonstertartare", ismonstertartare)

    if not inst.inlimbo then
        inst.AnimState:PlayAnimation("eat")
        inst.AnimState:PushAnimation("idle", true)

        inst.SoundEmitter:PlaySound("terraria1/eye_shield/eat")
    end
end

for _, prefab in pairs(terrors_equis) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst.components.eater:SetOnEatFn(oneatfn)
    end)
end
