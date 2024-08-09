local cmd = chatcmdbuilder.register("jrankings", {
    description = "For use with the jrankings mod.",
    privs = {
        server = true,
        debug = true,
    }
})

cmd:sub("save", function(name)
    jrankings.file:save()
end)

cmd:sub("add_score :username :int", function(name, username, int)
    jrankings.file:add(username, {score = int})
end)

cmd:sub("get :username", function(name, username)
    local rank_num = jrankings.file:get_rank(username)
    local ranking = jrankings.file:get(username)

    minetest.chat_send_player(name, string.format("RANK: %d", rank_num))
    for k, v in pairs(ranking) do
        minetest.chat_send_player(name, string.format("%s: %s", k, tostring(v)))
    end
end)