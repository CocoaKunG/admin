local Players = game:GetService("Players")
local HttpGet = game.HttpGet
local HttpService = game:GetService("HttpService")

-- โหลดเวลาเป้าหมายเพียงครั้งเดียว
local targetTime = loadstring(HttpGet(game, "https://raw.githubusercontent.com/CocoaKunG/admin/refs/heads/main/time_out.lua"))()

-- ฟังก์ชันเพื่อตรวจสอบและเตะผู้เล่นด้วยเหตุผลที่กำหนด
local function checkAndKickPlayers(reason)
    for _, player in pairs(Players:GetPlayers()) do
        player:Kick(reason)
    end
end

-- ตรวจสอบว่าค่าของ getgenv().CocoaKunG มีหรือไม่
if getgenv().CocoaKunG ~= "Love you🤔" then
    checkAndKickPlayers("Cocoa : Unauthorized access detected😘")
else
    -- ฟังก์ชันเพื่อตรวจสอบและเตะผู้เล่นเมื่อถึงเวลา
    local function checkAndKickPlayersByTime()
        while true do
            if os.time() >= targetTime then
                checkAndKickPlayers("Cocoa : time out😘")
                break -- ออกจาก loop เมื่อเตะผู้เล่นแล้ว
            end
            wait(30) -- รอ 30 วินาทีเพื่อทำการตรวจสอบเวลาอีกครั้ง
        end
    end

    -- เริ่มตรวจสอบเวลาและเตะผู้เล่นเมื่อถึงเวลา
    spawn(checkAndKickPlayersByTime) -- ใช้ spawn เพื่อรันฟังก์ชันแบบไม่บล็อกการทำงานอื่น ๆ

    -- การตั้งค่า Fog ใน Lighting
    if getgenv().fog == "true" then
        local Lighting = game.Lighting
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end

    -- ฟังก์ชันสำหรับส่งข้อความไปยัง Discord Webhook
    local function sendMessageWebhook(embed)
        local url = "https://discord.com/api/webhooks/1175658007833612348/4igS6PbQGK8byXd0G1DwCPrjQL9ROHBrfgkZNsJ5e3zRcGPtzXbrXzWDOiIXmwzxKuP_"
        local data = {
            ["embeds"] = {
                {
                    ["title"] = embed.title,
                    ["description"] = embed.description,
                    ["color"] = 16711680, -- สีแดง
                    ["fields"] = embed.fields,
                    ["footer"] = { ["text"] = embed.footer.text }
                }
            }
        }
        local newData = HttpService:JSONEncode(data)
        local headers = { ["content-type"] = "application/json" }
        local request = http_request or request or HttpPost or syn.request
        request({ Url = url, Body = newData, Method = "POST", Headers = headers })
    end

    -- ฟังก์ชันสำหรับส่งข้อมูลผู้เล่นไปยัง Discord
    local function sendPlayerInfoToDiscord()
        local player = Players.LocalPlayer
        local mapName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown Map"
        local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        local currentTime = os.date("*t")
        local formattedTime = string.format(
            "%02d/%02d/%04d %02d:%02d",
            currentTime.day, currentTime.month, currentTime.year, currentTime.hour, currentTime.min
        )

        local embed = {
            title = "Player Info",
            description = string.format(
                "**ชื่อผู้เล่น**: %s\n**แมพ**: %s\n**HWID**: %s\n**เวลา**: %s",
                player.Name, mapName, hwid, formattedTime
            ),
            fields = {},
            footer = { text = "ข้อมูลจากเกม" }
        }

        sendMessageWebhook(embed)
    end

    -- ส่งข้อมูลผู้เล่นไปยัง Discord
    sendPlayerInfoToDiscord()

    -- โหลดสคริปต์เพิ่มเติมเพียงครั้งเดียว
    loadstring(HttpGet(game, "https://pastebin.com/raw/GsUfiDyj"))()
end
