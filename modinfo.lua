local L = locale ~= "zh" and locale ~= "zhr"

name = L and "Better Warly" or "更强的沃利"
description = L and [[
1.Food Memory Debuff Adjustment:
Warly's penalty system now tracks ​**[the last 3 unique foods consumed]** (number configurable via settings).
2.Buff Duration Extension:
Food buff durations are ​2-3× longer for Warly compared to other characters.
3.Butcher Warly:
15-25% chance to obtain bonus meat drops when killing creatures.
4.Chef Warly:
    a) Can ​butcher Large Meat into 3x Small Meat using a Razor
    b) ​**+25% spice yield** when processing ingredients at Spice Stations
    c) ​Field Seasoning - Apply spices directly to food without stations
5.Chef's Satchel Rework:
Now functions as an ​equippable inventory item rather than backpack gear.
6.Gastronomic Efficiency:
Receives ​**+33% hunger/sanity** values from all consumed foods.
7.Culinary Combat:
Gains ​1.2× damage multiplier when wielding freshness-based weapons (e.g. Ham Bat) or feedable tools.
]]
    or [[
1，食物debuff调整：调整了沃利的食物记忆，现在沃利的所有食物惩罚debuff调整为【最近吃的三种不同的食物,食物种类的数量是可配置】
2，Buff时间延长：沃利获得的食物特效时长是其他角色的数倍
3，屠夫沃利：沃利在击杀生物时，将有概率获得额外食物掉落
4，厨师沃利：
    1.可以使用剃刀将大肉分割成小肉
    2.将原料给予香料站可研磨出更多香料
    3.可直接使用香料调味食物无需香料站
5，厨师袋调整：现在可以随身携带了而不再是背包。
6，额外食物收益：沃利能够从食物中获得额外的收益。
7，攻击倍率：沃利使用某些新鲜度/可喂食的装备时获得额外的攻击增益。
]]

author = "去码头整点薯条, 我家小虎虎"
version = "2026.4.19"

forumthread = ""

api_version = 10

priority = -100

dont_starve_compatible = true
reign_of_giants_compatible = true
all_clients_require_mod = true
client_only_mod = false
dst_compatible = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

-- forumthread = "https://steamcommunity.com/sharedfiles/filedetails/?id=3216130088"

server_filter_tags = { "warly", "better warly", "stronger warly", "沃利", "更强的沃利" }

configuration_options =
{
    {
        name = "food_memory_tweaks",
        label = L and "food memory tweaks" or "食物记忆调整",
        hover = L and "During the food memory period, warly can remember up to 'N' types of food." or
            "在食物记忆时期，沃利最多记住N种食物种类。",
        options =
        {
            { description = "7", hover = L and "Warly can remember up to 7 types of food." or "沃利最多记住7种食物种类。", data = 7 },
            { description = "6", hover = L and "Warly can remember up to 6 types of food." or "沃利最多记住6种食物种类。", data = 6 },
            { description = "5", hover = L and "Warly can remember up to 5 types of food." or "沃利最多记住5种食物种类。", data = 5 },
            { description = "4", hover = L and "Warly can remember up to 4 types of food." or "沃利最多记住4种食物种类。", data = 4 },
            { description = "3", hover = L and "Warly can remember up to 3 types of food." or "沃利最多记住3种食物种类。", data = 3 },
            { description = "2", hover = L and "Warly can remember up to 2 types of food." or "沃利最多记住2种食物种类。", data = 2 },
            {
                description = L and "Disable" or "关闭",
                hover = L and "Vanilla"
                    or "关闭该调整",
                data = 20
            }
        },
        default = 3
    },
    {
        name = "is_spice_food_tweaks",
        label = L and "Spice Food" or "调料食物",
        hover = L and "Spiced foods will no longer count towards Warly's food penalty\nWarly can now consecutively consume the same type of spiced dish without incurring an effect penalty" or
            "调料食物将不再计入沃利的食物惩罚\n沃利现在可以连续食用同一种调味料理而无收益惩罚",
        options =
        {
            { description = L and "Enable" or "开启", data = true },
            { description = L and "Disable" or "关闭", data = false }
        },
        default = true
    },
    {
        name = "food_memory_duration",
        label = L and "food memory duration" or "食物记忆时间",
        hover = L and "Warly will forget the food he ate after duration." or
            "沃利食物debuff时间。",
        options =
        {
            { description = L and "30 day" or "30天", data = 30 },
            { description = L and "20 day" or "20天", data = 20 },
            { description = L and "10 day" or "10天", data = 10 },
            { description = L and "5 day" or "5天", data = 5 },
            { description = L and "2 day[Vanilla]" or "2天[默认]", data = 2 },
            { description = L and "1 day" or "1天", data = 1 },
            { description = L and "0.5 day" or "0.5天", data = 0.5 },
        },
        default = 2
    },
    {
        name = "longer_buff_time",
        label = L and "longer buff time" or "更长buff时间",
        hover = L and "The buff obtained by warly after eating special food lasts longer than other characters" or
            "沃利食用特殊料理后获得的buff时间比其他角色更长",
        options =
        {
            { description = "5", hover = L and "Get 5x the buff time" or "获得 5 倍的buff时间", data = 5 },
            { description = "4", hover = L and "Get 4x the buff time" or "获得 4 倍的buff时间", data = 4 },
            { description = "3", hover = L and "Get 3x the buff time" or "获得 3 倍的buff时间", data = 3 },
            { description = "2", hover = L and "Get 2x the buff time" or "获得 2 倍的buff时间", data = 2 },
            { description = "1.5", hover = L and "Get 1.5x the buff time" or "获得 1.5 倍的buff时间", data = 1.5 },
            { description = L and "Disable" or "关闭", hover = L and "Vanilla" or "关闭该调整", data = 1 }
        },
        default = 2
    },
    {
        name = "warly_extra_lightninggoathorn",
        label = L and "extra lightninggoathorn lootdrop" or "额外羊角掉落概率",
        hover = L and "Warly has a chance to gain an extra Volt Goat Horn when killing a Volt Goat." or
            "沃利击杀伏特羊时有概率获得额外羊角。",
        options =
        {
            { description = L and "Enable" or "开启", data = true },
            { description = L and "Disable" or "关闭", data = false }
        },
        default = true
    },
    {
        name = "extra_food_benefits",
        label = L and "extra food benefits" or "额外食物收益",
        hover = L and "Warly's chef's palate allows him to get more from his food[from UM]" or
            "沃利的厨师味觉可以让他从食物中获得额外收益[来自UM]",
        options =
        {
            { description = "30%", hover = L and "Extra 30% food benefits" or "额外30%的食物收益", data = .3 },
            { description = "20%", hover = L and "Extra 20% food benefits" or "额外20%的食物收益", data = .2 },
            { description = "10%", hover = L and "Extra 10% food benefits" or "额外10%的食物收益", data = .1 },
            {
                description = L and "Disable" or "关闭",
                hover = L and "Warly does not get additional food benefits"
                    or "沃利不会获得额外的食物收益",
                data = 0
            }
        },
        default = .2
    },
    {
        name = "warly_butcher",
        label = L and "butcher warly" or "屠夫沃利",
        hover = L and "Warly has a chance to get more food when he kills creatures." or
            "沃利在击杀生物是有概率获得更多食物。",
        options =
        {
            -- { description = "100%", hover = L and "100% chance of dropping more food loot." or "100%的概率掉落更多食物掉落物。", data = 0 },
            { description = "90%", hover = L and "90% chance of dropping more food loot." or "90%的概率掉落更多食物掉落物。", data = 0.1 },
            { description = "70%", hover = L and "70% chance of dropping more food loot." or "70%的概率掉落更多食物掉落物。", data = 0.3 },
            { description = "50%", hover = L and "50% chance of dropping more food loot." or "50%的概率掉落更多食物掉落物。", data = 0.5 },
            { description = "30%", hover = L and "30% chance of dropping more food loot." or "30%的概率掉落更多食物掉落物。", data = 0.7 },
            { description = "10%", hover = L and "15% chance of dropping more food loot." or "15%的概率掉落更多食物掉落物。", data = 0.9 },
            { description = L and "Disable" or "关闭", hover = L and "No additional edible items will fall off." or "不会额外掉落食物。", data = 1 }
        },
        default = 0.7
    },
    {
        name = "portable_chef_pouch",
        label = L and "portable chef pouch" or "便携厨师袋",
        hover = L and "The Chef Pouch can now be taken in his inventory[from UM]" or
            "厨师袋现在可以随身携带了而不再是背包！[来自UM]",
        options =
        {
            { description = L and "Enable" or "开启", data = true },
            { description = L and "Disable" or "关闭", data = false }
        },
        default = true
    },
    -- {
    --     name = "warly_action",
    --     label = L and "more actions" or "更多动作",
    --     hover = L and "1.warly can use the razor to split meat into smaller pieces. 2.seasoning by using Seasoning Station to get more spices." or
    --         "1.沃利可以使用剃刀将肉分割成更多的小肉，2.使用香料站可研磨获得更多香料",
    --     options =
    --     {
    --         { description = L and "Enable" or "开启", data = true },
    --         { description = L and "Disable" or "关闭", data = false }
    --     },
    --     default = true
    -- },
    {
        name = "food_damage_mult",
        label = L and "“food” damage mult" or "高效“食”战",
        hover = L and "Warly knows how to use his “food equipment”(and two Terror equipments”) to fight!" or
            "沃利知道怎么使用他的“食物装备”(以及克眼的两个装备）去战斗！",
        options =
        {
            {
                description = "20%",
                hover = L and "Increases Damage by 20%,\nPer equipment of perishable"
                    or "每穿戴一件有新鲜度的装备，伤害增加20%",
                data = 0.2
            },
            {
                description = "15%",
                hover = L and "Increases Damage by 15%,\nPer equipment of perishable"
                    or "每穿戴一件有新鲜度的装备，伤害增加15%",
                data = 0.15
            },
            {
                description = "10%",
                hover = L and "Increases Damage by 10%,\nPer equipment of perishable"
                    or "每穿戴一件有新鲜度的装备，伤害增加10%",
                data = 0.1
            },
            {
                description = "5%",
                hover = L and "Increases Damage by 5%,\nPer equipment of perishable"
                    or "每穿戴一件有新鲜度的装备，伤害增加5%",
                data = 0.05
            },
            { description = L and "Disable" or "关闭", data = 0 },
        },
        default = 0
    },
    {
        name = "warly_aligned",
        label = L and "Lunar or Shadow-aligned" or "月亮/暗影阵营抉择",
        hover = L and "Choose aligned and fight!" or
            "选择一方阵营去战斗吧！",
        options =
        {
            {
                description = L and "Lunar Strategist III" or "月亮战略家 III",
                hover = L and "Add +30% of total damage fighting Shadow-aligned creatures"
                    or "与暗影阵营生物战斗时总伤害增加 +30%",
                data = 1.3
            },
            {
                description = L and "Lunar Strategist II" or "月亮战略家 II",
                hover = L and "Add +20% of total damage fighting Shadow-aligned creatures"
                    or "与暗影阵营生物战斗时总伤害增加 +20%",
                data = 1.2
            },
            {
                description = L and "Lunar Strategist I" or "月亮战略家 I",
                hover = L and "Add +10% of total damage fighting Shadow-aligned creatures"
                    or "与暗影阵营生物战斗时总伤害增加 +10%",
                data = 1.1
            },
            {
                description = L and "Disable" or "关闭",
                data = 0
            },
            {
                description = L and "Shadow Guard I" or "暗影守卫 I",
                hover = L and "Add +10% of total damage fighting Lunar-aligned creatures"
                    or "与月亮阵营的生物战斗时总伤害增加 +10%。",
                data = -1.1
            },
            {
                description = L and "Shadow Guard II" or "暗影守卫 II",
                hover = L and "Add +20% of total damage fighting Lunar-aligned creatures"
                    or "与月亮阵营的生物战斗时总伤害增加 +20%。",
                data = -1.2
            },
            {
                description = L and "Shadow Guard III" or "暗影守卫 III",
                hover = L and "Add +30% of total damage fighting Lunar-aligned creatures"
                    or "与月亮阵营的生物战斗时总伤害增加 +30%。",
                data = -1.3
            },
        },
        default = 0
    },
}
