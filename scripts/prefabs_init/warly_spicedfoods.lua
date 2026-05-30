require("tuning")

local spicedfoods = {}

local function oneaten_spice_bone(inst, eater)
    eater:AddDebuff("buff_strong_for_heavy", "buff_strong_for_heavy")
end

local function oneaten_spice_glom(inst, eater)
    eater:AddDebuff("buff_stronggrip_state", "buff_stronggrip_state")
end

local function oneaten_spice_shell(inst, eater)
    eater:AddDebuff("buff_damage_reflection", "buff_damage_reflection")
end

local SPICES =
{
    SPICE_BONE = { oneatenfn = oneaten_spice_bone, prefabs = { "buff_strong_for_heavy" } },
    SPICE_GLOM = { oneatenfn = oneaten_spice_glom, prefabs = { "buff_stronggrip_state" } },
    SPICE_SHELL = { oneatenfn = oneaten_spice_shell, prefabs = { "buff_damage_reflection" } },
    -- SPICE_SALT = { }
}

local function GenerateSpicedFoods(foods)
    for foodname, fooddata in pairs(foods) do
        for spicenameupper, spicedata in pairs(SPICES) do
            local newdata = shallowcopy(fooddata)
            local spicename = string.lower(spicenameupper)
            if foodname == "wetgoop" then
                newdata.test = function(cooker, names, tags) return names[spicename] end
                newdata.priority = -10
            else
                newdata.test = function(cooker, names, tags) return names[foodname] and names[spicename] end
                newdata.priority = 100
            end
            newdata.cooktime = .12
            newdata.stacksize = nil
            newdata.spice = spicenameupper
            newdata.basename = foodname
            newdata.name = foodname.."_"..spicename
            newdata.floater = {"med", nil, {0.85, 0.7, 0.85}}
			newdata.official = true
			newdata.cookbook_category = fooddata.cookbook_category ~= nil and ("spiced_"..fooddata.cookbook_category) or nil
            spicedfoods[newdata.name] = newdata

            if spicename == "spice_chili" then
                if newdata.temperature == nil then
                    --Add permanent "heat" to regular food
                    newdata.temperature = TUNING.HOT_FOOD_BONUS_TEMP
                    newdata.temperatureduration = TUNING.FOOD_TEMP_LONG
                    newdata.nochill = true
                elseif newdata.temperature > 0 then
                    --Upgarde "hot" food to permanent heat
                    newdata.temperatureduration = math.max(newdata.temperatureduration, TUNING.FOOD_TEMP_LONG)
                    newdata.nochill = true
                end
            -- elseif spicename == "spice_salt" then
            --     print("测试1")
            --     if newdata.perishtime then
            --         print("data name:", newdata.name)
            --         print("data perishtime:", newdata.perishtime)
            --         newdata.perishtime = newdata.perishtime * 1.5
            --         print("data perishtime:", newdata.perishtime)
            --     end
            end

            if spicedata.prefabs ~= nil then
                --make a copy (via ArrayUnion) if there are dependencies from the original food
                newdata.prefabs = newdata.prefabs ~= nil and ArrayUnion(newdata.prefabs, spicedata.prefabs) or spicedata.prefabs
            end

            if spicedata.oneatenfn ~= nil then
                if newdata.oneatenfn ~= nil then
                    local oneatenfn_old = newdata.oneatenfn
                    newdata.oneatenfn = function(inst, eater)
                        spicedata.oneatenfn(inst, eater)
                        oneatenfn_old(inst, eater)
                    end
                else
                    newdata.oneatenfn = spicedata.oneatenfn
                end
            end
        end
    end
end

GenerateSpicedFoods(require("preparedfoods"))
GenerateSpicedFoods(require("preparedfoods_warly"))

for _, recipe in pairs(spicedfoods) do
    AddCookerRecipe("portablespicer", recipe)
end

return spicedfoods
