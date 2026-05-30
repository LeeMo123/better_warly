GLOBAL.setmetatable(GLOBAL.getfenv(1), { __index = function(self, index) return GLOBAL.rawget(GLOBAL, index) end })

-- Prefab导入
PrefabFiles = {
    "warly_foodbuffs",     -- 食物buff
    "warly_spices",        -- 香料
    "warly_preparedfoods", -- 食物加载

    "warly_light",         -- 光源buff

    "warly_seedpacket",     -- 种子包

    "minimap_icon"          -- 小地图图标
}

-- 模块导入
modimport("scripts/tuning_init")     -- 配置数据
modimport("scripts/hook/foodmemory") -- 沃利食物改版，修改食物记忆debuff只会记住N种食物
modimport("scripts/hook/inventory")  -- 绝缘
modimport("scripts/hook/locomotor")  -- 重物不减速Buff
modimport("scripts/hook/stewer")     -- 烹饪组件
-- modimport("scripts/hook/perishable") -- 腐烂度组件

modimport("scripts/strings")         -- 字符Strings
modimport("scripts/warly_recipes")   -- 配方相关的
-- modimport("scripts/warly_actions")   -- 动作

-- 预设
modimport("scripts/prefabs_init/preparedfoods")   -- 食物属性调整
modimport("scripts/prefabs_init/warly")           -- 沃利调整
modimport("scripts/prefabs_init/portableblender") -- 研磨器
modimport("scripts/prefabs_init/portablecookpot") -- 烹饪锅
modimport("scripts/prefabs_init/portablespicer")  -- 便携香料站
-- modimport("scripts/prefabs_init/pigking")         -- 给猪王怪物料理 获得猪王的种子袋
modimport("scripts/prefabs_init/foodbuffs")       -- 料理buff
modimport("scripts/prefabs_init/foods_spice_salt")-- 盐调料食物

-- 小地图图标
modimport("scripts/prefabs_init/wanderingtrader")   -- 流浪商人
modimport("scripts/prefabs_init/lightninggoatherd") -- 伏特羊刷新点

-- SG
modimport("scripts/hook/SGwilson")

-- 其他
modimport("scripts/hook/hook_actions")
AddClassPostConstruct("components/talker", function(self)
    -- 仅在客户端生效，且仅当本地玩家是 Wonkey 时，我们才需要特殊处理显示
    -- 但注意：Talker 组件属于实体。如果这个实体是本地玩家，我们才修改。
    -- 如果这个实体是其他玩家，我们不应该修改他们的 Talker 逻辑，除非你想让所有人在你看来都是胡言乱语（通常不是这样）
    
    -- 这里的 self 是 Talker 组件实例
    -- self.inst 是拥有该 Talker 的实体
    
    -- 我们只关心本地玩家自己的说话显示
    if ThePlayer and self.inst == ThePlayer then
        if ThePlayer:HasTag("wonkey") then
            -- 保存旧的 override fn 如果有
            local old_override_fn = self.inst.speech_override_fn
            
            self.inst.speech_override_fn = function(inst, message)
                -- 先经过旧的 override (如果有)
                if old_override_fn then
                    message = old_override_fn(inst, message)
                end
                
                -- Wonkey 特殊逻辑：将消息转换为胡言乱语用于显示
                -- 注意：这里只影响本地显示，不影响网络广播的内容（网络广播在 Say 函数内部处理）
                -- 原始代码中，CraftGiberish 是在 display_message 确定后，SetString 之前做的吗？
                -- 看 file1 183行: 如果玩家是 wonkey 且说话者不是 monkey，则 display_message = CraftGiberish()
                -- 所以我们在这里模拟这个逻辑
                
                -- 检查说话者是不是猴子（通常 Wonkey 说话时，self.inst 就是 Wonkey 自己）
                -- 原始逻辑: if ThePlayer and not self.inst:HasTag("monkey") and ThePlayer:HasTag("wonkey") then
                -- 因为这是本地玩家的 Talker，self.inst 就是 ThePlayer。
                -- 如果 ThePlayer 是 Wonkey，他通常没有 "monkey" 标签 (Wonkey 是独立 prefab)
                
                if not inst:HasTag("monkey") then
                    return CraftGiberish()
                end
                
                return message
            end
        end
    end
end)
