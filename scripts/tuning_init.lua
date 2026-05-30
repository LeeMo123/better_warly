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

    -- buff时间之类的：
    BUFF_STRONG_FOR_HEAVY = TUNING.TOTAL_DAY_TIME * 5/8,  --重物不减速
    BUFF_STRONGGRIP_STATE = TUNING.TOTAL_DAY_TIME * 5/8,  --武器不脱手
    BUFF_DAMAGE_REFLECTION = TUNING.TOTAL_DAY_TIME * 5/8,  --反伤

    -- 香料站研磨香料buff应用最大距离
    PORTABLESPICER_BUFF_RANGE = 6,

    -- 大肉
    meats_table = { "meat", "cookedmeat", "meat_dried", "drumstick", "drumstick_cooked", "fishmeat",
    "fishmeat_cooked" },
    
    -- 小肉
    smallmeat_table = { "smallmeat", "cookedsmallmeat", "smallmeat_dried", "smallmeat", "cookedsmallmeat",
    "fishmeat_small", "fishmeat_small_cooked" },

    nummaxguarou_table = { 2, 2, 2, 2, 2, 1, 1 }, -- 可以获得最多的小块肉的数量--移除预制物(预制物,数量)

}

if GLOBAL.KnownModIndex:IsModEnabled("workshop-2039181790") then
    local monster_meats_table = {"monstermeat", "cookedmonstermeat", "monstermeat_dried"}
    local smallmonster_meats_table = {"monstersmallmeat", "cookedmonstersmallmeat", "monstersmallmeat_dried"}
    
    for _, monster_meat in pairs(monster_meats_table) do
        table.insert(TUNING.WARLY_CHANGE.meats_table, monster_meat)
    end

    for _, monster_smallmeat in pairs(smallmonster_meats_table) do
        table.insert(TUNING.WARLY_CHANGE.smallmeat_table, monster_smallmeat)
    end

    TUNING.WARLY_CHANGE.nummaxguarou_table = { 2, 2, 2, 2, 2, 1, 1 ,2 ,2, 2}
end