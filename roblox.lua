

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
}

-- Roblox services
local Players = game:GetService('Players')
local localPlayer = Players.LocalPlayer
local username = localPlayer and localPlayer.Name

-- Pick webhook
local whbk = webhookMap[username] or 'https://discord.com/api/webhooks/default/defaultwebhook'

-- HTTP support
local httpRequest = (syn and syn.request)
    or (http and http.request)
    or request
    or http_request
    or (fluxus and fluxus.request)
    or (krnl and krnl.request)

-- Webhook sending
local function sendgoon(name, rarity, mutation, jobId)
    if not httpRequest then return end

    local placeId = tostring(game.PlaceId)
    local robloxJoinLink = string.format(
        'roblox://placeID=%s&gameInstanceId=%s',
        placeId,
        tostring(jobId)
    )

    local info
    if mutation then
        info = string.format(
            "**Info**\n```ini\n[Brainrot] %s\n[Rarity] %s\n[Mutation] %s\n```\n**Join Server**\n%s",
            tostring(name), tostring(rarity), tostring(mutation), robloxJoinLink
        )
    else
        info = string.format(
            "**Info**\n```ini\n[Brainrot] %s\n[Rarity] %s\n```\n**Join Server**\n%s",
            tostring(name), tostring(rarity), robloxJoinLink
        )
    end

    local payload = {
        embeds = {
            {
                title = 'We Found',
                description = info,
                color = 500989,
            },
        },
        attachments = {},
    }

    local HttpService = game:GetService('HttpService')
    local body = HttpService:JSONEncode(payload)

    task.wait(1) -- avoid rate limits

    pcall(function()
        httpRequest({
            Url = whbk,
            Method = 'POST',
            Headers = { ['Content-Type'] = 'application/json' },
            Body = body,
        })
    end)
end

-- 🧠 Rare-checking function
local function scanForRare()
    local plots = workspace:WaitForChild('Plots', 10)
    local jobId = game.JobId

    if not plots then return false end

    for _, plot in pairs(plots:GetChildren()) do
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

                        if
                            rarityLabel and rarityLabel:IsA('TextLabel') and
                            nameLabel and nameLabel:IsA('TextLabel')
                        then
                            local rarity = rarityLabel.Text
                            local name = nameLabel.Text
                            local mutation

                            if mutationLabel and mutationLabel:IsA('TextLabel') and mutationLabel.Visible then
                                mutation = mutationLabel.Text
                            end

                            if rarity == 'Brainrot God' or rarity == 'Secret' then
                                print("✅ RARE FOUND:", name, rarity, mutation or "None")
                                sendgoon(name, rarity, mutation, jobId)
                                return true -- ✅ Rare found!
                            end
                        end
                    end
                end
            end
        end
    end

    return false -- ❌ No rare found in this server
end

-- 🔁 Main retry loop
local function main()
    local success = scanForRare()

    if not success then
        print("❌ No rare found. Hopping in 10s...")
        task.wait(10)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Cesare0328/my-scripts/refs/heads/main/CachedServerhop.lua"))()
    else
        print("✅ Rare sent. Script complete.")
    end
end

main()
