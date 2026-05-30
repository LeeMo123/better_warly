AddComponentPostInit("foodmemory", function(self)
    self.foodcount = 2
    self.recordedfoods = {}

    local function DoForgetFood(prefab)
        prefab = self:GetBaseFood(prefab)
        self.inst:DoTaskInTime(self.duration, function()
            if table.contains(self.recordedfoods, prefab) then
                table.removearrayvalue(self.recordedfoods, prefab)
                print("已经到期，移除食物：", prefab)
            end
        end)
    end

    function self:IsSpiceFood(prefab)
        return string.find(prefab, "_spice_") and true or false
    end

    local _RememberFood = self.RememberFood
    function self:RememberFood(prefab)
        IsSpiceFood = self:IsSpiceFood(prefab)
        prefab = self:GetBaseFood(prefab)
        local currentDiff = self:GetDiffFoodCount()
        local maxFood = self:GetFoodcount()
        local hasRecorded = table.contains(self.recordedfoods, prefab)

        if IsSpiceFood and TUNING.WARLY_CHANGE.is_spice_food_tweaks then
            return
        end

        if currentDiff <= maxFood then
            if not hasRecorded then
                table.insert(self.recordedfoods, prefab)
            end
            self:DoSortRecfoods(prefab)
        else
            if not hasRecorded then
                local oldestFood = self.recordedfoods[1]
                self.foods[oldestFood] = nil
            end
            self:DoSortRecfoods(prefab)
        end

        DoForgetFood(prefab)
        return _RememberFood(self, prefab)
    end

    -- 返回recordedfoods的列表元素总数
    function self:GetDiffFoodCount()
        return #self.recordedfoods
    end

    -- 直接清除所有记忆的食物
    function self:CleanFood()
        self.foods = {}
    end

    function self:SetFoodcount(count)
        self.foodcount = count - 1
    end

    function self:GetFoodcount()
        return self.foodcount
    end

    -- 重新排序食物表格
    function self:DoSortRecfoods(prefab)
        prefab = self:GetBaseFood(prefab)
        if table.contains(self.recordedfoods, prefab) then
            table.removearrayvalue(self.recordedfoods, prefab)
            table.insert(self.recordedfoods, prefab)
        else
            table.remove(self.recordedfoods, 1)
            table.insert(self.recordedfoods, prefab)
        end
    end

    -- 获取食物的记忆数量
    function self:GetFoodMultiplier(prefab)
        local count = self:GetMemoryCount(prefab)
        return count > 0 and self.mults ~= nil and self.mults[math.min(#self.mults, count)] or TUNING.WARLY_CHANGE.extra_food_benefits + 1
    end

    -- local _OnSave = self.OnSave
    function self:OnSave()
        local data = {}

        -- 保存self.foods表格数据
        if next(self.foods) ~= nil then
            local foodsData = {}
            for k, v in pairs(self.foods) do
                foodsData[k] = { count = v.count, t = GetTaskRemaining(v.task) }
            end
            data.foods = foodsData
        end

        -- 保存self.recordedfoods表格数据
        if next(self.recordedfoods) ~= nil then
            data.recordedfoods = self.recordedfoods
        end

        data.foodcount = self.foodcount
        return data
    end

    local _OnLoad = self.OnLoad
    function self:OnLoad(data)
        -- 调整了食物记忆数量之后，直接清空foods和recderdfoods
        -- 防止出现两个表格数据不同步的问题
        if data.recordedfoods and data.foodcount ~= self.foodcount then return end
        if data.recordedfoods ~= nil then
            for k, v in pairs(data.recordedfoods) do
                table.insert(self.recordedfoods, v)
                print("重载已载入：",v)
                DoForgetFood(v)
            end
        end
        return _OnLoad(self, data)
    end
end)
