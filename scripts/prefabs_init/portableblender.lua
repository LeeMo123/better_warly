local AllRecipes = GLOBAL.AllRecipes

-- 香料原料表
TUNING.SPICEMATERIALS = {}
TUNING.SPICEMPREFAB = {}

-- 将调料从研磨器制作改成可以直接制作
-- 为什么要这么写？是为了兼容其他mod（希望吧）
for i, recipe in pairs(AllRecipes) do
    if recipe.builder_tag == "professionalchef" then
        table.insert(TUNING.SPICEMPREFAB, recipe.name)
        -- 检查 ingredients 的每个成分
        if recipe.ingredients then
            for _, ingredient in ipairs(recipe.ingredients) do
                if ingredient.type then
                    table.insert(TUNING.SPICEMATERIALS, ingredient.type)
                end
            end
        end
    end
end

-- 打印结果
print("SPICEMPREFAB:", table.concat(TUNING.SPICEMPREFAB, ", "))
print("SPICEMATERIALS:", table.concat(TUNING.SPICEMATERIALS, ", "))
-- 给香料原料加一个tag
for _, prefab in pairs(TUNING.SPICEMATERIALS) do
    AddPrefabPostInit(prefab,function (inst)
        inst:AddTag("spicematerials")
    end)
end