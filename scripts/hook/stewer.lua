AddComponentPostInit("stewer", function(self)
    -- local _StartCooking = self.StartCooking
    -- function self:StartCooking(doer)
    --     _StartCooking(self, doer)  -- 保留原版逻辑

    --     -- 新增：若未匹配到食谱，强制设置为 wetgoop
    --     if self.inst.prefab == "portablecookpot" and self.product == nil then
    --         self.product = "wetgoop"
    --     end
    -- end

    local _CanCook = self.CanCook
    function self:CanCook()
        local item = self.inst.components.container:GetAllItems()
        if self.inst.prefab == "portablecookpot" then
            return self.inst.components.container ~= nil and #item >= 3
        else
            return _CanCook(self)
        end
    end
end)