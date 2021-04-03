--========================================================
--                    GRID
--========================================================
local deltas = {
	vector2(-1, -1),
	vector2(-1, 0),
	vector2(-1, 1),
	vector2(0, -1),
	vector2(1, -1),
	vector2(1, 0),
	vector2(1, 1),
	vector2(0, 1),
}
local bitShift = 2
local zoneRadius = 128

function GetGridChunk(x)
	return math.floor((x + 8192) / zoneRadius)
end

function GetGridBase(x)
	return (x * zoneRadius) - 8192
end

function GetChunkId(v)
	return v.x << bitShift | v.y
end

function GetMaxChunkId()
	return zoneRadius << bitShift
end

function GetCurrentChunk(pos)
	local chunk = vector2(GetGridChunk(pos.x), GetGridChunk(pos.y))
	local chunkId = GetChunkId(chunk)

	return chunkId
end

function GetNearbyChunks(pos)
    local nearbyChunksList = {}
	local nearbyChunks = {}
	
    for i = 1, #deltas do -- Get nearby chunks
        local chunkSize = pos.xy + (deltas[i] * 20) -- edge size
        local chunk = vector2(GetGridChunk(chunkSize.x), GetGridChunk(chunkSize.y)) -- get nearby chunk
        local chunkId = GetChunkId(chunk) -- Get id for chunk

		if not nearbyChunksList[chunkId] then		
			nearbyChunks[#nearbyChunks + 1] = chunkId
			nearbyChunksList[chunkId] = true
		end
    end

    return nearbyChunks
end
--========================================================
--                    MODULES
--========================================================
voiceData = {}
radioData = {}
callData = {}

phoneticAlphabet = {
	"Alpha",
	"Bravo",
	"Charlie",
	"Delta",
	"Echo",
	"Foxtrot",
	"Golf",
	"Hotel",
	"India",
	"Juliet",
	"Kilo",
	"Lima",
	"Mike",
	"November",
	"Oscar",
	"Papa",
	"Quebec",
	"Romeo",
	"Sierra",
	"Tango",
	"Uniform",
	"Victor",
	"Whisky",
	"XRay",
	"Yankee",
	"Zulu",
}
--========================================================
--                  FUNCTIONS
--========================================================
if IsDuplicityVersion() then
	function DebugMsg(msg)
		if Config.debug then
			print("\x1b[32m[" .. GetCurrentResourceName() .. "]\x1b[0m ".. msg)
		end
	end
else
	function DebugMsg(msg)
		if Config.debug then
			print("[" .. GetCurrentResourceName() .. "] ".. msg)
		end
	end

	function SetMumbleProperty(key, value)
		if Config[key] ~= nil and Config[key] ~= "controls" and Config[key] ~= "radioChannelNames" then
			Config[key] = value

			if key == "callSpeakerEnabled" then
				SendNUIMessage({ speakerOption = true })
			end
		end
	end

	function SetRadioChannelName(channel, name)
		local channel = tonumber(channel)

		if channel ~= nil and name ~= nil and name ~= "" then
			if not Config.radioChannelNames[channel] then
				Config.radioChannelNames[channel] = tostring(name)
			end
		end
	end

	function SetCallChannelName(channel, name)
		local channel = tonumber(channel)

		if channel ~= nil and name ~= nil and name ~= "" then
			if not Config.callChannelNames[channel] then
				Config.callChannelNames[channel] = tostring(name)
			end
		end
	end

	exports("SetMumbleProperty", SetMumbleProperty)
	exports("SetTokoProperty", SetMumbleProperty)
	exports("SetRadioChannelName", SetRadioChannelName)
	exports("SetCallChannelName", SetCallChannelName)
end

function GetRandomPhoneticLetter()
	math.randomseed(GetGameTimer())

	return phoneticAlphabet[math.random(1, #phoneticAlphabet)]
end

function GetPlayersInRadioChannel(channel)
	local channel = tonumber(channel)
	local players = false

	if channel ~= nil then
		if radioData[channel] ~= nil then
			players = radioData[channel]
		end
	end

	return players
end

function GetPlayersInRadioChannels(...)
	local channels = { ... }
	local players = {}

	for i = 1, #channels do
		local channel = tonumber(channels[i])

		if channel ~= nil then
			if radioData[channel] ~= nil then
				players[#players + 1] = radioData[channel]
			end
		end
	end

	return players
end

function GetPlayersInAllRadioChannels()
	return radioData
end

function GetPlayersInPlayerRadioChannel(serverId)
	local players = false

	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			local channel = voiceData[serverId].radio
			if channel > 0 then
				if radioData[channel] ~= nil then
					players = radioData[channel]
				end
			end
		end
	end

	return players
end

function GetPlayerRadioChannel(serverId)
	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			return voiceData[serverId].radio
		end
	end
end

function GetPlayerCallChannel(serverId)
	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			return voiceData[serverId].call
		end
	end
end
--========================================================
--                  EXPORTS
--========================================================
exports("GetPlayersInRadioChannel", GetPlayersInRadioChannel)
exports("GetPlayersInRadioChannels", GetPlayersInRadioChannels)
exports("GetPlayersInAllRadioChannels", GetPlayersInAllRadioChannels)
exports("GetPlayersInPlayerRadioChannel", GetPlayersInPlayerRadioChannel)
exports("GetPlayerRadioChannel", GetPlayerRadioChannel)
exports("GetPlayerCallChannel", GetPlayerCallChannel)