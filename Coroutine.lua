local util = require "xlua/util"

local gameobject = DRCSRef.FindGameObj("UIBase")
local cs_coroutine_runner = gameobject:GetComponent("LuaBehaviour")

CS_Coroutine = {}


CS_Coroutine.start = function(func, ...)
	local fun = function() xpcall(function(...) func(...) end,xpcallTraceback) end
	return cs_coroutine_runner:StartCoroutine(util.cs_generator(fun))
end;
	
CS_Coroutine.stop = function(coroutine)
	 cs_coroutine_runner:StopCoroutine(coroutine)
end;	
	
return CS_Coroutine