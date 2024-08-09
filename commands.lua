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
    local rank = jrankings.file:get_rank(username)
    return true, "RANK: " .. rank
end)