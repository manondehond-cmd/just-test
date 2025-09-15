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

local Players = game:GetService('Players')
local localPlayer = Players.LocalPlayer
local username = localPlayer and localPlayer.Name


local whbk = webhookMap[username]
    or 'https://discord.com/api/webhooks/default/defaultwebhook'


local httpRequest = (syn and syn.request)
    or (http and http.request)
    or request
    or http_request
    or (fluxus and fluxus.request)
    or (krnl and krnl.request)


local function sendgoon(name, rarity, mutation, jobId)
    if not httpRequest then
        return
    end

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
            tostring(name),
            tostring(rarity),
            tostring(mutation),
            robloxJoinLink
        )
    else
        info = string.format(
            "**Info**\n```ini\n[Brainrot] %s\n[Rarity] %s\n```\n**Join Server**\n%s",
            tostring(name),
            tostring(rarity),
            robloxJoinLink
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

    pcall(function()
        httpRequest({
            Url = whbk,
            Method = 'POST',
            Headers = { ['Content-Type'] = 'application/json' },
            Body = body,
        })
    end)
end


local plots = workspace:WaitForChild('Plots')
local jobId = game.JobId

for _, plot in pairs(plots:GetChildren()) do
    local podiums = plot:FindFirstChild('AnimalPodiums')
    if podiums then
        for i = 0, 30 do
            local podium = podiums:FindFirstChild(tostring(i))
            if podium then
                local base = podium:FindFirstChild('Base')
                local spawn = base and base:FindFirstChild('Spawn')
                local attach = spawn and spawn:FindFirstChild('Attachment')
                local overhead = attach
                    and attach:FindFirstChild('AnimalOverhead')
                if overhead then
                    local rarityLabel = overhead:FindFirstChild('Rarity')
                    local nameLabel = overhead:FindFirstChild('DisplayName')
                    local mutationLabel = overhead:FindFirstChild('Mutation')
                    if
                        rarityLabel
                        and rarityLabel:IsA('TextLabel')
                        and nameLabel
                        and nameLabel:IsA('TextLabel')
                    then
                        local rarity = rarityLabel.Text
                        if rarity == 'Brainrot God' or rarity == 'Secret' then
                            local name = nameLabel.Text
                            local mutation
                            if
                                mutationLabel
                                and mutationLabel:IsA('TextLabel')
                                and mutationLabel.Visible
                            then
                                mutation = mutationLabel.Text
                            end
                            print(
                                'Plot:',
                                plot.Name,
                                'Podium:',
                                i,
                                '-> Name:',
                                name,
                                'Rarity:',
                                rarity,
                                'Mutation:',
                                mutation or 'None'
                            )
                            sendgoon(name, rarity, mutation, jobId)

                            while true do
                                wait(15)
                            loadstring(game:HttpGet('https://raw.githubusercontent.com/Cesare0328/my-scripts/refs/heads/main/CachedServerhop.lua'))()
                        end
                    end
                    end
                end
            end
        end
    end
end


