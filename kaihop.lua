wait(16)
getgenv().kaigakufound = false

function ServerTeleport()
while wait() do
    local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
    for i,v in pairs(Servers.data) do
        wait()
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
    end
end
end

function teleport(location)
    wait(0.01)
    if game.Players.LocalPlayer:FindFirstChild("SecurityBypass") == nil then
        game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Player", "SpawnCharacter")
        wait(1.25)
    end
    if game.Players.LocalPlayer:FindFirstChild("SecurityBypass") == nil then
        game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Player", "SpawnCharacter")
        wait(1.25)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Position = location
        else
        game.Players.LocalPlayer.Character.HumanoidRootPart.Position = location
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
    
    spawn(function()
        while wait() do
            if game.Workspace:FindFirstChild("Kaigaku") == nil then
                wait(6)
                ServerTeleport()
            end
        end
    end)
    if game.Workspace:FindFirstChild("Kaigaku") ~= nil then
        if game.Workspace.Kaigaku:FindFirstChild("SpawnValue") ~= nil then
            local val = game.Workspace.Kaigaku.SpawnValue.Value
            if val == "Okuiya" then
                for i,v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui.LoadingScreen.Background.Loading.Skip.MouseButton1Click)) do
                   v:Fire()
                end
                wait(3)
                teleport(Vector3.new(-3163, 706, -1154))
                wait(1)
                loadstring(game:HttpGet(("https://stepbrofurious.xyz/furioushub.lua"), true))()
                getgenv().chosenmob = "Kaigaku" 
                getgenv().MobFarm = true
                getgenv().Itemaura = true
            elseif val == "Hayakawa" then
                for i,v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui.LoadingScreen.Background.Loading.Skip.MouseButton1Click)) do
                   v:Fire()
                end
                wait(3)
                teleport(Vector3.new(464, 759, -2016))
                wait(1)
                loadstring(game:HttpGet(("https://stepbrofurious.xyz/furioushub.lua"), true))()
                getgenv().chosenmob = "Kaigaku" 
                getgenv().MobFarm = true
                getgenv().Itemaura = true
            elseif val == "Kamakura" then
                for i,v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui.LoadingScreen.Background.Loading.Skip.MouseButton1Click)) do
                   v:Fire()
                end
                wait(3)
                teleport(Vector3.new(-2369, 1164, -1491))
                wait(1)
                loadstring(game:HttpGet(("https://stepbrofurious.xyz/furioushub.lua"), true))()
                getgenv().chosenmob = "Kaigaku" 
                getgenv().MobFarm = true
                getgenv().Itemaura = true
            elseif game.Workspace.Kaigaku:FindFirstChild("HumanoidRootPart")  ~= nil then
                for i,v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui.LoadingScreen.Background.Loading.Skip.MouseButton1Click)) do
                   v:Fire()
                end
                wait(3)
                loadstring(game:HttpGet(("https://stepbrofurious.xyz/furioushub.lua"), true))()
                getgenv().chosenmob = "Kaigaku" 
                getgenv().MobFarm = true
                getgenv().Itemaura = true
            else
                ServerTeleport()
            end
        end
    end
    --Okuiya
    --teleport
end

