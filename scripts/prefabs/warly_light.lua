-----------------------------------------------------------------------

local GREATER_DURATION_MULT = 4

-----------------------------------------------------------------------

local greaterlightprefabs =
{
    "warly_light_fx_greater",
}

local function light_resume(inst, time)
    inst.fx:setprogress(1 - time / inst.components.spell.duration)
end

local function light_start(inst)
    inst.fx:setprogress(0)
end

local function pushbloom(inst, target)
    if target.components.bloomer ~= nil then
        target.components.bloomer:PushBloom(inst, "shaders/anim.ksh", -1)
    else
        target.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
end

local function popbloom(inst, target)
    if target.components.bloomer ~= nil then
        target.components.bloomer:PopBloom(inst)
    else
        target.AnimState:ClearBloomEffectHandle()
    end
end


local function OnOwnerChange(inst)
    local newowners = {}
    local owner = inst._target
    local isrider = false
    while true do
        newowners[owner] = true

        local rider = owner.components.rideable and owner.components.rideable:GetRider()
        local invowner = owner.components.inventoryitem and owner.components.inventoryitem.owner

        if inst._owners[owner] then
            inst._owners[owner] = nil
        else
            if owner.components.rideable then
                inst:ListenForEvent("riderchanged", inst._onownerchange, owner)
            end
            if not rider and owner.components.inventoryitem then
                inst:ListenForEvent("onputininventory", inst._onownerchange, owner)
                inst:ListenForEvent("ondropped", inst._onownerchange, owner)
            end
        end

        local nextowner = rider or invowner
        if not nextowner then break end
        isrider = rider ~= nil
        owner = nextowner
    end

    inst.fx.entity:SetParent(owner.entity)

    if inst._popbloom ~= nil and inst._popbloom ~= owner then
        popbloom(inst, inst._popbloom)
        if isrider then
            pushbloom(inst, owner)
            inst._popbloom = owner
        else
            inst._popbloom = nil
        end
    end

    for k, v in pairs(inst._owners) do
        if k:IsValid() then
            if k.components.inventoryitem then
                inst:RemoveEventCallback("onputininventory", inst._onownerchange, k)
                inst:RemoveEventCallback("ondropped", inst._onownerchange, k)
            end
            if k.components.rideable then
                inst:RemoveEventCallback("riderchanged", inst._onownerchange, k)
            end
        end
    end

    inst._owners = newowners
end

local function light_ontarget(inst, target)
    if target == nil or target:HasTag("playerghost") or target:HasTag("overcharge") then
        inst:Remove()
        return
    end

    local function forceremove()
        inst.components.spell:OnFinish()
    end

    inst._target = target
    target.wormlight = inst
    --FollowSymbol position still works on blank symbol, just
    --won't be visible, but we are an invisible proxy anyway.
    inst.Follower:FollowSymbol(target.GUID, "", 0, 0, 0)
    inst:ListenForEvent("onremove", forceremove, target)
    inst:ListenForEvent("death", function() inst.fx:setdead() end, target)

    if target:HasTag("player") then
        inst:ListenForEvent("ms_becameghost", forceremove, target)
        if target:HasTag("electricdamageimmune") then
            inst:ListenForEvent("ms_overcharge", forceremove, target)
        end
        inst.persists = false
    else
        inst.persists = not target:HasTag("critter")
    end

    pushbloom(inst, target)
    OnOwnerChange(inst)
end

local function light_onfinish(inst)
    local target = inst.components.spell.target
    if target ~= nil then
        target.wormlight = nil

        popbloom(inst, target)

        if target.components.rideable ~= nil then
            local rider = target.components.rideable:GetRider()
            if rider ~= nil then
                popbloom(inst, rider)
            end
        end
    end
end

local function light_onremove(inst)
    inst.fx:Remove()
end

local function light_commonfn(duration, fxprefab)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddFollower()
    inst:Hide()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]

    inst:AddComponent("spell")
    inst.components.spell.spellname = "wormlight"
    inst.components.spell.duration = duration
    inst.components.spell.ontargetfn = light_ontarget
    inst.components.spell.onstartfn = light_start
    inst.components.spell.onfinishfn = light_onfinish
    inst.components.spell.resumefn = light_resume
    inst.components.spell.removeonfinish = true

    inst.persists = false --until we get a target
    inst.fx = SpawnPrefab(fxprefab)
    inst.OnRemoveEntity = light_onremove

    inst._owners = {}
    inst._onownerchange = function() OnOwnerChange(inst) end

    return inst
end

local function greaterlightfn()
    return light_commonfn(TUNING.WORMLIGHT_DURATION * GREATER_DURATION_MULT, "warly_light_fx_greater")
end

-----------------------------------------------------------------------

local function OnUpdateLight(inst, dframes)
    local frame =
        inst._lightdead:value() and
        math.ceil(inst._lightframe:value() * .9 + inst._lightmaxframe * .1) or
        (inst._lightframe:value() + dframes)

    if frame >= inst._lightmaxframe then
        inst._lightframe:set_local(inst._lightmaxframe)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end

    inst.Light:SetRadius(5)
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    OnUpdateLight(inst, 0)
end

local function setprogress(inst, percent)
    inst._lightframe:set(math.max(0, math.min(inst._lightmaxframe, math.floor(percent * inst._lightmaxframe + .5))))
    OnLightDirty(inst)
end

local function setdead(inst)
    inst._lightdead:set(true)
    inst._lightframe:set(inst._lightframe:value())
end

local function lightfx_commonfn(duration)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.Light:SetRadius(1.5)
    inst.Light:SetIntensity(.8)
    inst.Light:SetFalloff(.5)
    inst.Light:SetColour(169/255, 231/255, 245/255)
    inst.Light:Enable(true)
    inst.Light:EnableClientModulation(true)

    inst._lightmaxframe = math.floor(duration / FRAMES + .5)
    inst._lightframe = net_ushortint(inst.GUID, "wormlight_light_fx._lightframe", "lightdirty")
    inst._lightframe:set(inst._lightmaxframe)
    inst._lightdead = net_bool(inst.GUID, "wormlight_light_fx._lightdead")
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

    inst.setprogress = setprogress
    inst.setdead = setdead
    inst.persists = false

    return inst
end

local function greaterlightfxfn()
    return lightfx_commonfn(TUNING.WORMLIGHT_DURATION * GREATER_DURATION_MULT)
end

return  Prefab("warly_light_greater", greaterlightfn, nil, greaterlightprefabs),
        Prefab("warly_light_fx_greater", greaterlightfxfn)
