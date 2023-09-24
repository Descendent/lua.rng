# API Reference

### Philox

#### Constructors

##### Philox New(integer key)
##### Philox New(table key)
##### Philox New(integer key, table counter)
##### Philox New(table key, table counter)
Creates and returns a new `Philox` instance, with seed `key`, and state `counter`. If `counter` isn't given, it will be `{0, 0, 0, 0}`. If `key` isn't an integer, it must be an array-like table of 2 unsigned integers less than 2<sup>32</sup> (representing a single 64-bit unsigned integer). `counter` must be an array-like table of 4 unsigned integers less than 2<sup>32</sup> (representing a single 128-bit unsigned integer).

#### Static Methods

##### nil ConfigureDebug(boolean value)
If `value` is `false`, most assertions in methods will be skipped; otherwise, all assertions will be checked. By default, all assertions will be checked. Skipping assertions will slightly increase performance, but will also make the cause of errors more difficult to pinpoint.

##### table Philox_4x32_10(table counter, table key)
Returns an array-like table of 4 random, unsigned integers less than 2<sup>32</sup>, generated using the Philox counter-based random number generator algorithm, with key `key`, counter `counter`, and 10 rounds. `key` must be an array-like table of 2 unsigned integers less than 2<sup>32</sup> (representing a single 64-bit unsigned integer). `counter` must be an array-like table of 4 unsigned integers less than 2<sup>32</sup> (representing a single 128-bit unsigned integer).

#### Methods (Accessors)

##### table GetKey()
Returns this `Philox` instance's seed as an array-like table of 2 unsigned integers less than 2<sup>32</sup> (representing a single 64-bit unsigned integer).

##### table GetCounter()
Returns this `Philox` instance's state as an array-like table of 4 unsigned integers less than 2<sup>32</sup> (representing a single 128-bit unsigned integer).

#### Methods

##### nil Step()
##### nil Step(integer count)
Increments this `Philox` instance's state by `count`. If `count` isn't given, it will be 1. `count` must be an unsigned integer greater than 0, and less than 2<sup>32</sup>.

##### nil Jump()
Increments this `Philox` instance's state by 2<sup>64</sup>.

##### float Next()
Returns a random float greater than or equal to 0.0, and less than 1.0, following a uniform distribution. Increments this `Philox` instance's state at the end of the second call after each time this `Philox` instance's state is initialized or changed.

# Examples

## Usage

### Example.lua

```lua
local Philox = require("Philox")

--local _rng = Philox.New(os.time() * 1000)
local _rng = Philox.New(1672549200000)

print(_rng:Next())
print(_rng:Next())
print(_rng:Next())

-- Random angle (in degrees)
print(_rng:Next() * 360.0)
print(_rng:Next() * 360.0)
print(_rng:Next() * 360.0)

-- Random angle (in degrees) greater than or equal to 45.0, and less than 135.0
print(45.0 + (_rng:Next() * (135.0 - 45.0)))
print(45.0 + (_rng:Next() * (135.0 - 45.0)))
print(45.0 + (_rng:Next() * (135.0 - 45.0)))

-- Random integer 1–100
print(math.floor(1 + (_rng:Next() * 100)))
print(math.floor(1 + (_rng:Next() * 100)))
print(math.floor(1 + (_rng:Next() * 100)))
```

### 🧾 (Output)

```text
0.70412068382327
0.035012175855091
0.49512467875001
190.21300870166
175.84232993457
105.67664541339
53.2981959591
103.89078449904
65.377112548898
56
22
33
```
