local TUNING = GLOBAL.TUNING

TUNING.WARLY_CHANGE = {
    -- 配置选项
    food_memory_tweaks = GetModConfigData("food_memory_tweaks"),
    food_memory_duration = GetModConfigData("food_memory_duration"),
    longer_buff_time = GetModConfigData("longer_buff_time"),
    -- warly_seasoning_recipe = GetModConfigData("warly_seasoning_recipe"),
    extra_food_benefits = GetModConfigData("extra_food_benefits"),
    warly_butcher = GetModConfigData("warly_butcher"),
    portable_chef_pouch = GetModConfigData("portable_chef_pouch"),
    -- warly_action = GetModConfigData("warly_action"),
    food_damage_mult = GetModConfigData("food_damage_mult"),
    warly_aligned = GetModConfigData("warly_aligned"),
    is_spice_food_tweaks = GetModConfigData("is_spice_food_tweaks"),
    -- 羊角掉落额外概率
    warly_extra_lightninggoathorn = GetModConfigData("warly_extra_lightninggoathorn"),
    -- 三格便携烹饪锅
    fif_slot_portable_cook_pot = GetModConfigData("fif_slot_portable_cook_pot"),

    -- buff时间之类的：
    BUFF_STRONG_FOR_HEAVY = TUNING.TOTAL_DAY_TIME * 5/8,  --重物不减速
    BUFF_STRONGGRIP_STATE = TUNING.TOTAL_DAY_TIME * 5/8,  --武器不脱手
    BUFF_DAMAGE_REFLECTION = TUNING.TOTAL_DAY_TIME * 5/8,  --反伤

    -- 香料站研磨香料buff应用最大距离
    PORTABLESPICER_BUFF_RANGE = 6,

    ---------------------------------------------------------------
    meats_table = {     
        meat              = { "smallmeat", 2 },     -- 生大肉 -> 2小块肉
        cookedmeat        = { "cookedsmallmeat", 2 }, -- 熟大肉 -> 2小块熟肉
        meat_dried        = { "smallmeat_dried", 2 }, -- 肉干 -> 2小块肉干
        drumstick         = { "smallmeat", 1 },     -- 鸡腿(生) -> 2小块肉
        drumstick_cooked  = { "cookedsmallmeat", 1 }, -- 鸡腿(熟) -> 2小块熟肉
        fishmeat          = { "fishmeat_small", 2 }, -- 鱼肉 -> 2小块鱼肉
        fishmeat_cooked   = { "fishmeat_small_cooked", 2 }, -- 熟鱼肉 -> 2小块熟鱼肉
        fishmeat_dried    = { "fishmeat_small_dried", 2 }, -- 鱼肉干 -> 2小块鱼肉干
        trunk_summer      = { "meat", 2 },     -- 夏象鼻 -> 2生大肉
        trunk_winter      = { "meat", 2 },     -- 冬象鼻 -> 2生大肉
        trunk_cooked      = { "cookedmeat", 2 },-- 熟象鼻 -> 2熟大肉    
    },
}