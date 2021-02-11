if not CustomArchetype then
	CustomArchetype = {}
	
	local MakeCheck=function(setcodes,archtable,extrafuncs)
		return function(c,sc,sumtype,playerid)
			sumtype=sumtype or 0
			playerid=playerid or PLAYER_NONE
			if extrafuncs then
				for _,func in pairs(extrafuncs) do
					if Card[func](c,sc,sumtype,playerid) then return true end
				end
			end
			if setcodes then
				for _,setcode in pairs(setcodes) do
					if c:IsSetCard(setcode,sc,sumtype,playerid) then return true end
				end
			end
			if archtable then
				if c:IsSummonCode(sc,sumtype,playerid,table.unpack(archtable)) then return true end
			end
			return false
		end
	end
	AnimeArchetype.OCGAncient={
	93221206,50781944,26304459,10532969,
	6849042,38520918,25862681,25958491,
	11830996,71039903,4179255
	}
	Card.IsAncient=MakeCheck({0x700},AnimeArchetype.OCGAncient)
	--Ancient Elf;Ancient Crimson Ape;Ancient Flamvell Deity;Hyper-Ancient Shark Megalodon
	--Super-Ancient Dinobeast;Ancient Dragon;Ancient Fairy Dragon;Ancient Sacred Wyvern
	-- Ancient Leaf;The White Stone of Ancients;Ancient Pixie Dragon
end