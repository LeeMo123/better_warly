local function MinimapIcon(name)
    local assets = {
        Asset("ATLAS", "images/mapicon/"..name..".xml"), -- 小地图图标
        Asset("IMAGE", "images/mapicon/"..name..".tex"),
    }

    local function icon_init(inst)
        inst.icon = SpawnPrefab("globalmapicon")
        inst.icon.MiniMapEntity:SetPriority(11)
        inst.icon:TrackEntity(inst)
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        inst.MiniMapEntity:SetIcon(name..".tex")
        inst.MiniMapEntity:SetPriority(11)
        inst.MiniMapEntity:SetCanUseCache(false)
        inst.MiniMapEntity:SetDrawOverFogOfWar(true)

        inst:AddTag("CLASSIFIED")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.icon = nil
        inst:DoTaskInTime(0, icon_init)
        inst.OnRemoveEntity = inst.OnRemoveEntity
        inst.persists = false

        return inst
    end

    return Prefab(name.."_icon", fn, assets)
end

return MinimapIcon("wanderingtrader"),
    MinimapIcon("lightninggoatherd")