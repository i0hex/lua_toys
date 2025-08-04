-- random_event.lua
-- @author eric zhang
-- @date Aug 4, 2025

-- Data table
local data = {
	-- event_sequence		Event sequence
	-- last_group_index		Last group index
}

-- Event groups
-- { {start1, end1}, {start2, end2}, ... }
local event_groups = {{1, 3}, {4, 6}, {7, 9}, {10, 12}, {13, 15}, {16, 18}, {19, 21}, {22, 24}}

-- Random event
-- @param num_event:number Number of random events
local function gen_random_events(num_events)
	local group_count = #event_groups
	if group_count < 3 then
		-- The group must be at least 3!
		print("the group length must be at least 3!")
		return
	end

	local offset = math.floor(group_count / 2)
	if math.fmod(group_count, 2) == 0 then
		-- When the group length is even, the offset and the random value upper bound become equal.
		-- However, to prevent the grouping from falling into a cycle, the random value upper bound must exceed the offset.
		-- Thus, the offset can be adjusted to the largest odd number smaller than the current offset.
		if math.fmod(offset, 2) == 0 then
			-- If the currently calculated offset is even,
			-- subtract 1 to obtain the largest odd number.
			offset = offset - 1
		else
			-- If it is odd, subtract 2 to obtain the largest odd number.
			offset = offset - 2
		end

		-- offset = math.fmod(offset, 2) == 0 and offset - 1 or offset - 2
	end
	-- Random upper bound
	local max_start_index = group_count - offset
	print(string.format("count:%-3d max_start_index:%-3d offset:%-3d", group_count, max_start_index, offset))

	for index = 1, num_events do
		if not data.event_sequence or math.fmod(#data.event_sequence, group_count) == 0 then
			-- Generate the grouping random value randomly at the first occurrence
			-- and once after every 'length' grouping operations.
			local seed = os.time()
			if data.event_sequence then seed = seed + #data.event_sequence end
			math.randomseed(seed)
			data.last_group_index = math.random(max_start_index)
		end

		-- Calculate the current grouping.
		local current_group_index = math.fmod(data.last_group_index + offset, group_count)
		if current_group_index == 0 then current_group_index = group_count end
		data.last_group_index = current_group_index

		-- Randomly select an event from the group
		local event_id = math.random(event_groups[current_group_index][1], event_groups[current_group_index][2])
		if not data.event_sequence then data.event_sequence = {} end
		data.event_sequence[#data.event_sequence + 1] = { id = event_id }
		print(string.format("event#%-3d group:%-3d id:%-3d", index, current_group_index, event_id))
	end
end

gen_random_events(#event_groups * 2)

for index, event in ipairs(data.event_sequence) do
	print(string.format("index:%-3d id:%-3d", index, event.id))
end
