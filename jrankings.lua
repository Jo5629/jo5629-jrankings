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
    self.rankings[pname] = nil
end

function Builder:load()
    local file = io.open(self.filepath, "r")
    if not file then
        return
    end

    for line in file:lines() do
        local ranking = minetest.parse_json(line)
        local pname = ranking.name

        table.insert(self.top, pname)
        self:set(pname, ranking)
    end
    file:close()
    self:sort_rankings()
end

function Builder:save()
    local file = io.open(self.filepath, "w")
    if not file then
        return
    end

    for pname, ranking in pairs(self.rankings) do
        ranking.name = pname
        file:write(minetest.write_json(ranking) .. "\n")
    end
    file:close()
end

function Builder:sort_rankings()
    table.sort(self.top, function (a, b)
        local p1 = self:get(a).score or 0
        local p2 = self:get(b).score or 0
        return p1 > p2
    end)
end

local function TableLength(tbl)
    local count = 0
    for k, v in pairs(tbl) do
        count = count + 1
    end
    return count
end

function Builder:get_top(count)
    self:sort_rankings()
    if count > TableLength(self.top) then
        return
    end

    local index = 0
    local top = {}
    for _, name in ipairs(self.top) do
        index = index + 1
        table.insert(top, name)
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

return jrankings