-- 咸的料理保鲜度比原来多1/3
AddPrefabPostInitAny(function(inst)
    if inst.components.perishable and string.find(inst.prefab, "_spice_salt") then
        inst.components.perishable:SetPerishTime(inst.components.perishable.perishtime*4/3)
    end
end)