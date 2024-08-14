dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/tests/player.lua")

if not minetest.get_modpath("lib_chatcmdbuilder") then
    return
end

local cmd = chatcmdbuilder.register("jrankings", {
    description = "For use with the jrankings mod.",
    privs = {
        server = true,
        debug = true,
    },
    params = "<load> | <save> | (<set> <name> <stat> <num>) | (<get> <name>) | (<add> <name> <stat> <num>)",
})

cmd:sub("load", function(name)
    jrankings.file:load()
end)

cmd:sub("save", function(name)
    jrankings.file:save()
end)

cmd:sub("add :username:username :stat :int:int", function(name, username, stat, int)
    jrankings.file:add(username, {[stat] = int})
end)

cmd:sub("add :stat :int:int", function(name, stat, int)
    jrankings.file:add(name, {[stat] = int})
end)

cmd:sub("set :username:username :stat :int:int", function(name, username, stat, int)
    jrankings.file:set(username, {[stat] = int})
end)

cmd:sub("set :stat :int:int", function(name, stat, int)
    jrankings.file:set(name, {[stat] = int})
end)

cmd:sub("get :username:username", function(name, username)
    local rank_num = jrankings.file:get_rank(username)
    local ranking = jrankings.file:get(username)

    minetest.chat_send_player(name, string.format("RANK: %d", rank_num))
    for k, v in pairs(ranking) do
        minetest.chat_send_player(name, string.format("%s: %s", k, tostring(v)))
    end
end)