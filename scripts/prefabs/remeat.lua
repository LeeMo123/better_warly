local Assets =
{
    Asset("ANIM", "anim/remeat.zip"),  --地上的动画
	Asset("ATLAS", "images/inventoryimages/remeat.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/remeat.tex"),
}

local function oneaten(inst, owner)
	if owner.components.talker ~= nil and owner:HasTag("Player") and not owner:HasTag("mime") then
		owner.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_EAT.SPOILED)
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)
	inst.AnimState:SetBank("remeat")
	inst.AnimState:SetBuild("remeat")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("remeat")
	inst:AddTag("meat")

	MakeInventoryFloatable(inst, "med", nil, 1.0)
	
	if not TheNet:GetIsServer() then
        return inst
    end
	
	inst.entity:SetPristine()
	
	inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.SPOILED_HEALTH
    inst.components.edible.hungervalue = TUNING.SPOILED_HUNGER
	-- inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible:SetOnEatenFn(oneaten)
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/remeat.xml"
	inst.components.inventoryitem.imagename = "remeat"
		
	MakeHauntableLaunch(inst)
	
	return inst
end


return Prefab( "remeat", fn, Assets )