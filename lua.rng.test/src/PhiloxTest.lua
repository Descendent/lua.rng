local LuaUnit = require("luaunit")

local Philox = require("Philox")

local PhiloxTest = {}

local function TestPhilox_4x32_10(counter, key, x)
	local o = Philox.Philox_4x32_10(counter, key)

	LuaUnit.assertEquals(o, x)
end

function PhiloxTest.TestPhilox_4x32_10()
	-- https://www.deshawresearch.com/resources_random123.html
	-- https://www.thesalmons.org/john/random123/
	-- "Known Answer Test" vectors
	TestPhilox_4x32_10({0x00000000, 0x00000000, 0x00000000, 0x00000000}, {0x00000000, 0x00000000},
		{0x6627e8d5, 0xe169c58d, 0xbc57ac4c, 0x9b00dbd8})
	TestPhilox_4x32_10({0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff}, {0xffffffff, 0xffffffff},
		{0x408f276d, 0x41c83b0e, 0xa20bc7c6, 0x6d5451fd})
	TestPhilox_4x32_10({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {0xa4093822, 0x299f31d0},
		{0xd16cfe09, 0x94fdcceb, 0x5001e420, 0x24126ea1})
end

local function TestPhilox_4x32_10_WithTableAndTable_WhereLengthNotValid(counter, key)
	LuaUnit.assertError(function ()
		Philox.Philox_4x32_10(counter, key)
	end)
end

function PhiloxTest.TestPhilox_4x32_10_WithTableAndTable_WhereLengthNotValid()
	TestPhilox_4x32_10_WithTableAndTable_WhereLengthNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {})
	TestPhilox_4x32_10_WithTableAndTable_WhereLengthNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {0x00000000})
	TestPhilox_4x32_10_WithTableAndTable_WhereLengthNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {0x00000000, 0x00000000, 0x00000000})
	TestPhilox_4x32_10_WithTableAndTable_WhereLengthNotValid({}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereLengthNotValid({0x00000000, 0x00000000, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereLengthNotValid({0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000}, {0xa4093822, 0x299f31d0})
end

local function TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid(counter, key)
	LuaUnit.assertError(function ()
		Philox.Philox_4x32_10(counter, key)
	end)
end

function PhiloxTest.TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid()
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {-1, 0x00000000})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {0x00000000, -1})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {0xffffffff + 1, 0x00000000})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {0x00000000, 0xffffffff + 1})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {0.1, 0x00000000})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344}, {0x00000000, 0.1})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({-1, 0x00000000, 0x00000000, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, -1, 0x00000000, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, 0x00000000, -1, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, 0x00000000, 0x00000000, -1}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0xffffffff + 1, 0x00000000, 0x00000000, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, 0xffffffff + 1, 0x00000000, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, 0x00000000, 0xffffffff + 1, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, 0x00000000, 0x00000000, 0xffffffff + 1}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0.1, 0x00000000, 0x00000000, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, 0.1, 0x00000000, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, 0x00000000, 0.1, 0x00000000}, {0xa4093822, 0x299f31d0})
	TestPhilox_4x32_10_WithTableAndTable_WhereFormatNotValid({0x00000000, 0x00000000, 0x00000000, 0.1}, {0xa4093822, 0x299f31d0})
end

local function TestNew_WithTable(a)
	local o = Philox.New(a)

	LuaUnit.assertEquals(o:GetKey(), a)
end

function PhiloxTest.TestNew_WithTable()
	TestNew_WithTable({0x00000000, 0x00000000})
	TestNew_WithTable({0xa4093822, 0x299f31d0})
end

local function TestNew_WithTable_WhereLengthNotValid(a)
	LuaUnit.assertError(function ()
		Philox.New(a)
	end)
end

function PhiloxTest.TestNew_WithTable_WhereLengthNotValid()
	TestNew_WithTable_WhereLengthNotValid({})
	TestNew_WithTable_WhereLengthNotValid({0x00000000})
	TestNew_WithTable_WhereLengthNotValid({0x00000000, 0x00000000, 0x00000000})
end

local function TestNew_WithTable_WhereFormatNotValid(a)
	LuaUnit.assertError(function ()
		Philox.New(a)
	end)
end

function PhiloxTest.TestNew_WithTable_WhereFormatNotValid()
	TestNew_WithTable_WhereFormatNotValid({-1, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, -1})
	TestNew_WithTable_WhereFormatNotValid({0xffffffff + 1, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0xffffffff + 1})
	TestNew_WithTable_WhereFormatNotValid({0.1, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0.1})
end

local function TestNew_WithTableAndTable(a)
	local o = Philox.New({0xa4093822, 0x299f31d0}, a)

	LuaUnit.assertEquals(o:GetCounter(), a)
end

function PhiloxTest.TestNew_WithTableAndTable()
	TestNew_WithTableAndTable({0x000000ff, 0x00000000, 0x00000000, 0x00000000})
	TestNew_WithTableAndTable({0x00000000, 0x0000ff00, 0x00000000, 0x00000000})
	TestNew_WithTableAndTable({0x00000000, 0x00000000, 0x00ff0000, 0x00000000})
	TestNew_WithTableAndTable({0x00000000, 0x00000000, 0x00000000, 0xff000000})
end

local function TestNew_WithTableAndTable_WhereLengthNotValid(a)
	LuaUnit.assertError(function ()
		Philox.New(a)
	end)
end

function PhiloxTest.TestNew_WithTableAndTable_WhereLengthNotValid()
	TestNew_WithTable_WhereLengthNotValid({})
	TestNew_WithTable_WhereLengthNotValid({0x00000000, 0x00000000, 0x00000000})
	TestNew_WithTable_WhereLengthNotValid({0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000})
end

local function TestNew_WithTableAndTable_WhereFormatNotValid(a)
	LuaUnit.assertError(function ()
		Philox.New({0xa4093822, 0x299f31d0}, a)
	end)
end

function PhiloxTest.TestNew_WithTableAndTable_WhereFormatNotValid()
	TestNew_WithTable_WhereFormatNotValid({-1, 0x00000000, 0x00000000, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, -1, 0x00000000, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0x00000000, -1, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0x00000000, 0x00000000, -1})
	TestNew_WithTable_WhereFormatNotValid({0xffffffff + 1, 0x00000000, 0x00000000, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0xffffffff + 1, 0x00000000, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0x00000000, 0xffffffff + 1, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0x00000000, 0x00000000, 0xffffffff + 1})
	TestNew_WithTable_WhereFormatNotValid({0.1, 0x00000000, 0x00000000, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0.1, 0x00000000, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0x00000000, 0.1, 0x00000000})
	TestNew_WithTable_WhereFormatNotValid({0x00000000, 0x00000000, 0x00000000, 0.1})
end

local function TestNext(a)
	local o = Philox.New(a)
	local p = Philox.New(a)

	local r
	for i = 0, 1024 do
		r = o:Next()

		LuaUnit.assertTrue((r >= 0.0) and (r < 1.0))
		LuaUnit.assertTrue(r == p:Next())
	end
end

function PhiloxTest.TestNext()
	TestNext({0x00000000, 0x00000000})
	TestNext({0xa4093822, 0x299f31d0})
end

local function TestStep(a, x)
	local o = Philox.New({0xa4093822, 0x299f31d0}, a)

	o:Step()

	LuaUnit.assertEquals(o:GetCounter(), x)
end

function PhiloxTest:TestStep()
	TestStep({0x00000000, 0x00000000, 0x00000000, 0x00000000},
		{0x00000001, 0x00000000, 0x00000000, 0x00000000})
	TestStep({0xffffffff, 0x00000000, 0x00000000, 0x00000000},
		{0x00000000, 0x00000001, 0x00000000, 0x00000000})
	TestStep({0xffffffff, 0xffffffff, 0x00000000, 0x00000000},
		{0x00000000, 0x00000000, 0x00000001, 0x00000000})
	TestStep({0xffffffff, 0xffffffff, 0xffffffff, 0x00000000},
		{0x00000000, 0x00000000, 0x00000000, 0x00000001})
	TestStep({0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff},
		{0x00000000, 0x00000000, 0x00000000, 0x00000000})
end

local function TestStep_WithNumber(a, count, x)
	local o = Philox.New({0xa4093822, 0x299f31d0}, a)

	o:Step(count)

	LuaUnit.assertEquals(o:GetCounter(), x)
end

function PhiloxTest:TestStep_WithNumber()
	TestStep_WithNumber({0x00000000, 0x00000000, 0x00000000, 0x00000000}, 0x00000000,
		{0x00000000, 0x00000000, 0x00000000, 0x00000000})
	TestStep_WithNumber({0x00000001, 0x00000000, 0x00000000, 0x00000000}, 0xffffffff,
		{0x00000000, 0x00000001, 0x00000000, 0x00000000})
	TestStep_WithNumber({0x00000001, 0xffffffff, 0x00000000, 0x00000000}, 0xffffffff,
		{0x00000000, 0x00000000, 0x00000001, 0x00000000})
	TestStep_WithNumber({0x00000001, 0xffffffff, 0xffffffff, 0x00000000}, 0xffffffff,
		{0x00000000, 0x00000000, 0x00000000, 0x00000001})
	TestStep_WithNumber({0x00000001, 0xffffffff, 0xffffffff, 0xffffffff}, 0xffffffff,
		{0x00000000, 0x00000000, 0x00000000, 0x00000000})
	TestStep_WithNumber({0xffffffff, 0x00000000, 0x00000000, 0x00000000}, 0xffffffff,
		{0xfffffffe, 0x00000001, 0x00000000, 0x00000000})
end

local function TestStep_WithNumber_WhereFormatNotValid(count)
	local o = Philox.New({0xa4093822, 0x299f31d0})

	LuaUnit.assertError(function ()
		o:Step(count)
	end)
end

function PhiloxTest:TestStep_WithNumber_WhereFormatNotValid()
	TestStep_WithNumber_WhereFormatNotValid(-1)
	TestStep_WithNumber_WhereFormatNotValid(0xffffffff + 1)
	TestStep_WithNumber_WhereFormatNotValid(0.1)
end

local function TestJump(a, x)
	local o = Philox.New({0xa4093822, 0x299f31d0}, a)

	o:Jump()

	LuaUnit.assertEquals(o:GetCounter(), x)
end

function PhiloxTest:TestJump()
	TestJump({0x00000000, 0x00000000, 0x00000000, 0x00000000},
		{0x00000000, 0x00000000, 0x00000001, 0x00000000})
	TestJump({0x00000000, 0x00000000, 0xffffffff, 0x00000000},
		{0x00000000, 0x00000000, 0x00000000, 0x00000001})
	TestJump({0x00000000, 0x00000000, 0xffffffff, 0xffffffff},
		{0x00000000, 0x00000000, 0x00000000, 0x00000000})
end

return PhiloxTest
