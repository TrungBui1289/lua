local games = "https://raw.githubusercontent.com/TrungBui1289/lua/main/games/"

local link = {
    [8357510970] = games.."AnimePunchingSimulator.lua",
    [8302406789] = games.."AnimeLiftingSimulator.lua" ,
    [5326405001] = games.."BaseBattles.lua",
    [8540346411] = games.."RebirthChampionX.lua",
    [5055081323] = games.."SwordmanSimulator.lua",
    [5670292785] = games.."UndeadDefenseTycoon.lua",
    [6875469709] = games.."StrongestPunchSim.lua",
    [6953291455] = games.."EatingSimulator.lua",
    [6531005851] = games.."LiftingTitans.lua",
    [6897226634] = games.."Timber.lua",
    [7728848215] = games.."SlashSim.lua",
    [7363174769] = games.."DeliverymanSim.lua",
    [6312753269] = games.."SuperEvolution.lua",
    [8884334497] = games.."MiningCLieckerSim.lua",
    [8737602449] = games.."PlsDonate.lua",
    [8304191830] = games.."AnimeAdventures.lua"
}

for i, v in pairs(link) do
    if i == game.PlaceId or i == game.GameId then
        loadstring(game:HttpGet(v))()
    end
end
