--------------------------------------------------------------------
----------------------] ers-discord-reports [-----------------------
--------------------------------------------------------------------
--------------------------] Config File [---------------------------
--------------------------------------------------------------------

-- This script was designed for Night's Emergency Response 
-- Simulator system exclusively.

-- For checking ERS operation data, this script uses oxmysql
-- https://github.com/overextended/oxmysql

Config  = Config or {}

Config = {
    Debug = false, -- Enable this for additional logging in the console
    WebhookURL = "", -- Discord webhook URL in the channel you want the data posted to
    DataCheckInterval = 60 -- Interval in seconds you'd like the script to check for new records (recommend every minute at a minimum)
    
    EmbedTitle = "New MDT Report", -- Title on each Embedded message
    EmbedFooterText = "Your Server Name" -- Footer text at the bottom of each message
}