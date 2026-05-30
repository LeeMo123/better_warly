-- 强壮形态
local function strong_attach(inst, target)
    target:AddTag("strong_for_heavy")
end

local function strong_detach(inst, target)
    target:RemoveTag("strong_for_heavy")
end

local function reset_cd(inst)
    if inst.attack_cd ~= nil then
        inst.attack_cd:Cancel()
        inst.attack_cd = nil
    end

    if inst.attack_stacks ~= 0 then
        inst.attack_stacks = 0
    end
end

local function DoAttacked(inst, data)
    -- 取消已有任务并重新计时
    if inst.attack_cd then
        inst.attack_cd:Cancel()  -- 取消正在进行的倒计时
    end

    -- 无动作6秒后重置
    inst.attack_cd = inst:DoTaskInTime(6, reset_cd)

    -- 初始化攻击次数
    if inst.attack_stacks == nil then
        inst.attack_stacks = 0
    end

    inst.attack_stacks = inst.attack_stacks + 1
end


-- 强力捉握和攻速加快
local function stronggrip_attach(inst, target)
    target:AddTag("stronggrip")
    target:AddTag("fasterattack")

    -- 攻速加快
    target:ListenForEvent("onattackother", DoAttacked)
end

local function stronggrip_detach(inst, target)
    target:RemoveTag("stronggrip")
    target:RemoveTag("fasterattack")

    -- 移除攻速
    target:RemoveEventCallback("onattackother", DoAttacked)
end

local function OnCooldown(target)
	target.cdtask = nil
end

-- 荆棘特效
local function DoThorns(inst, damage)
    inst.cdtask = inst:DoTaskInTime(1, OnCooldown)

    local fx = SpawnPrefab("bramblefx_armor")
    fx:SetFXOwner(inst)        -- 设置fx的拥有者
    fx.damage = damage

    -- 设置伤害
    if inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
    end
end

local function BeAttacked(target, data)  --owner, data, inst
    if target.cdtask == nil and data ~= nil and not data.redirected then
        DoThorns(target, 24.5)
    end
end

local function OnAttacked(inst, data) 
    DoAttacked(inst, data)

    if inst.cdtask == nil and  inst.attack_stacks % 6 == 0 then
        DoThorns(inst, 17)
        inst.cdtask = inst:DoTaskInTime(2, OnCooldown)
    end
end

-- 伤害反射
local function damage_reflection_attach(inst, target)
    target:ListenForEvent("blocked", BeAttacked)
    target:ListenForEvent("attacked", BeAttacked)

    target:ListenForEvent("onattackother",OnAttacked)
end

local function damage_reflection_detach(inst, target)
    target:RemoveEventCallback("blocked", BeAttacked)
    target:RemoveEventCallback("attacked", BeAttacked)
    
    target:RemoveEventCallback("onattackother",OnAttacked)
end
-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
    local ATTACH_BUFF_DATA = {
        buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name),
        priority = priority
    }
    local DETACH_BUFF_DATA = {
        buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name),
        priority = priority
    }

    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
            target.extended = false
        end, target)

        target:PushEvent("foodbuffattached", ATTACH_BUFF_DATA)
        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end

    local function OnExtended(inst, target)
        -- 获取剩余时间
        local TimeLeft = math.floor(inst.components.timer:GetTimeLeft("buffover"))
        if TimeLeft then
            -- 延长时间
            target.extended = true
            inst.components.timer:SetTimeLeft("buffover", TimeLeft + duration *TUNING.WARLY_CHANGE.longer_buff_time )
        end

        target:PushEvent("foodbuffattached", ATTACH_BUFF_DATA)
        if onextendedfn ~= nil then
            onextendedfn(inst, target)
        end
    end

    local function OnDetached(inst, target)
        target.extended = false
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end

        target:PushEvent("foodbuffdetached", DETACH_BUFF_DATA)
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", duration)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab("buff_"..name, fn, nil, prefabs)
end


return MakeBuff("strong_for_heavy", strong_attach, nil, strong_detach, TUNING.WARLY_CHANGE.BUFF_STRONG_FOR_HEAVY, 1),
    MakeBuff("stronggrip_state", stronggrip_attach, nil, stronggrip_detach, TUNING.WARLY_CHANGE.BUFF_STRONGGRIP_STATE, 1),
    MakeBuff("damage_reflection", damage_reflection_attach, nil, damage_reflection_detach, TUNING.WARLY_CHANGE.BUFF_DAMAGE_REFLECTION, 1)