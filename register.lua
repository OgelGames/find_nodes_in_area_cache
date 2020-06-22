


function find_nodes_in_area_cache.register(nodename)
  -- node name
  find_nodes_in_area_cache.nodenames[nodename] = true

  local nodedef = minetest.registered_nodes[nodename]

  if not nodedef then
    minetest.log("warn", "[find_nodes_in_area_cache] node not found: " .. nodename)
    return
  end

  -- node id
  local content_id = minetest.get_content_id(nodename)
  find_nodes_in_area_cache.node_id_map[content_id] = nodename


  -- track place/destroy
  local old_after_place_node = nodedef.after_place_node
  local old_after_destruct = nodedef.after_destruct

  minetest.override_item(nodename, {
    after_place_node = function(pos, placer)
      find_nodes_in_area_cache.add(nodename, pos)
      return old_after_place_node(pos, placer)
    end,
    after_destruct = function(pos, oldnode)
      find_nodes_in_area_cache.remove(nodename, pos)
      return old_after_destruct(pos, oldnode)
    end
  })
end
