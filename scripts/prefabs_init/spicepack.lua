local containers = require("containers")

containers.params.spicepack = GLOBAL.deepcopy(containers.params.beargerfur_sack)

containers.params.spicepack.itemtestfn = function(container, item, slot)
    for i, v in ipairs(GLOBAL.FOODGROUP.OMNI.types) do
        if item:HasTag("edible_" .. v) or item:HasTag("spice") then return true end
    end
end

for i = 1,6 do
    containers.params.spicepack.widget.slotbg[i] = { image = "inv_slot_morsel.tex" }
end

local function onopen(inst, data)
    inst.SoundEmitter:PlaySound("meta3/wigfrid/battlesong_container_open")

    local doer = data and data.doer
    local perishratemultiplier
    if doer and doer:HasTag("masterchef") then
        perishratemultiplier = 0.50
    else
        perishratemultiplier = 0.75
    end

    if inst.components.preserver:GetPerishRateMultiplier(inst) ~= perishratemultiplier then
        inst.components.preserver:SetPerishRateMultiplier(perishratemultiplier)
    end
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("meta3/wigfrid/battlesong_container_close")
end

local function OnSave(inst, data)
    data.perishratemultiplier = inst.components.preserver:GetPerishRateMultiplier(inst)
end

local function OnLoad(inst, data)
    inst.components.preserver:SetPerishRateMultiplier(data.perishratemultiplier)
end

AddPrefabPostInit("spicepack", function(inst)
    inst:RemoveTag("backpack")
    inst:AddTag("portablestorage")

    if not TheWorld.ismastersim then return end

    if inst.components.equippable ~= nil then
        inst:RemoveComponent("equippable")
    end

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
    inst.components.container.droponopen = true

    inst.components.inventoryitem.cangoincontainer = true
    inst.components.inventoryitem.canonlygoinpocket = true

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0.75)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
end)