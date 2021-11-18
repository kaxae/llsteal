    local function CC()
    local Count = 0
    for i,v in next, getreg() do
        if typeof(v) == 'function' and is_synapse_function(v) and typeof(i) == 'string' and i:len() == 16 then
            Count = Count + 1
      end
    end
    print(Count)
    return Count > 30 and 30 < Count
end
