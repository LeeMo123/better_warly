
-- 猪王可以交易换取专属种子包

local DEGREES = math.pi/180
local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function ontradeforgold(inst, item, giver)
    local x, y, z = inst.Transform:GetWorldPosition() y = 4.5

    local angle
    if giver ~= nil and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end

    local nug = SpawnPrefab("warly_seedpacket")
    nug.Transform:SetPosition(x, y, z)
    launchitem(nug, angle)
end

AddPrefabPostInit("pigking", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local _AcceptTest = inst.components.trader.test
    local function AcceptTest(inst, item, giver)
        -- Wurt can still play the mini-game though
        if giver:HasTag("masterchef") and string.find(item.prefab, "monstertartare") and inst.canaccept_monstertartare == nil then
            inst.canaccept_monstertartare = inst:DoTaskInTime(60 *8,function()
                inst.canaccept_monstertartare:Cancel()
                inst.canaccept_monstertartare = nil
            end)
            return true
        else
            return _AcceptTest(inst, item, giver)
        end
    end

    local _OnAcceptOld = inst.components.trader.onaccept
    local function OnGetItemFromPlayer(inst, giver, item)
        if string.find(item.prefab, "monstertartare") then
            inst.sg:GoToState("cointoss")
            inst:DoTaskInTime(2 / 3, ontradeforgold, item, giver)
        else
            _OnAcceptOld(inst, giver, item)
        end
    end

    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer
end)