local databaseIDLastChecked = 0 -- Last checked ID variable to persist when resource running to prevent duplicate
                                -- reports from hitting Discord

-- Initialise the thread that will be checking
-- the reports on an interval
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.DataCheckInterval * 1000)
        checkForNewReports()
    end
end)

-- On resource start, grab the latest report ID so
-- we don't duplicate operation reports in Discord
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Validation check on config
        if Config.DataCheckInterval == nil or type(Config.DataCheckInterval) ~= "number" then
            print("[ers-discord-reports] [WARN] The data check interval in the config is invalid or missing, please correct.")
        end
        if Config.WebhookURL == nil then
            print("[ers-discord-reports] [WARN] The Webhook URL you have provided is invalid or missing, please correct")
        end

        -- Grab the last checked ID as the latest ID in the database table
        exports["oxmysql"]:execute("SELECT MAX(id) as max_id FROM ns_mdt_operations", {}, function(result)
            if result[1] then
                databaseIDLastChecked = result[1].max_id or 0

                if Config.Debug then
                    print("[ers-discord-reports] Resource started, setting database last checked ID to: " .. databaseIDLastChecked)
                end
            end
        end)
    end
end)

-- Function to handle checking new operation reports
function checkForNewReports()
    if Config.Debug then
        print("[ers-discord-reports] Checking for new operation reports...")
    end
    exports["oxmysql"]:execute("SELECT * FROM ns_mdt_operations WHERE id > @lastId ORDER BY id ASC", {["@lastId"] = databaseIDLastChecked}, function(result)
        if result and #result > 0 then
            for _, row in ipairs(result) do
                if Config.Debug then
                    print("[ers-discord-reports] New operation report found, sending webhook... (ID:" .. row.id .. ")")
                end
                sendReportWebhook(row)
                databaseIDLastChecked = row.id
                if Config.Debug then
                    print("[ers-discord-reports] Updating database last checked ID to: " .. databaseIDLastChecked)
                end
            end
        else
            if Config.Debug then
                print("[ers-discord-reports] No new operation reports have been found, waiting...")
            end
        end
    end)
end

-- Function to build the required Discord JSON to send to the webhook
-- this contains all of the report data
function buildEmbedJson(report)
    return {
        ["title"] = Config.EmbedTitle or "New MDT Report",
        ["description"] = "A new " .. (report.sub_report_type == "Other..." and "report" or report.sub_report_type .. " report") .. " has been added to the system by " .. report.employee_involved,
        ["fields"] = {
            {
                ["name"] = "Report Type",
                ["value"] = report.sub_report_type or "N/A",
                ["inline"] = true
            },
            {
                ["name"] = "Officers Involved",
                ["value"] = report.employee_involved or "N/A",
                ["inline"] = true
            },
            {
                ["name"] = "Description",
                ["value"] = report.description or "N/A",
                ["inline"] = false
            },
            {
                ["name"] = "Location",
                ["value"] = report.location or "N/A",
                ["inline"] = true
            },
            {
                ["name"] = "Civilians Involved",
                ["value"] = report.civilian_involved or "N/A",
                ["inline"] = true
            },
            {
                ["name"] = "Vehicles Involved",
                ["value"] = report.vehicle_involved or "N/A",
                ["inline"] = true
            },
            {
                ["name"] = "Signed By",
                ["value"] = report.signature or "N/A",
                ["inline"] = false
            }
        },
        ["footer"] = {
            ["text"] = Config.EmbedFooterText or "MDT System" .. " " .. os.date("%Y") .. " | " .. os.date("%d-%m-%Y at %H:%M:%S"),
            ["icon_url"] = ""
        },
    }
end

-- Function to send the operation report data to Discord
function sendReportWebhook(report)

    -- Build the JSON to send to Discord
    local jsonToSend = buildEmbedJson(report)

    -- HTTP POST the generated JSON for the specific operation report
    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) 
        if Config.Debug then
            if err then
                print("[ers-discord-reports] Error sending webhook: " .. tostring(err))
            else
                print("[ers-discord-reports] HTTP request successfully sent to Webhook URL")
            end
        end
    end, "POST", json.encode({username = "MDT System", embeds = {jsonToSend}}), { ["Content-Type"] = "application/json" })

end
