--[[
=============================================
Tasks can delay or repeatedly call function
=============================================
]]

if Task == nil then
	Task = class ({})
end

--all of the existing task
Task.waitingTasks = {}

--used for task ids
tasksCreatedCount = 0

--delay a function call, returns the TaskID
function Task:Delay(func, seconds, tbl)
	tasksCreatedCount = tasksCreatedCount + 1
	table.insert(Task.waitingTasks, {
		endTime = GameTime:SinceStart() + seconds,
		func = func,
		tbl = tbl,
		id = tasksCreatedCount,
		interupted = false
	})
	return tasksCreatedCount
end

--calls a function repeatitivly with a delay for a limited number of times, returns the TaskID
function Task:IntervalLimited(func, seconds, tbl, intervalCount)
	tasksCreatedCount = tasksCreatedCount + 1
	table.insert(Task.waitingTasks, {
		endTime = GameTime:SinceStart() + seconds,
		func = func,
		tbl = tbl,
		interval = seconds,
		intervalCount = intervalCount,
		id = tasksCreatedCount,
		interupted = false
	})
	return tasksCreatedCount
end

--calls a function repeatitivly with a delay, returns the TaskID
function Task:Interval(func, seconds, tbl)
	tasksCreatedCount = tasksCreatedCount + 1
	table.insert(Task.waitingTasks, {
		endTime = GameTime:SinceStart() + seconds,
		func = func,
		tbl = tbl,
		interval = seconds,
		id = tasksCreatedCount,
		interupted = false
	})
	return tasksCreatedCount
end

--ends an interval, returns true if a task was interupted
function Task:Interupt(id)
	local len = table.getn(Task.waitingTasks) - 1
	for i=1, len do
		if Task.waitingTasks[i].id == id then
			Task.waitingTasks[i].interupted = true
			return true
		end
	end
	return false
end

--checks and updates the waitingTasks each frame
function Task:update()
	local now = GameTime:SinceStart()
	local len = table.getn(Task.waitingTasks)
	local i=1
	while Task.waitingTasks[i] ~= nil do
		--removed any interupted tasks
		if Task.waitingTasks[i].interupted then
				table.remove(Task.waitingTasks, i)
				i = i-1
		
		
		--if delay has passed call function
		elseif Task.waitingTasks[i].endTime <= now then
			Task.waitingTasks[i].func(Task.waitingTasks[i].tbl)
			
			--if is an interval
			if Task.waitingTasks[i].interupted == false and Task.waitingTasks[i].interval ~= nil then
				
				--no interval limiting, updating endTime for next delay
				if Task.waitingTasks[i].intervalCount == nil then
					Task.waitingTasks[i].endTime = now + Task.waitingTasks[i].interval
				
				--interval count
				else
					--remove task because of last iteration on the limited intervals
					if Task.waitingTasks[i].intervalCount <= 1 then
						table.remove(Task.waitingTasks, i)
						i = i-1
					else
						--decrement interval count and update endTime
						Task.waitingTasks[i].intervalCount = Task.waitingTasks[i].intervalCount - 1
						Task.waitingTasks[i].endTime = now + Task.waitingTasks[i].interval
					end
				end
			
			--basic delay or interupted
			else
				table.remove(Task.waitingTasks, i)
				i = i-1
			end
		end
		i = i+1
	end
	
	return 0.03
end