-- 盐调味料理腐烂时间延长1/3
AddComponentPostInit("perishable", function(self)
    local _SetPerishTime = self.SetPerishTime

    function self:SetPerishTime(time)
        if self.inst and self.inst.prefab and string.find(self.inst.prefab, "_spice_salt") then
            self.perishremainingtime = time + time / 3
            if self.updatetask ~= nil then
                self:StartPerishing()
            end
        else
            for k, v in pairs(self.inst) do
                print(k, v)
            end
            return _SetPerishTime(self, time)
        end
    end
end)