
local function MakeSpice(name)
    local assets =
    {
        Asset("ANIM", "anim/warly_spices.zip"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name.."_over.tex"),
        Asset("ATLAS", "images/inventoryimages/"..name.."_over.xml"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("warly_spices")
        inst.AnimState:SetBuild("warly_spices")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_spice", "warly_spices", name)
        inst.scrapbook_overridedata={"swap_spice", "warly_spices", name}

        inst:AddTag("spice")

        MakeInventoryFloatable(inst, "med", nil, (name == "spice_garlic" and 0.85) or 0.7)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name --物品贴图
        inst.components.inventoryitem.atlasname = "images/inventoryimages/".. name ..".xml"

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeSpice("spice_bone"),
    MakeSpice("spice_glom"),
    MakeSpice("spice_shell")