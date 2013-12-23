-- Config
local botNick = "JustCause" -- The bot's name
local user = "IRC" -- the bots username
local real = "BOT" -- the bots realname
local server = "irc.j3w.biz" -- the server the bot needs to connect to
local channels = {"#jcmp"} -- the channels the bot will join (note that it will only output things into the first channel unless it is scripted otherwise

local irc = require("init")
local socket = require("socket")
local sleep = socket.sleep
local ircConnection = irc:new({nick=botNick, username=user, realname=real}) -- Send details to the server
ircConnection:connect(server) -- Connect to the server
-- Join all the channels
for a,b in pairs(channels) do
	ircConnection:join(b)
end
-- Output the channel(s) which were joined
if (#channels == 1) then
	print("Connected to server " .. server .. " and joined " .. channels[1] .. "!")
elseif (#channels == 0) then
	print("Connected to server " .. server .. " but didn't join any channels, since none were defined!")
else
	print("Connected to server " .. server .. " and joined the defined channels!")
end

local commands = {
--	["commandName"] = functionName,
	["!test"] = test,
}

local ircFunctions = {
	["!kick"] = kickPlayer,
}

-- Keep the connection going
function processIRC()
	repeat
		if (ircConnection) then
			ircConnection:think()
		end
		coroutine.yield()
	until false
end
local serverLoop = coroutine.create(processIRC)

-- Keep the connection going and make sure the bot doesnt miss any messages
function onTick()
	coroutine.resume(serverLoop)
end
Events:Subscribe("PostTick", onTick)

-- Function for when a player chats ingame
function chatmsg(args)
	if (args.text:sub(1, 1) == "/") then
		return
	end
	ircConnection:sendChat(channels[1], "[" .. args.player:GetName() .. "] " .. args.text)
	return
end
Events:Subscribe("PlayerChat", chatmsg)

-- Function for when a user chats on IRC
function onIRCChat(user, channel, message)
	print("1")
	if (message:sub(1, 1) == "!") then
		print("2")
		local args = string.split(message, " ")
		if (commands[args[1]]) then
			print("ASD")
			commands[args[1]](user, message)
		end
		return false
	end
	if (message:sub(1, 1) == "!") then
		local args = string.split(message, " ")
		if (ircFunctions[args[1]]) then
			print("CUNT")
			ircFunctions[args[1]](user, message)
		end
		return false
	end
	Chat:Broadcast("[" .. channel .. "] " .. user.nick .. ": " .. message, Color(255, 255, 255))
end
ircConnection:hook("OnChat", onIRCChat)

-- Output to IRC when a player joins the server
function OnPlayerJoin(origArgs)
	local player = origArgs.player
	ircConnection:sendChat(channels[1], player:GetName() .. " joined the server!")
	return
end
Events:Subscribe("PlayerJoin", OnPlayerJoin)

-- Output to IRC when a player quits from the server
function OnPlayerQuit(origArgs)
	local player = origArgs.player
	ircConnection:sendChat(channels[1], player:GetName() .. " quit the game!")
	return
end
Events:Subscribe("PlayerQuit", OnPlayerQuit)

function test(user, message)
	print("tested")
	ircConnect:sendChat(channels[1], "TESTING")
	return
end

