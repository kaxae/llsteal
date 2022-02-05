wait(20)
getgenv().kaigakufound = false

function ServerTeleport()
while wait() do
    local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. "5094651510" .. '/servers/Public?sortOrder=Asc&limit=100'))
    for i,v in pairs(Servers.data) do
        game:GetService('TeleportService'):TeleportToPlaceInstance(5094651510, v.id)
    end
end
end

game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        syn.queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/StepBroFurious/Script/main/kaihop.lua"))()')
    end
end)

for i,v in pairs(workspace:GetChildren()) do
    if v.Name == "Kaigaku" then
        getgenv().kaigakufound = true
    end
end

if getgenv().kaigakufound ~= true then
    ServerTeleport()
    else
    warn("Kai found")
    for i,v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui.LoadingScreen.Background.Loading.Skip.MouseButton1Click)) do
        v:Fire()
    end
end


