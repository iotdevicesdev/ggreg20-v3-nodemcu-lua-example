[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct-team.svg)](https://stand-with-ukraine.pp.ua)

# GGreg20_V3 NodeMCU firmware Lua code example

This is a simple Lua script example for [GGreg20_V3](https://iot-devices.com.ua/en/product/ggreg20_v3-ionizing-radiation-detector-with-geiger-tube-sbm-20/) / GGreg20_V1 ionizing radiation detector module with SBM-20 GM tube working under [NodeMCU firmware](https://github.com/nodemcu/nodemcu-firmware) on ESP32 / ESP8266

This script is based on [alterstrategy.lab](https://alterstrategy.com/) (c) [RadCounter](https://alterstrategy.com/product/radcounter/) - a full fledged LUA driver library module for radiation pulse counters under NodeMCU firmware.

Developed in 2022 by IoT-devices LLC, Kyiv, Ukraine with special alterstrategy.lab permission

This opensource free example code is licensed under: Apache 2.0 License

## Usage

To get results:
 1) Run the script
````lua
dofile('ggreg20_v3_nodemcu_firmware_lua_example.lua')
````
 2) Run init() function with parameters
````lua
init(3, 1, 60000)
````
 3) Wait for 1 minute (after first pulse from GGreg20_V3) OR just run read() function to get current values
````lua
read()
-- or:
ma5_rad_lvl, cpm, minutes = read()
````

## The Full fledged driver 
If you want to obtain ready-to-use and well commented Lua code with: 
+ debug output mode, 
+ calculation of minimum / maximum instantaneous levels, 
+ accumulated dose of radiation, 
+ low-pass and hi-pass debounce filtering,
+ UNKNOWN / NORMAL / HIGH / DANGER event handling 

as a complete Lua module with public methods registration, you may find it here: 
https://alterstrategy.com/product/radcounter/

## The GGreg20_V3 Project on Hackaday:
https://hackaday.io/project/183103-ggreg20v3-ionizing-radiation-detector
