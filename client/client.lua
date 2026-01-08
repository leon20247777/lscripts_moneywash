-- Load selected language
local Lang = Locales[Config.Locale] or Locales["en"]

local ped

-- Spawn NPC safely
CreateThread(function()
    lib.requestModel(Config.NPC.model)
    ped = CreatePed(4, GetHashKey(Config.NPC.model), Config.NPC.coords.xyz, Config.NPC.coords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            label = Lang.menu_title or "Money Wash",
            icon = 'fa-solid fa-sack-dollar',
            onSelect = openWashMenu
        }
    })
end)

-- Open input dialog safely
local function openAmountDialog(maxAmount)
    CreateThread(function()
        local input = lib.inputDialog(Lang.menu_title, {
            { type = 'number', label = Lang.menu_amount, min = Config.Limits.min, max = maxAmount, required = true }
        })
        if input and tonumber(input[1]) then
            local amount = math.floor(tonumber(input[1]))
            if amount >= Config.Limits.min and amount <= maxAmount then
                TriggerServerEvent('leon_moneywash:start', amount)
            else
                lib.notify({ type = 'error', description = Lang.invalid_amount })
            end
        end
    end)
end

-- Moneywash menu
function openWashMenu()
    local dirty = exports.ox_inventory:Search('count', Config.Items.dirty) or 0
    if dirty < Config.Limits.min then
        return lib.notify({ type = 'error', description = Lang.not_enough_dirty })
    end

    if dirty > Config.Limits.max then
        dirty = Config.Limits.max
    end

    lib.registerContext({
        id = 'moneywash_menu',
        title = Lang.menu_title,
        options = {
            {
                title = Lang.menu_amount,
                icon = 'hashtag',
                onSelect = function()
                    openAmountDialog(dirty)
                end
            },
            {
                title = Lang.menu_all,
                description = ('$%s'):format(dirty),
                icon = 'sack-dollar',
                onSelect = function()
                    TriggerServerEvent('leon_moneywash:start', dirty)
                end
            }
        }
    })

    lib.showContext('moneywash_menu')
end

-- Progress bar for washing
RegisterNetEvent('leon_moneywash:progress', function(time)
    lib.progressBar({
        duration = time,
        label = Lang.washing_progress,
        canCancel = true,
        disable = { move = true, car = true, combat = true }
    })
end)
