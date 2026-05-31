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