-- 流浪商人小地图图标

AddMinimapAtlas("images/mapicon/wanderingtrader.xml")
AddPrefabPostInit("wanderingtrader", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local wanderingtradershop_warly = {
        ["wanderingtradershop_butter"] = {recipe = "wanderingtradershop_butter", min = 2, max = 4, limit = 4,},
        ["wanderingtradershop_warly_seedpacket"] = {recipe = "wanderingtradershop_warly_seedpacket", min = 1, max = 2, limit = 2,},
    }

    --  wanderer
    inst:AddWares(wanderingtradershop_warly)
    
    --  wanderer_shop
    local old_RerollWares = inst.RerollWares
    inst.RerollWares = function(inst)
        old_RerollWares(inst)
        inst:AddWares(wanderingtradershop_warly)
    end

    inst.icon = SpawnPrefab("wanderingtrader_icon")
    inst.icon.entity:SetParent(inst.entity)
    inst.OnRemoveEntity = function (inst)
        if inst.icon ~= nil then
            inst.icon:Remove()
        end
    end
end)