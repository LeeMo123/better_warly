-----------------------------------------------------------------------
local function setprogress(inst, percent)
    inst._lightframe:set(math.max(0, math.min(inst._lightmaxframe, math.floor(inst._lightmaxframe + .5))))
    -- OnLightDirty(inst)
end

AddPrefabPostInit("wormlight_light_fx_greater", function(inst)
    inst.Light:SetRadius(4)
    inst.Light:SetIntensity(.8)
    inst.Light:SetFalloff(.5)
    if not TheWorld.ismastersim then
        return
    end

    inst.setprogress = setprogress
end)