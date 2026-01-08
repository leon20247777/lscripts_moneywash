local cooldowns = {}

-- Discord webhook
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1458884440402165760/p2_2wNqZsUkLMIZKEjin3HH24LWpt--f1z-Z5xvltg94Bj8asAE6ZFiLxCeALCZfMwMs"

local function getWashTime(amount)
    for _, data in ipairs(Config.WashTimes) do
        if amount >= data.amount then
            return data.time
        end
    end
    return Config.WashTimes[#Config.WashTimes].time
end

-- Discord logging
local function sendDiscordLog(name, identifier, amount, clean)
    if not DISCORD_WEBHOOK or DISCORD_WEBHOOK == "" then return end
    local embed = {
        {
            ["color"] = 3066993,
            ["title"] = "💰 Money Wash",
            ["description"] = ("**Player:** %s\n**ID:** %s\n**Dirty Money:** $%s\n**Clean Money:** $%s"):format(name, identifier, amount, clean),
            ["footer"] = { ["text"] = "Leon2024 Moneywash Script" },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    PerformHttpRequest(DISCORD_WEBHOOK, function() end, 'POST', json.encode({ username = "MoneyWash", embeds = embed }), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('leon_moneywash:start', function(amount)
    local src = source
    local now = os.time() * 1000

    if not amount or type(amount) ~= 'number' or amount < Config.Limits.min or amount > Config.Limits.max then
        return TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = Locales[Config.Locale].invalid_amount })
    end

    if cooldowns[src] and cooldowns[src] > now then
        return TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = Locales[Config.Locale].must_wait })
    end

    local dirty = exports.ox_inventory:GetItemCount(src, Config.Items.dirty) or 0
    if dirty < amount then
        return TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = Locales[Config.Locale].not_enough_dirty })
    end

    local washTime = getWashTime(amount)
    TriggerClientEvent('leon_moneywash:progress', src, washTime)

    SetTimeout(washTime, function()
        local current = exports.ox_inventory:GetItemCount(src, Config.Items.dirty) or 0
        if current < amount then return end

        exports.ox_inventory:RemoveItem(src, Config.Items.dirty, amount)
        local clean = math.floor(amount * Config.Rate)
        exports.ox_inventory:AddItem(src, Config.Items.clean, clean)

        cooldowns[src] = now + Config.Cooldown

        -- Notify player
        TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = string.format(Locales[Config.Locale].washed_success, clean) })

        -- Discord log
        local playerName = GetPlayerName(src)
        local identifiers = GetPlayerIdentifiers(src)
        local identifier = identifiers[1] or "N/A"
        sendDiscordLog(playerName, identifier, amount, clean)
    end)
end)
