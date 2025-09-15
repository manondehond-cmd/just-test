local Players = game:GetService('Players')
local localPlayer = Players.LocalPlayer
local username = localPlayer and localPlayer.Name

--// Webhook map for specific usernames
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

--// Use their custom webhook or fallback
local whbk = webhookMap[username]
    or 'https://discord.com/api/webhooks/default/defaultwebhook'

--// Determine HTTP request function
local httpRequest = (syn and syn.request)
    or (http and http.request)
    or request
    or http_request
    or (fluxus and fluxus.request)
    or (krnl and krnl.request)

--// Send webhook to Discord
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
            '**Info**\n```ini\n[Brainrot] %s\n[Rarity] %s\n[Mutation] %s\n```\n**Join Server**\n%s',
            tostring(name),
            tostring(rarity),
            tostring(mutation),
            robloxJoinLink
        )
    else
        info = string.format(
            '**Info**\n```ini\n[Brainrot] %s\n[Rarity] %s\n```\n**Join Server**\n%s',
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

--// Loop through plots and check podiums
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

local IGNORE_FILE = "ServerHop.txt"
local HOUR = 3600

local Module = {}

local HttpService, TeleportService = game:GetService"HttpService", game:GetService"TeleportService"

local function GET()
    if not isfile(IGNORE_FILE) then return {} end
    local list = {}
    local now = os.time()
    for _, line in next, readfile(IGNORE_FILE):split("\n") do
        local pmo, ts = line:match("([^|]+)|?(%d*)")
        ts = tonumber(ts) or 0
        if now - ts < HOUR then list[pmo] = ts end
    end
    return list
end

local function Update(List)
    local sybau = {}
    for ts, pmo in next, List do
        table.insert(sybau, ts .. "|" .. pmo)
    end
    writefile(IGNORE_FILE, table.concat(sybau, "\n"))
end

local IgnoredServers = GET()

function Module:GetServers(Sort)
    Sort = Sort or { ping = true, fps = false, asc = false }
    
    local cursor = ""
    while true do
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(`https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?limit=100&sortOrder={(Sort.asc and "Asc" or "Desc")}&excludeFullGames=true&cursor={cursor}`))
        end)
        
        if not success or not result or not result.data then error("server error (not success or no result or no data)") end

        local ServersList = result.data

        table.sort(ServersList, function(a, b)
            if Sort.ping and Sort.fps then
                return a.ping == b.ping and a.fps > b.fps or a.ping < b.ping
            elseif Sort.ping then
                return a.ping < b.ping
            elseif Sort.fps then
                return a.fps > b.fps
            end
        end)

        for _, Server in next, ServersList do
            if not IgnoredServers[Server.id] then
                IgnoredServers[Server.id] = os.time()
                Update(IgnoredServers)

                return TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game:GetService("Players").LocalPlayer)
            end
        end

        assert(result.nextPageCursor, "No server found.")

        cursor = result.nextPageCursor
    end
end

return Module
                        end
                    end  
                end
            end
        end
    end
end
