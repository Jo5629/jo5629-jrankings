minetest.register_on_dieplayer(function(player, reason)
    local name = player:get_player_name()
    jrankings.file:add(name, {deaths = 1, score = 10})
end)