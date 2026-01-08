Config = {}

-- Items
Config.Items = {
    dirty = 'black_money', -- dirty_money / dirty_cash / black_cash
    clean = 'money' -- cash
}

-- Locale
Config.Locale = 'de' -- 'de', 'es', 'it', 'fr'

-- Limits
Config.Limits = {
    min = 1000,
    max = 75000
}

-- Cooldown
Config.Cooldown = 5 * 60000 -- 5 minutes

-- Time tiers
Config.WashTimes = {
    { amount = 50000, time = 180000 }, -- 3 minutes
    { amount = 15000, time = 60000  }, -- 1 minute
    { amount = 5000,  time = 30000  }  -- 30 seconds
}

-- Rate
Config.Rate = 0.65

-- NPC
Config.NPC = {
    model = 'a_m_m_business_01',
    coords = vector4(1069.79, -2438.58, 28.78, 175.74)
}
