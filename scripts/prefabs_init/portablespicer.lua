--------------------------------------------------------------------------
--[[ portablespicer containers ]]
--------------------------------------------------------------------------
local containers = require("containers")
local params = containers.params
-- local upvaluehelper = require "hook/upvaluehelper"

params.portablespicer.widget.slotbg = { { image = "cook_slot_spice.tex" }, { image = "cook_slot_spice.tex" }}
params.portablespicer.usespecificslotsforitems = false
--
local function itemsfn(container, item, slot)
    return item:HasTag("spice") and not container.inst:HasTag("burnt")
end

params.portablespicer.itemtestfn = itemsfn

function params.portablespicer.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    elseif inst.replica.container ~= nil then
        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
    end
end

function params.portablespicer.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
end

--------------------------------------------------------------------------
--[[ portablespicer rework ]]
--------------------------------------------------------------------------
local spicesbuffs =
{
    -- vallige
    spice_garlic = "buff_playerabsorption",
    spice_sugar  = "buff_workeffectiveness",
    spice_chili  = "buff_attack",
    spice_salt   = "",

    -- mod
    spice_bone = "buff_strong_for_heavy",
    spice_glom = "buff_stronggrip_state",
    spice_shell = "buff_damage_reflection",
}


local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/lid_open")
    end

    if inst.foodtask then
        inst.foodtask:Cancel()
        inst.foodtask = nil
    end
end

-- apply spice buff
local function applyspicebuff(spice, player)
    print("apply spice buff: "..spice)

    -- fx
    player:AddChild(SpawnPrefab("abigail_rising_twinkles_fx"))
    
    -- buff
    if player.components.debuffable then
        player.components.debuffable:AddDebuff(spicesbuffs[spice], spicesbuffs[spice])
    end
end

-- 
local function onclose(inst, doer)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/lid_close")

        local container = inst.components.container
        local items = container:GetAllItems()
        container:RemoveAllItems()
        if #items > 0 then
            local itemmun = 1

            -- cooking
            container.canbeopened = false
            inst.AnimState:PlayAnimation("cooking_loop", true)
            inst.SoundEmitter:KillSound("snd")
            inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/cooking_LP", "snd")

            -- buff
            inst.applybuff = inst:DoPeriodicTask(3,function()
                local x, y, z = inst.Transform:GetWorldPosition()
                local players = TheSim:FindEntities(x, y, z, TUNING.WARLY_CHANGE.PORTABLESPICER_BUFF_RANGE, { "player" , "character" }, {"ghost", "playerghost"})
                local player_num = 0
                for i, v in pairs(players) do
                    if v and v:IsValid() and player_num <= 3 then
                        applyspicebuff(items[itemmun].prefab, v)
                        player_num = player_num + 1                
                    end
                end

                -- items[itemmun]:Remove()
                itemmun = itemmun + 1
                
                inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/cooking_pst")
            end)

            inst:DoTaskInTime(3*#items + FRAMES, function()
                inst.SoundEmitter:KillSound("snd")
                inst.AnimState:PushAnimation("cooking_loop", false)

                container.canbeopened = true

                if inst.applybuff ~= nil then
                    inst.applybuff:Cancel()
                    inst.applybuff = nil
                end
            end)
        end
    end
end

local function getstatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
        or inst.components.container:IsEmpty() and "EMPTY"
        or "COOKING_SHORT"
end

AddPrefabPostInit("portablespicer", function(inst)
    if not TheWorld.ismastersim then return end

    -- remove stewer
    -- if inst.components.stewer then
    --     inst:RemoveComponent("stewer")
    -- end

    -- open/close
    if inst.components.container then
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
        inst.components.container.restrictedtag = "masterchef"
    end

    -- status
    inst.components.inspectable.getstatus = getstatus
end)
