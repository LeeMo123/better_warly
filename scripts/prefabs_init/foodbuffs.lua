-- vallige
local foodbuffs = {
    ["buff_playerabsorption"] = TUNING.BUFF_PLAYERABSORPTION_DURATION,
    ["buff_workeffectiveness"] = TUNING.BUFF_WORKEFFECTIVENESS_DURATION,
    ["buff_attack"] = TUNING.BUFF_ATTACK_DURATION,
}

for buff, duration in pairs(foodbuffs) do
    AddPrefabPostInit(buff, function(inst)
        if not TheWorld.ismastersim then
            -- Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        -- OnAttached
        local old_onattachedfn = inst.components.debuff.onattachedfn
        inst.components.debuff.onattachedfn = function(self, target)
            if old_onattachedfn  ~= nil then
                old_onattachedfn(self, target)
            end

            inst:ListenForEvent("death", function()
                target.extended = false
            end, target)
        end

        -- OnDetached
        local old_ondetachedfn = inst.components.debuff.ondetachedfn
        inst.components.debuff.ondetachedfn = function(inst, target)
            if old_ondetachedfn then
                old_ondetachedfn(inst, target)
            end
            target.extended = false
        end

        -- SetExtendedFn
        local old_onextendedfn = inst.components.debuff.onextendedfn
        inst.components.debuff:SetExtendedFn(function(inst, target)
            -- 获取剩余时间
            local TimeLeft = math.floor(inst.components.timer:GetTimeLeft("buffover"))
            if TimeLeft then
                -- 延长时间
                target.extended = true
                inst.components.timer:SetTimeLeft("buffover", TimeLeft + duration * TUNING.WARLY_CHANGE.longer_buff_time)
            end

            target:PushEvent("foodbuffattached", {
                buff = (target.components.talker and "ANNOUNCE_ATTACH_"..string.upper(inst.prefab)) or nil,
                priority = 1
            })
        end)
    end)
end
