																																--[[
---------------------------------------------------
			-- >> DOCUMENTATION << --
---------------------------------------------------

		(Raw Functions | Bypass Hooking API)
			:: rawget
			- Instance [Inst]
			- Property [Str]

			:: rawset
				- Instance [Inst]
				- Property [Str]
				- Value [ALL]

			:: rawcall
				- Instance [Inst]
				- Arguments [Var Args]
				- Method [Str]

		(API Functions)
			:: get (Get Hook Table)
				- Instance [Inst]
					ClassName [Str]
					Method [Func]
				- Property [Str] (Optional)

		 :: set (Create Hook)
			 - Instance [Inst]
				 ClassName [Str]
				 Method [Func]
			 - Property [Str]
				 PropertyList [Array]
				 MethodHook [Func]
			 - HookFunction [Func] (Inst, Func, ... *Args*)

		 :: toggle (Hook Enabled)
			 - Instance [Inst]
				 ClassName [Str]
				 Method [Func]
			 - Property [Str]
			 	 PropertyList [Array]
			 - Debounce [Bool]

		 :: setwrite	(Write to Property)
			 - Instance [Inst]
				 ClassName [Str]
			 - Property [Str]
				 PropertyList [Array]
			 - Debounce [Bool]

-----------------------------------------------
		      ---- >>> END <<< ----
-----------------------------------------------
			 																														 ]]
local newcclosure = newcclosure or (function(f) return f end)
local getnamecallmethod = getnamecallmethod or get_namecall_method
local getrawmetatable = getrawmetatable or debug.getrawmetatable
local setreadonly = function(t, b)
	if setreadonly then 
		setreadonly(t, b)
	elseif make_writable then
		make_writable(t, not b)
	elseif fullaccess then
		fullaccess(t, not b)
	end
end

if not getrawmetatable then
	return 'Methods not available.'
end

local Metatable   = getrawmetatable(game);
local MetatableIndex  = Metatable.__index;
local MetatableCall   = Metatable.__namecall;
local MetatableNew    = Metatable.__newindex;
local IsA             = game.IsA

local CanWrite = true;
local deb, Hooks = {},{
	Globals = {};
	Funcs = {};
	Insts = {}
}

local function Get(i)
  local Type = typeof(i);
	return (
    ((Type == 'string') and 'Globals') or
		((Type == 'function') and 'Funcs') or
		((Type == 'Instance') and 'Insts')
	)
end

local function Check(t, ...)
	local Args, Ret = {...}
	local Recurse do
		function Recurse(r, i)
			if not Args[i] then return Ret end
			if not r[Args[i]] then
				r[Args[i]] = setmetatable({}, {
					__newindex = function(s, i, v)
						if (i == 1) and (typeof(v) == 'function') then
							rawset(s, i, newcclosure(v))
						else
							rawset(s, i, v)
						end
					end
				})
			end

      Ret = r[Args[i]]
      return Recurse(Ret, i + 1)
		end
	end

  return Recurse(t, 1)
end

deb.get = newcclosure(function(Index, Property)
  local Act = Get(Index)
  if not Act then return end

	local Target = Hooks[Act]
  if (Act == 'Globals') or (Act == 'Insts') then
    if not (Property) then
	    return Check(Target, Index)
    else
      return Check(Target, Index, Property)
    end
	elseif (Act == 'Funcs') then
		return Check(Hooks.Funcs, Index)
	end
end)

deb.set = newcclosure(function(Index, Props, Func)
  local Action, Act = typeof(Props), Get(Index)
  if not Act then return end

	if ((Act == 'Globals') or (Act == 'Insts')) and (Action == 'table') then
		for __, Property in next, (Props) do
      local Old = deb.get(Index, Property)
			Old[1] = (function() 
				if typeof(Func) == 'function' then
					return Func
				else
					return function() return Func end
				end
			end)()
		end
	elseif (Action == 'string') then
		local Old = deb.get(Index, Props)
		Old[1] = (function() 
			if typeof(Func) == 'function' then
				return Func
			else
				return function() return Func end
			end
		end)()
	elseif (Act == 'Funcs') then
		local Old = deb.get(Index)
		Old[1] = Props
	end
end)

deb.toggle = newcclosure(function(Index, ...)
	local Args, Act = {...}, Get(Index)
	local Action = typeof(Args[1])
  if not Act then return end

	if ((Act == 'Globals') or (Act == 'Insts')) and (#Args > 1) and (Action == 'table') then
			for __, Property in next, (Args[1]) do
	      local Old = deb.get(Index, Property)
				Old[2] = not Args[2]
			end
	elseif ((Act == 'Globals') or (Act == 'Insts') or (Act == 'Funcs')) and (#Args == 1) then
		local Old = deb.get(Index)
		Old.MainToggle = not Args[1]
	elseif (Action == 'string') and (#Args > 1) then
		local Old = deb.get(Index, Args[1])
		Old[2] = not Args[2]
	end
end)

deb.rawget = newcclosure(function(...)
	return MetatableIndex(...)
end)

deb.rawset = newcclosure(function(...)
	MetatableNew(...)
end)

deb.rawcall = newcclosure(function(...)
	return MetatableCall(...)
end)

deb.setwrite = newcclosure(function(Index, ...)
	local Args, Act = {...}, Get(Index)
	local Action = typeof(Args[1])
  if not Act then return end

	if ((Act == 'Globals') or (Act == 'Insts')) and (#Args > 1) and (Action == 'table') then
			for __, Property in next, (Args[1]) do
	      local Old = deb.get(Index, Property)
				Old[3] = not Args[2]
			end
	elseif ((Act == 'Globals') or (Act == 'Insts') or (Act == 'Funcs')) and (#Args == 1) then
		local Old = deb.get(Index)
		Old.MainWrite = not Args[1]
	elseif (Action == 'string') and (#Args > 1) then
		local Old = deb.get(Index, Args[1])
		Old[3] = not Args[2]
	end
end)

local function PropertyHook(Return, Obj, Index)
  local IndexName = tostring(Index)
  if (IndexName == 'MainToggle') or (IndexName == 'MainWrite') then
    return Return
  end

  local InstHook = Hooks.Insts[Obj]
  if InstHook and not InstHook.MainToggle then
    local Prop = InstHook[IndexName]
    if Prop and Prop[1] and not Prop[2] then
      return Prop[1](Obj, Return)
    end
  end

  for Class, Hook in next, (Hooks.Globals) do
    if IsA(Obj, Class) and not Hook.MainToggle then
      local ClassHook = Hook[IndexName]
      if ClassHook and ClassHook[1] and not ClassHook[2] then
        return ClassHook[1](Obj, Return)
      end
    end
  end

  return Return
end

local function MethodHook(Obj, ...)
  local Args = {...};
  local Method = getnamecallmethod();
  local IsIndex = (type(Obj) == 'table')
  if IsIndex then
    Obj = table.remove(Obj)
    Method = Args[1]
  end

  local MethodFunc = MetatableIndex(Obj, Method)
  if (Method == 'MainToggle') or (Method == 'MainWrite') then
    return MetatableCall(Obj, ...)
  end

  local FuncHook = Hooks.Funcs[MethodFunc]
  if FuncHook and FuncHook[1] and not FuncHook[2] then
    return (IsIndex and FuncHook[1]) or FuncHook[1](Obj, MethodFunc, unpack(Args))
  end

  local InstHook = Hooks.Insts[Obj]
  if InstHook and not InstHook.MainToggle then
    local Prop = InstHook[Method]
    if Prop and Prop[1] and not Prop[2] then
      return (IsIndex and Prop[1]) or Prop[1](Obj, unpack(Args))
    end
  end

  for Class, Hook in next, (Hooks.Globals) do
   if IsA(Obj, Class) and not Hook.MainToggle then
     local ClassHook = Hook[IndexName]
     if ClassHook and ClassHook[1] and not ClassHook[2] then
       return (IsIndex and ClassHook[1]) or ClassHook[1](Obj, unpack(Args))
     end
   end
  end

  if IsIndex then
    return MetatableIndex(Obj, ...)
  else
    return MetatableCall(Obj, ...)
  end
end

setreadonly(Metatable, false)
----- NAMECALL -----
Metatable.__namecall = newcclosure(MethodHook)

----- INDEX -----
Metatable.__index = newcclosure(function(Parent, Index)
  local Return = MetatableIndex(Parent, Index);
  local Category = (type(Return) == 'function')
  if Category then
    return MethodHook({Parent}, Index)
  end

  return PropertyHook(Return, Parent, Index)
end)

----- NEWINDEX -----
Metatable.__newindex = newcclosure(function(Obj, Index, Value)
  local Return =  (((Index == 'OnClientInvoke') or (Index == 'OnInvoke')) and Index) or (MetatableIndex(Obj, Index));
  if (typeof(Return) ~= typeof(Value)) and (Return ~= Index) then
	return MetatableNew(Obj, Index, Value)
  end

	local InstHook = Hooks.Insts[Obj]
  if InstHook then
    local Prop = InstHook[Index]
    if InstHook.MainWrite or (Prop and Prop[3]) then
      return
    end
  end

  for Class, Hook in next, (Hooks.Globals) do
    if IsA(Obj, Class) then
      local ClassHook = Hook[Index]
      if Hook.MainWrite or (ClassHook and ClassHook[3]) then
        return
      end
    end
  end

	return MetatableNew(Obj, Index, Value)
end)

return deb
