local modpath = minetest.get_modpath(minetest.get_current_modname())

jrankings = dofile(modpath .. "/jrankings.lua")

jrankings.file = jrankings.new(minetest.get_worldpath() .. "/jrankings.txt")
jrankings.file:load()

if minetest.get_modpath("lib_chatcmdbuilder") then
    dofile(modpath .. "/commands.lua")
end

dofile(modpath .. "/player.lua")

minetest.after(0, function()
    local function save_interval()
        jrankings.file:save()
        minetest.after(15, save_interval)
    end
    save_interval()
end)

minetest.register_on_shutdown(function()
    jrankings.file:save()
end)

local version = "v1.0.0-dev"
minetest.log("action", "[JRankings] Mod loaded, running version " .. version)