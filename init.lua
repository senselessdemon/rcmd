-- SenselessDemon

local runningArguments = {...}

if _G.rCMD and _G.rCMD.running then
	return error("rCMD is already running!")
end

local AUTO_TEXT_RESIZE = true
local TERMINAL_MODE = false
local OPEN_HOTKEY = Enum.KeyCode.BackSlash

local VERSION = "v0.6.3"

local startTime = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local NetworkClient = game:GetService("NetworkClient")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local TextService = game:GetService("TextService")
local VirtualUser = game:GetService("VirtualUser")
local LogService = game:GetService("LogService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local localPlayer = Players.LocalPlayer

local playerGui = localPlayer:WaitForChild("PlayerGui")
local playerScripts = localPlayer:WaitForChild("PlayerScripts")
local backpack = localPlayer:WaitForChild("Backpack")

local camera = Workspace.CurrentCamera
local mouse = localPlayer:GetMouse()

--local loadstring = require(script.Loadstring)

TERMINAL_MODE = runningArguments[1] == nil and TERMINAL_MODE or runningArguments[1]
OPEN_HOTKEY = runningArguments[2] == nil and OPEN_HOTKEY or runningArguments[2]


function getIdentity()
	local currentIdentity = 1
	local messageConnection = LogService.MessageOut:Connect(function(message)
		for identity in message:gmatch("Current identity is (%d+)") do
			currentIdentity = identity
		end
	end)

	currentIdentity = nil
	printidentity()
	repeat wait() until currentIdentity
	messageConnection:Disconnect()

	return currentIdentity or 2
end

function getExecutor()
	local executor = "unknown"
	if syn then
		executor = "Synapse X"
	elseif proto or pebc_execute then
		executor = "ProtoSmasher"
	elseif sirhurt or is_sirhurt_closure then
		executor = "SirHurt"
	elseif secure_load then
		execseutor = "Sentinel"
	end
	return executor
end

function getTool()
	return (backpack:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("HopperBin")) or (localPlayer.Character and (localPlayer.Character:FindFirstChildOfClass("Tool") or localPlayer.Character:FindFirstChildOfClass("HopperBin")))
end

function attach(target)
	if getTool() then
		local character = localPlayer.Character
		local targetCharacter = target.Character

		if character and targetCharacter then
			local humanoid = character:FindFirstChild("Humanoid")
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")

			if humanoid and humanoidRootPart and targetHumanoidRootPart then
				humanoid.Name = "Old"

				local newHumanoid = humanoid:Clone()
				newHumanoid.Parent = character
				newHumanoid.Name = "Humanoid"
				newHumanoid.DistanceDisplayType = Enum.HumanoidDisplayDistanceType.None

				RunService.Stepped:Wait()
				humanoid:Destroy()
				camera.CameraSubject = character

				local tool = getTool()
				tool.Parent = character
				character:SetPrimaryPartCFrame(targetHumanoidRootPart.CFrame * CFrame.new(
					math.random(-100, 100) / 200,
					math.random(-100, 100) / 200,
					math.random(-100, 100) / 200
					))

				local connection
				local lastCycle = 0
				local cycles = 0
				connection = RunService.RenderStepped:Connect(function()
					local deltaTime = tick() - lastCycle

					if deltaTime >= 0.1 then
						cycles = cycles + 1
						character:SetPrimaryPartCFrame(targetHumanoidRootPart.CFrame)
					end

					if not tool or not tool.Parent then
						connection:Disconnect()
					end
				end)
			end
		end
	end
end


local Color3 = setmetatable({
	toHex = function(color3)
		local result = "#"

		for _, element in ipairs({color3.r, color3.g, color3.b}) do
			local hex = ""
			element = element * 255

			while element > 0 do
				local index = math.fmod(element, 16) + 1
				element = math.floor(element / 16)
				hex = ("0123456789abcdef"):sub(index, index) .. hex			
			end

			if #hex == 0 then
				hex = "00"
			elseif #hex == 1 then
				hex = "0" .. hex
			end

			result = result .. hex
		end
		return result
	end;

	fromHex = function(hex)
		hex = hex:gsub("#","")
		return Color3.fromRGB(
			tonumber("0x" .. hex:sub(1, 2)),
			tonumber("0x" .. hex:sub(3, 4)),
			tonumber("0x" .. hex:sub(5, 6))
		)
	end;
}, {__index = Color3})


local Themes = {
	light = {
		controlAlignment = Enum.HorizontalAlignment.Left,
		controlRoundness = UDim.new(0.5, 0),
		roundness = UDim.new(0, 5),
		background = Color3.fromRGB(235, 235, 240),
		headerBackground = Color3.fromRGB(235, 235, 240),
		text = Color3.fromRGB(0, 0, 0),
		textBox = Color3.fromRGB(84, 84, 86),
		boxPrefix = Color3.fromRGB(0, 0, 0),
		suggestion = Color3.fromRGB(174, 174, 178),
		--controlBackgroundTransparency = 0,
		--controlIconTransparency = 1,
		transparency = 0.01,
		shadow = true,
	},

	dark = {
		controlAlignment = Enum.HorizontalAlignment.Left,
		controlRoundness = UDim.new(0.5, 0),
		roundness = UDim.new(0, 5),
		background = Color3.fromRGB(36, 36, 38),
		headerBackground = Color3.fromRGB(36, 36, 38),
		text = Color3.fromRGB(255, 255, 255),
		textBox = Color3.fromRGB(216, 216, 220),
		boxPrefix = Color3.fromRGB(255, 255, 255),
		suggestion = Color3.fromRGB(174, 174, 178),
		--controlBackgroundTransparency = 0,
		--controlIconTransparency = 1,
		transparency = 0.01,
		shadow = true,
	},

	dracula = {
		controlAlignment = Enum.HorizontalAlignment.Left,
		controlRoundness = UDim.new(0.5, 0),
		roundness = UDim.new(0, 5),
		background = Color3.fromRGB(40, 42, 54),
		headerBackground = Color3.fromRGB(40, 42, 54),
		text = Color3.fromRGB(248, 248, 242),
		textBox = Color3.fromRGB(241, 250, 140),
		boxPrefix = Color3.fromRGB(255, 121, 198),
		suggestion = Color3.fromRGB(174, 174, 178),
		--controlBackgroundTransparency = 0,
		--controlIconTransparency = 1,
		transparency = 0.01,
		shadow = true,
	},

	materialDark = {
		controlAlignment = Enum.HorizontalAlignment.Right,
		controlRoundness = UDim.new(0.5, 0),
		roundness = UDim.new(0, 5),
		background = Color3.fromRGB(40, 42, 52),
		headerBackground = Color3.fromRGB(40, 42, 52),
		text = Color3.fromRGB(127, 169, 92),
		textBox = Color3.fromRGB(155, 78, 85),
		boxPrefix = Color3.fromRGB(127, 92, 194),
		suggestion = Color3.fromRGB(174, 174, 178),
		--controlBackgroundTransparency = 0,
		--controlIconTransparency = 1,
		transparency = 0.01,
		shadow = true,
	},

	radical = {
		controlAlignment = Enum.HorizontalAlignment.Left,
		controlRoundness = UDim.new(0.5, 0),
		roundness = UDim.new(0, 5),
		background = Color3.fromRGB(20, 19, 35),
		headerBackground = Color3.fromRGB(20, 19, 35),
		text = Color3.fromRGB(248, 248, 242),
		textBox = Color3.fromRGB(140, 225, 213),
		boxPrefix = Color3.fromRGB(98, 120, 131),
		suggestion = Color3.fromRGB(174, 174, 178),
		--controlBackgroundTransparency = 0,
		--controlIconTransparency = 1,
		transparency = 0.01,
		shadow = true,
	},

	aero = {
		controlAlignment = Enum.HorizontalAlignment.Right,
		controlRoundness = UDim.new(0, 0),
		roundness = UDim.new(0, 0),
		background = Color3.fromRGB(31, 31, 31),
		headerBackground = Color3.fromRGB(31, 31, 31),
		text = Color3.fromRGB(235, 235, 235),
		textBox = Color3.fromRGB(210, 210, 210),
		boxPrefix = Color3.fromRGB(255, 255, 255),
		suggestion = Color3.fromRGB(178, 178, 178),
		--controlBackgroundTransparency = 1,
		--controlIconTransparency = 0,
		transparency = 0.5,
		shadow = false,
	},

	omega = {
		controlAlignment = Enum.HorizontalAlignment.Right,
		controlRoundness = UDim.new(0, 0),
		roundness = UDim.new(0, 0),
		background = Color3.fromRGB(46, 46, 47),
		headerBackground = Color3.fromRGB(36, 36, 37),
		text = Color3.fromRGB(235, 235, 235),
		textBox = Color3.fromRGB(210, 210, 210),
		boxPrefix = Color3.fromRGB(255, 255, 255),
		suggestion = Color3.fromRGB(178, 178, 178),
		--controlBackgroundTransparency = 0,
		--controlIconTransparency = 1,
		transparency = 0,
		shadow = true,
	},

	synapse = {
		controlAlignment = Enum.HorizontalAlignment.Right,
		controlRoundness = UDim.new(0, 0),
		roundness = UDim.new(0, 0),
		background = Color3.fromRGB(30, 30, 30),
		headerBackground = Color3.fromRGB(61, 61, 61),
		text = Color3.fromRGB(235, 235, 235),
		textBox = Color3.fromRGB(210, 210, 210),
		boxPrefix = Color3.fromRGB(255, 255, 255),
		suggestion = Color3.fromRGB(178, 178, 178),
		--controlBackgroundTransparency = 0,
		--controlIconTransparency = 1,
		transparency = 0,
		shadow = true,
	},

	hacker = {
		controlAlignment = Enum.HorizontalAlignment.Right,
		controlRoundness = UDim.new(0, 0),
		roundness = UDim.new(0, 0),
		background = Color3.fromRGB(5, 5, 5),
		headerBackground = Color3.fromRGB(0, 0, 0),
		text = Color3.fromRGB(0, 255, 0),
		textBox = Color3.fromRGB(0, 170, 0),
		boxPrefix = Color3.fromRGB(0, 240, 0),
		suggestion = Color3.fromRGB(0, 100, 0),
		--controlBackgroundTransparency = 0,
		--controlIconTransparency = 1,
		transparency = 0,
		shadow = true,
	},
}

Themes.custom = runningArguments[3] or Themes.aero


local PlayerTypes = {
	{
		calls = {"me", "myself", "i", "@p"},
		process = function(command, parameter)
			return {localPlayer}
		end
	},

	{
		calls = {"all", "everyone", "@a", "@e", "@everyone"},
		process = function(command, parameter)
			return Players:GetPlayers()
		end
	},

	{
		calls = {"others", "everyoneElse", "@s"},
		process = function(command, parameter)
			local targets = {}
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					targets[#targets+1] = player
				end
			end
			return targets
		end
	},

	{
		calls = {"random", "rand", "@r"},
		process = function(command, parameter)
			local players = Players:GetPlayers()
			local targets = {}
			for i = 1, tonumber(parameter) or 1 do
				local choice
				repeat 
					choice = players[math.random(1, #players)]
				until not table.find(targets, choice)
			end
			return targets
		end
	},

	{
		calls = {"bacons", "baconHairs"},
		process = function(command, parameter)
			local targets = {}
			for _, player in ipairs(Players:GetPlayers()) do
				local character = player.Character
				if character and character:FindFirstChild("Pal Hair") then
					targets[#targets+1] = player
				end
			end
			return targets
		end
	},

	{
		calls = {"nearest"},
		process = function(command, parameter)
			local targets = {}
			local localCharacter = localPlayer.Character
			if localCharacter then
				for i = 1, tonumber(parameter) or 1 do
					local closestDistance, closestPlayer
					for _, player in ipairs(Players:GetPlayers()) do
						local character = player.Character
						if player ~= localPlayer and not table.find(targets, player) and character and character.PrimaryPart then
							local distance = localPlayer.DistanceFromCharacter(character.PrimaryPart.Position)
							if not closestDistance or distance < closestDistance then
								closestDistance = distance
								closestPlayer = Players
							end
						end
					end
					if closestPlayer then
						targets[#targets+1] = closestPlayer
					end
				end
			end
			return targets
		end
	},

	{
		calls = {"farthest"},
		process = function(command, parameter)
			local targets = {}
			local localCharacter = localPlayer.Character
			if localCharacter then
				for i = 1, tonumber(parameter) or 1 do
					local farthestDistance, farthestPlayer
					for _, player in ipairs(Players:GetPlayers()) do
						local character = player.Character
						if player ~= localPlayer and not table.find(targets, player) and character and character.PrimaryPart then
							local distance = localPlayer.DistanceFromCharacter(character.PrimaryPart.Position)
							if not farthestDistance or distance > farthestDistance then
								farthestDistance = distance
								farthestPlayer = Players
							end
						end
					end
					if farthestPlayer then
						targets[#targets+1] = farthestPlayer
					end
				end
			end
			return targets
		end
	},

	{
		calls = {"userId"},
		process = function(command, parameter)
			return {Players:GetPlayerByUserId(tonumber(parameter))}
		end
	},

	{
		calls = {"group"},
		process = function(command, parameter)
			local targets = {}
			for _, player in ipairs(Players:GetPlayers()) do
				if player:IsInGroup(tonumber(parameter)) then
					targets[#targets+1] = player
				end
			end
			return targets
		end
	},

	{
		calls = {"team", "onTeam", "ofTeam"},
		process = function(command, parameter)
			for _, team in ipairs(Teams:GetTeams()) do
				if team.Name:sub(1, #parameter):lower() == parameter:lower() then
					return team:GetPlayers()
				end
			end
		end
	},

	{
		calls = {"premium"},
		process = function(command, parameter)
			local targets = {}
			for _, player in ipairs(Players:GetPlayers()) do
				if player.MembershipType == Enum.MembershipType.Premium then
					targets[#targets+1] = player
				end
			end
			return targets
		end
	},

	{
		calls = {"accountAge", "age"},
		process = function(command, parameter)
			local targets = {}
			local age = tonumber(parameter)
			for _, player in ipairs(Players:GetPlayers()) do
				if player.MembershipType == age then
					targets[#targets+1] = player
				end
			end
			return targets
		end
	},
}


local ArgumentTypes = {
	{
		calls = {"string", "raw"},
		expandable = true,
		process = function(argument)
			return argument.raw
		end
	},

	{
		calls = {"int", "integer"},
		process = function(argument)
			return math.floor(tonumber(argument.raw) or 0)
		end
	},

	{
		calls = {"number"},
		process = function(argument)
			return tonumber(argument.raw) or 0
		end
	},

	{
		calls = {"boolean", "bool", "setting"},
		process = function(argument)
			argument = argument.raw:lower()
			return (argument == "on" or argument == "true" or argument == "yes" or argument == "1") or false
		end
	},

	{
		calls = {"player(s)", "target(s)", "players", "targets"},
		process = function(argument, modifier, commandSystem)
			return commandSystem:getTargets(argument)
		end
	},

	{
		calls = {"player", "target", "individual"},
		process = function(argument, modifier, commandSystem)
			return commandSystem:getTargets(argument)[1]
		end
	},

	{
		calls = {"color", "colour"},
		process = function(argument, modifier, commandSystem)
			local raw = argument and argument.raw or ""
			if raw:sub(1, 1) == "#" then
				return Color3.fromHex(raw)
			end
			if argument and #argument.segments == 3 then
				return Color3.fromRGB(
					tonumber(argument.segments[1]),
					tonumber(argument.segments[2]),
					tonumber(argument.segments[3])
				)
			end
		end
	},

	{
		calls = {"theme"},
		expandable = true,
		process = function(argument, modifier, commandSystem)
			for name, theme in pairs(Themes) do
				if name:lower() == argument.raw:lower() then
					return theme
				end
			end
			commandSystem:notify(("\"%s\" is not a valid theme"):format(argument.raw))
			return commandSystem.themeSyncer.currentTheme
		end
	},

	{
		calls = {"command", "cmd"},
		process = function(argument, modifier, commandSystem)
			local command = commandSystem:findCommand(argument.raw or "")
			if not command then
				commandSystem:notify(("\"%s\" is not a valid command"):format(argument.raw))
				return commandSystem.commands[1]
			else
				return command
			end
		end
	},

	{
		calls = {"enum", "enumItem"},
		process = function(argument, modifier, commandSystem)
			local enumType, defaultItem = unpack(modifier:gsub(" ", ""):split(","))
			local enumItem

			for index, item in ipairs(Enum[enumType]:GetEnumItems()) do
				local elements = tostring(item):split(".")
				local name = elements[#elements]

				if argument.raw:lower() == name:lower():sub(1, #argument.raw) or (tonumber(argument.raw) and tonumber(argument.raw) == index) then
					return item
				end
			end

			return defaultItem and enumType[defaultItem] or enumType:GetEnumItems()[1]
		end
	},

	{
		calls = {"options", "selection", "enumeration"},
		process = function(argument, modifier, commandSystem)
			local options = modifier:gsub(" ", ""):split(",")

			for _, option in ipairs(options) do
				if argument.raw:lower() == option:lower():sub(1, #argument.raw) then
					return option
				end
			end
		end
	},

	{
		calls = {"tuple", "group"},
		process = function(argument, modifier, commandSystem)
			-- TODO: make tuples work
			local options = modifier:gsub(" ", ""):split(",")
			local tuple = {}

			for index, option in ipairs(options) do
				tuple[option] = argument.segments[index]
			end

			return tuple
		end
	}
}


local Commands = {
	{
		name = "echo",
		terminalCommand = true,
		description = "Outputs the given message",
		arguments = {
			{
				name = "message",
				type = "string"
			}
		},
		process = function(self, arguments, commandSystem)
			commandSystem.terminal:addText(arguments.message)
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.terminal:addText(arguments.message:reverse())
		end
	},

	{
		name = "theme",
		description = "Changes the theme of the interface",
		arguments = {
			{
				name = "theme",
				type = "theme"
			}
		},
		process = function(self, arguments, commandSystem)
			commandSystem.windowHandler.themeSyncer:updateTheme(arguments.theme)
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.windowHandler.themeSyncer:updateTheme(Themes.white)
		end
	},

	{
		name = "terminal",
		description = "Opens a new terminal",
		terminalCommand = true,
		arguments = {},
		process = function(self, arguments, commandSystem)
			commandSystem.terminal = commandSystem.classes.Terminal.new(commandSystem.windowHandler)
		end,
	},

	{
		name = "advertise",
		description = "Advertises rCMD. Thanks for the support!",
		aliases = {"adv"},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("advertise") then
				commandSystem.cache:get("advertise"):Disconnect()
				commandSystem.cache:remove("advertise")
			end

			RunService.RenderStepped:Wait()

			local message = "Get rCMD: The best admin script! Our disquord is FYYET36!"
			local updateThreshold = 5
			local lastMessage = 0
			commandSystem.cache:set("advertise", RunService.RenderStepped:Connect(function()
				local deltaTime = tick() - lastMessage
				if deltaTime >= updateThreshold then
					ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
					lastMessage = tick()
				end
			end))
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.cache:get("advertise"):Disconnect()
			commandSystem.cache:remove("advertise")
		end
	},

	{
		name = "safeChat",
		description = "Toggles Roblox's Safe-Chat",
		aliases = {"setSafeChat"},
		arguments = {
			{
				name = "enabled",
				type = "bool"
			}	
		},
		process = function(self, arguments, commandSystem)
			localPlayer:SetSuperSafeChat(arguments.enabled)
		end,
	},

	{
		name = "framesPerSecond",
		description = "Displays your FPS",
		aliases = {"FPS"},
		process = function(self, arguments, commandSystem)
			commandSystem:notify("You are playing at " .. commandSystem.performanceMonitor.framesPerSecond .. " frames per second")
		end,
	},

	{
		name = "capFPS",
		description = "Throttles your FPS",
		aliases = {"throttleFPS", "setFPS"},
		arguments = {
			{
				name = "fps",
				type = "int",
			}
		},
		process = function(self, arguments, commandSystem)
			local existingCap = commandSystem.cache:get("fpsCap")
			if existingCap then
				existingCap:Disconnect()
				commandSystem.cache:remove("mimic")
			end

			local maxFps = arguments.fps
			commandSystem.cache:set("fpsCap", RunService.RenderStepped:Connect(function()
				local start = tick()
				repeat until (start + 1/maxFps) < tick()
			end))
		end,
		reverseProcess = function(self, arguments, commandSystem)
			local cap = commandSystem.cache:get("fpsCap")
			if cap then
				cap:Disconnect()
				commandSystem.cache:remove("mimic")
			end
		end
	},

	{
		name = "mimic",
		description = "Does a chat mimic",
		aliases = {"copyCat"},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("mimic") then
				commandSystem.cache:remove("mimic")
			end

			local messageFormat = "[%s]: %s"
			local connections = {}
			local function addPlayer(player)
				if not player == localPlayer then
					connections[#connections+1] = player.Chatted:Connect(function(message)
						if not commandSystem.cache:get("mimic") then
							commandSystem.cache:remove("mimic")
							for _, connection in ipairs(connections) do
								connection:Disconnect()
							end
						end

						ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(messageFormat:format(player.Name, message), "All")
					end)
				end
			end

			for _, player in ipairs(Players:GetPlayers()) do
				addPlayer(player)
			end
			connections[#connections+1] = Players.PlayerAdded:Connect(addPlayer)
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.cache:remove("mimic")
		end
	},

	{
		name = "themes",
		description = "Displays a list of available themes",
		process = function(self, arguments, commandSystem)
			local listData = {}
			for name, theme in pairs(Themes) do
				listData[#listData+1] = {name}
			end
			commandSystem:createList("Themes", listData)
		end,
	},

	{
		name = "rejoin",
		description = "Allows you to rejoin the game",
		process = function(self, arguments, commandSystem)
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
		end,
	},

	{
		name = "close",
		description = "Closes  (until executed again)",
		process = function(self, arguments, commandSystem)
			commandSystem:shutdown()
		end,
	},

	{
		name = "exit",
		description = "Closes the Roblox client",
		process = function(self, arguments, commandSystem)
			game:Shutdown()
		end,
	},

	{
		name = "help",
		description = "Gives some help",
		aliases = {"info"},
		arguments = {
			{
				name = "command",
				type = "command",
				optional = true
			}
		},
		process = function(self, arguments, commandSystem)
			if not arguments.command then
				local help = {
					"rCMD " .. VERSION,
					"Your executor is " .. getExecutor(),
					"Filtering is " .. (Workspace.FilteringEnabled and "enabled" or "disabled"),
					"This script is running at level " .. getIdentity(),
					"To view a list of commands, enter \"cmds\"",
					"To view info on a specific command, enter \"help [command]\"",
					"If you require further assistance, contact us",
					"To report issues, create one on our repository.",
					"You may also contrubute to rCMD there.",
					"rCMD's Repository: https://github.com/senselessdemon/rcmd",
					"Our Discord server: https://discord.io/demonden"
				}
				commandSystem:createList("Help", help, UDim2.new(0, 375, 0, 250))
			else
				local command = arguments.command
				if command.hidden and not arguments.core.force then
					return commandSystem:error("I do not understand what command you are talking about bro")
				end

				local arguments = {}
				for index, argument in ipairs(command.arguments or {}) do
					local display = (argument.optional and "" or "*") .. argument.name
					if argument.type then
						display = display .. "[" .. argument.type .. "]"
					end
					arguments[index] = display
				end
				if arguments == {} then
					arguments = {"none"}
				end

				local data = {
					"Name: " .. (command.name or "none"),
					"Description: " .. (command.description or "none"),
					"Aliases: { " .. table.concat(command.aliases or {"none"}, ", ") .. " }",
					"Opposites: { " .. table.concat({"un"..command.name, unpack(command.opposites or {})}, ", ") .. " }",
					"Arguments: { " .. table.concat(arguments, ", ") .. " }",
					"Replicates: " .. (command.noReplication and "no" or "yes"),
					"Reversable: " .. (command.reverseProcess and "yes" or "no")
				}
				commandSystem:createList("Command Info", data)
			end
		end,
	},

	{
		name = "commands",
		description = "Displays a list of available commands",
		aliases = {"cmds"},
		process = function(self, arguments, commandSystem)
			local listData = {}
			for _, command in pairs(commandSystem.commands) do
				if not command.hidden then
					--commandSystem.terminal:addText(("%s - %s"):format(command.name, command.description or "No description"))
					listData[#listData+1] = {command.name, command.description or "No description"}
				end
			end
			commandSystem:createList("Commands", listData)
		end,
	},

	{
		name = "directory",
		description = "Displays the children of a directory",
		aliases = {"dir", "ls"},
		process = function(self, arguments, commandSystem)
			local function getChildren()
				if commandSystem.location == game then
					return {{Name="Cannot get children of this instnace"}} -- lol
				end
				return commandSystem.location:GetChildren()
			end

			for _, child in ipairs(getChildren()) do
				commandSystem.terminal:addText(child.Name)
			end
		end,
	},

	{
		name = "changeDirectory",
		description = "Changes the directory",
		aliases = {"cd"},
		arguments = {
			{
				name = "child",
				type = "string"
			}
		},
		process = function(self, arguments, commandSystem)
			for _, givenChild in ipairs(arguments.child:split("/")) do
				local newLocation

				if commandSystem.location == game then
					newLocation = game[givenChild]
				else
					for _, child in ipairs(commandSystem.location:GetChildren()) do
						if child.Name:sub(1, #givenChild):lower() == givenChild:lower() then
							newLocation = child
						end
					end
				end

				if newLocation then
					commandSystem.location = newLocation
				end
			end
		end,
	},

	{
		name = "rename",
		description = "Changes the given object to the given name",
		aliases = {"ren"},
		arguments = {
			{
				name = "object",
				type = "string"
			},
			{
				name = "name",
				type = "string"
			}
		},
		process = function(self, arguments, commandSystem)
			local object

			if commandSystem.location == game then
				object = game[arguments.object]
			else
				for _, child in ipairs(commandSystem.location:GetChildren()) do
					if child.Name:sub(1, #arguments.object):lower() == arguments.object:lower() then
						object = child
					end
				end
			end

			if object then
				object.Name = arguments.name
			end
		end,
	},

	{
		name = "changeDirectory..",
		description = "Changes the directory to the parent",
		aliases = {"cd..", "changeDirectory\\", "cd\\"},
		process = function(self, arguments, commandSystem)
			commandSystem.location = commandSystem.location.Parent
		end,
	},

	{
		name = "makeDirectory",
		description = "Creates a directory at the current location",
		aliases = {"mkdir"},
		arguments = {
			{
				name = "name",
				type = "string"
			}
		},
		process = function(self, arguments, commandSystem)
			local directory = Instance.new("Folder", commandSystem.location)
			directory.Name = arguments.name
		end,
	},

	{
		name = "create",
		description = "Creates an instance of the given class",
		aliases = {"touch", "make"},
		arguments = {
			{
				name = "class",
				type = "string"
			},
			{
				name = "name",
				type = "string"
			},
		},
		process = function(self, arguments, commandSystem)
			local object = Instance.new(arguments.class, commandSystem.location)
			if arguments.name and arguments.name ~= "" then
				object.Name = arguments.name
			end
		end,
	},

	{
		name = "removeDirectory",
		description = "Removes a directory at the current location",
		aliases = {"rm", "rmdir"},
		arguments = {
			{
				name = "name",
				type = "string"
			}
		},
		process = function(self, arguments, commandSystem)
			local toDelete

			for _, child in ipairs(commandSystem.location:GetChildren()) do
				if child.Name:sub(1, #arguments.child):lower() == arguments.child:lower() then
					toDelete = child
				end
			end

			if toDelete then
				toDelete:Destroy()
			end
		end,
	},

	{
		name = "displayLocation",
		description = "Displays the current location",
		aliases = {"pwd"},
		process = function(self, arguments, commandSystem)
			commandSystem.terminal:addText(commandSystem.location:GetFullName())
		end,
	},

	{
		name = "lua",
		terminalCommand = true,
		description = "Allows the executing of lua code",
		aliases = {"loadstring"},
		process = function(self, arguments, commandSystem)
			commandSystem.terminal:addText("Lua 5.1\nType \"exit\" to exit")

			local done = false
			local function execute()
				local prompt = commandSystem.terminal:addPrompt(">", function(code)
					if not code:lower():find("exit") then
						local didParse, parseResult = pcall(loadstring, code)

						if didParse then
							local didExecute, executeResult = pcall(parseResult, commandSystem)

							if didExecute then
								if executeResult and executeResult ~= "" then
									commandSystem.terminal:addText(tostring(executeResult))
								end
							else
								commandSystem.terminal:addText(executeResult)
							end
						else
							commandSystem.terminal:addText(parseResult)
						end
						execute()
					else
						done = true
					end
				end)
			end

			execute()
			repeat wait() until done
		end,
	},

	{
		name = "loadstring",
		description = "Executes the given string as lua",
		aliases = {"script", "s"},
		arguments = {
			{
				name = "code",
				type = "string"
			}	
		},
		process = function(self, arguments, commandSystem)
			local didParse, parseResult = pcall(loadstring, arguments.code)

			if didParse then
				local didExecute, executeResult = pcall(parseResult, commandSystem)

				if didExecute then
					if executeResult and executeResult ~= "" then
						commandSystem:notify(tostring(executeResult))
					end
				else
					commandSystem:error(executeResult)
				end
			else
				commandSystem:error(parseResult)
			end
		end,
	},

	{
		name = "loadScript",
		description = "Executes the script at the given url",
		aliases = {"loadHttp"},
		arguments = {
			{
				name = "url",
				type = "string"
			}	
		},
		process = function(self, arguments, commandSystem)
			local didGet, getResult = pcall(game.HttpGet, game, arguments.url)
			if didGet then
				local didParse, parseResult = pcall(loadstring, arguments.code)
				if didParse then
					local didExecute, executeResult = pcall(parseResult, commandSystem)
					if didExecute then
						if executeResult and executeResult ~= "" then
							commandSystem:notify(tostring(executeResult))
						end
					else
						commandSystem:error(executeResult)
					end
				else
					commandSystem:error(parseResult)
				end
			else
				commandSystem:error(("Unable to make a GET request to \"%s\""):format(arguments.url))
			end
		end,
	},

	{
		name = "chatLogs",
		description = "Displays the chat logs",
		aliases = {"logs"},
		process = function(self, arguments, commandSystem)
			local logs = {}
			for _, log in ipairs(commandSystem.logger.logs.chat) do
				local timestamp, player, message = unpack(log)
				logs[#logs+1] = {("[%s]: %s"):format(tostring(player), message), timestamp}
			end

			local list = commandSystem:createList("Chat Logs", logs)
			if list then
				local addConnection = commandSystem.logger.logAdded:connect(function(type, player, message)
					if type == "chat" then
						list:addItem(("[%s]: %s"):format(tostring(player), message), tick())
					end
				end)

				list.window.closed:connect(function()
					addConnection:disconnect()
				end)
			end
		end,
	},

	{
		name = "joinLogs",
		description = "Displays the join logs",
		aliases = {"jlogs"},
		process = function(self, arguments, commandSystem)
			local logs = {}
			for _, log in ipairs(commandSystem.logger.logs.join) do
				local timestamp, player = unpack(log)
				logs[#logs+1] = {tostring(player), timestamp}
			end

			local list = commandSystem:createList("Join Logs", logs)
			if list then
				local addConnection = commandSystem.logger.logAdded:connect(function(type, player)
					if type == "join" then
						list:addItem(tostring(player), tick())
					end
				end)

				list.window.closed:connect(function()
					addConnection:disconnect()
				end)
			end
		end,
	},

	{
		name = "leaveLogs",
		description = "Displays the leave logs",
		aliases = {"llogs"},
		process = function(self, arguments, commandSystem)
			local logs = {}
			for _, log in ipairs(commandSystem.logger.logs.join) do
				local timestamp, player = unpack(log)
				logs[#logs+1] = {tostring(player), timestamp}
			end

			local list = commandSystem:createList("Leave Logs", logs)
			if list then
				local addConnection = commandSystem.logger.logAdded:connect(function(type, player)
					if type == "leave" then
						list:addItem(tostring(player), tick())
					end
				end)

				list.window.closed:connect(function()
					addConnection:disconnect()
				end)
			end
		end,
	},

	{
		name = "clientLogs",
		description = "Displays the client logs",
		aliases = {"clogs"},
		process = function(self, arguments, commandSystem)
			local logs = {}
			for _, log in ipairs(commandSystem.logger.logs.client) do
				local timestamp, message = unpack(log)
				logs[#logs+1] = {tostring(message), timestamp}
			end

			local list = commandSystem:createList("Client Logs", logs)
			if list then
				local addConnection = commandSystem.logger.logAdded:connect(function(type, message)
					if type == "client" then
						list:addItem(tostring(message), tick())
					end
				end)

				list.window.closed:connect(function()
					addConnection:disconnect()
				end)
			end
		end,
	},

	{
		name = "systemLogs",
		description = "Displays rCMD's logs",
		aliases = {"rLogs", "rCMDLogs"},
		process = function(self, arguments, commandSystem)
			local logs = {}
			for _, log in ipairs(commandSystem.logger.logs.system) do
				local timestamp, message = unpack(log)
				logs[#logs+1] = {tostring(message), timestamp}
			end

			local list = commandSystem:createList("Client Logs", logs)
			if list then
				local addConnection = commandSystem.logger.logAdded:connect(function(type, message)
					if type == "system" then
						list:addItem(tostring(message), tick())
					end
				end)

				list.window.closed:connect(function()
					addConnection:disconnect()
				end)
			end
		end,
	},

	{
		name = "remoteSpy",
		description = "Executes a remote-spy script",
		process = function(self, arguments, commandSystem)
			commandSystem:executeCommandByCall("loadScript", {
				url = "https://raw.githubusercontent.com/Nootchtai/FrostHook_Spy/master/Spy.lua"
			}, true)
		end
	},

	{
		name = "alignCommandBar",
		terminalCommand = false,
		aliases = {"alignCmdBar"},
		arguments = {
			{
				name = "alignment",
				type = "Enum<VerticalAlignment>"
			}
		},
		process = function(self, arguments, commandSystem)
			if commandSystem.commandBar then
				commandSystem.commandBar.alignment = arguments.alignment
			end
		end
	},

	{
		name = "walkSpeed",
		description = "Sets the local character's speed",
		aliases = {"ws", "speed", "wSpeed"},
		arguments = {
			{
				name = "speed",
				type = "number"
			}
		},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					commandSystem.cache:set("lastSpeed", humanoid.WalkSpeed)
					humanoid.WalkSpeed = arguments.speed
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.WalkSpeed = commandSystem.cache:get("lastSpeed") or 16
				end
			end
		end
	},

	{
		name = "jumpPower",
		description = "Sets the local character's jump power",
		aliases = {"jp", "jPower"},
		arguments = {
			{
				name = "power",
				type = "number"
			}
		},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					commandSystem.cache:set("lastJumpPower", humanoid.JumpPower)
					humanoid.JumpPower = arguments.power
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.JumpPower = commandSystem.cache:get("lastJumpPower") or 50
				end
			end
		end
	},

	{
		name = "invisiblility",
		noReplication = true,
		description = "Sets the local character's invisibility",
		aliases = {"invisible"},
		arguments = {
			{
				name = "enabled",
				type = "boolean"
			}
		},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local transparency = arguments.enabled and 1 or 0
				for _, child in ipairs(character:GetChildren()) do
					if child:IsA("BasePart") then
						child.Transparency = transparency
						if child:FindFirstChild("face") then
							child.face.Transparency = transparency
						end
					elseif child:IsA("Accoutrement") or child:FindFirstChild("Handle") then
						child.Handle.Transparency = transparency
					elseif child.Name == "Head" then
						local face = child:FindFirstChildOfClass("Decal")
						if face then
							face.Transparency = transparency
						end
					end
				end
			end
		end,
	},

	{
		name = "fireClickDetectors",
		description = "Fires all the click detectors",
		aliases = {"fireCD", "fireCDs"},
		process = function(self, arguments, commandSystem)
			if fireclickdetector then
				for _, descendant in ipairs(Workspace:GetDescendants()) do
					if descendant:IsA("ClickDetector") then
						fireclickdetector(descendant)
					end
				end
			else
				commandSystem:error("Your exploit does not support the firing of click-detectors")
			end
		end
	},

	{
		name = "naked",
		description = "Makes the local character naked",
		aliases = {"nude"},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				for _, child in ipairs(character:GetChildren()) do
					if child:IsA("Clothing") or child:IsA("ShirtGraphic") then
						child:Destroy()
					end
				end
			end
		end
	},

	{
		name = "virtualReality",
		description = "Makes the local character VR",
		aliases = {"vr"},
		process = function(self, arguments, commandSystem)
			commandSystem:executeCommandByCall("loadScript", {
				url = "https://ghostbin.co/paste/yb288/raw"
			}, true)
		end
	},

	{
		name = "console",
		description = "Loads the old Roblox console",
		aliases = {"vr"},
		process = function(self, arguments, commandSystem)
			commandSystem:executeCommandByCall("loadScript", {
				url = "https://pastebin.com/raw/i35eCznS"
			}, true)
		end
	},

	{
		name = "dataLimit",
		description = "Sets a data-limit (killobytes per second)",
		aliases = {"setDataLimit"},
		arguments = {
			{
				name = "kbps",
				type = "number"
			}
		},
		process = function(self, arguments, commandSystem)
			NetworkClient:SetOutgoingKBPSLimit(arguments.kbps)
		end
	},

	{
		name = "blockPurchasePrompts",
		opposites = {"displayPurchasePrompt"},
		description = "Blocks the Roblox purchase prompts",
		process = function(self, arguments, commandSystem)
			CoreGui.PurchasePromptUI.Visible = false
		end,
		reverseProcess = function(self, arguments, commandSystem)
			CoreGui.PurchasePromptUI.Visible = true
		end
	},

	{
		name = "split",
		description = "Splits the local character",
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local upperTorso = character:FindFirstChild("UpperTorso")
				if upperTorso then
					upperTorso.Waist:Destroy()
				end
			end
		end
	},

	{
		name = "friend",
		description = "Friends the given player(s)",
		arguments = {
			{
				name = "targets",
				type = "player(s)"
			}
		},
		process = function(self, arguments, commandSystem)
			for _, target in ipairs(arguments.targets) do
				if target ~= localPlayer then
					localPlayer:RequestFriendship(target)
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			for _, target in ipairs(arguments.targets) do
				if target ~= localPlayer then
					localPlayer:RevokeFriendship(target)
				end
			end
		end
	},

	{
		name = "chat",
		description = "Chats the given message",
		aliases = {"speak"},
		arguments = {
			{
				name = "message",
				type = "string"
			}
		},
		process = function(self, arguments, commandSystem)
			ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(arguments.message or "lol", "All") -- lol
		end,
	},

	{
		name = "respawn",
		description = "Respawns the local character",
		aliases = {"res"},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			character:ClearAllChildren()
			localPlayer.Character = Instance.new("Model", workspace)

			RunService.RenderStepped:Wait()
			localPlayer.Character = character
		end,
	},

	{
		name = "refresh",
		description = "Refreshed the local character",
		aliases = {"re"},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local location = character:GetPrimaryPartCFrame()
				commandSystem:executeCommandByCall("respawn", {}, true)

				RunService.RenderStepped:Wait()
				local humanoidRootPart = localPlayer:WaitForChild("HumanoidRootPart")
				localPlayer:SetPrimaryPartCFrame(location)
			end
		end,
	},

	{
		name = "teleport",
		description = "Teleports the given player(s) to the destination",
		aliases = {"tp"},
		arguments = {
			{
				name = "to",
				type = "player"
			},
			{
				name = "from",
				type = "player(s)"
			},
		},
		process = function(self, arguments, commandSystem)
			local player = self.to
			if player then
				local character1 = player.Character
				if character1 and character1.PrimaryPart then
					for _, target in ipairs(arguments.from) do
						local character2 = target.Character
						if character2 then
							character2:SetPrimaryPartCFrame(character1.PrimaryPart.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
						end
					end
				end
			end
		end,
	},

	{
		name = "reduceLag",
		description = "Reguces lag",
		aliases = {"antiLag", "boostFPS"},
		process = function(self, arguments, commandSystem)
			local terrain = Workspace:FindFirstChildOfClass("Terrain")
			if terrain then
				terrain.WaterWaveSize = 0
				terrain.WaterWaveSpeed = 0
				terrain.WaterReflectance = 0
				terrain.WaterTransparency = 0
			end

			Lighting.GlobalShadows = 0
			Lighting.FogEnd = math.huge
			settings().Rendering.QualityLevel = 1
		end,
	},

	{
		name = "to",
		description = "Teleports you to the given player",
		aliases = {"goto", "teleportTo", "tpTo"},
		arguments = {
			{
				name = "to",
				type = "player"
			},
		},
		process = function(self, arguments, commandSystem)
			local player = localPlayer
			if player then
				local character1 = player.Character
				if character1 and character1.PrimaryPart then
					local character2 = arguments.to.Character
					if character2 and character2.PrimaryPart then
						character1:SetPrimaryPartCFrame(character2:GetPrimaryPartCFrame() + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
					end
				end
			end
		end,
	},

	{
		name = "annoy",
		description = "Annoys the given player",
		arguments = {
			{
				name = "victim",
				type = "player"
			},
		},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			local victimCharacter = arguments.victim.Character
			if arguments.victim ~= localPlayer and character and victimCharacter then
				local existingAnnoy = commandSystem.cache:get("annoy")
				if existingAnnoy then
					existingAnnoy:Disconnect()
					commandSystem.cache:remove("annoy")
				end

				RunService.RenderStepped:Wait()
				commandSystem.cache:set("annoy", RunService.RenderStepped:Connect(function()
					if character and character.PrimaryPart and victimCharacter and victimCharacter.PrimaryPart then
						character:SetPrimaryPartCFrame(CFrame.new(victimCharacter.PrimaryPart.Position, victimCharacter:FindFirstChildWhichIsA("BasePart").Position))
					end
				end))
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			local existingAnnoy = commandSystem.cache:get("annoy")
			if existingAnnoy then
				existingAnnoy:Disconnect()
				commandSystem.cache:remove("annoy")
			end
		end
	},

	{
		name = "animation",
		description = "Plays the given animation",
		aliases = {"anim"},
		arguments = {
			{
				name = "animationId",
				type = "int"
			},
			{
				name = "speed",
				type = "int",
				default = 1
			}
		},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					local existingAnimation = commandSystem.cache:get("animation")
					if existingAnimation then
						existingAnimation:Stop()
						existingAnimation:Destroy()
					end

					local animation = Instance.new("Animation")
					animation.AnimationId = "rbxassetid://" .. arguments.animationId

					local animationTrack = humanoid:LoadAnimation(animation)
					animationTrack:Play(0.1, 1, 1)
					animationTrack:AdjustSpeed(arguments.speed == 0 and 1 or arguments.speed)

					animationTrack.AncestryChanged:Connect(function(_, parent)
						if not parent then
							RunService.RenderStepped:Wait()
							animation:Destroy()
						end
					end)

					commandSystem.cache:set("animation", animationTrack)
					animationTrack:Play()
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			self.cache:remove("annoy")
		end
	},

	{
		name = "bypass",
		description = "Bypasses a chat message",
		aliases = {"chatBypass"},
		arguments = {
			{
				name = "message",
				type = "raw",
			}
		},
		process = function(self, arguments, commandSystem)
			local dictionary = {
				a = "ٴٴa",
				b = "ٴٴb",
				c = "ٴٴc",
				d = "ٴٴd",
				e = "ٴٴe",
				f = "ٴٴf",
				g = "ٴٴg",
				h = "ٴٴh",
				i = "ٴٴi",
				j = "ٴٴj",
				k = "ٴٴk",
				l = "ٴٴl",
				m = "ٴٴm",
				n = "ٴٴn",
				o = "ٴٴo",
				p = "ٴٴp",
				q = "ٴٴq",
				r = "ٴٴr",
				s = "ٴٴs",
				t = "ٴٴt",
				u = "ٴٴu",
				v = "ٴٴv",
				w = "ٴٴw",
				x = "ٴٴx",
				y = "ٴٴy",
				z = "ٴٴz"
			}

			local message = arguments.message:lower()
			for find, replace in pairs(dictionary) do
				message:gsub(find, replace)
			end

			ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
		end
	},

	{
		name = "completeNoclip",
		description = "Fully noclips the given player(s)",
		aliases = {"fullNoclip"},
		opposites = {"completeClip", "fullClip"},
		arguments = {
			{
				name = "players",
				type = "player(s)"
			},
		},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("completeNoclip") then
				commandSystem.cache:remove("completeNoclip")
			end

			local connections = {}
			for _, target in ipairs(arguments.players) do
				local character = target.Character
				if character then
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					local humanoid = character:FindFirstChild("Humanoid")
					local originalAltitude = humanoidRootPart.CFrame.Y

					if humanoidRootPart and humanoid then
						RunService.RenderStepped:Wait()
						commandSystem.cache:set("completeNoclip", true)

						connections[target] = RunService.RenderStepped:Connect(function()
							if not commandSystem.cache:get("completeNoclip") then
								return connections[target]:Disconnect()
							end

							if character and humanoid and humanoidRootPart then
								local radX, radY, radZ = camera.CFrame:ToOrientation()

								humanoidRootPart.CFrame = CFrame.new(
									humanoidRootPart.CFrame.X,
									originalAltitude,
									humanoidRootPart.CFrame.Z
								) * CFrame.fromEulerAnglesXYZ(0, radY, radZ)

								humanoid:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
							end
						end)
					end
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.cache:remove("completeNoclip")
		end
	},

	{
		name = "noclip",
		description = "Noclips the given player(s)",
		opposites = {"clip"},
		arguments = {
			{
				name = "players",
				type = "player(s)"
			},
		},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("noclip") then
				commandSystem.cache:remove("noclip")
			end

			local connections = {}
			for _, target in ipairs(arguments.players) do
				local character = target.Character
				if character then
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					local humanoid = character:FindFirstChild("Humanoid")
					local originalAltitude = humanoidRootPart.CFrame.Y

					if humanoidRootPart and humanoid then
						RunService.RenderStepped:Wait()
						commandSystem.cache:set("noclip", true)

						connections[target] = RunService.Stepped:Connect(function()
							if not commandSystem.cache:get("noclip") then
								return connections[target]:Disconnect()
							end

							if character and humanoid and humanoidRootPart then
								for _, child in ipairs(character:GetDescendants()) do
									if child:IsA("BasePart") and child.CanCollide then
										child.CanCollide = false
									end
								end
							end
						end)
					end
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.cache:remove("noclip")
		end
	},

	{
		name = "noclipFly",
		description = "Noclips and flies the given player(s)",
		aliases = {"flyNoclip"},
		opposites = {"clipFly", "flyClip"},
		arguments = {
			{
				name = "players",
				type = "player(s)"
			},
		},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("noclipFly") then
				commandSystem.cache:remove("noclipFly")
			end

			local connections = {}
			for _, target in ipairs(arguments.players) do
				local character = target.Character
				if character then
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					local humanoid = character:FindFirstChild("Humanoid")
					local originalAltitude = humanoidRootPart.CFrame.Y

					if humanoidRootPart and humanoid then
						RunService.RenderStepped:Wait()
						commandSystem.cache:set("noclipFly", true)
						connections[target] = {}

						local direction = {w = 0, s = 0, a = 0, d = 0} 
						local speed = 2 

						connections[target].keyDown = mouse.KeyDown:connect(function(key)
							if key:lower() == "w" then 
								direction.w = 1 
							elseif key:lower() == "s" then 
								direction.s = 1 
							elseif key:lower() == "a" then 
								direction.a = 1 
							elseif key:lower() == "d" then 
								direction.d = 1 
							elseif key:lower() == "q" then 
								direction = speed + 1 
							elseif key:lower() == "e" then 
								direction = speed - 1 
							end 
						end) 
						connections[target].keyUp = mouse.KeyUp:connect(function(key)
							if key:lower() == "w" then 
								direction.w = 0 
							elseif key:lower() == "s" then 
								direction.s = 0 
							elseif key:lower() == "a" then 
								direction.a = 0 
							elseif key:lower() == "d" then 
								direction.d = 0 
							end 
						end) 

						humanoidRootPart.Anchored = true 
						humanoid.PlatformStand = true 
						connections[target].changed = humanoid.Changed:connect(function() 
							humanoid.PlatformStand = true 
						end)

						connections[target].renderStepped = RunService.Stepped:Connect(function()
							if not commandSystem.cache:get("noclipFly") then
								for _, connection in pairs(connections[target]) do
									connection:Disconnect()
								end
								humanoidRootPart.Anchored = false
								humanoid.PlatformStand = false
								return
							end

							if character and humanoid and humanoidRootPart then
								character:SetPrimaryPartCFrame(CFrame.new(
									humanoidRootPart.Position,
									camera.CFrame.p) * CFrame.Angles(0,math.rad(180),0) * CFrame.new((direction.d - direction.a)*speed, 0, (direction.s - direction.w) * speed
									))
							end
						end)
					end
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.cache:remove("noclipFly")
		end
	},

	{
		name = "noRecoil",
		description = "Disables any sort of recoil",
		arguments = {
			name = "enabled",
			type = "bool"
		},
		process = function(self, arguments, commandSystem)
			local randomHook
			randomHook = hookfunction(math.random, function(a, b)
				if a and b then
					b = a
				else
					return 0
				end
				return randomHook(a, b)
			end)
		end
	},

	{
		name = "fly",
		description = "Flies the given player(s)",
		arguments = {
			{
				name = "players",
				type = "player(s)"
			},
		},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("fly") then
				commandSystem.cache:remove("fly")
			end

			local connections = {}
			for _, target in ipairs(arguments.players) do
				local character = target.Character
				if character then
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					local humanoid = character:FindFirstChild("Humanoid")
					local originalAltitude = humanoidRootPart.CFrame.Y

					if humanoidRootPart and humanoid then
						RunService.RenderStepped:Wait()

						local maxSpeed, magnitude, acceleration, direction, cframe = 100, 5, Vector3.new()
						local bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
						bodyGyro.Parent = humanoidRootPart
						bodyGyro.D = 200
						bodyGyro.CFrame = humanoidRootPart.CFrame

						local bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
						bodyVelocity.Parent = humanoidRootPart
						bodyVelocity.P = 5000

						local indicator = Instance.new("BoolValue", humanoidRootPart)
						indicator.Name = 'Fly'
						indicator.Changed:connect(function(property)
							if property then
								local force = property and Vector3.new(9e9, 9e9, 9e9) or Vector3.new()
								humanoid.PlatformStand = property
								bodyGyro.MaxTorque = force
								bodyVelocity.MaxForce = force
								connection = humanoid.Changed:connect(function(Wat)
									if not indicator.Parent then
										connection:disconnect()
									end
									humanoid.Jump = false
								end)
							else
								humanoid.PlatformStand = false
								humanoidRootPart:FindFirstChild('BodyGyro'):Destroy()
								humanoidRootPart:FindFirstChild('BodyVelocity'):Destroy()

								if indicator and indicator.Parent then
									indicator.Value = false
									indicator:Destroy()
								end
							end
						end)
						indicator.Value = true
						commandSystem.cache:set("fly", indicator)

						connections[target] = RunService.RenderStepped:Connect(function()
							if indicator.Value then
								local direction = humanoid.MoveDirection
								local cframe = camera.CoordinateFrame
								direction = (cframe:inverse() * CFrame.new(cframe.p + direction)).p
								acceleration = acceleration * 0.95
								local inABox = UserInputService:GetFocusedTextBox()
								acceleration = Vector3.new(
									math.max(-maxSpeed, math.min(maxSpeed, acceleration.x + direction.x * magnitude)),
									math.max(-maxSpeed, math.min(maxSpeed and not inABox and ((UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E)) and acceleration.y + magnitude or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.Q)) and acceleration.y - magnitude) or acceleration.y)),
									math.max(-maxSpeed, math.min(maxSpeed, acceleration.z + direction.z * magnitude))
								)
								bodyGyro.cframe = cframe
								bodyVelocity.velocity = (cframe * CFrame.new(acceleration)).p - cframe.p
							end
						end)
					end
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			local indicator = commandSystem.cache:get("fly")
			if indicator then
				indicator.Value = false
			end
		end
	},

	{
		name = "autoclick",
		description = "Autoclicks at the given speed",
		arguments = {
			{
				name = "clicksPerSecond",
				type = "int"
			},
		},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("autoClick") then
				commandSystem.cache:get("autoClick"):Disconnect()
				commandSystem.cache:remove("autoClick")
			end

			if mouse1press and mouse1release then
				RunService.RenderStepped:Wait()

				local updateThreshold = 1 / ((arguments.clicksPerSecond or 1) * 2)
				local mouseDown = false
				local lastClick = 0
				commandSystem.cache:set("autoClick", RunService.RenderStepped:Connect(function()
					local deltaTime = tick() - lastClick
					if deltaTime >= updateThreshold then
						(mouseDown and mouse1release or mouse1press)()
						mouseDown = not mouseDown
						lastClick = tick()
					end
				end))
			else
				commandSystem:error("Your exploit does not have the ability to force mouse input")
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			if commandSystem.cache:get("autoClick") then
				commandSystem.cache:get("autoClick"):Disconnect()
				commandSystem.cache:remove("autoClick")
			end
		end
	},

	{
		name = "antiIdle",
		description = "Prevents you from idling",
		arguments = {
			{
				name = "enabled",
				type = "bool"
			},
		},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("antiIdle") then
				commandSystem.cache:get("antiIdle"):Disconnect()
				commandSystem.cache:remove("antiIdle")
			end

			commandSystem.cache:set("antiIdle", VirtualUser.Idled:Connect(function()
				VirtualUser:Button2Down(Vector2.new(0,0), camera.CFrame)
				wait(1)
				VirtualUser:Button2Up(Vector2.new(0,0), camera.CFrame)
			end))
		end,
		reverseProcess = function(self, arguments, commandSystem)
			if commandSystem.cache:get("antiIdle") then
				commandSystem.cache:get("antiIdle"):Disconnect()
				commandSystem.cache:remove("antiIdle")
			end
		end
	},

	{
		name = "reach",
		requiresTool = true,
		description = "Extends the rainge of your weapon (sword)",
		aliases = {"range"},
		arguments = {
			{
				name = "studs",
				type = "int"
			},
		},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				for _, child in ipairs(character:GetChildren()) do
					if child:IsA("Tool") then
						local handle = child:FindFirstChild("Handle")
						if handle then
							commandSystem.cache:set("lastReach", {
								tool = child,
								size = handle.Size,
								gripPos = child.GripPos
							})

							local selectionBox = Instance.new("SelectionBox", child)
							selectionBox.Name = "Reach"
							selectionBox.Adornee = handle

							handle.Size = Vector3.new(0.5, 0.5, arguments.studs == 0 and 10 or arguments.studs)
							handle.Massless = true
							child.GripPos = Vector3.new(0, 0, 0)
						end
					end
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			local lastReach = commandSystem.cache:get("lastReach")

			if lastReach and lastReach.tool then
				local handle = lastReach.tool:FindFirstChild("Handle")
				lastReach.tool.GripPos = lastReach.gripPos
				if handle then
					handle.Size = lastReach.size
				end

				commandSystem.cache:remove("lastReach")
			end
		end
	},

	{
		name = "kill",
		requiresTool = true,
		description = "Kills the given players",
		aliases = {"exterminate", "commitDie"},
		arguments = {
			{
				name = "players",
				type = "player(s)"
			},
		},
		process = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				for _, target in ipairs(arguments.players) do
					local targetCharacter = target.Character
					if targetCharacter then
						local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
						if targetHumanoidRootPart then
							local originalLocation = character:GetPrimaryPartCFrame()
							attach(character)

							local connection
							local lastUpdate = 0
							connection = RunService.RenderStepped:Connect(function()
								local deltaTime = tick() - lastUpdate

								if not targetCharacter:FindFirstChild("HumanoidRootPart") then
									connection:Disconnect()
									character:SetPrimaryPartCFrame(originalLocation)
								end

								if deltaTime > 0.1 then
									character:SetPrimaryPartCFrame(CFrame.new(9e9, workspace.FallenPartsDestroyHeight + 5, 9e9))
								end
							end)
						end
					end
				end
			end
		end
	},

	{
		name = "esp",
		description = "Toggles ESP",
		aliases = {"extraSensoryPerception"},
		arguments = {
			{
				name = "enabled",
				type = "boolean"
			},
		},
		process = function(self, arguments, commandSystem)
			if not commandSystem.cache:get("esp") then
				local esp = commandSystem.classes.ESP.new()
				esp:hide()
				commandSystem.cache:set("esp", esp)
			end

			local esp = commandSystem.cache:get("esp")
			if arguments.enabled then
				esp:display()
			else
				esp:hide()
			end
		end,
	},

	{
		name = "xray",
		description = "Toggles X-Ray vision",
		aliases = {"x-ray"},
		arguments = {
			{
				name = "enabled",
				type = "boolean"
			},
		},
		process = function(self, arguments, commandSystem)
			if arguments.enabled then
				for _, descendant in ipairs(Workspace:GetDescendants()) do
					if descendant:IsA("BasePart") and not descendant.Parent:FindFirstChild("Humanoid") and not descendant.Parent.Parent:FindFirstChild("Humanoid") then
						descendant.LocalTransparencyModifier = 0.5
					end
				end
			else
				for _, descendant in ipairs(Workspace:GetDescendants()) do
					if descendant:IsA("BasePart") and not descendant.Parent:FindFirstChild("Humanoid") and not descendant.Parent.Parent:FindFirstChild("Humanoid") then
						descendant.LocalTransparencyModifier = 0
					end
				end
			end
		end,
	},

	{
		name = "aimbot",
		description = "Toggles aimbot",
		arguments = {
			{
				name = "enabled",
				type = "boolean"
			},
		},
		process = function(self, arguments, commandSystem)
			if not commandSystem.cache:get("aimbot") then
				local aimbot = commandSystem.classes.Aimbot.new()
				aimbot:start()
				commandSystem.cache:set("aimbot", aimbot)
			end

			local aimbot = commandSystem.cache:get("aimbot")
			aimbot.enabled = arguments.enabled
		end,
	},

	{
		name = "watch",
		description = "Watches the given player",
		aliases	 = {"spectate", "view"},
		arguments = {
			{
				name = "player",
				type = "player"
			},
		},
		process = function(self, arguments, commandSystem)
			local target = arguments.player
			if target then
				local character = target.Character
				if character then
					local humanoid = character:FindFirstChild("Humanoid")
					if humanoid then
						camera.CameraSubject = humanoid
					end
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			local character = localPlayer.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					camera.CameraSubject = humanoid
				end
			end
		end,
	},

	{
		name = "clickTeleport",
		description = "Toggles click teleporting",
		aliases = {"clickTP"},
		arguments = {
			{
				name = "enabled",
				type = "boolean"
			}	
		},
		process = function(self, arguments, commandSystem)
			if not commandSystem.cache:get("clickTeleport") then
				commandSystem.cache:set("clickTeleport", mouse.Button1Down:Connect(function()
					local character = localPlayer.Character
					if character and character.PrimaryPart then
						character:SetPrimaryPartCFrame(CFrame.new(mouse.Hit.p))
					end
				end))
			end

			if not arguments.enabled then
				commandSystem.cache:get("clickTeleport"):Disconnect()
				commandSystem.cache:remove("clickTeleport")
			end
		end,
	},

	{
		name = "playingSounds",
		description = "Finds a list of playing sounds",
		aliases = {"grabAudio", "grabSounds", "playingAudio"},
		process = function(self, arguments, commandSystem)
			local sounds = {}
			local locations = {
				Workspace,
				SoundService,
				playerGui
			}

			local function scanInstance(instance)
				for _, child in ipairs(instance:GetDescendants()) do
					if child:IsA("Sound") and child.Playing then
						sounds[#sounds+1] = child
					end
				end
			end

			for _, location in ipairs(locations) do
				scanInstance(location)
			end

			local list = {}
			for _, sound in ipairs(sounds) do
				list[#list+1] = {sound.SoundId, sound:GetFullName()}
			end
			commandSystem:createList("Sounds", list)
		end,
	},

	{
		name = "mlgMode",
		description = "Toggles MLG mode",
		aliases = {"mlg"},
		arguments = {
			{
				name = "enabled",
				type = "boolean"
			}	
		},
		process = function(self, arguments, commandSystem)
			if arguments.enabled then 
				local music = Instance.new("Sound", workspace)
				music.SoundId = "rbxassetid://234298689"
				music:Play()
				commandSystem.cache:set("mlg", music)
				commandSystem:executeCommandByCall("esp", {enabled = true})
				commandSystem:executeCommandByCall("aimbot", {enabled = true})
			else
				local existingMlg = commandSystem.cache:get("mlg")
				if existingMlg then
					existingMlg:Destroy()
				end
				commandSystem:executeCommandByCall("esp", {enabled = false})
				commandSystem:executeCommandByCall("aimbot", {enabled = false})
			end
		end,
	},
}


local SignalConnection = {}
SignalConnection.__index = SignalConnection

function SignalConnection:disconnect()
	self.signal:disconnect(self.connectionId)
end

function SignalConnection:run(...)
	if self.alive and (not self.suspendedUntil or tick() >= self.suspendedUntil) then
		pcall(self.callback, ...)
	end
end

function SignalConnection:suspend(duration)
	self.suspendedUntil = math.max(self.suspendedUntil, tick() + duration)
end

function SignalConnection.new(signal, connectionId, callback)
	local self = setmetatable({
		signal = signal,
		connectionId = connectionId,
		callback = callback,
		alive = true,
	}, SignalConnection)

	return self
end


local Signal = {}
Signal.__index = Signal

function Signal:disconnect(connectionId)
	local connection = self.connections[connectionId]
	connection.alive = false
	self.connections[connectionId] = nil
end

function Signal:connect(callback)
	local connectionId = #self.connections + 1
	local connection = SignalConnection.new(self, connectionId, callback)

	self.connections[connectionId] = connection
	return connection
end

function Signal:fire(...)
	self._bindable:Fire(...)
end

function Signal:wait()
	return self._bindable:Wait()
end

function Signal.new(name)
	local self = setmetatable({
		name = name,
		connections = {},
		_bindable = Instance.new("BindableEvent")
	}, Signal)

	self._bindable.Event:Connect(function(...)
		for _, connection in pairs(self.connections) do
			connection:run(...)
		end
	end)

	return self
end


local ThemeSyncer = {}
ThemeSyncer.__index = ThemeSyncer

function ThemeSyncer:updateTheme(theme)
	self.currentTheme = theme
	for _, bind in ipairs(self.binds or {}) do
		self:updateBind(bind)
	end
end

function ThemeSyncer:updateBind(bind, duration)
	if bind.object and bind.object.Parent then
		if typeof(self.currentTheme[bind.themeElement]) == "EnumItem" then
			bind.object[bind.property] = self.currentTheme[bind.themeElement]
		else
			local tween = TweenService:Create(bind.object, TweenInfo.new(duration or 1, Enum.EasingStyle.Quad), {
				[bind.property] = self.currentTheme[bind.themeElement]
			})
			tween:Play()	
		end
	end
end

function ThemeSyncer:bindElement(object, property, themeElement)
	local bind = {
		object = object,
		property = property,
		themeElement = themeElement
	}
	self:updateBind(bind, 0)
	self.binds[#self.binds+1] = bind
end

function ThemeSyncer.new(theme)
	local self = setmetatable({
		currentTheme = theme or Themes.light,
		binds = {}
	}, ThemeSyncer)

	return self
end


local PerformanceMonitor = {}
PerformanceMonitor.__index = PerformanceMonitor

function PerformanceMonitor:resetFrames()
	self.frameCount = 0
	self.intervalStart = tick()
end

function PerformanceMonitor:trackFrames()
	self:resetFrames()

	self.connections[#self.connections+1] = RunService.Heartbeat:Connect(function()
		local deltaTime = tick() - self.intervalStart
		if deltaTime > self.countResetInterval then
			self.framesPerSecond = math.floor(10 * self.frameCount / deltaTime + 0.5) / 10
			self:resetFrames()
		end
		self.frameCount = self.frameCount + 1
	end)
end

function PerformanceMonitor:init()
	self:trackFrames()
end

function PerformanceMonitor.new()
	local self = setmetatable({
		framesPerSecond = 0,
		countResetInterval = 5,
		intervalStart = 0,
		connections = {}
	}, PerformanceMonitor)

	self:init()

	return self
end


local InputBinder = {}
InputBinder.__index = InputBinder

function InputBinder:bind(keys, callback)
	self.inputBinds[#self.inputBinds+1] = {
		input = keys,
		callback = callback
	}
end

function InputBinder:checkValidity(bind)
	for _, keyCode in ipairs(bind.input) do
		if not table.find(self.currentInput, keyCode) then
			return false
		end
	end
	return true
end

function InputBinder.new()
	local self = setmetatable({
		inputBinds = {},
		currentInput = {},
		connections = {},
	}, InputBinder)

	self.connections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		self.currentInput[#self.currentInput+1] = input.KeyCode
		for _, bind in ipairs(self.inputBinds) do
			if self:checkValidity(bind) then
				bind:callback()
			end
		end
	end)
	self.connections.inputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessed)
		local inputIndex = table.find(self.currentInput, input.KeyCode)
		if inputIndex then
			table.remove(self.currentInput, inputIndex)
		end
	end)

	return self
end


local Cache = {}

function Cache:get(index)
	return self._cache[index]
end

function Cache:set(index, value)
	self._cache[index] = value
end

function Cache:find(value, initialIndex)
	return table.find(self._cache, value, initialIndex)
end

function Cache:update(index, callback)
	local currentValue = self:get(index)
	self:set(index, callback(index) or index)
end

function Cache:remove(index)
	self._cache[index] = nil
end

function Cache:clear()
	self._cache = {}
end

function Cache:forEach(callback)
	return table.foreach(self._cache, callback)
end

function Cache:__index(index)
	local fromSelf = rawget(Cache, index)
	if fromSelf then
		return fromSelf
	else
		local fromCache = rawget(self._cache, index)
		if fromCache then
			return fromCache
		end
	end
end

function Cache:__newindex(index, value)
	Cache.set(self, index, value)
end

function Cache:__pairs()
	return pairs(self._cache)
end

function Cache:__ipairs()
	return ipairs(self._cache)
end

function Cache.new(initialData)
	local self = setmetatable({
		_cache = initialData or {}
	}, Cache)

	return self
end


local ESP = {}
ESP.__index = ESP

function ESP:addCharacter(player, color)
	local character = player.Character
	if character and not self.container:FindFirstChild(character.Name) then
		local espHolder = Instance.new("Folder", self.container)
		espHolder.Name = character.Name

		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("BasePart") then
				local indicator = Instance.new("BoxHandleAdornment", espHolder)
				indicator.Name = child.Name
				indicator.Adornee = child
				indicator.ZIndex = 10
				indicator.AlwaysOnTop = true
				indicator.Size = child.Size
				indicator.Transparency = self.visible and 0.3 or 1
				indicator.Color3 = color or player.TeamColor.Color
			end
		end

		local teamChangeConnection
		teamChangeConnection = player:GetPropertyChangedSignal("TeamColor"):Connect(function()
			if not player or not character then
				return teamChangeConnection:Disconnect()
			end

			for _, child in ipairs(espHolder and espHolder:GetChildren() or {}) do
				child.Color3 = color or player.TeamColor.Color
			end
		end)
	end
end

function ESP:removeCharacter(character)
	local espHolder = self.container:FindFirstChild(character)
	if espHolder then
		espHolder:Destroy()
	end

	if self.connections[character] then
		self.connections[character]:Disconnect()
		self.connections[character] = nil
	end
end

function ESP:addPlayer(player)
	if player.Character then
		self:addCharacter(player, self.color)
	end
	self.connections[player.Name] = player.CharacterAdded:Connect(function(character)
		self:addCharacter(player, self.color)
	end)
end

function ESP:removePlayer(player)
	self:removeCharacter(player.Name)
end

function ESP:connect()
	for _, player in ipairs(Players:GetPlayers()) do
		self:addPlayer(player)
	end

	self.addConnection = Players.PlayerAdded:Connect(function(player)
		self:addPlayer(player)
	end)

	self.removeConnection = Players.PlayerRemoving:Connect(function(player)
		self:removePlayer(player)
	end)
end

function ESP:hide()
	self.visible = false
	for _, espHolder in ipairs(self.container:GetChildren()) do
		for _, indicator in ipairs(espHolder:GetChildren()) do
			indicator.Transparency = 1
		end
	end
end

function ESP:display()
	self.visible = false
	for _, espHolder in ipairs(self.container:GetChildren()) do
		for _, indicator in ipairs(espHolder:GetChildren()) do
			indicator.Transparency = 0.3
		end
	end
end

function ESP.new()
	local self = setmetatable({
		container = Instance.new("Folder", Workspace),
		visible = true,
		connections = {}
	}, ESP)

	self:connect()

	return self
end


--[[
local Shadow = {}
Shadow.__index = Shadow

function Shadow:build()
	local root = Instance.new("Frame", self.parent)
	local umbra = Instance.new("ImageLabel", root)
	local penumbra = Instance.new("ImageLabel", root)
	local ambient = Instance.new("ImageLabel", root)
	
	root.Name = "Shadow"
	root.BackgroundTransparency = 1
	root.Size = UDim2.new(1, 0, 1, 0)
	root.ZIndex = -1
	
	umbra.Name = "Umbra"
end

function Shadow.new(frame)
	local self = setmetatable({
		parent = frame
	}, Shadow)
	
	if not self.shadow then
		self:build()
	end
	
	return self
end
]]


local Aimbot = {}
Aimbot.__index = Aimbot

function Aimbot:validateTarget(player)
	return player ~= localPlayer and ((self.teamCheck and player.Team ~= localPlayer.Team) or true)
end

function Aimbot:mapWorldToScreen(...)
	return camera:WorldToScreenPoint(...)
end

function Aimbot:distanceFromCenter(x, y)
	return (Vector2.new(x, y) - camera.ViewportSize/2).magnitude
end

function Aimbot:checkLineOfSight(part, ...)
	return localPlayer.Character and camera:GetPartsObscuringTarget({part}, {camera, localPlayer.Character, ...})
end

function Aimbot:getTargets()
	local targets = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if self:validateTarget(player) and player.Character then
			targets[#targets+1] = player.Character
		end
	end
	return targets
end

function Aimbot:getTarget()
	local target
	local distance = math.huge

	local localCharacter = localPlayer.Character
	if localCharacter and localCharacter.PrimaryPart then
		local localPosition = localCharacter:GetPrimaryPartCFrame().p

		for _, character in ipairs(self:getTargets()) do
			if character and character.PrimaryPart then
				local position = character:GetPrimaryPartCFrame().p
				if not distance or (localPosition - position).magnitude < distance then
					target = Players
					distance = (localPosition - position).magnitude
				end
			end
		end
	end

	return target, distance
end

function Aimbot:aimAt(x, y)
	local center = camera.ViewportSize / 2
	local targetX
	local targetY

	if x ~= 0 then
		if x > center.X then
			targetX = -(center.X - x)
			targetX = targetX / self.speed
			if targetX + center.X > center.X * 2 then
				targetX = 0
			end
		end
		if x < center.X then
			targetX = x - center.X
			targetX = targetX / self.speed
			if targetX + center.X < 0 then
				targetX = 0
			end
		end
	end

	if y ~= 0 then
		if x > center.X then
			targetY = -(center.Y - x)
			targetY = targetY / self.speed
			if targetY + center.Y > center.Y * 2 then
				targetY = 0
			end
		end
		if x < center.Y then
			targetY = y - center.Y
			targetY = targetY / self.speed
			if targetY + center.Y < 0 then
				targetY = 0
			end
		end
	end	

	return Vector2.new(targetX, targetY)
end

function Aimbot:moveMouse(...)
	return (mousemoverel or Input and Input.MoveMouse or function(...) end)(...)
end

function Aimbot:shoot()
	if mouse1press and mouse1release then
		mouse1press()
		wait()
		mouse1release()
	elseif Input and Input.LeftClick then
		Input.LeftClick()
	end
end

function Aimbot:update()
	local target = self:getTarget()
	if target then
		local targetPart = target:FindFirstChild(self.targetChild or "HumanoidRootPart")
		if targetPart then
			if self:checkLineOfSight(targetPart.Position, target) and self.visiblilityCheck then
				local point = self:mapWorldToScreen(targetPart.Position)
				local distance = self:aimAt(point.X + self.aimOffset.X, point.Y + self.aimOffset.Y + 32)
				self:moveMouse(distance.X, distance.Y)

				if self.autoShoot then
					RunService.RenderStepped:Wait()
					self:shoot()
				end
			end
		end
	end
end

function Aimbot:start()
	self.connections.update = RunService.Stepped:Connect(function()
		if self.enabled then
			self:update()
		end
	end)
end

function Aimbot:stop()
	for _, connection in pairs(self.connections) do
		connection:Disconnect()
	end
end

function Aimbot.new()
	local self = setmetatable({
		connections = {},
		targetChild = "Head",
		speed = 5,
		aimOffset = {
			x = 0,
			y = 0
		},
		teamCheck = true,
		visibleCheck = false,
		autoShoot = false,
		enabled = false
	}, Aimbot)

	return self
end


local MouseHover = {}
MouseHover.__index = MouseHover

function MouseHover:determineBounds(text)
	local bounds = TextService:GetTextSize(
		text,
		self.label.TextSize,
		self.label.Font,
		Vector2.new(
			math.max(camera.ViewportSize.X / 4, 200),
			camera.ViewportSize.Y
		)
	)
	return bounds
end

function MouseHover:addElement(uiElement, hoverText, validationCallback)
	validationCallback = validationCallback or function(...)
		return true
	end

	self.connections[uiElement] = {
		mouseEnter = uiElement.MouseEnter:Connect(function()
			uiElement.MouseMoved:Connect(function(mouseX, mouseY)
				if validationCallback(mouseX, mouseY) then
					self.label.Text = hoverText or uiElement.Hover.Value

					self.label.TextScaled = not self.label.TextScaled -- again, fix roblox bug :\
					self.label.TextScaled = not self.label.TextScaled

					local bounds = self:determineBounds(self.label.Text)
					self.container.Size = UDim2.new(
						0, bounds.X + self.padding*2,
						0, bounds.Y + self.padding*2
					)

					local mouseOffset
					if self.container.AbsoluteSize.Y <= self.label.TextSize + self.padding*2 then
						mouseOffset = self.container.AbsoluteSize.Y*2 - 5
					else
						mouseOffset = 60
					end

					if mouseX -self.container.AbsoluteSize.X >= 0 then
						self.container.Position = UDim2.new(
							0, mouseX - self.container.AbsoluteSize.X,
							0, mouseY - self.container.AbsoluteSize.Y/2 - mouseOffset
						)
					elseif mouseX - self.container.AbsoluteSize.X <= 0 then
						self.container.Position = UDim2.new(
							0, mouseX,
							0, mouseY - self.container.AbsoluteSize.Y/2 - mouseOffset
						)
					end
				end
			end)
		end),

		mouseLeave = uiElement.MouseLeave:Connect(function()
			self.label.Text = ""
			self.container.Size = UDim2.new(0, 0, 0, 0)
			self.container.Position = UDim2.new(2, 0, 2, 0)
		end)
	}
end

function MouseHover:build()
	local container = Instance.new("Frame", self.handler.gui)
	local shadow = Instance.new("ImageLabel", container)
	local frame = Instance.new("Frame", container)
	local corner = Instance.new("UICorner", frame)
	local label = Instance.new("TextLabel", frame)

	container.Name = "MouseLabel"
	container.BackgroundTransparency = 1
	container.Position = UDim2.new(1, 0, 1, 0)
	container.Size = UDim2.new(0, 0, 0, 0)
	container.ZIndex = 9e5

	frame.Name = "Content"
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BorderSizePixel = 0
	self.handler.themeSyncer:bindElement(frame, "BackgroundColor3", "headerBackground")
	--self.handler.themeSyncer:bindElement(frame, "BackgroundTransparency", "transparency")

	shadow.Name = "Shadow"
	shadow.Image = "rbxassetid://1113384364"
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(50, 50, 50, 50)
	shadow.Size = UDim2.new(1, 80, 1, 80)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.ImageTransparency = 0.8
	self.handler.themeSyncer:bindElement(shadow, "Visible", "shadow")

	corner.Name = "Corner"
	self.handler.themeSyncer:bindElement(corner, "CornerRadius", "roundness")

	label.Name = "Label"
	label.Size = UDim2.new(1, -self.padding*2, 1, -self.padding*2)
	label.Position = UDim2.new(0.5, 0, 0.5, 0)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.BackgroundTransparency = 1
	label.Text = ""
	self.handler.themeSyncer:bindElement(label, "TextColor3", "text")

	local toAdd = {
		container = container,
		shadow = shadow,
		frame = frame,
		label = label,
		corner = corner,
	}

	for name, object in pairs(toAdd) do
		self[name] = object
	end

	return container
end

function MouseHover:init()
	if not self.frame then
		self:build()
	end
end

function MouseHover.new(handler)
	local self = setmetatable({
		handler = handler,
		padding = 7.5,
		connections = {}
	}, MouseHover)

	self:init()

	return self
end


local Menu = {}
Menu.__index = Menu

function Menu:close()
	self.container.Visible = false
end

function Menu:open()
	local contentSize = self.listLayout.AbsoluteContentSize
	self.container.Size = UDim2.new(0, contentSize.X+self.outline, 0, contentSize.Y+self.outline)
	for _, option in ipairs(self.data) do
		option.textLabel.TextTransparency = 1
	end
	self.container.Visible = true
	for _, option in ipairs(self.data) do
		TweenService:Create(option.textLabel, TweenInfo.new(0.5), {
			TextTransparency = 0
		}):Play()
		wait(0.1)
	end
end

function Menu:getBounds(object, text, maxSize)
	return TextService:GetTextSize(
		text,
		object.TextSize,
		object.Font,
		maxSize or Vector2.new(
			self.options.Size.X.Offset,
			9e6
		)
	)
end

function Menu:connectBoundsUpdate(object, callback)
	local function callbackProxy(...)
		callback(object, ...)
		--self:updateSize()
	end

	object:GetPropertyChangedSignal("Text"):Connect(callbackProxy)
	object:GetPropertyChangedSignal("TextSize"):Connect(callbackProxy)

	if AUTO_TEXT_RESIZE then
		self.options:GetPropertyChangedSignal("AbsoluteSize"):Connect(callbackProxy)
	end

	callbackProxy()
end

function Menu:addOption(text)
	if not text then
		return
	end

	local container = Instance.new("TextButton", self.options)
	local textLabel = Instance.new("TextLabel", container)
	local corner = Instance.new("UICorner", container)

	container.Name = #self.options:GetChildren()
	container.Text = ""
	container.BorderSizePixel = 0
	container.Size = UDim2.new(1, 0, 0, 25)
	self.handler.themeSyncer:bindElement(container, "BackgroundColor3", "background")

	textLabel.Name = #self.options:GetChildren()
	textLabel.Text = text
	textLabel.TextSize = self.textSize or 14
	textLabel.Size = UDim2.new(1, -10, 1, -10)
	textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.BackgroundTransparency = 1
	textLabel.TextTransparency = 1
	self.handler.themeSyncer:bindElement(textLabel, "TextColor3", "text")

	corner.Name = "Corner"
	self.handler.themeSyncer:bindElement(corner, "CornerRadius", "roundness")

	self:connectBoundsUpdate(textLabel, function()
		local bounds = self:getBounds(textLabel, textLabel.Text)
		container.Size = UDim2.new(1, 0, 0, bounds.Y+5)
		textLabel.TextScaled = not textLabel.TextScaled
		textLabel.TextScaled = not textLabel.TextScaled
	end)

	container.MouseButton1Click:Connect(function()
		self:close()
		self.clicked:fire(text)
	end)

	TweenService:Create(textLabel, TweenInfo.new(0.5), {
		TextTransparency = 0
	}):Play()

	self.data[#self.data+1] = {
		text = text,
		container = container,
		textLabel = textLabel,
		corner = corner
	}

	return container
end

function Menu:build(size, position)
	local container = Instance.new("Frame", self.handler.gui)
	local window = Instance.new("Frame", container)
	local options = Instance.new("Frame", window)
	local corner = Instance.new("UICorner", window)
	local listLayout = Instance.new("UIListLayout", options)
	local shadow = Instance.new("ImageLabel", window)

	container.Name = self.name or "Menu"
	container.BackgroundTransparency = 1
	container.ZIndex = 100
	container.Size = size or UDim2.new(0, 150, 0, 30)
	container.Position = position or UDim2.new(
		0, (camera.ViewportSize.X - container.AbsoluteSize.X) / 2,
		0, (camera.ViewportSize.Y - container.AbsoluteSize.Y) / 2
	)

	window.Name = "Content"
	window.ZIndex = 2
	window.Size = UDim2.new(1, 0, 1, 0)
	window.BackgroundTransparency = 0.025
	window.BorderSizePixel = 0
	self.handler.themeSyncer:bindElement(window, "BackgroundColor3", "background")
	self.handler.themeSyncer:bindElement(window, "BackgroundTransparency", "transparency")

	options.Name = "Options"
	options.BackgroundTransparency = 1
	options.Size = UDim2.new(1, -self.outline, 1, -self.outline)
	options.Position = UDim2.new(0.5, 0, 0.5, 0)
	options.AnchorPoint = Vector2.new(0.5, 0.5)

	corner.Name = "Corner"
	self.handler.themeSyncer:bindElement(corner, "CornerRadius", "roundness")

	shadow.Name = "Shadow"
	shadow.Image = "rbxassetid://1113384364"
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(50, 50, 50, 50)
	shadow.Size = UDim2.new(1, 80, 1, 80)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.ImageTransparency = 0.75
	self.handler.themeSyncer:bindElement(shadow, "Visible", "shadow")

	listLayout.Name = "ListLayout"
	listLayout.Padding = UDim.new(0, 1)
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.SortOrder = Enum.SortOrder.Name
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top

	local toAdd = {
		container = container,
		window = window,
		options = options,
		shadow = shadow,
		corner = corner,
		listLayout = listLayout,
	}

	for name, object in pairs(toAdd) do
		self[name] = object
	end
end

function Menu:display(position)
	position = Vector2.new(
		position.X.Scale*camera.ViewportSize.X + position.X.Offset,
		position.Y.Scale*camera.ViewportSize.X + position.Y.Offset
	)
	self.container.Position = UDim2.new(0, position.X, 0, position.Y)
	self:open()
end

function Menu:init(options)
	if not self.container then
		self:build()
	end
	for _, option in ipairs(options or {}) do
		self:addOption(option)
	end
	self:close()
end

function Menu.new(handler, options)
	local self = setmetatable({
		handler = handler,
		outline = 5,
		data = {},
		clicked = Signal.new("clicked")
	}, Menu)

	self:init(options)

	return self
end


local CommandBar = {}
CommandBar.__index = CommandBar

function CommandBar:determineBounds(text)
	local bounds = TextService:GetTextSize(
		text,
		self.box.TextSize,
		self.box.Font,
		Vector2.new(
			self.container.AbsoluteSize.X,
			camera.ViewportSize.Y
		)
	)
	return bounds
end

function CommandBar:open()
	self.opened = true
	local alignmentData = self.alignmentData[self.alignment]
	TweenService:Create(self.container, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
		AnchorPoint = alignmentData.anchorPoint,
		Position = alignmentData.position
	}):Play()
	wait(0.25)
	self.box:CaptureFocus()
	self.box.Text = ""
end

function CommandBar:close()
	self.opened = false
	self.box:ReleaseFocus()
	TweenService:Create(self.container, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 1, 0)
	}):Play()
	self.box.Text = ""
end

function CommandBar:toggle()
	if self.opened then
		self:close()
	else
		self:open()
	end
end

function CommandBar:bind()
	self.connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.KeyCode == self.hotkey and not UserInputService:GetFocusedTextBox() then
			self:toggle()
		elseif (input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.Escape) and self.box.Text ~= "" then
			if input.KeyCode == Enum.KeyCode.Return then
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
					self.box.Text = self.box.Text .. "\n"
				else
					local command = self.box.Text
					coroutine.wrap(self.defaultCallback)(command)
				end
			end
			self:close()
		elseif input.KeyCode == Enum.KeyCode.Escape then
			self:close()
		end
	end)
end

function CommandBar:build()
	local container = Instance.new("Frame", self.handler.gui)
	local shadow = Instance.new("ImageLabel", container)
	local frame = Instance.new("Frame", container)
	local corner = Instance.new("UICorner", frame)
	local box = Instance.new("TextBox", frame)

	container.Name = "CommandBar"
	container.BackgroundTransparency = 1
	container.AnchorPoint = Vector2.new(0.5, 0)
	container.Position = UDim2.new(0.5, 0, 1, 0)
	container.Size = UDim2.new(1, 0, 0, 30)
	container.ZIndex = 9e6

	frame.Name = "Content"
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BorderSizePixel = 0
	self.handler.themeSyncer:bindElement(frame, "BackgroundColor3", "headerBackground")
	self.handler.themeSyncer:bindElement(frame, "BackgroundTransparency", "transparency")

	shadow.Name = "Shadow"
	shadow.Image = "rbxassetid://1113384364"
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(50, 50, 50, 50)
	shadow.Size = UDim2.new(1, 80, 1, 80)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.ImageTransparency = 0.75
	self.handler.themeSyncer:bindElement(shadow, "Visible", "shadow")

	corner.Name = "Corner"
	self.handler.themeSyncer:bindElement(corner, "CornerRadius", "roundness")

	box.Name = "Box"
	box.Size = UDim2.new(1, -self.padding*2, 1, -self.padding*2)
	box.Position = UDim2.new(0.5, 0, 0.5, 0)
	box.AnchorPoint = Vector2.new(0.5, 0.5)
	box.Font = Enum.Font.Gotham
	box.TextSize = 16
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.TextYAlignment = Enum.TextYAlignment.Top
	box.BackgroundTransparency = 1
	box.Text = ""
	box.PlaceholderText = "Enter command here..."
	self.handler.themeSyncer:bindElement(box, "TextColor3", "textBox")
	box:GetPropertyChangedSignal("Text"):Connect(function()
		local bounds = self:determineBounds(box.Text)
		container.Size = UDim2.new(
			(self.fullScreen and 1 or 0), (self.fullScreen and 0 or (bounds.X + self.padding*2)),
			0, bounds.Y + self.padding*2
		)
		box.TextScaled = not box.TextScaled
		box.TextScaled = not box.TextScaled
	end)

	local function callbackProxy()
		local success, response = pcall(self.defaultCallback, self.box.Text)
	end

	local toAdd = {
		container = container,
		shadow = shadow,
		frame = frame,
		box = box,
		corner = corner,
	}

	for name, object in pairs(toAdd) do
		self[name] = object
	end

	return container
end

function CommandBar:init()
	if not self.container then
		self:build()
	end
	self:bind()
end

function CommandBar.new(handler, hotkey, defaultCallback)
	local self = setmetatable({
		fullScreen = true,
		handler = handler,
		padding = 7.5,
		hotkey = hotkey,
		alignment = Enum.VerticalAlignment.Bottom,
		alignmentData = {
			[Enum.VerticalAlignment.Top] = {
				anchorPoint = Vector2.new(0.5, 0),
				position = UDim2.new(0.5, 0, 0, 0),
				chatEnabled = false
			},
			[Enum.VerticalAlignment.Center] = {
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.new(0.5, 0, 0.5, 0),
				chatEnabled = true
			},
			[Enum.VerticalAlignment.Bottom] = {
				anchorPoint = Vector2.new(0.5, 1),
				position = UDim2.new(0.5, 0, 1, 0),
				chatEnabled = true
			},
		},
		defaultCalaback = defaultCallback or function(...)
		end
	}, CommandBar)

	self:init()

	return self
end


local Notification = {}
Notification.__index = Notification

function Notification:display()
	self.container.Position = UDim2.new(
		1, self.container.AbsoluteSize.X*2 + 15,
		1, -15
	)

	local absoluteSize = self:determineSize(self.body.Text)
	self.container.Size = UDim2.new(0, absoluteSize.X, 0, absoluteSize.Y)
	self.body.TextScaled = not self.body.TextScaled
	self.body.TextScaled = not self.body.TextScaled

	for _, existingNotification in ipairs(self.handler.notifications) do
		if existingNotification.container ~= self.container and existingNotification.container.Parent then
			existingNotification.container:TweenPosition(UDim2.new(
				1, -15,
				0, existingNotification.container.AbsolutePosition.Y + existingNotification.container.AbsoluteSize.Y - existingNotification.container.AbsoluteSize.Y - 15
				), "In", "Quint", 0.25)
		end
	end

	self.container:TweenPosition(UDim2.new(1, -15, 1, -15), "Out", "Quint", 0.25)

	local closing = false
	local function close(clicked)
		self.container:TweenPosition(UDim2.new(
			1, self.container.AbsoluteSize.X * 2 + 15,
			0, self.container.AbsolutePosition.Y + self.container.AbsoluteSize.Y
			), "In", "Quint", 0.25, true, function(status)
				if status == Enum.TweenStatus.Completed then
					self.container:Destroy()
				end
			end)

		for _, existingNotification in pairs(self.handler.notifications) do
			if existingNotification.container.Parent and existingNotification.container ~= self.container and existingNotification.container.AbsolutePosition.Y < self.container.AbsolutePosition.Y then
				existingNotification.container:TweenPosition(UDim2.new(
					1, -15,
					0, existingNotification.container.AbsolutePosition.Y + existingNotification.container.AbsoluteSize.Y + self.container.AbsoluteSize.Y + 15
					), "In", "Quint", 0.25)
			end
		end

		wait(0.1)
		if clicked and not closing then
			self.clicked:fire()
		else
			self.closed:fire()
		end
	end

	self.buttons.close.MouseButton1Click:Connect(function()
		closing = true
		close(false)
	end)

	self.container.MouseButton1Click:Connect(function()
		closing = false
		close(true)
	end)

	delay(self.duration or 10, function()
		if self.container and self.container.Parent then
			closing = true
			close(false)
		end
	end)
end

function Notification:determineSize(text)
	local bodyBounds = TextService:GetTextSize(
		text,
		self.body.TextSize,
		self.body.Font,
		Vector2.new(
			self.body.AbsoluteSize.X,
			200
		)
	)

	return Vector2.new(
		self.body.AbsoluteSize.X,
		bodyBounds.Y - self.body.Size.Y.Offset + self.header.AbsoluteSize.Y
	)
end

function Notification:build()
	local container = Instance.new("TextButton", self.handler.gui)
	local notification = Instance.new("Frame", container)
	local uiCorner = Instance.new("UICorner", notification)
	local shadow = Instance.new("ImageLabel", notification)
	local body = Instance.new("Frame", notification)
	local header = Instance.new("Frame", notification)
	local headerCorner = Instance.new("UICorner", header)
	local title = Instance.new("TextLabel", header)
	local bodyText = Instance.new("TextLabel", body)
	local controls = Instance.new("Frame", header)
	local controlsLayout = Instance.new("UIListLayout", controls)

	container.Name = self.name or "Notitication"
	container.BackgroundTransparency = 1
	container.AnchorPoint = Vector2.new(1, 1)
	container.Size = UDim2.new(0, 200, 0, 50)
	container.Position = UDim2.new(2, 0, 2, 0)
	container.Text = ""

	notification.Name = "Content"
	notification.ZIndex = 2
	notification.Size = UDim2.new(1, 0, 1, 0)
	notification.BackgroundTransparency = 0.025
	self.handler.themeSyncer:bindElement(notification, "BackgroundColor3", "background")
	self.handler.themeSyncer:bindElement(notification, "BackgroundTransparency", "transparency")

	uiCorner.Name = "Corner"
	self.handler.themeSyncer:bindElement(uiCorner, "CornerRadius", "roundness")

	shadow.Name = "Shadow"
	shadow.Image = "rbxassetid://1113384364"
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(50, 50, 50, 50)
	shadow.Size = UDim2.new(1, 80, 1, 80)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.ImageTransparency = 0.75
	self.handler.themeSyncer:bindElement(shadow, "Visible", "shadow")

	body.Name = "Body"
	body.Size = UDim2.new(1, 0, 1, -25)
	body.Position = UDim2.new(0, 0, 0, 25)
	body.BackgroundTransparency = 1
	body.ClipsDescendants = true

	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 25)
	header.BorderSizePixel = 0
	self.handler.themeSyncer:bindElement(header, "BackgroundColor3", "headerBackground")
	self.handler.themeSyncer:bindElement(header, "BackgroundTransparency", "transparency")

	headerCorner.Name = "Corner"
	self.handler.themeSyncer:bindElement(headerCorner, "CornerRadius", "roundness")

	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 1, -10)
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Position = UDim2.new(0.5, 0, 0.5, 0)
	title.BackgroundTransparency = 1
	title.TextScaled = true
	title.Font = Enum.Font.Gotham
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.Text = self.title or "Notification"
	self.handler.themeSyncer:bindElement(title, "TextColor3", "text")

	bodyText.Name = "Content"
	bodyText.Size = UDim2.new(1, -10, 1, -10)
	bodyText.AnchorPoint = Vector2.new(0.5, 0.5)
	bodyText.Position = UDim2.new(0.5, 0, 0.5, 0)
	bodyText.BackgroundTransparency = 1
	bodyText.TextSize = 15
	bodyText.Font = Enum.Font.Gotham
	bodyText.TextXAlignment = Enum.TextXAlignment.Left
	bodyText.TextYAlignment = Enum.TextYAlignment.Top
	bodyText.Text = self.text or "Hello there!"
	self.handler.themeSyncer:bindElement(bodyText, "TextColor3", "text")

	controls.Name = "Controls"
	controls.Size = UDim2.new(1, -10, 1, -2)
	controls.Position = UDim2.new(0.5, 0, 0.5, 0)
	controls.AnchorPoint = Vector2.new(0.5, 0.5)
	controls.BackgroundTransparency = 1

	controlsLayout.Name = "ListLayout"
	controlsLayout.Padding = UDim.new(0, 5)
	controlsLayout.FillDirection = Enum.FillDirection.Horizontal
	controlsLayout.SortOrder = Enum.SortOrder.Name
	controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	local closeButton = Instance.new("TextButton", controls)
	local closeCorner = Instance.new("UICorner", closeButton)

	closeButton.Name = "1"
	closeButton.Size = UDim2.new(0, 15, 0, 15)
	closeButton.BackgroundColor3 = Color3.fromRGB(252, 87, 83)
	closeButton.Text = ""

	self.handler.themeSyncer:bindElement(closeCorner, "CornerRadius", "controlRoundness")

	controlsLayout:GetPropertyChangedSignal("HorizontalAlignment"):Connect(function()
		local isRight = controlsLayout.HorizontalAlignment == Enum.HorizontalAlignment.Right
		closeButton.Name = isRight and "3" or "1"
	end)
	self.handler.themeSyncer:bindElement(controlsLayout, "HorizontalAlignment", "controlAlignment")

	local toAdd = {
		container = container,
		notification = notification,
		corner = uiCorner,
		bodyHolder = body,
		header = header,
		headerCorner = headerCorner,
		title = title,
		body = bodyText,
		controls = controls,
		controlsLayout = controlsLayout,
		maximumSize = Vector2.new(800, 500),
		minimumSize = Vector2.new(300, 175),
		buttons = {
			close = closeButton,
		},
	}

	for name, object in pairs(toAdd) do
		self[name] = object
	end

	return notification
end

function Notification:init()
	if not self.notification then
		self:build()
	end
end

function Notification.new(handler, title, text, duration)
	local self = setmetatable({
		handler = handler,
		title = title or "Notification",
		text = text or "Hello world!",
		duration = duration or 10,
		clicked = Signal.new("clicked"),
		closed = Signal.new("closed")
	}, Notification)

	self:init()

	return self
end


local Window = {}
Window.__index = Window

function Window:destroy()
	self.container:Destroy()
end

function Window:addTraceback()
	self.lastState = {
		anchorPoint = self.container.AnchorPoint,
		position = self.container.Position,
		size = self.container.Size
	}
end

function Window:minimize()
	self:addTraceback()

	TweenService:Create(self.container, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(0, 0, 0, 0),
	}):Play()

	delay(0.15, function()
		self.container.Visible = false
	end)

	self.minimized:fire()
end

function Window:maximize()
	if not self.maximized then
		self:addTraceback()

		self.container.Position = UDim2.new(0, 0, 0, 0)
		self.container.Size = UDim2.new(1, 0, 1, 0)
		self.container.AnchorPoint = Vector2.new(0, 0)
	else
		self.container.Position = self.lastState.position
		self.container.Size = self.lastState.size
		self.container.AnchorPoint = self.lastState.anchorPoint
	end

	self.maximized = not self.maximized
end

function Window:close()
	self:addTraceback()

	local offset = 25
	local tween = TweenService:Create(self.container, TweenInfo.new(0.1), {
		Position = UDim2.new(
			0, self.lastState.position.X.Offset + offset/2,
			0, self.lastState.position.Y.Offset + offset/2
		),
		Size = UDim2.new(
			0, self.lastState.size.X.Offset - offset,
			0, self.lastState.size.Y.Offset - offset
		)
	})

	tween.Completed:Connect(function()
		self:destroy()
		self.handler.dock:remove(self.name)
	end)
	tween:Play()

	self.closed:fire()
end

function Window:open()
	local tween = TweenService:Create(self.container, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {
		Position = self.lastState.position,
		Size = self.lastState.size,
		AnchorPoint = self.lastState.anchorPoint
	})

	tween:Play()

	delay(0.1, function()
		self.container.Visible = true
	end)

	self.opened:fire()
end

function Window:toAbsolute(size)
	if typeof(size) == "UDim2" then
		size = Vector2.new(
			size.X.Scale * camera.ViewportSize.X + size.X.Offset,
			size.Y.Scale * camera.ViewportSize.Y + size.Y.Offset
		)
	end
	return size
end

function Window:isOnTop(x, y, additional)
	for _, window in pairs(self.handler.windows) do
		local position = window.container.AbsolutePosition
		local size = window.container.AbsoluteSize

		local xInbound = x > position.X and x - position.X < size.X
		local yInbound = y > position.Y and y - position.Y < size.Y

		if xInbound and yInbound and window.container ~= self.container then
			if window.container.ZIndex > self.container.ZIndex then
				return false
			end
		end
	end

	--[[if additional then
		for _, element in pairs(additional) do
			local position = element.AbsolutePosition
			local size = element.AbsoluteSize

			local xInbound = x > position.X and x - position.X < size.X
			local yInbound = y > position.Y and y - position.Y < size.Y

			if xInbound and yInbound and element ~= self.container then
				if element.ZIndex > self.container.ZIndex then
					return false
				end
			end
		end
	end]]

	return true
end

function Window:runOverlapping()
	local acceptedInputs = {Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch}

	local function editOverlap(input)
		if not input or table.find(acceptedInputs, input.UserInputType) then
			if not input or self:isOnTop(input.Position.X, input.Position.Y) then
				local highestZIndex = self.container.ZIndex

				for _, window in ipairs(self.handler.windows) do
					if window.container ~= self.container then
						highestZIndex = math.max(highestZIndex, window.container.ZIndex)
					end
				end

				self.container.ZIndex = highestZIndex + 1
			end
		end
	end

	self.container.InputBegan:Connect(editOverlap)
	self.header.InputBegan:Connect(editOverlap)
	editOverlap()
end

function Window:allocateSpace(size, maxCycles)
	size = self:toAbsolute(size or self.container.Size)
	maxCycles = maxCycles or 50

	local position = (camera.ViewportSize - size) / 2
	local incrementDelta = Vector2.new(17.5, 17.5)

	local function isTaken(position)
		for _, window in pairs(self.handler.windows) do
			if (window.container.AbsolutePosition - position).magnitude < 1 then
				return true
			end
		end
		return false
	end

	local cycleIndex = 0
	while cycleIndex <= maxCycles and isTaken(position) do
		local updatedPosition = position + incrementDelta
		local endPosition = updatedPosition + size

		updatedPosition = Vector2.new(
			updatedPosition.X % camera.ViewportSize.X,
			updatedPosition.Y % camera.ViewportSize.Y
		)

		--[[if endPosition.X > camera.ViewportSize.X then
			updatedPosition = Vector2.new(0, updatedPosition.Y)
		elseif endPosition.Y > camera.ViewportSize.Y then
			updatedPosition = Vector2.new(updatedPosition.X, 0)
		end]]

		position = updatedPosition
		cycleIndex = cycleIndex + 1
	end

	local anchorPoint = self.container.AnchorPoint
	self.container.Position = UDim2.new(
		0, position.X + anchorPoint.X*size.X,
		0, position.Y + anchorPoint.Y*size.Y
	)
end

function Window:runDragging()
	local dragging
	local dragInput
	local dragStart
	local startPosition

	local function update(input)
		if not self.draggable or self.maximized or not self:isOnTop(input.Position.X, input.Position.Y) then
			return
		end

		local delta = input.Position - dragStart
		local position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		if self.dragTween then
			self.container:TweenPosition(position, "Out", "Back", 0.325, true)
		else
			self.container.Position = position
		end
	end

	self.header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = self.container.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	self.header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function Window:runResizing()
	local dragging
	local dragInput
	local dragStart
	local startPosition
	local startSize

	local function update(input)
		if not self.resizable or self.maximized then
			return
		end

		local delta = input.Position - dragStart
		self.container.Size = UDim2.new(
			0, math.clamp(startSize.X + delta.X, self.minimumSize.X, self.maximumSize.X),
			0, math.clamp(startSize.Y + delta.Y, self.minimumSize.Y, self.maximumSize.Y)
		)
	end

	self.resizeButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = self.container.AbsolutePosition
			startSize = self.container.AbsoluteSize
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	self.resizeButton.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function Window:build(size, position)
	local container = Instance.new("Frame", self.handler.gui)
	local window = Instance.new("Frame", container)
	local uiCorner = Instance.new("UICorner", window)
	local shadow = Instance.new("ImageLabel", window)
	local body = Instance.new("Frame", window)
	local header = Instance.new("Frame", window)
	local headerCorner = Instance.new("UICorner", header)
	local resizeButton = Instance.new("Frame", window)
	local title = Instance.new("TextLabel", header)
	local controls = Instance.new("Frame", header)
	local controlsLayout = Instance.new("UIListLayout", controls)

	container.Name = self.name or "Window"
	container.BackgroundTransparency = 1
	container.Size = size or UDim2.new(0, 400, 0, 250)
	container.Position = position or UDim2.new(
		0, (camera.ViewportSize.X - container.AbsoluteSize.X) / 2,
		0, (camera.ViewportSize.Y - container.AbsoluteSize.Y) / 2
	)

	window.Name = "Content"
	window.ZIndex = 2
	window.Size = UDim2.new(1, 0, 1, 0)
	window.BackgroundTransparency = 0.025
	self.handler.themeSyncer:bindElement(window, "BackgroundColor3", "background")
	self.handler.themeSyncer:bindElement(window, "BackgroundTransparency", "transparency")

	uiCorner.Name = "Corner"
	self.handler.themeSyncer:bindElement(uiCorner, "CornerRadius", "roundness")

	shadow.Name = "Shadow"
	shadow.Image = "rbxassetid://1113384364"
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(50, 50, 50, 50)
	shadow.Size = UDim2.new(1, 80, 1, 80)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.ImageTransparency = 0.75
	self.handler.themeSyncer:bindElement(shadow, "Visible", "shadow")

	body.Name = "Body"
	body.Size = UDim2.new(1, 0, 1, -25)
	body.Position = UDim2.new(0, 0, 0, 25)
	body.BackgroundTransparency = 1
	body.ClipsDescendants = true

	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 25)
	header.BorderSizePixel = 0
	self.handler.themeSyncer:bindElement(header, "BackgroundColor3", "headerBackground")
	self.handler.themeSyncer:bindElement(header, "BackgroundTransparency", "transparency")

	headerCorner.Name = "Corner"
	self.handler.themeSyncer:bindElement(headerCorner, "CornerRadius", "roundness")

	resizeButton.Name = "ResizeButton"
	resizeButton.Position = UDim2.new(1, -10, 1, -10)
	resizeButton.Size = UDim2.new(0, 10+5, 0, 10+5)
	resizeButton.BackgroundTransparency = 1
	--resizeButton.Text = ""
	resizeButton.MouseEnter:Connect(function()
		mouse.Icon = "rbxassetid://1243145350"
	end)
	resizeButton.MouseLeave:Connect(function()
		mouse.Icon = ""
	end)

	title.Name = "Title"
	title.Size = UDim2.new(1, -10, 1, -10)
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Position = UDim2.new(0.5, 0, 0.5, 0)
	title.BackgroundTransparency = 1
	title.TextScaled = true
	title.Font = Enum.Font.Gotham
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.Text = self.name or "Untitled Window"
	self.handler.themeSyncer:bindElement(title, "TextColor3", "text")

	controls.Name = "Controls"
	controls.Size = UDim2.new(1, -10, 1, -2)
	controls.Position = UDim2.new(0.5, 0, 0.5, 0)
	controls.AnchorPoint = Vector2.new(0.5, 0.5)
	controls.BackgroundTransparency = 1

	controlsLayout.Name = "ListLayout"
	controlsLayout.Padding = UDim.new(0, 5)
	controlsLayout.FillDirection = Enum.FillDirection.Horizontal
	controlsLayout.SortOrder = Enum.SortOrder.Name
	controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	--[[local closeButton = Instance.new("TextButton", controls)
	local closeIcon = Instance.new("ImageLabel", closeButton)

	local minimizeButton = Instance.new("TextButton", controls)
	local minimizeIcon = Instance.new("Frame", minimizeButton)

	closeButton.Name = "Close"	
	closeButton.Size = UDim2.new(0, 40, 1, 0)
	closeButton.Text = ""
	closeButton.BackgroundTransparency = 1

	closeIcon.Name = "2"
	closeIcon.Size = UDim2.new(0, 10, 0, 10)
	closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	closeIcon.Image = "rbxassetid://5522725451"
	closeIcon.ImageTransparency = 0.3
	closeIcon.BackgroundTransparency = 1
	self.handler.themeSyncer:bindElement(closeIcon, "ImageColor3", "text")

	minimizeButton.Name = "1"	
	minimizeButton.Size = UDim2.new(0, 28, 1, 0)
	minimizeButton.Text = ""
	minimizeButton.BackgroundTransparency = 1

	minimizeIcon.Name = "Icon"
	minimizeIcon.Size = UDim2.new(0, 13, 0, 2)
	minimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	minimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	minimizeIcon.BackgroundTransparency = 0.5
	minimizeIcon.BorderSizePixel = 0
	self.handler.themeSyncer:bindElement(minimizeIcon, "BackgroundColor3", "text")]]
	local closeButton = Instance.new("TextButton", controls)
	local minimizeButton = Instance.new("TextButton", controls)
	local maximizeButton = Instance.new("TextButton", controls)

	--[[local closeIcon = Instance.new("ImageLabel", closeButton)
	local minimizeIcon = Instance.new("ImageLabel", minimizeButton)
	local maximizeIcon = Instance.new("ImageLabel", maximizeButton)]]

	local closeCorner = Instance.new("UICorner", closeButton)
	local minimizeCorner = Instance.new("UICorner", minimizeButton)
	local maximizeCorner = Instance.new("UICorner", maximizeButton)

	closeButton.Name = "1"
	closeButton.Size = UDim2.new(0, 15, 0, 15)
	closeButton.BackgroundColor3 = Color3.fromRGB(252, 87, 83)
	closeButton.Text = ""
	--self.handler.themeSyncer:bindElement(closeButton, "BackgroundTransparency", "controlBackgroundTransparency")

	minimizeButton.Name = "2"
	minimizeButton.Size = UDim2.new(0, 15, 0, 15)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(253, 188, 64)
	minimizeButton.Text = ""
	--self.handler.themeSyncer:bindElement(minimizeButton, "BackgroundTransparency", "controlBackgroundTransparency")

	maximizeButton.Name = "3"
	maximizeButton.Size = UDim2.new(0, 15, 0, 15)
	maximizeButton.BackgroundColor3 = Color3.fromRGB(51, 199, 72)
	maximizeButton.Text = ""
	--self.handler.themeSyncer:bindElement(maximizeButton, "BackgroundTransparency", "controlBackgroundTransparency")

	--[[closeIcon.Name = "Icon"
	closeIcon.Size = UDim2.new(1, -5, 1, -5)
	closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	closeIcon.BackgroundTransparency = 1
	closeIcon.Image = "rbxassetid://6095654890"
	self.handler.themeSyncer:bindElement(closeIcon, "ImageColor3", "text")
	self.handler.themeSyncer:bindElement(closeIcon, "ImageTransparency", "controlIconTransparency")
	
	minimizeIcon.Name = "Icon"
	minimizeIcon.Size = UDim2.new(1, -5, 1, -5)
	minimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	minimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	minimizeIcon.BackgroundTransparency = 1
	minimizeIcon.Image = "rbxassetid://6095654175"
	self.handler.themeSyncer:bindElement(minimizeIcon, "ImageColor3", "text")
	self.handler.themeSyncer:bindElement(minimizeIcon, "ImageTransparency", "controlIconTransparency")
	
	maximizeIcon.Name = "Icon"
	maximizeIcon.Size = UDim2.new(1, -5, 1, -5)
	maximizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	maximizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	maximizeIcon.BackgroundTransparency = 1
	maximizeIcon.Image = "rbxassetid://6095655417"
	self.handler.themeSyncer:bindElement(maximizeIcon, "ImageColor3", "text")
	self.handler.themeSyncer:bindElement(maximizeIcon, "ImageTransparency", "controlIconTransparency")]]

	self.handler.themeSyncer:bindElement(closeCorner, "CornerRadius", "controlRoundness")
	self.handler.themeSyncer:bindElement(minimizeCorner, "CornerRadius", "controlRoundness")
	self.handler.themeSyncer:bindElement(maximizeCorner, "CornerRadius", "controlRoundness")

	controlsLayout:GetPropertyChangedSignal("HorizontalAlignment"):Connect(function()
		local isRight = controlsLayout.HorizontalAlignment == Enum.HorizontalAlignment.Right
		closeButton.Name = isRight and "3" or "1"
		minimizeButton.Name = isRight and "2" or "2"
		maximizeButton.Name = isRight and "1" or "3"
	end)
	self.handler.themeSyncer:bindElement(controlsLayout, "HorizontalAlignment", "controlAlignment")

	local toAdd = {
		container = container,
		window = window,
		corner = uiCorner,
		body = body,
		header = header,
		headerCorner = headerCorner,
		resizeButton = resizeButton,
		title = title,
		controls = controls,
		controlsLayout = controlsLayout,
		maximumSize = Vector2.new(800, 500),
		minimumSize = Vector2.new(300, 175),
		buttons = {
			close = closeButton,
			minimize = minimizeButton,
			maximize = maximizeButton
		},
		lastState = {
			size = window.Size,
			position = window.Position
		}
	}

	for name, object in pairs(toAdd) do
		self[name] = object
	end

	return window
end

function Window:add(originalClass, data)
	local class = originalClass

	--[[if class == "TextLabel" then
		class = "TextBox"
	end]]

	local object = Instance.new(class, self.body)

	if typeof(data) == "table" then
		for property, value in pairs(data) do
			object[property] = value
		end
	elseif typeof(data) == "Instance" then
		object.Parent = data
	end

	--[[if originalClass == "TextLabel" then
		object.ClearTextOnFocus = false
		object.TextEditable = false
	end]]

	return object
end

function Window:init(size)
	if not self.window then
		self:build(size)
		self:allocateSpace()
		self:runOverlapping()

		self.buttons.close.MouseButton1Click:Connect(function()
			self:close()
		end)

		self.buttons.minimize.MouseButton1Click:Connect(function()
			self:minimize()
		end)

		self.buttons.maximize.MouseButton1Click:Connect(function()
			self:maximize()
		end)
	end

	if self.runDragging then
		self:runDragging()
	end

	if self.runResizing then
		self:runResizing()
	end
end

function Window.new(handler, name, size)
	local self = setmetatable({
		handler = handler,
		name = name,
		opened = Signal.new("opened"),
		closed = Signal.new("closed"),
		minimized = Signal.new("minimized"),
		draggable = true,
		dragTween = false,
		resizable = true,
		maximized = false,
	}, Window)

	self:init(size)

	return self
end


local Dock = {}
Dock.__index = Dock

function Dock:add(name, clickCallback)
	local element = Instance.new("TextButton", self.dock)
	local corner = Instance.new("UICorner", element)
	local textLabel = Instance.new("TextLabel", element)

	element.Name = name
	element.Size = UDim2.new(0, 200, 1, 0)
	element.BorderSizePixel = 0
	element.Text = ""
	self.handler.themeSyncer:bindElement(element, "BackgroundColor3", "background")
	self.handler.themeSyncer:bindElement(element, "BackgroundTransparency", "transparency")

	corner.Name = "Corner"
	self.handler.themeSyncer:bindElement(corner, "CornerRadius", "roundness")

	textLabel.Name = "Content"
	textLabel.Size = UDim2.new(1, -10, 0.5, -10)
	textLabel.Position = UDim2.new(0.5, 0, 0.25, 0)
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = name
	textLabel.TextScaled = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Font = Enum.Font.Gotham
	self.handler.themeSyncer:bindElement(textLabel, "TextColor3", "text")

	local clickConnection = element.MouseButton1Click:Connect(function()
		if self.elements[name] then
			for _, callback in ipairs(self.elements[name].callbacks or {}) do
				pcall(callback, self.elements[name])
			end
		end
	end)

	local toAdd = {
		button = element,
		corner = corner,
		label = textLabel,
		callbacks = {clickCallback},
		clickConnection = clickConnection
	}

	self.elements[name] = toAdd
	return self.elements[name]
end

function Dock:remove(name)
	if self.elements[name] and self.elements[name].button then
		local closeTween = TweenService:Create(self.elements[name].button, TweenInfo.new(0.5), {
			Size = UDim2.new(0,self.elements[name].button.AbsoluteSize.X, 0, 0)
		})

		closeTween.Completed:Connect(function()
			self.elements[name].button:Destroy()
			if self.elements[name].clickConnection then
				self.elements[name].clickConnection:Disconnect()
			end
			self.elements[name] = nil
		end)

		closeTween:Play()
	end
end

function Dock:connect(name, callback)
	if self.elements[name] then
		self.elements[name].callbacks = self.elements[name].callbacks or {}
		self.elements[name].callbacks[#self.elements[name].callbacks+1] = callback
	end
end

function Dock:build()
	local dock = Instance.new("Frame", self.handler.gui)
	local dockLayout = Instance.new("UIListLayout", dock)

	dock.Name = "Dock"
	dock.Position = UDim2.new(0.5, 0, 1, 0)
	dock.Size = UDim2.new(1, 0, 0, (self.size or 25) * 2)
	dock.AnchorPoint = Vector2.new(0.5, 0.5)
	dock.BackgroundTransparency = 1

	dockLayout.Name = "Layout"
	dockLayout.Padding = UDim.new(0, 10)
	dockLayout.FillDirection = Enum.FillDirection.Horizontal
	dockLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	dockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	dockLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local toAdd = {
		dock = dock,
		dockLayout = dockLayout
	}

	for name, object in pairs(toAdd) do
		self[name] = object
	end

	return dock
end

function Dock:sync()
	if self.dynamic then
		UserInputService.InputChanged:Connect(function(input, gameProcessed)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				TweenService:Create(self.dock, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
					AnchorPoint = Vector2.new(
						0,
						(input.Position.Y >= camera.ViewportSize.Y - self.dock.AbsoluteSize.Y/2 and 0.5 or 0)
					)
				}):Play()
			end
		end)
	end
end

function Dock:init()
	if not self.dock then
		self:build()
	end
	self:sync()
end

function Dock.new(handler)
	local self = setmetatable({
		handler = handler,
		size = 27.5,
		dynamic = not TERMINAL_MODE,
		elements = {}
	}, Dock)

	self:init()

	return self
end


local Terminal = {}
Terminal.__index = Terminal

function Terminal:updateSize()
	local contentSize = self.contentLayout.AbsoluteContentSize
	self.content.CanvasSize = UDim2.new(
		0, contentSize.X,
		0, contentSize.Y + self.content.AbsoluteSize.Y
	)
end

function Terminal:connectBoundsUpdate(object, callback)
	local function callbackProxy(...)
		callback(object, ...)
		self:updateSize()
	end

	object:GetPropertyChangedSignal("Text"):Connect(callbackProxy)
	object:GetPropertyChangedSignal("TextSize"):Connect(callbackProxy)

	if AUTO_TEXT_RESIZE then
		--self.content:GetPropertyChangedSignal("AbsoluteSize"):Connect(callbackProxy)
		self.content:GetPropertyChangedSignal("CanvasSize"):Connect(callbackProxy)
	end

	callbackProxy()
end

function Terminal:getBounds(object, text, maxSize)
	return TextService:GetTextSize(
		text,
		object.TextSize,
		object.Font,
		maxSize or Vector2.new(
			self.content.CanvasSize.X.Offset,
			9e6
		)
	)
end

function Terminal:addText(text, color, isPrompt)
	if not text then
		return
	end

	local textLabel = self.window:add("TextLabel", self.content)

	if typeof(text) == "string" and script then
		text = text:gsub(script:GetFullName(), "rCMD")
	end

	textLabel.Name = #self.content:GetChildren()
	textLabel.Text = text
	textLabel.TextSize = self.textSize or 16
	textLabel.Size = UDim2.new(1, 0, 0, 25)
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.BackgroundTransparency = 1
	self.handler.themeSyncer:bindElement(textLabel, "TextColor3", isPrompt and "boxPrefix" or "text")

	self:connectBoundsUpdate(textLabel, function()
		local bounds = self:getBounds(textLabel, textLabel.Text)
		textLabel.Size = UDim2.new(1, -self.content.ScrollBarThickness, 0, bounds.Y)
		textLabel.TextScaled = not textLabel.TextScaled
		textLabel.TextScaled = not textLabel.TextScaled
	end)

	if isPrompt then
		local textBox = self.window:add("TextBox", textLabel)

		textBox.Name = #self.content:GetChildren()
		textBox.Text = ""
		textBox.PlaceholderText = "Enter command here"
		textBox.TextSize = self.textSize or 16
		textBox.Position = UDim2.new(0, textLabel.TextBounds.X+10, 0, 0)
		textBox.Size = UDim2.new(1, -(textLabel.TextBounds.X+10), 1, 0)
		textBox.Font = Enum.Font.Gotham
		textBox.TextXAlignment = Enum.TextXAlignment.Left
		textBox.TextYAlignment = Enum.TextYAlignment.Top
		textBox.BackgroundTransparency = 1
		textBox.ClearTextOnFocus = false
		self.handler.themeSyncer:bindElement(textBox, "TextColor3", "textBox")

		self:connectBoundsUpdate(textBox, function()
			local bounds = self:getBounds(textBox, textBox.Text)
			textLabel.Size = UDim2.new(1, -self.content.ScrollBarThickness, 0, bounds.Y)
		end)
		return textLabel, textBox
	end

	return textLabel
end

function Terminal:addPrompt(givenPrefix, callback)
	local prefix = "terminal:~ " .. (givenPrefix and tostring(givenPrefix) or localPlayer.Name) .. "$"
	if givenPrefix == ">" then
		prefix = ">"
	end

	local label, box = self:addText(prefix, nil, true)

	local focused = false
	local inputConnections = {}

	callback = callback or self.defaultCallback
	local function callbackProxy()
		box.TextEditable = false
		for _, connection in pairs(inputConnections) do
			connection:Disconnect()
		end
		local success, response = pcall(callback or self.defaultCallback, box.Text)
		if not success then
			self:addText(("Unable to handle input: %s"):format(response))
		end
	end

	local inputs = {Enum.KeyCode.Return, Enum.KeyCode.ButtonA}
	inputConnections.focused = box.Focused:Connect(function()
		focused = true
	end)
	inputConnections.focusLost = box.FocusLost:Connect(function()
		wait()
		focused = false
	end)
	inputConnections.keyCode = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if table.find(inputs, input.KeyCode) and focused then
			callbackProxy()
		end
	end)
	inputConnections.onScreenKeyboard = box.ReturnPressedFromOnScreenKeyboard:Connect(function()
		callbackProxy()
	end)

	if box.AbsolutePosition.Y > self.content.AbsolutePosition.Y + self.content.AbsoluteSize.Y then
		self.content.CanvasPosition = Vector2.new(
			0,
			math.max(
				self.content.CanvasPosition.Y, 
				(box.AbsolutePosition.Y + box.AbsoluteSize.Y) - (self.content.AbsolutePosition.Y - self.content.AbsoluteSize.Y) -- for some room lol
			)
		)
	end
	box:CaptureFocus()
end

function Terminal:build()
	local window = self.handler:addWindow("Terminal")
	local content = window:add("ScrollingFrame")
	local contentLayout = window:add("UIListLayout", content)

	content.Name = "Content"
	content.Size = UDim2.new(1, -10, 1, -10)
	content.AnchorPoint = Vector2.new(0.5, 0.5)
	content.Position = UDim2.new(0.5, 0, 0.5, 0)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 5
	content.ScrollBarImageTransparency = 0.5

	contentLayout.Name = "Layout"
	contentLayout.Padding = UDim.new(0, 5)
	contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top	
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local toAdd = {
		window = window,
		content = content,
		contentLayout = contentLayout
	}

	for name, object in pairs(toAdd) do
		self[name] = object
	end
end

function Terminal:init()
	if not self.window then
		self:build()
	end

	self:addText(("rCMD [%s] - level %d\n(c) 2020 SenselessDemon. All rights reserved."):format(VERSION, getIdentity()))
	self:addPrompt()
end

function Terminal.new(handler, defaultCallback)
	local self = setmetatable({
		handler = handler,
		inputBinder = InputBinder.new(),
		textSize = 15
	}, Terminal)

	self.inputBinder:bind({Enum.KeyCode.LeftControl, Enum.KeyCode.Equals}, function()
		if self.content then
			for _, descendant in ipairs(self.content:GetDescendants()) do
				if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
					descendant.TextSize = descendant.TextSize + 2
				end
			end
		end
	end)
	self.inputBinder:bind({Enum.KeyCode.LeftControl, Enum.KeyCode.Minus}, function()
		if self.content then
			for _, descendant in ipairs(self.content:GetDescendants()) do
				if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
					descendant.TextSize = descendant.TextSize - 2
				end
			end
		end
	end)

	self.defaultCallback = defaultCallback or function(entry)
		self:addPrompt()
	end
	self:init()

	return self
end


local List = {}
List.__index = List

function List:updateSize()
	local contentSize = self.contentLayout.AbsoluteContentSize
	self.content.CanvasSize = UDim2.new(
		0, contentSize.X,
		0, contentSize.Y
	)
end

function List:connectBoundsUpdate(object, callback)
	local function callbackProxy(...)
		callback(object, ...)
		self:updateSize()
	end

	object:GetPropertyChangedSignal("Text"):Connect(callbackProxy)
	object:GetPropertyChangedSignal("TextSize"):Connect(callbackProxy)

	if AUTO_TEXT_RESIZE then
		self.content:GetPropertyChangedSignal("AbsoluteSize"):Connect(callbackProxy)
		self.content:GetPropertyChangedSignal("CanvasSize"):Connect(callbackProxy)
	end

	callbackProxy()
end

function List:getBounds(object, text, maxSize)
	return TextService:GetTextSize(
		text,
		object.TextSize,
		object.Font,
		maxSize or Vector2.new(
			self.content.CanvasSize.X.Offset,
			9e6
		)
	)
end

function List:addItem(text, onHover)
	if not text then
		return
	end

	local textLabel = self.window:add("TextLabel", self.content)
	textLabel.Name = #self.content:GetChildren()
	textLabel.Text = text
	textLabel.TextSize = self.textSize or 16
	textLabel.Size = UDim2.new(1, 0, 0, 25)
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.BackgroundTransparency = 1
	textLabel.TextTransparency = 1
	self.handler.themeSyncer:bindElement(textLabel, "TextColor3", "text")

	self:connectBoundsUpdate(textLabel, function()
		local bounds = self:getBounds(textLabel, textLabel.Text)
		textLabel.Size = UDim2.new(1, -self.content.ScrollBarThickness, 0, bounds.Y)
		textLabel.TextScaled = not textLabel.TextScaled
		textLabel.TextScaled = not textLabel.TextScaled
	end)

	if onHover then
		local hoverIndicator = self.window:add("StringValue", textLabel)
		hoverIndicator.Name = "Hover"
		hoverIndicator.Value = onHover

		self.handler.mouseHover:addElement(textLabel, nil, function(x, y)
			return self.window:isOnTop(x, y, self.handler.windowMenu and {self.handler.windowMenu.container})
		end)
	end

	TweenService:Create(textLabel, TweenInfo.new(0.5), {
		TextTransparency = 0
	}):Play()

	return textLabel
end

function List:build(size)
	local window = self.handler:addWindow(self.name, size or UDim2.new(0, 250, 0, 300))
	local content = window:add("ScrollingFrame")
	local contentLayout = window:add("UIListLayout", content)

	window.minimumSize = Vector2.new(125, 200)
	window.maximumSize = Vector2.new(400, 500)

	content.Name = "Content"
	content.Size = UDim2.new(1, -10, 1, -10)
	content.AnchorPoint = Vector2.new(0.5, 0.5)
	content.Position = UDim2.new(0.5, 0, 0.5, 0)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 5
	content.ScrollBarImageTransparency = 0.5

	contentLayout.Name = "Layout"
	contentLayout.Padding = UDim.new(0, 5)
	contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top	
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local toAdd = {
		window = window,
		content = content,
		contentLayout = contentLayout
	}

	for name, object in pairs(toAdd) do
		self[name] = object
	end
end

function List:init(initialData, ...)
	if not self.window then
		self:build(...)
	end

	coroutine.wrap(function()
		for _, item in ipairs(initialData) do
			self:addItem(unpack(item))
			wait(0.1)
		end
	end)()
end

function List:formatData(rawData)
	local data = {}
	if typeof(rawData) == "string" then
		rawData = rawData:split("\n")
	end
	for _, element in ipairs(rawData) do
		if typeof(element) == "string" then
			element = {element}
		end
		data[#data+1] = element
	end
	return data
end

function List.new(handler, name, data, ...)
	local self = setmetatable({
		handler = handler,
		name = name
	}, List)

	self:init(self:formatData(data or {}), ...)

	return self
end


local NotificationHandler = {}
NotificationHandler.__index = NotificationHandler

function NotificationHandler:addNotification(...)
	local notification = Notification.new(self, ...)
	self.notifications[#self.notifications+1] = notification
	return notification
end

function NotificationHandler.new(windowHandler)
	local self = setmetatable({
		windowHandler = windowHandler,
		gui = Instance.new("Frame", windowHandler.gui),
		themeSyncer = windowHandler.themeSyncer,
		notifications = {},
	}, NotificationHandler)

	self.gui.Name = "Notifications"
	self.gui.Size = UDim2.new(1, 0, 1, 0)
	self.gui.BackgroundTransparency = 1

	return self
end


local WindowHandler = {}
WindowHandler.__index = WindowHandler

function WindowHandler:addWindow(name, ...)
	local window = Window.new(self, name, ...)
	window.header.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.windowMenu.window = window
			wait()
			self.windowMenu:display(UDim2.new(0, input.Position.X, 0, input.Position.Y))
		end
	end)
	self.windows[name] = window
	self.dock:add(name, function()
		window:open()
	end)
	return window
end

function WindowHandler.new(parent, theme)
	local self = setmetatable({
		gui = Instance.new("ScreenGui"),
		windows = {},
		themeSyncer = ThemeSyncer.new(theme),
	}, WindowHandler)

	if syn then
		syn.protect_gui(self.gui)
	end

	self.gui.Parent = parent or playerGui
	self.gui.DisplayOrder = 9e9
	--self.gui.IgnoreGuiInset = true
	self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	if not self.mouseHover then
		self.mouseHover = MouseHover.new(self)
	end
	if not self.windowMenu then
		self.windowMenu = Menu.new(self, {"Restore", "Minimize", "Maximize", "Close"})
		self.windowMenu.clicked:connect(function(button)
			local window = self.windowMenu.window
			if window then
				if button == "Restore" then
					if window.maximized then
						window:maximize()
					end
				elseif button == "Minimize" then
					if not window.maximized then
						window:maximize()
					end
				elseif button == "Minimize" then
					window:minimize()
				elseif button == "Close" then
					window:close()
				end
			end
			self.windowMenu.window = nil
		end)

		local acceptedInputs = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.Touch}
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if self.windowMenu.container.Visible and table.find(acceptedInputs, input.UserInputType) then
				local position = Vector2.new(input.Position.X, input.Position.Y)

				local absolutePosition, absoluteSize = self.windowMenu.container.AbsolutePosition, self.windowMenu.container.AbsoluteSize
				local endPoint = absolutePosition + absoluteSize

				if not ((position.X > absolutePosition.X and position.Y > absolutePosition.Y) and
					(position.X > endPoint.X and position.Y > endPoint.Y)
					) then
					wait()
					self.windowMenu:close()
				end
			end
		end)
	end
	if not self.dock then
		self.dock = Dock.new(self)
	end

	return self
end


local Task = {}
Task.__index = Task

function Task:run(...)
	local function run(...)
		self.alive = true
		local response = {pcall(self.process, ...)}

		local success = response[1]
		local result = {select(2, unpack(response))}

		if not success and self.errorHandler then
			self.errorHandler(unpack(result))
		else
			return unpack(result)
		end
	end

	if self.thread then
		run = coroutine.wrap(run)
	end

	return run(...)
end

function Task:kill()
	self.alive = false
end

function Task.new(process, errorHandler)
	local self = setmetatable({
		environment = {},
		process = process,
		yields = false,
		thread = false,
		alive = true,
		killFunction = function()
			--coroutine.yield()
		end,
		errorHandler = errorHandler or function(...)
			-- something
		end
	}, Task)

	self.environmentProxy = setmetatable({}, {
		__index = function(_, index)
			if self.alive then
				return self.environment[index]
			else
				return self.killFunction()
			end
		end,

		__newindex = function(_, index, value)
			if self.alive then
				self.environment[index] = value
			else
				self.killFunction()
			end
		end,
	})

	setfenv(self.process, self.environmentProxy)

	return self
end


local Sandbox = {}
Sandbox.__index = Sandbox

function Sandbox:addTask(task)
	self.tasks[#self.tasks+1] = task
	task.environment = self.environment
	return #self.tasks
end

function Sandbox:clearTasks()
	for _, task in ipairs(self.tasks or {}) do
		task:kill()
	end
end

function Sandbox:updateEnvironment(environment)
	for name, variable in pairs(environment) do
		self.environment[name] = variable
	end
end

function Sandbox.new(environment)
	local self = setmetatable({
		tasks = {},
		environment = environment or {}
	}, Sandbox)

	return self
end


local Logger = {}
Logger.__index = Logger

function Logger:log(type, ...)
	if self.options[type] then
		self.logAdded:fire(type, ...)
		self.logs[type][#self.logs[type]+1] = {tick(), ...}
	end
end

function Logger:addConnection(connection)
	self.connections[#self.connections+1] = connection
end

function Logger:addPlayer(player)
	self:addConnection(player.Chatted:Connect(function(message)
		self:log("chat", player, message)
	end))
end

function Logger:init()
	for _, player in ipairs(Players:GetPlayers()) do
		self:addPlayer(player)
	end

	self:addConnection(Players.PlayerAdded:Connect(function(player)
		self:log("join", player)
		self:addPlayer(player)
	end))

	self:addConnection(Players.PlayerRemoving:Connect(function(player)
		self:log("leave", player)
	end))

	self:addConnection(LogService.MessageOut:Connect(function(message)
		self:log("client", message)
	end))
end

function Logger.new(options)
	local self = setmetatable({
		logs = {
			chat = {},
			join = {},
			leave = {},
			client = {},
			system = {}
		},
		connections = {},
		options = options or {
			chat = true,
			join = true,
			leave = true,
			client = true,
			system = true
		},
		logAdded = Signal.new("logAdded")
	}, Logger)

	self:init()

	return self
end


local Parser = {}
Parser.__index = Parser

function Parser:trim(str)
	return str:match("^%s*(.-)%s*$")
end

function Parser:reconstructArguments(arguments, index)
	local segments = {}

	for index, argument in ipairs(arguments) do
		segments[index] = argument.raw
	end

	segments = {select(index or 1, unpack(segments))}
	return table.concat(segments, self.options.splitKey)
end

function Parser:splitArgumentType(argument)
	local argumentType = argument
	local typeModifier

	if argument:find("<") and argument:sub(#argument) == ">" then
		argumentType = argumentType:sub(1, argument:find("<")-1)
		typeModifier = argument:sub(argument:find("<")+1, #argument-1)
	end

	return argumentType, typeModifier
end

function Parser:splitBatch(rawBatch)
	local overrideSplit = rawBatch:split(self.options.overrideKey)
	local batchElements = {}

	for i = 1, #overrideSplit do
		local overrideSegment = overrideSplit[i]
		overrideSegment = self:trim(overrideSegment)
		if overrideSegment ~= "" then
			if i % 2 == 1 then
				local split = overrideSegment:split(self.options.splitKey)
				for _, splitSegment in ipairs(split) do
					batchElements[#batchElements+1] = splitSegment
				end
			else
				batchElements[#batchElements+1] = overrideSegment
			end
		end
	end

	return batchElements
end

function Parser:parse(data, requiresPrefix)
	local tree = {
		raw = data,
		batches = {}
	}

	if data:sub(1, 3) == "/e " then
		data = data:sub(4)
	end

	data = data:gsub("\n", ""):gsub("\t", "")

	for batchIndex, rawBatch in ipairs(data:split(self.options.batchKey)) do
		rawBatch = self:trim(rawBatch)
		if rawBatch:sub(1, #self.options.prefix) == self.options.prefix then
			rawBatch = rawBatch:sub(#self.options.prefix)
		else
			if requiresPrefix then
				continue
			end
		end

		local batch = {
			raw = rawBatch,
			command = nil,
			arguments = {},
			coreArguments = {}
		}

		local batchElements = self:splitBatch(batch.raw)

		local command = self:trim(batchElements[1])
		local arguments = {select(2, unpack(batchElements))}

		for argumentIndex, rawArgument in ipairs(arguments) do
			if rawArgument:sub(1, #self.options.coreArgumentPrefix) == self.options.coreArgumentPrefix then
				batch.coreArguments[#batch.coreArguments+1] = rawArgument:sub(#self.options.coreArgumentPrefix+1)
			else
				local argument = {
					raw = rawArgument,
					segments = {}
				}

				rawArgument = self:trim(rawArgument)
				local segments = rawArgument:split(self.options.argumentSplitKey)
				for segmentIndex, rawSegment in ipairs(segments) do
					local segment = {
						raw = rawSegment,
						call = nil,
						parameter = nil,
					}

					rawSegment = self:trim(rawSegment)
					segment.call, segment.parameter = unpack(segment.raw:split(self.options.argumentParameterKey))
					argument.segments[segmentIndex] = segment
				end

				batch.arguments[#batch.arguments+1] = argument
			end
		end

		batch.command = command
		tree.batches[batchIndex] = batch
	end

	return tree
end

function Parser.new(options)
	local self = setmetatable({
		options = options or {
			prefix = "/",
			batchKey = ";",
			splitKey = " ",
			overrideKey = "\"",
			coreArgumentPrefix = "--",
			argumentSplitKey = ",",
			argumentParameterKey = "-"
		}
	}, Parser)

	return self
end


local Plugin = {}
Plugin.__index = Plugin

function Plugin:setEnvironment(environmentVariables)
	local pluginEnvironment = getfenv(self.process)
	for name, value in pairs(environmentVariables) do
		pluginEnvironment[name] = value
	end
end

function Plugin:execute(...)
	local response = {pcall(self.process, ...)}

	local success = response[1]
	local returns = {select(2, unpack(response))}

	return success, returns
end

function Plugin.new(name, process)
	local self = setmetatable({
		name = name,
		process = process
	}, Plugin)

	return self
end


local CommandSystem = {}
CommandSystem.__index = CommandSystem

function CommandSystem:error(message, isEnd)
	if self.terminal then
		self.terminal:addText(message)
		if isEnd then
			self.terminal:addPrompt()
		end
	else
		self:notify(message)
	end
	self.logger:log("system", message, true)
end

function CommandSystem:notify(message, onClick)
	if self.terminal then
		self.terminal:addText(message)
	else
		local notification = self.notificationHandler:addNotification("Notification", message, 10)
		notification.clicked:connect(function(...)
			if onClick then
				return onClick(...)
			end
			return self:executeCommandByCall("systemLogs", {}, true)
		end)
		notification:display()
	end
	self.logger:log("system", message)
end

function CommandSystem:createList(name, listData, ...)
	if self.terminal then
		for _, item in ipairs(listData) do
			self.terminal:addText(table.concat(item, " - "))
		end
	else
		return List.new(self.windowHandler, name, listData, ...)
	end
end

function CommandSystem:shutdown()
	self.windowHandler.gui:Destroy()
	if script then
		script:Destroy()
	end
	_G.rCMD = nil
end

function CommandSystem:getTargets(argument, command)
	local targets = {}

	if argument.raw == "" then
		targets = {localPlayer}
	end

	for _, segment in ipairs(argument.segments) do
		local callFound = false

		for _, playerType in ipairs(self.playerTypes) do
			for _, call in ipairs(playerType.calls or {}) do
				if segment.call:lower() == call:lower() then
					local success, response = pcall(playerType.process, command, segment.parameter, self)

					if success then
						callFound = true
						for _, target in ipairs(response or {}) do
							targets[#targets+1] = target
						end
						break
					end
				end
			end
		end

		if not callFound then
			for _, player in ipairs(Players:GetPlayers()) do
				if player.Name:sub(1, #segment.call):lower() == segment.call:lower() then
					targets[#targets+1] = targets
				end
			end
		end
	end

	for index, target in ipairs(targets) do
		if typeof(target) ~= "Instance" or not target:IsA("Player") then
			table.remove(targets, index)
		end
	end

	return targets or {}
end

function CommandSystem:parseArguments(command, arguments, coreArguments)
	local finalArguments = {
		core = {}
	}
	command.arguments = command.arguments or {}
	for index, argument in pairs(command.arguments or {}) do
		if typeof(argument) == "string" then
			argument = {
				name = typeof(index) == "string" and index or argument,
				type = typeof(index) == "string" and argument or "raw"
			}
		end

		local parentType, subType = self.parser:splitArgumentType(argument.type)

		for _, argumentType in ipairs(self.argumentTypes) do
			for _, call in ipairs(argumentType.calls or {}) do
				if parentType:lower() == call:lower() then
					local givenArgument = arguments[index]
					if index == #command.arguments and argumentType.expandable then
						givenArgument.raw = self.parser:reconstructArguments(arguments, index)
					end

					local success, response = pcall(argumentType.process, givenArgument, subType, self)

					if success then
						givenArgument = response
					end
					finalArguments[argument.name] = givenArgument

					break
				end
			end
		end
	end

	for _, coreArgument in ipairs(coreArguments or {}) do
		finalArguments.core[coreArgument] = true
	end

	return finalArguments
end

function CommandSystem:findCommand(call)
	local function validateCall(string1, string2)
		return string1:lower() == (string2 or call):lower()
	end

	local responseType = "process"
	if call:sub(1, 2):lower() == "un" then
		call = call:sub(3)
		responseType = "reverseProcess"
	end

	for _, command in ipairs(self.commands or {}) do
		if validateCall(command.name) then
			return command, responseType
		else
			for _, aliase in ipairs(command.aliases or {}) do
				if validateCall(aliase) then
					return command, responseType
				end
			end
			for _, opposite in ipairs(command.opposites or {}) do
				if validateCall(opposite) then
					return command, "reverseProcess"
				end
			end
		end
	end
end

function CommandSystem:executeCommand(command, processType, arguments, isNested)
	if command.requiresTool and not getTool() then
		return self:error("You must have a tool to use this command", true)
	end
	if command.terminalCommand == true and not self.terminal then
		return self:error("This command requires terminal-mode to be enabled", true)
	elseif command.terminalCommand == false and self.terminal then
		return self:error("This command requires terminal-mode to be disabled", true)
	end

	local task = Task.new(command[processType])
	task.yields = true
	task.thread = false
	task.errorHandler = function(err)
		self:error(("Unable to run command: %s"):format(tostring(err)))
	end

	local taskId = self.sandbox:addTask(task)
	local response = {task:run(command, arguments, self)}

	if not isNested and self.terminal then
		self.terminal:addPrompt(self.location)
	end

	return response
end

function CommandSystem:executeCommandByCall(call, ...)
	local command, processType = self:findCommand(call)
	if command and processType then
		self:executeCommand(command, processType, ...)
	end
end

function CommandSystem:executeTree(tree)
	for _, batch in ipairs(tree.batches) do
		local command, processType = self:findCommand(batch.command)
		if command then
			if command[processType] then
				local arguments = self:parseArguments(command, batch.arguments, batch.coreArguments)
				if arguments then
					self:executeCommand(command, processType, arguments)
				end
			else
				self:error(("\"%s\" is not a valid process-type"):format(processType), true)
			end
		else
			local found, result = false, nil
			local instance = batch.arguments[1] and self.location:FindFirstChild(batch.arguments[1].raw or "") or self.location

			if not instance then
				for _, child in ipairs(self.location:GetChildren()) do
					if child.Name:sub(1, #batch.arguments[1].raw):lower() == batch.arguments[1].raw:lower() then
						instance = child
					end
				end
			end

			if instance then
				found, result = pcall(function()
					return instance[batch.command](
						instance,
						unpack(self.parser:reconstructArguments(
							batch.arguments,
							2
							))
					)
				end)

				if found and self.terminal then
					self.terminal:addText(tostring(result))
				end
			end

			if not found then
				self:error(("\"%s\" is not a valid command"):format(batch.command), true)
			end
		end
	end
end

function CommandSystem:addPlugin(plugin)
	self.plugins[plugin.name] = plugin

	plugin:setEnvironment(self)
	local success, result = plugin:execute()

	if not success then
		self:error(("Unable to run %s plugin"):format(plugin.name))
	end
end

function CommandSystem:handleCall(message, isChat)
	local tree = self.parser:parse(message, isChat)
	self:executeTree(tree)
end

function CommandSystem.new()
	local self = setmetatable({
		chatCommands = true,
		cache = Cache.new(),
		location = localPlayer,
		parser = Parser.new(),
		logger = Logger.new(),
		performanceMonitor = PerformanceMonitor.new(),
		inputBinder = InputBinder.new(),
		sandbox = Sandbox.new(getfenv()), -- just gets the global environment, so chill dude
		commands = Commands or {},
		plugins = {},
		variables = {},
		playerTypes = PlayerTypes,
		argumentTypes = ArgumentTypes,
		classes = {
			SignalConnection = SignalConnection,
			Signal = Signal,
			ThemeSyncer = ThemeSyncer,
			PerformanceMonitor = PerformanceMonitor,
			InputBinder = InputBinder,
			Cache = Cache,
			ESP = ESP,
			Aimbot = Aimbot,
			MouseHover = MouseHover,
			Menu = Menu,
			CommandBar = CommandBar,
			Notification = Notification,
			Window = Window,
			Dock = Dock,
			Terminal = Terminal,
			List = List,
			WindowHandler = WindowHandler,
			Task = Task,
			Sandbox = Sandbox,
			Logger = Logger,
			Parser = Parser,
			CommandSystem = CommandSystem
		}
	}, CommandSystem)

	local function callback(message, fromChat)
		if self.parser:trim(message) ~= "" then
			self:handleCall(message, fromChat)
		else
			if self.terminal and not fromChat then
				self.terminal:addPrompt()
			else
				self.commandBar.box.Text = ""
			end
		end
	end

	--[[self.sandbox:updateEnvironment({
		error = function(...)
			return self:error(...)
		end,
		print = function(...)
			return self:notify(...)
		end,
		luaprint = function(...)
			return print(...)
		end,
		debugprint = function(...)
			return self.logger:add("system", ..., false)
		end
	})]]
	self.windowHandler = WindowHandler.new()
	self.notificationHandler = NotificationHandler.new(self.windowHandler, callback)
	if not TERMINAL_MODE then
		self.commandBar = CommandBar.new(self.windowHandler, OPEN_HOTKEY, callback)
		self.commandBar.defaultCallback = callback

		local notification = self.notificationHandler:addNotification("Welcome to rCMD", "Click here to open the help window", 10)
		notification.clicked:connect(function()
			self:executeCommandByCall("help", {}, true)
		end)
		notification:display()
	else
		self.terminal = Terminal.new(self.windowHandler, callback)
		self.terminal.defaultCallback = callback
	end

	localPlayer.Chatted:Connect(function(message)
		if self.chatCommands then
			callback(message, true)
		end
	end)

	for _, command in pairs(self.commands) do
		if command.init then
			local task = Task.new(command.init)
			task.yields = true
			task.thread = false
			task.errorHandler = function(err)
				self:error(("Unable to initialize command: %s"):format(tostring(err)))
			end

			local taskId = self.sandbox:addTask(task)
			local response = {task:run(command, self)}
		end
	end

	return self
end


-- you've made it this far, so might as well join our discord :D
-- https://discord.io/demonden

local commandSystem = CommandSystem.new()

pcall(function()
	commandSystem.windowHandler.gui.Parent = CoreGui
end)

local rCMD = {
	running = true,
	bootTime = tick() - startTime,
	commandSystem = commandSystem,
}

_G.rCMD = rCMD
return rCMD

-- if you were looking for any of that obfuscated getfenv stuff, you just got caught lacking
-- this script doesnt have any of that stuff, so chill
-- i'm not that type of guy

-- SenselessDemon
