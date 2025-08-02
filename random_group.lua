-- random_group.lua
-- @author eric zhang
-- @date Aug 2, 2025

-- Data table
local data = {
	-- event_list:table		Event list
	-- last_group:number 	Last random group
}

-- Event group
-- { {start1, end1}, {start2, end2}, ... }
local event_group = {{1, 3}, {4, 6}, {7, 9}, {10, 12}, {13, 15}, {16, 18}, {19, 21}, {22, 24}}

local math_fmod = math.fmod
local math_floor = math.floor
local math_random = math.random
local str_fmt = string.format

-- Random event
-- @param times:number Random times
local function random_event(times)
	local length = #event_group
	if length < 3 then
		-- The group must be at least 3!
		print("the group length must be at least 3!")
		return
	end

	local is_even_length = (math_fmod(length, 2) == 0)

	local offset = math_floor(length / 2)
	if is_even_length then
		-- When the group length is even, the offset and the random value upper bound become equal.
		-- However, to prevent the grouping from falling into a cycle, the random value upper bound must exceed the offset.
		-- Thus, the offset can be adjusted to the largest odd number smaller than the current offset.
		if math_fmod(offset, 2) == 0 then
			-- If the currently calculated offset is even,
			-- subtract 1 to obtain the largest odd number.
			offset = offset - 1
		else
			-- If it is odd, subtract 2 to obtain the largest odd number.
			offset = offset - 2
		end
	end
	-- Random upper bound
	local rand_max = length - offset
	print(str_fmt("length:%-3d rand_max:%-3d offset:%-3d", length, rand_max, offset))

	for index = 1, times do
		local start = 0
		if not data.event_list or math_fmod(#data.event_list, length) == 0 then
			-- Generate the grouping random value randomly at the first occurrence
			-- and once after every 'length' grouping operations.
			math.randomseed(os.time() + (data.event_list and #data.event_list or 0))
			start = math_random(rand_max)
		elseif data.last_group then
			-- At all other times, simply use the previously saved group
			start = data.last_group
		end

		-- Calculate the current grouping.
		data.last_group = start + offset
		if data.last_group > length then
			-- When the value exceeds the group length, take the modulus with the group length
			-- to ensure the calculated group falls within the valid range.
			data.last_group = math_fmod(data.last_group, length)
		end

		-- Randomly select an event from the group
		local event_id = math_random(event_group[data.last_group][1], event_group[data.last_group][2])
		if not data.event_list then data.event_list = {} end
		data.event_list[#data.event_list+1] = { id = event_id }
		print(str_fmt("index:%-3d start:%-3d last_group:%-3d event_id:%-3d", index, start, data.last_group, event_id))
	end
end

random_event(#event_group * 2)

