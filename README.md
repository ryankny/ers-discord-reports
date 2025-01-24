<a id="readme-top"></a>


<!-- PROJECT LOGO -->
<br />
<div align="center">

<h3 align="center">ERS-Discord-Reports</h3>

  <p align="center">
    A FiveM Lua script that allows Emergency Response Simulator Operation Reports to be posted into Discord via Webhooks
    <br />
    <a href="https://docs.nights-software.com/resources/ers/"><strong>Explore Night's ERS Docs »</strong></a>
    <br />
    <br />
    <a href="https://discord.gg/vgrdrp">VanguardRP</a>
  </p>
</div>


## Description

<p>The <code>ers-discord-report</code> script exclusively designed for Night's Emergency Response Simulator script for FiveM and enables operation report data to be streamed into Discord on an interval. Players can use the MDT as normal and then this gets pushed into a designated Discord channel via a Discord Webhook URL.</p>

<img style="width: 300px; height: auto;" src="https://i.imgur.com/kDv1TB0.png"/>

<h3>Dependencies:</h3>
<ul>
  <li>Requires a MySQL database setup for data persistence.</li>
  <li>The script uses the <b>oxmysql</b> resource (https://github.com/overextended/oxmysql)
  <li>Database queries are exclusive to Night's Emergency Response Simulator script.</li>
</ul>

<h3>Future Enhancements:</h3>
<ul>
  <li>Multiple department support i.e. (LSPD, SASP, LSCSO, SAFD).</li>
</ul>

### Changelog

<h3>1.0.0</h3>
<ul>
  <li>Intial release of the script.</li>
</ul>

### Installation

1. Download the contents of this repo into a ZIP file and extract it as a folder
2. Drag and drop the folder into your `resources` folder for your FiveM server
3. Configure the config.lua file by adding your Discord Webhook URL
   ```sh
    Config  = Config or {}

    Config = {
        Debug = false, -- Enable this for additional logging in the console
        WebhookURL = "", -- Discord webhook URL in the channel you want the data posted to
        DataCheckInterval = 60 -- Interval in seconds you\'d like the script to check for new records (recommend every minute at a minimum)
        
        EmbedTitle = "New MDT Report", -- Title on each Embedded message
        EmbedFooterText = "Your Server Name" -- Footer text at the bottom of each message
    }
   ```
4. Run the script and (optional) enable Debug to ensure everything is working as it should

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Night's Software](https://store.nights-software.com/)
* [London Studios](https://store.londonstudios.net/)
* [Vanguard Roleplay](https://discord.gg/vgrdrp)

<p align="right">(<a href="#readme-top">back to top</a>)</p>