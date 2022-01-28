-- This is a simple LUA script example for GGreg20_V3 / GGreg20_V1 ionizing radiation detector module with SBM-20 GM tube working under NodeMCU on ESP32 / ESP8266
-- This script is based on alterstrategy.lab (c) RadCounter - a full fledged LUA driver library module for radiation pulse counters under NodeMCU firmware
--
-- Developed in 2022 by IoT-devices LLC, Kyiv, Ukraine with special alterstrategy.lab permission
-- This opensource free example code is licensed under: Apache 2.0 License
--
-- Usage:
-- to get results: 
-- 1) run init() function with parameters
-- 2) wait for 1 minute (after first pulse from GGreg20_V3) OR just run read() function to get current values
--
-- If you want to obtain ready-to-use and well commented Lua code with: 
-- + debug output mode, 
-- + calculation of minimum / maximum instantaneous levels, 
-- + accumulated dose of radiation, 
-- + low-pass and hi-pass debounce filtering,
-- + UNKNOWN / NORMAL / HIGH / DANGER event handling 
-- as a complete Lua module with public methods registration, you may find it here: 
-- https://alterstrategy.com/product/radcounter/

INPUT_PIN = 3 -- D3 just for testing purposes with standard NodeMCU devboard button
t0, t1, i, j, count, minutes_passed = 0,0,1,1,0,0 
ts_prev = 0
-- moving avgerage five minute data cache array
meas = {}

-- starting measurement values
avg_rad_lvl = 0
g_count = 0

DIR, TIMEOUT, DEADTIME, SBM20_COEF = 1, 60000, 190, 0.0054


function cntr(level, ts, evcnt)
	if count == 0 then
		t0 = tmr.now()/1000000 
		meas_tmr:start()
	end

	-- GM tube deadtime debounce
	if level == DIR and ((ts - ts_prev) > DEADTIME or (ts + 2147483648 - ts_prev) > DEADTIME) then 
		count = count + (1 * evcnt) 
	end
	ts_prev = ts

end

function cntr_clr()
	t1 = tmr.now()/1000000
	print (i, t1-t0, "sec", "Imps: ", count, "Rad_lvl: ", count * SBM20_COEF, "uSv/h", count * SBM20_COEF * 100, "uR/h")
	meas[i] = count * SBM20_COEF
	avg_rad_lvl = meas[i]
	minutes_passed = minutes_passed + 1
	g_count = g_count + count
	count = 0
	if #meas == 5 then
		local avg_ = 0
		for j = 1, #meas do
			avg_ = avg_ + meas[j]
		end
		avg_rad_lvl = avg_ / #meas
		print (#meas.." pass avg: ", avg_rad_lvl, "uSv/h")
	end

	print ('avgLvl:', avg_rad_lvl, 'imps:', g_count,'mins:', minutes_passed)
	
	if i == 5 then i = 1 else i = i + 1 end

	meas_tmr:stop()
end

function init(pin, dir, time_out)

	if type(pin) == 'number' then INPUT_PIN = pin end
	if type(dir) == 'number' then DIR = dir end
	if type(time_out) == 'number' then TIMEOUT = time_out end

	gpio.mode(INPUT_PIN,gpio.INT,gpio.FLOAT)
	meas_tmr = tmr.create()
	meas_tmr:register(TIMEOUT, tmr.ALARM_SEMI, function() cntr_clr() end)
	-- WARNING! 'up'-mode is recommended, because we need to filterout (debounce) low false-positives from SBM-20 behavior
	gpio.trig(INPUT_PIN, DIR == 1 and "up" or "down",cntr)
end

function read()
	print('avg_lvl:', avg_rad_lvl, 'imps:', g_count,'mins:', minutes_passed)
	return avg_rad_lvl, g_count, minutes_passed
end

init(INPUT_PIN, DIR, TIMEOUT)
-- read()