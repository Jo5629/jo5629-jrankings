local jrankings = {}

function jrankings.new(filepath)
    local rankings = jrankings.Builder:new()

    rankings.filepath = filepath
    return rankings
end

local Builder = {}
jrankings.Builder = Builder

function Builder:new()
    local o = {
        rankings = {},
        top ={},
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

function Builder:get(pname)
    local ranking = self.rankings[pname] or {}
    if ranking.name then
        self.rankings[pname].name = nil
    end

    return ranking
end

function Builder:set(pname, newrankings, erase_unset)
    local rankings = self:get(pname)
    if erase_unset then
        rankings = {}
    end

    for k, v in pairs(newrankings) do
        rankings[k] = v
    end
    self.rankings[pname] = rankings
end

function Builder:add(pname, amounts)
    local newrankings = self:get(pname)

    for k, v in pairs(amounts) do
        newrankings[k] = (newrankings[k] or 0) + v
    end

    self:set(pname, newrankings)
end

function Builder:del(pname)
    self.rankings[pname] = {}

    for i, name in ipairs(self.top) do
        if name == pname then
            table.remove(self.top, i)
            return
        end
    end
end

function Builder:load()
    local file = io.open(self.filepath, "r")
    if not file then
        return false
    end

    for line in file:lines() do
        local ranking = minetest.parse_json(line)
        local pname = ranking.name

        table.insert(self.top, pname)
        self:set(pname, ranking)
    end
    file:close()
    self:sort_rankings()

    minetest.log("action", "[JRankings] Loaded rankings from: " .. self.filepath)
    return true
end

function Builder:save()
    local file = io.open(self.filepath, "w")
    if not file then
        return false
    end

    for pname, ranking in pairs(self.rankings) do
        ranking.name = pname
        file:write(minetest.write_json(ranking) .. "\n")
    end
    file:close()

    minetest.log("action", "[JRankings] Saved rankings to: " .. self.filepath)
    return true
end

function Builder:sort_rankings()
    table.sort(self.top, function (a, b)
        local p1 = self:get(a).score or 0
        local p2 = self:get(b).score or 0
        return p1 > p2
    end)

    return self.top
end

function Builder:get_top(count)
    self:sort_rankings()
    if count > #self.top then
        return self:get_top(#self.top)
    end

    local index = 0
    local top = {}
    for _, name in ipairs(self.top) do
        index = index + 1
        table.insert(top, name)

        if index >= count then
            break
        end
    end
    return top
end

function Builder:get_rank(pname)
    self:sort_rankings()
    for i, name in ipairs(self.top) do
        if name == pname then
            return i
        end
    end
end

function Builder:get_ranks_in_range(min, max)
    if max > #self.top then
        max = #self.top
    end

    local top = {}
    for i = min, max do
        table.insert(top, self.top[i])
    end
    return top
end

function Builder:get_largest_rank()
    return #self.top
end

function Builder:ranking_reset()
    for pname, _ in pairs(self.rankings) do
        self:del(pname)
    end
    self.top = {}
end

return jrankings