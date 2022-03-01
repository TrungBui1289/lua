local games = "https://raw.githubusercontent.com/TrungBui1289/lua/main/games/"

local link = {
    [8357510970] = games.."AnimePunchingSimulator.lua",
    [7560156054] = games.."Clicker%20Simulator.lua" ,
    [7560156054] = games.."AnimeLiftingSimulator.lua" ,
    [7363858705] = games.."FishSim.lua",
    [7363858705] = games.."BaseBattles.lua",
    [8540346411] = games.."RebirthChampionsX.lua",
    [7107498084] = games.."UndeadDefenseTycoon.lua"
}

for i, v in pairs(link) do
    if i == game.PlaceId or i == game.GameId then
        loadstring(game:HttpGet(v))()
    end
end
