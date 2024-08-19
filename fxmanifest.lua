fx_version "cerulean"
game "common"
author "turshu"
description "superman"
lua54 "yes"

client_scripts{
    "client/utils.lua",
    "client/main.lua"
}

server_scripts{
    "server/utils.lua",
    "server/main.lua"
}

shared_scripts{
    "config.lua",
    "@ox_lib/init.lua"
}

ui_page"html/index.html"

files{
    "html/script.js",
    "html/style.css",
    "html/index.html"
}