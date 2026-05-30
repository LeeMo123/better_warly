local seedpacket_loots = {
    -- 设置所有种子权重为1（等概率）
    potato_seeds = 1,       -- 土豆
    asparagus_seeds = 1,    -- 芦笋
    dragonfruit_seeds = 1,  -- 火龙果
    garlic_seeds = 1,       -- 大蒜
    onion_seeds = 1,        -- 洋葱
    pepper_seeds = 1,       -- 辣椒
    pomegranate_seeds = 1,  -- 石榴
}

local yotc_seedpacket = {
    common_postinit = function(inst, setupdata)
        MakeInventoryFloatable(inst, "small")
    end,

    master_postinit = function(inst, setupdata)
        inst.components.inventoryitem:SetSinks(false)
    end,

    lootfn = function(inst, doer)
        local loots = {}
        
        -- 生成6个随机种子（允许重复）
        for i = 1, 3 do
            table.insert(loots, weighted_random_choice(seedpacket_loots))
        end

        return loots
    end,
    -- lootfn = function(inst, doer)
    --     local loots = {}
    --     local temp_loots = shallowcopy(seedpacket_loots)  -- 需要先实现浅拷贝函数
        
    --     for i = 1, 4 do
    --         if next(temp_loots) == nil then break end  -- 防止空表
    --         local chosen = weighted_random_choice(temp_loots)
    --         table.insert(loots, chosen)
    --         temp_loots[chosen] = nil  -- 移除已选中的选项
    --     end
        
    --     return loots
    -- end
}

local function onburnt(inst)
    inst.burnt = true
    inst.components.unwrappable:Unwrap()
end

local function onignite(inst)
    inst.components.unwrappable.canbeunwrapped = false
end

local function onextinguish(inst)
    inst.components.unwrappable.canbeunwrapped = true
end

local function MakeBundle(name, onesize, variations, loot, tossloot, setupdata, bank, build, inventoryimage)
    local assets =
    {
        Asset("ANIM", "anim/"..(inventoryimage or name)..".zip"),
    }

    if variations ~= nil then
        for i = 1, variations do
            if onesize then
                table.insert(assets, Asset("INV_IMAGE", (inventoryimage or name)..tostring(i)))
            else
                table.insert(assets, Asset("INV_IMAGE", (inventoryimage or name).."_small"..tostring(i)))
                table.insert(assets, Asset("INV_IMAGE", (inventoryimage or name).."_medium"..tostring(i)))
                table.insert(assets, Asset("INV_IMAGE", (inventoryimage or name).."_large"..tostring(i)))
            end
        end
    elseif not onesize then
        table.insert(assets, Asset("INV_IMAGE", (inventoryimage or name).."_small"))
        table.insert(assets, Asset("INV_IMAGE", (inventoryimage or name).."_medium"))
        table.insert(assets, Asset("INV_IMAGE", (inventoryimage or name).."_large"))
    end

    local prefabs =
    {
        "ash",
        "yotc_seedpacket_unwrap",
    }

    if loot ~= nil then
        for _, v in ipairs(loot) do
            table.insert(prefabs, v)
        end
    end

    local function UpdateInventoryImage(inst)
        local suffix = inst.suffix or "_small"
        if variations ~= nil then
            inst.variation = inst.variation or math.random(variations)
            local variation_string = tostring(inst.variation)

            suffix = (onesize and variation_string) or suffix..variation_string

            inst.components.inventoryitem:ChangeImageName((inst:GetSkinName() or name)..suffix)
        elseif not onesize then
            inst.components.inventoryitem:ChangeImageName((inst:GetSkinName() or name)..suffix)
        end
    end


    local function OnWrapped(inst, num, doer)
        local suffix =
            (onesize and "_onesize") or
            (num > 3 and "_large") or
            (num > 1 and "_medium") or
            "_small"

        inst.suffix = suffix

        UpdateInventoryImage(inst)

        if inst.variation then
            suffix = suffix..tostring(inst.variation)
        end
        inst.AnimState:PlayAnimation("idle"..suffix)
        inst.scrapbook_anim = "idle"..suffix

        if doer ~= nil and doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound(inst.skin_wrap_sound or "dontstarve/common/together/packaged")
        end
    end

    local function OnUnwrapped(inst, pos, doer)
        if inst.burnt then
            SpawnPrefab("ash").Transform:SetPosition(pos:Get())
        else
            local loottable = (setupdata ~= nil and setupdata.lootfn ~= nil) and setupdata.lootfn(inst, doer) or loot
            if loottable ~= nil then
                local moisture = inst.components.inventoryitem:GetMoisture()
                local iswet = inst.components.inventoryitem:IsWet()
                for i, v in ipairs(loottable) do
                    local item = SpawnPrefab(v)
                    if item ~= nil then
                        if item.Physics ~= nil then
                            item.Physics:Teleport(pos:Get())
                        else
                            item.Transform:SetPosition(pos:Get())
                        end
                        if item.components.inventoryitem ~= nil then
                            item.components.inventoryitem:InheritMoisture(moisture, iswet)
                            if tossloot then
                                item.components.inventoryitem:OnDropped(true, .5)
                            end
                        end
                    end
                end
            end
            SpawnPrefab("yotc_seedpacket_unwrap").Transform:SetPosition(pos:Get())
        end
        if doer ~= nil and doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound(inst.skin_wrap_sound or "dontstarve/common/together/packaged")
        end
        inst:Remove()
    end

    local OnSave = variations ~= nil and function(inst, data)
        data.variation = inst.variation
    end or nil

    local OnPreLoad = variations ~= nil and function(inst, data)
        if data ~= nil then
            inst.variation = data.variation
        end
    end or nil

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(bank or name)
        inst.AnimState:SetBuild(build or name)
        inst.AnimState:PlayAnimation(
            variations ~= nil and
            (onesize and "idle_onesize1" or "idle_large1") or
            (onesize and "idle_onesize" or "idle_large")
        )
        inst.scrapbook_anim = variations ~= nil and
            (onesize and "idle_onesize1" or "idle_large1") or
            (onesize and "idle_onesize" or "idle_large")

        inst:AddTag("bundle")

        --unwrappable (from unwrappable component) added to pristine state for optimization
        inst:AddTag("unwrappable")

        if setupdata ~= nil and setupdata.common_postinit ~= nil then
            setupdata.common_postinit(inst, setupdata)
        end

        inst.scrapbook_specialinfo = "BUNDLE"

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetSinks(true)

        if inventoryimage then
            inst.components.inventoryitem:ChangeImageName(inventoryimage)
        end

        if variations ~= nil or not onesize then
            inst.components.inventoryitem:ChangeImageName(
                name..
                (variations == nil and "_large" or (onesize and "1" or "_large1"))
            )
        end

        inst:AddComponent("unwrappable")
        inst.components.unwrappable:SetOnWrappedFn(OnWrapped)
        inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
        inst.UpdateInventoryImage = UpdateInventoryImage

        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
        inst.components.propagator.flashpoint = 10 + math.random() * 5
        inst.components.burnable:SetOnBurntFn(onburnt)
        inst.components.burnable:SetOnIgniteFn(onignite)
        inst.components.burnable:SetOnExtinguishFn(onextinguish)

        MakeHauntableLaunchAndIgnite(inst)

        if setupdata ~= nil and setupdata.master_postinit ~= nil then
            setupdata.master_postinit(inst, setupdata)
        end

        inst.OnSave = OnSave
        inst.OnPreLoad = OnPreLoad

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeBundle("warly_seedpacket", true, nil, nil, true, yotc_seedpacket, "yotc_seedpacket", "yotc_seedpacket", "yotc_seedpacket")