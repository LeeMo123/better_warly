-- 阿尔法伏特羊添加地图图标

AddMinimapAtlas("images/mapicon/lightninggoatherd.xml")
AddPrefabPostInit("lightninggoatherd", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.icon = SpawnPrefab("lightninggoatherd_icon")
    inst.icon.entity:SetParent(inst.entity)
    inst.OnRemoveEntity = function (inst)
        if inst.icon ~= nil then
            inst.icon:Remove()
        end
    end
end)
