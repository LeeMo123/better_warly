-- if GLOBAL.KnownModIndex:IsModEnabled("workshop-2039181790") then
--     local TUNING.WARLY_CHANGE.monster_meats_table = {"monstermeat", "cookedmonstermeat", "monstermeat_dried"}
--     local smallmonster_meats_table = {"monstersmallmeat", "cookedmonstersmallmeat", "monstersmallmeat_dried"}
    
--     for _, monster_meat in pairs(TUNING.WARLY_CHANGE.TUNING.WARLY_CHANGE.monster_meats_table) do
--         table.insert(TUNING.WARLY_CHANGE.meats_table, monster_meat)
--     end

--     for _, monster_smallmeat in pairs(smallmonster_meats_table) do
--         table.insert(smallmeat_table, monster_smallmeat)
--     end

--     nummaxguarou_table = { 2, 2, 2, 2, 2, 1, 1 ,2 ,2, 2}
-- end

-- 移除物品
local function removeItem(item,num)
	if item.components.stackable then
		item.components.stackable:Get(num):Remove()
	else
		item:Remove()
	end
end

-- 添加一个用于发射物品的函数
local DEGREES = math.pi/180
local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

-- 添加一个用于更新伤害的函数
local function UpdateDamage(inst)
    if inst.components.perishable and inst.components.weapon then
        local dmg = TUNING.HAMBAT_DAMAGE * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, 0, TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_MIN_DAMAGE_MODIFIER*TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_DAMAGE)
        inst.components.weapon:SetDamage(dmg)
    end
end

local warly_actions =
{
    {
		id = "TIAOWEI",--调味
		str = STRINGS.ACTIONS.SPICE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("masterchef") and act.invobject ~= nil and act.invobject:HasTag("spice") and act.target:HasTag("preparedfood") and not act.target:HasTag("spicedfood") then
				local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil
				local container = nil--目标料理所在容器组件
				if owner then
					container = owner.components.inventory or owner.components.container
				end
				
				local newfood = SpawnPrefab(act.target.prefab.."_"..act.invobject.prefab)
				local perishablePercent = nil
                local x, y, z = act.doer.Transform:GetWorldPosition()
                local pos = Vector3(x, y, z)
				if act.target.components.perishable then
					perishablePercent=act.target.components.perishable:GetPercent()
				end
				if newfood then
					removeItem(act.invobject)
					removeItem(act.target)
					if newfood.components.perishable and perishablePercent ~= nil then
						newfood.components.perishable:SetPercent(perishablePercent)
					end
					if not (container and container:GiveItem(newfood)) then
						act.doer.components.inventory:GiveItem(newfood, nil, pos)
					end
                    act.doer.SoundEmitter:PlaySound("dontstarve/HUD/repair_clothing")
				end
				return true
			end
		end,
		state = "domediumaction",
		actiondata = {
            priority = 10, --99999,
			mount_valid=true,
		},
		canqueuer = "rightclick",   --兼容排队论
    },
    {
        id = "GUAROU", --刮肉
        str = STRINGS.CHARACTERS.WARLY.DESCRIBE.DECIDUOUSTREE.CHOPPED:gsub("[！!]", ""),
        fn = function(act)
            if act.doer ~= nil and act.invobject ~= nil and act.doer:HasTag("masterchef") and act.invobject.prefab == "razor" then
                local info = TUNING.WARLY_CHANGE.meats_table[act.target.prefab]
                if info and info[2] > 0 then
                    local x, y, z = act.doer.Transform:GetWorldPosition()
                    local pos = Vector3(x, y, z)
                    local SetMeatPerish = math.min(1, act.target.components.perishable:GetPercent() + 0.2)
        
                    for i = 1, info[2] do
                        local smallmeat = SpawnPrefab(info[1])
                        smallmeat.components.perishable:SetPercent(SetMeatPerish)
                        act.doer.components.inventory:GiveItem(smallmeat, nil, pos)
                    end
        
                    if math.random() > 0.5 then
                        local boneshard = SpawnPrefab("boneshard")
                        act.doer.components.inventory:GiveItem(boneshard, nil, pos)
                    end
        
                    removeItem(act.target)
                    act.doer.SoundEmitter:PlaySound("dontstarve/common/plant")
                end
                return true
            end
        end,
        state = "domediumaction",
        actiondata = {
            priority = -10, --99999,
            mount_valid = true,
        },
		canqueuer = "allclick",--兼容排队论
    },
    {
		id = "YANMO",--研磨
		str = STRINGS.ACTIONS.GIVE.GENERIC, -- "给予"
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("masterchef") and act.invobject ~= nil and act.invobject:HasTag("spicematerials")
               and act.target ~= nil and act.target.prefab =="portableblender" then

                -- 有概率获得额外的香料
                local base_stack = act.invobject and (act.invobject.components.stackable and act.invobject.components.stackable.stacksize) or math.random(2,4)
                
                local bonus_chance = 0.3
                local bonus_multiplier = math.random(1.5, 2.5)
                
                local stack
                if math.random() < bonus_chance then
                    stack = math.floor(base_stack * bonus_multiplier)
                else
                    stack = base_stack
                end
                
                stack = math.max(stack, 1)                
                
                local x, y, z = act.target.Transform:GetWorldPosition()  y = 1.6
                local angle

                if act.doer ~= nil and act.doer:IsValid() then
                    angle = 180 - act.doer:GetAngleToPoint(x, 0, z)
                else
                    local down = TheCamera:GetDownVec()
                    angle = math.atan2(down.z, down.x) / DEGREES
                    act.doer = nil
                end

                act.invobject:Remove()

                act.target:DoTaskInTime(0.4, function ()
                    for k = 1, stack do
                        local spice = SpawnPrefab(TUNING.SPICEMPREFAB[table.reverselookup(TUNING.SPICEMATERIALS, act.invobject.prefab)])
                        spice.Transform:SetPosition(x, y, z)
                        launchitem(spice, angle)
                        -- 研磨完后移除该物品
                    end
                end)

                act.target.AnimState:PlayAnimation("use")
                act.target.AnimState:PushAnimation("idle", false)
                act.target.SoundEmitter:PlaySound("dontstarve/common/together/portable/blender/use")
				return true
			end
		end,
        state = "give",
		actiondata = {
            priority = 10, --99999,
			mount_valid=true,
		},
		canqueuer = "allclick",--兼容排队论
    },
    {
        id = "REMEAT", --修补肉块  修复大肉棒
        str = STRINGS.ACTIONS.APPLYCONSTRUCTION.REPAIR,
        fn = function(act)
            if act.doer ~= nil and act.invobject:HasTag("remeat") and act.target.prefab == "hambat" then
                -- 修复
                act.target.components.perishable:SetPercent(math.min(1, act.target.components.perishable:GetPercent() + 0.5))
                act.doer.SoundEmitter:PlaySound("dontstarve/HUD/repair_clothing")
                -- 移除物品
                removeItem(act.invobject)
                -- 更新伤害
                UpdateDamage(act.target)
            end
            return true
        end,
        state = "dolongaction",
        actiondata = {
            priority = -10, --99999,
            mount_valid = true,
        },
		canqueuer = "allclick",--兼容排队论
    },
}

--动作与组件绑定
local component_actions  = {
    {
        type = "USEITEM",
        component = "inventoryitem",
        tests = {
			{
				action = "TIAOWEI",--调味
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("masterchef") and inst:HasTag("spice") and target:HasTag("preparedfood") and not target:HasTag("spicedfood") and right
				end,
			},
            {
                action = "GUAROU", --刮肉
                testfn = function(inst, doer, target, actions, right)
                    return inst.prefab == 'razor' and doer:HasTag('masterchef') and TUNING.WARLY_CHANGE.meats_table[target.prefab]
                end,
            },
            {
                action = "YANMO", --研磨
                testfn = function(inst, doer, target, actions, right)
                    return inst:HasTag("spicematerials") and doer:HasTag('masterchef') and
                        target.prefab == "portableblender"
                end,
            },
            {
                action = "REMEAT", --修补肉块 修复大肉棒
                testfn = function(inst, doer, target, actions, right)
                    return inst:HasTag("remeat") and target.prefab == "hambat"
                end,
            },
        }
    }
}

return {
	actions = warly_actions,
	component_actions = component_actions
}
