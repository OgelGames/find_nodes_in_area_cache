
-- original (engine) function
local old_find_nodes_in_area = minetest.find_nodes_in_area

minetest.find_nodes_in_area = function(pos1, pos2, nodenames)
  local nodenametable = nodenames
  if type(nodenametable) == "string" then
    nodenametable = {nodenames}
  end

  local count = 0
  for _, nodename in ipairs(nodenametable) do
    if find_nodes_in_area_cache.nodenames[nodename] then
      count = count + 1
    else
      break
    end
  end

  if count == #nodenametable then
    -- all nodenames are cached, query cached function
    -- print("[cache] cached call for nodenames " .. dump(nodenametable))
    return find_nodes_in_area_cache.get(pos1, pos2, nodenametable)
  else
    -- non-cached call
    -- print("[cache] non-cached call for nodenames " .. dump(nodenames))
    return old_find_nodes_in_area(pos1, pos2, nodenames)
  end

end
