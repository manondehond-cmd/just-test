-- ✅ Guard against re-execution
if _G.ShopFinderHasRun then return end
_G.ShopFinderHasRun = true

-- 🌐 Webhook map
local webhookMap = {
    ['TheShopFinder1'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder2'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder3'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder4'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder5'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder6'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder7'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder8'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder9'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder10'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
    ['TheShopFinder11'] = 'https://discord.com/api/webhooks/1415431634622087378/9t3g2OQ-H5d1qtJG0LhJmamtDSyhp6OdTODcmE2rnHjcdicdS1xMn1JjLRPha029M4zB',
}

-- Roblox services
local Players = game:GetService('Players')
local TeleportService = game:GetService('TeleportService')
local HttpService = game:GetService('HttpService')

local localPlayer = Players.LocalPlayer
local username = localPlayer and localPlayer.Name
local placeId = game.PlaceId
local currentJobId = game.JobId

-- Pick webhook
local whbk = webhookMap[username] or 'https://discord.com/api/webhooks/default/defaultwebhook'

-- HTTP request function
local httpRequest = (syn and syn.request)
    or (http and http.request)
    or request
    or http_request
    or (fluxus and fluxus.request)
    or (krnl and krnl.request)

-- Send Discord webhook
local function sendgoon(name, rarity, mutation, jobId)
    if not httpRequest then return end

    local robloxJoinLink = string.format(
        'roblox://placeID=%s&gameInstanceId=%s',
        placeId, tostring(jobId)
    )

    local info = mutation
        and string.format("**Info**\n```ini\n[Brainrot] %s\n[Rarity] %s\n[Mutation] %s\n```\n**Join Server**\n%s", name, rarity, mutation, robloxJoinLink)
        or string.format("**Info**\n```ini\n[Brainrot] %s\n[Rarity] %s\n```\n**Join Server**\n%s", name, rarity, robloxJoinLink)

    local payload = {
        embeds = {
            {
                title = 'We Found',
                description = info,
                color = 500989,
            },
        },
    }

    local body = HttpService:JSONEncode(payload)

    task.wait(1)
    pcall(function()
        httpRequest({
            Url = whbk,
            Method = 'POST',
            Headers = { ['Content-Type'] = 'application/json' },
            Body = body,
        })
    end)
end

-- Scan all podiums for rare
local function scanForRare()
    local plots = workspace:WaitForChild('Plots', 10)
    if not plots then return false end

    for _, plot in ipairs(plots:GetChildren()) do
        local podiums = plot:FindFirstChild('AnimalPodiums')
        if podiums then
            for i = 0, 30 do
                local podium = podiums:FindFirstChild(tostring(i))
                if podium then
                    local base = podium:FindFirstChild('Base')
                    local spawn = base and base:FindFirstChild('Spawn')
                    local attach = spawn and spawn:FindFirstChild('Attachment')
                    local overhead = attach and attach:FindFirstChild('AnimalOverhead')

                    if overhead then
                        local rarityLabel = overhead:FindFirstChild('Rarity')
                        local nameLabel = overhead:FindFirstChild('DisplayName')
                        local mutationLabel = overhead:FindFirstChild('Mutation')

                        if rarityLabel and rarityLabel:IsA('TextLabel') and nameLabel and nameLabel:IsA('TextLabel') then
                            local rarity = rarityLabel.Text
                            if rarity == 'Brainrot God' or rarity == 'Secret' then
                                local name = nameLabel.Text
                                local mutation = (mutationLabel and mutationLabel:IsA('TextLabel') and mutationLabel.Visible) and mutationLabel.Text
                                print("✅ RARE FOUND:", name, rarity, mutation or "None")
                                sendgoon(name, rarity, mutation, currentJobId)
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

-- Get public server list and find one to hop to
local function getServerToHop()
    local success, result = pcall(function()
        local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(placeId)
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= currentJobId then
                return server.id
            end
        end
    end

    return nil
end

-- Queue this script to re-run on teleport
local function queueSelf()
    local scriptUrl = "https://raw.githubusercontent.com/manondehond-cmd/just-test/refs/heads/main/roblox.lua"
    local exec = "loadstring(game:HttpGet('" .. scriptUrl .. "'))()"
    if queue_on_teleport then
        queue_on_teleport(exec)
    elseif syn and syn.queue_on_teleport then
        syn.queue_on_teleport(exec)
    end
end

-- 🔁 Main logic
local function main()
    local foundRare = scanForRare()
    if not foundRare then
        print("❌ No rare found. Trying next server...")
        queueSelf()
        task.wait(3)
        local nextServer = getServerToHop()
        if nextServer then
            TeleportService:TeleportToPlaceInstance(placeId, nextServer, Players.LocalPlayer)
        else
            warn("⚠️ No server found to hop to. Retrying in 30 seconds.")
            task.wait(30)
            main() -- try again
        end
    else
        print("✅ Done. Rare found and reported.")
    end
end

main()

