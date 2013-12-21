function toggleDx(origArgs)
	local player = LocalPlayer
	local args = string.split(origArgs.text, " ")
	if (args[1] == "/stickmanhelp") then
		Chat:Print("Correct syntax: /stickman [r, g, b]", Color(255, 83, 0))
	end
	if (args[1] == "/stickman") then
		if (tonumber(args[2]) and tonumber(args[3]) and tonumber(args[4])) then
			theColor = Color(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
		end
		if (not isDxEnabled) then
			Chat:Print("stickman mode enabled!", Color(0, 255, 0))
			isDxEnabled = true
		else
			Chat:Print("stickman mode disabled!", Color(0, 255, 0))
			isDxEnabled = false
		end
	end
end
Events:Subscribe("LocalPlayerChat", toggleDx)

function addLineAboveHead()
	if (isDxEnabled) then
		local pos = LocalPlayer:GetBonePosition("ragdoll_LeftArm") 
		-- Arms
			-- Left arm
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_LeftArm"), LocalPlayer:GetBonePosition("ragdoll_LeftForeArm"), theColor) -- Shoulder -> elbow
				--Render:DrawLine(LocalPlayer:GetBonePosition -- elbow -> hand ??
			--
			-- Right arm
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_RightArm"), LocalPlayer:GetBonePosition("ragdoll_RightForeArm"), theColor) -- Shoulder -> elbow
				-- Render:DrawLine(LocalPlayer:GetBonePosition -- elbow -> hand ?
			-- Connect arms
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_LeftArm"), LocalPlayer:GetBonePosition("ragdoll_RightArm"), theColor)
			--
		--
		-- Head & Spine & hips
			-- Head
				Render:FillCircle(LocalPlayer:GetBonePosition("ragdoll_Head"), 0.1, theColor) -- Draw a circle for the head
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_Head"), LocalPlayer:GetBonePosition("ragdoll_Spine1"), theColor) -- Head -> mid-spine
			--
			-- Spine
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_Spine1"), LocalPlayer:GetBonePosition("ragdoll_Spine"), theColor) -- mid-spine -> lower spine
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_Spine"), LocalPlayer:GetBonePosition("ragdoll_Hips"), theColor) -- lower spine -> hips
			--
			-- Hips & Upper legs
			Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_Hips"), LocalPlayer:GetBonePosition("ragdoll_LeftUpLeg"), theColor) -- hips -> upper left leg
			Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_Hips"), LocalPlayer:GetBonePosition("ragdoll_RightUpLeg"), theColor) -- hips -> upper right leg
			--
		--
		-- Legs
			-- Left leg
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_LeftUpLeg"), LocalPlayer:GetBonePosition("ragdoll_LeftLeg"), theColor) -- upper left leg -> left knee
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_LeftLeg"), LocalPlayer:GetBonePosition("ragdoll_LeftFoot"), theColor) -- left knee -> left ankle
			--
			-- Right leg
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_RightUpLeg"), LocalPlayer:GetBonePosition("ragdoll_RightLeg"), theColor) -- upper right leg -> right knee
				Render:DrawLine(LocalPlayer:GetBonePosition("ragdoll_RightLeg"), LocalPlayer:GetBonePosition("ragdoll_RightFoot"), theColor) -- right knee -> right ankle
			--
		--
	end
end
Events:Subscribe("Render", addLineAboveHead)