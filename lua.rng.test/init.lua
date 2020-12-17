local LuaUnit = require("luaunit")

local PhiloxTest = require("PhiloxTest")

local luaUnit = LuaUnit.LuaUnit.new()

luaUnit:runSuiteByInstances({
	{"PhiloxTest", PhiloxTest}})

os.exit((luaUnit.result.notSuccessCount == nil) or (luaUnit.result.notSuccessCount == 0))
