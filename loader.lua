local games = "https://raw.githubusercontent.com/TrungBui1289/lua/main/games/"

local link = {
    [8357510970] = games.."AnimePunchingSimulator.lua",
    [8302406789] = games.."AnimeLiftingSimulator.lua" ,
    [5326405001] = games.."BaseBattles.lua",
    [8540346411] = games.."RebirthChampionX.lua",
    [5055081323] = games.."SwordmanSimulator.lua",
    [5670292785] = games.."UndeadDefenseTycoon.lua",
    [6875469709] = games.."StrongestPunchSim.lua"
}

for i, v in pairs(link) do
    if i == game.PlaceId or i == game.GameId then
        loadstring(game:HttpGet(v))()
    end
end
