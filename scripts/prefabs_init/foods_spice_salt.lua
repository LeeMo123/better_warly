AddPrefabPostInitAny(function(inst)
    if inst:HasTag("masterfood") and inst.components.perishable and string.find(inst.prefab, "_spice_salt") then
        inst.components.perishable:SetPerishTime(inst.components.perishable.perishtime*4/3)
    end
end)