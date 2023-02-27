local function Quote(value)
	local t = type(value)

	if t == "string" then
		return string.format("%q", value)
	end

	if t == "table" then
		return string.format("[%s]", value)
	end

	if t == "function" then
		return string.format("[%s]", value)
	end

	if t == "thread" then
		return string.format("[%s]", value)
	end

	if t == "userdata" then
		return string.format("[%s]", value)
	end

	return value
end

--------------------------------------------------------------------------------

local Philox = {}
Philox.__index = Philox

local M0 = 0xd2511f53

local M1 = 0xcd9e8d57

local W0 = 0x9e3779b9

local W1 = 0xbb67ae85

local SIGNIFICAND_HI = (1 << (53 - 32)) - 1

local _debug = true

function Philox.ConfigureDebug(value)
	_debug = value
end

local function MulHiLo32(a, b)
	-- Long multiplication

	local aL = a & 0xffff
	local aH = a >> 16
	local bL = b & 0xffff
	local bH = b >> 16

	local aL_bL = aL * bL
	local aH_bL = aH * bL
	local aL_bH = aL * bH
	local aH_bH = aH * bH

	local lo = (aL_bL + (aH_bL << 16) + (aL_bH << 16)) & 0xffffffff

	local hi = (((aL_bL >> 16) + (aH_bL & 0xffff) + (aL_bH & 0xffff)) >> 16) -- Carry from `lo`
		+ (aH_bL >> 16) + (aL_bH >> 16) + aH_bH

	return lo, hi
end

local function Philox_4x32_10_Round(counter, key)
	local aL, aH = MulHiLo32(M0, counter[1])
	local bL, bH = MulHiLo32(M1, counter[3])

	counter[1] = bH ~ counter[2] ~ key[1]
	counter[2] = bL
	counter[3] = aH ~ counter[4] ~ key[2]
	counter[4] = aL

	key[1] = (key[1] + W0) & 0xffffffff
	key[2] = (key[2] + W1) & 0xffffffff
end

function Philox.Philox_4x32_10(counter, key)
	if _debug then
		assert(#counter == 4,
			string.format("invalid argument: #counter=%s", Quote(#counter)))
		assert(counter[1] == counter[1] & 0xffffffff,
			string.format("invalid argument: counter[1]=%s", Quote(counter[1])))
		assert(counter[2] == counter[2] & 0xffffffff,
			string.format("invalid argument: counter[2]=%s", Quote(counter[2])))
		assert(counter[3] == counter[3] & 0xffffffff,
			string.format("invalid argument: counter[3]=%s", Quote(counter[3])))
		assert(counter[4] == counter[4] & 0xffffffff,
			string.format("invalid argument: counter[4]=%s", Quote(counter[4])))

		assert(#key == 2,
			string.format("invalid argument: #key=%s", Quote(#key)))
		assert(key[1] == key[1] & 0xffffffff,
			string.format("invalid argument: key[1]=%s", Quote(key[1])))
		assert(key[2] == key[2] & 0xffffffff,
			string.format("invalid argument: key[2]=%s", Quote(key[2])))
	end

	counter = {table.unpack(counter)}
	key = {table.unpack(key)}

	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)
	Philox_4x32_10_Round(counter, key)

	return counter
end

function Philox.New(key, counter)
	if type(key) == "number" then
		key = {key & 0xffffffff, key >> 32}
	end

	if counter == nil then
		counter = {0x00000000, 0x00000000, 0x00000000, 0x00000000}
	end

	if _debug then
		assert(#key == 2,
			string.format("invalid argument: #key=%s", Quote(#key)))
		assert(key[1] == key[1] & 0xffffffff,
			string.format("invalid argument: key[1]=%s", Quote(key[1])))
		assert(key[2] == key[2] & 0xffffffff,
			string.format("invalid argument: key[2]=%s", Quote(key[2])))

		assert(#counter == 4,
			string.format("invalid argument: #counter=%s", Quote(#counter)))
		assert(counter[1] == counter[1] & 0xffffffff,
			string.format("invalid argument: counter[1]=%s", Quote(counter[1])))
		assert(counter[2] == counter[2] & 0xffffffff,
			string.format("invalid argument: counter[2]=%s", Quote(counter[2])))
		assert(counter[3] == counter[3] & 0xffffffff,
			string.format("invalid argument: counter[3]=%s", Quote(counter[3])))
		assert(counter[4] == counter[4] & 0xffffffff,
			string.format("invalid argument: counter[4]=%s", Quote(counter[4])))
	end

	local self = setmetatable({}, Philox)

	self._key = key
	self._counter = counter

	self._value = {}
	self._index = 0

	return self
end

function Philox:GetKey()
	return self._key
end

function Philox:GetCounter()
	return self._counter
end

function Philox:Step(count)
	if count == nil then
		count = 1
	end

	if _debug then
		assert(count ~= 0,
			string.format("invalid argument: count=%s", Quote(count)))
		assert(count == count & 0xffffffff,
			string.format("invalid argument: count=%s", Quote(count)))
	end

	self._index = 0

	self._counter[1] = (self._counter[1] + count) & 0xffffffff
	if self._counter[1] >= count then
		return
	end

	self._counter[2] = (self._counter[2] + 1) & 0xffffffff
	if self._counter[2] ~= 0 then
		return
	end

	self._counter[3] = (self._counter[3] + 1) & 0xffffffff
	if self._counter[3] ~= 0 then
		return
	end

	self._counter[4] = (self._counter[4] + 1) & 0xffffffff
end

function Philox:Jump()
	self._index = 0

	self._counter[3] = (self._counter[3] + 1) & 0xffffffff
	if self._counter[3] ~= 0 then
		return
	end

	self._counter[4] = (self._counter[4] + 1) & 0xffffffff
end

local function Dequeue(self)
	if self._index == 0 then
		local r = Philox.Philox_4x32_10(self._counter, self._key)

		self._value[1] = r[1]
		self._value[2] = r[2]
		self._value[3] = r[3]
		self._value[4] = r[4]
	end

	self._index = self._index + 1

	local value = self._value[self._index]

	if self._index >= 4 then
		self:Step()
	end

	return value
end

function Philox:Next()
	-- https://prng.di.unimi.it/

	local lo = Dequeue(self)
	local hi = Dequeue(self) & SIGNIFICAND_HI

	return ((hi << 32) | lo) * 0x1p-53
end

return Philox
