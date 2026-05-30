AddStategraphPostInit("wilson", function(sg)
    -- 攻速加快
    local old_onenter = sg.states.attack.onenter
    if old_onenter ~= nil then
        sg.states.attack.onenter = function(inst)
            old_onenter(inst)
            
			if not inst:HasTag("fasterattack") then
				return
			end
			local attack_speed = inst.attack_stacks and ( inst.attack_stacks >= 13 and 2*FRAMES or FRAMES ) or 0
			if attack_speed ~= 0 then
				inst.sg:SetTimeout(inst.sg.timeout - attack_speed)
			end
        end
    end

    -- 搬重物不掉速
    if sg.states.run_start then
		local oldonenter = sg.states.run_start.onenter
		sg.states.run_start.onenter = function(inst, ...)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("strong_for_heavy") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pre")
				inst.sg.mem.footsteps = 0--(inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
	if sg.states.run then
		local oldonenter = sg.states.run.onenter
		sg.states.run.onenter = function(inst, ...)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("strong_for_heavy") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				if not inst.AnimState:IsCurrentAnimation("heavy_walk_fast") then
					inst.AnimState:PlayAnimation("heavy_walk_fast", true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
	if sg.states.run_stop then
		local oldonenter = sg.states.run_stop.onenter
		sg.states.run_stop.onenter = function(inst, ...)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("strong_for_heavy") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pst")
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
end)
