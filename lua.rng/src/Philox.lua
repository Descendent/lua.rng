local Philox = {}
Philox.__index = Philox

local M0 = 0xd2511f53

local M1 = 0xcd9e8d57

local W0 = 0x9e3779b9

local W1 = 0xbb67ae85

local SIGNIFICAND = (1 << 53) - 1

local SIGNIFICAND_HI = (1 << (53 - 32)) - 1

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
	assert(#counter == 4)
	assert(counter[1] == counter[1] & 0xffffffff)
	assert(counter[2] == counter[2] & 0xffffffff)
	assert(counter[3] == counter[3] & 0xffffffff)
	assert(counter[4] == counter[4] & 0xffffffff)

	assert(#key == 2)
	assert(key[1] == key[1] & 0xffffffff)
	assert(key[2] == key[2] & 0xffffffff)

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
	if counter == nil then
		counter = {0x00000000, 0x00000000, 0x00000000, 0x00000000}
	end

	assert(#key == 2)
	assert(key[1] == key[1] & 0xffffffff)
	assert(key[2] == key[2] & 0xffffffff)

	assert(#counter == 4)
	assert(counter[1] == counter[1] & 0xffffffff)
	assert(counter[2] == counter[2] & 0xffffffff)
	assert(counter[3] == counter[3] & 0xffffffff)
	assert(counter[4] == counter[4] & 0xffffffff)

	local self = setmetatable({}, Philox)

	self._key = key
	self._counter = counter

	self._value = {}

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

	assert(count == count & 0xffffffff)

	if count == 0 then
		return
	end

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
	self._counter[3] = (self._counter[3] + 1) & 0xffffffff
	if self._counter[3] ~= 0 then
		return
	end

	self._counter[4] = (self._counter[4] + 1) & 0xffffffff
end

local function Dequeue(self)
	if #self._value ~= 0 then
		return table.remove(self._value, 1)
	end

	local r = Philox.Philox_4x32_10(self._counter, self._key)
	self:Step()

	table.insert(self._value, r[2])
	table.insert(self._value, r[3])
	table.insert(self._value, r[4])

	return r[1]
end

function Philox:Next()
	local lo = Dequeue(self)
	local hi = Dequeue(self) & SIGNIFICAND_HI

	return ((lo + (hi << 32))
		/ (SIGNIFICAND + 1))
end

return Philox
