package.path = package.path .. ';./?.lua'

local nex = {}
nex.module = require("nex-module")
nex.os = nex.module.load["nex-os"]
nex.int = nex.module.load["nex-int"]
nex.data = nex.module.load["nex-data"]

return nex
