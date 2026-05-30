-- 增加一个绝缘防电的tag
AddComponentPostInit("inventory", function(self)
    local _IsInsulated = self.IsInsulated
    
    function self:IsInsulated()
        -- 优先检查绝缘标签
        if self.inst:HasTag("isinsulated") then
            return true
        end
        
        -- 保留原版绝缘检查逻辑
        return _IsInsulated and _IsInsulated(self) or false
    end
end)