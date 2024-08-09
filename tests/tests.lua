if not minetest.get_modpath("lib_chatcmdbuilder") then
    return
end

local cmd = chatcmdbuilder.register("jrankings", {
    description = "For use with the jrankings mod.",
    privs = {
        server = true,
        debug = true,
    }
})

cmd:sub("load", function(name)
    jrankings.file:load()
end)

cmd:sub("save", function(name)
    jrankings.file:save()
end)

cmd:sub("add :username :stat :int:int", function(name, username, stat, int)
    jrankings.file:add(username, {[stat] = int})
end)

cmd:sub("set :username :stat :int:int", function(name, username, stat, int)
    jrankings.file:set(username, {[stat] = int}, false)
end)

cmd:sub("get :username", function(name, username)
    local rank_num = jrankings.file:get_rank(username)
    local ranking = jrankings.file:get(username)

    minetest.chat_send_player(name, string.format("RANK: %d", rank_num))
    for k, v in pairs(ranking) do
        minetest.chat_send_player(name, string.format("%s: %s", k, tostring(v)))
    end
end)