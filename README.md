# JRankings

Rankings system with complex function and (hopefully) easy API.

Created by Jo5629. License: MIT

## API

### Installation

1. Depend on `jrankings`.
2. Include the `jrankings.lua` file in your mod and store in a **LOCAL** variable:
   - Store as a local to stop confliction with the actual mod.

``` lua
local jrankings = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/jrankings.lua")
```

### Functions

- `jrankings.new(filepath)` - Returns a class.
  - `filepath` is the path to store the rankings in.

#### `jrankings.Builder`

**Constructor:**

- `jranking.Builder:new()` - Returns a new instance, but there is no filepath.

**Methods:**

`pname` is a string and is a name of a valid player.

- `get(pname)` - Gets all of the values registered under player.
  - Returns a key-value table.
- `set(pname, newrankings, erase_unset)` - Sets a player's ranking.
  - `newrankings` is a key-value table.
  - `erase_unset` is a boolean. If true, any other keys not listed in `newrankings` will be deleted.
- `add(pname, amounts)` - Adds what value. ???
  - `amounts` is a key-value table.
- `del(pname)` - Deletes a player's ranking.
- `sort_rankings()` - Reorders the internal rankings based on score.
  - Higher score = higher ranking.
- `get_top(count)` - Gets the top players.
  - `count` is an integer.
  - Returns a table with all the top player names.
- `get_rank(pname)` - Gets the rank of a specific player.
  - Returns a number.
- `load()` - Loads the rankings from filepath.
- `save()`-  Save the rankings to filepath.
