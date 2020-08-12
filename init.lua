-- SenslessDemon

local AUTO_TEXT_RESIZE = true
local VERSION = "v0.2.2"

local startTime = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local NetworkClient = game:GetService("NetworkClient")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
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
		transparency = 0,
		shadow = true,
	}
}


local PlayerTypes = {
	{
		calls = {"me", "myself", "i", "@p"},
		process = function(command, parameter)
			return {localPlayer}
		end
	},

	{
		calls = {"all", "everyone", "@e"},
		process = function(command, parameter)
			return Players:GetPlayers()
		end
	},

	{
		calls = {"others", "everyoneElse", "@a"},
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
		calls = {"random"},
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
		calls = {"boolean", "bool"},
		process = function(argument)
			argument = argument.raw:lower()
			return (argument == "on" or argument == "true" or argument == "yes") or false
		end
	},

	{
		calls = {"player(s)", "target(s)", "players", "targets"},
		process = function(argument, commandSystem)
			return commandSystem:getTargets(argument)
		end
	},

	{
		calls = {"player", "target", "individual"},
		process = function(argument, commandSystem)
			return commandSystem:getTargets(argument)[1]
		end
	},

	{
		calls = {"theme"},
		expandable = true,
		process = function(argument, commandSystem)
			for name, theme in pairs(Themes) do
				if name:lower() == argument.raw:lower() then
					return theme
				end
			end
			commandSystem.terminal:addText(("\"%s\" is not a valid theme"):format(argument.raw))
			return commandSystem.themeSyncer.currentTheme
		end
	},

	{
		calls = {"command", "cmd"},
		process = function(argument, commandSystem)
			local command = commandSystem:findCommand(argument.raw or "")
			if not command then
				commandSystem.terminal:addText(("\"%s\" is not a valid command"):format(argument.raw))
				return commandSystem.commands[1]
			else
				return command
			end
		end
	},
}


local Commands = {
	{
		name = "echo",
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
		arguments = {},
		process = function(self, arguments, commandSystem)
			commandSystem.terminal = commandSystem.terminal.class.new(commandSystem.windowHandler)
		end,
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
					"This script is running at level " .. getIdentity(),
					"To view a list of commands, enter \"cmds\"",
					"To view info on a specific command, enter \"help [command]\"",
					"If you require further assistance, contact us",
					"To report issues, create one on our repository.",
					"You may also contrubute to rCMD there.",
					"rCMD's Repository: https://github.com/senslessdemon/rcmd",
					"Our Discord server: https://discord.io/demonden"
				}
				for _, message in ipairs(help) do
					commandSystem.terminal:addText(message)
				end
			else
				local command = arguments.command
				if command.hidden and not arguments.core.force then
					return commandSystem.terminal:addText("I do not understand what command you are talking about bro")
				end
				
				local arguments = {}
				for index, argument in ipairs(command.arguments or {}) do
					local display = (argument.optional and "" or "*") .. argument.name
					if argument.type then
						display ..= "[" .. argument.type .. "]"
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
					"Replicates: { " .. (command.noReplication and "no" or "yes"),
					"Reversable: " .. (command.reverseProcess and "yes" or "no")
				}

				for _, line in ipairs(data) do
					commandSystem.terminal:addText(line)
				end
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
							local didExecute, executeResult = pcall(parseResult)

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
				local didExecute, executeResult = pcall(parseResult)

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
					local didExecute, executeResult = pcall(parseResult)
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
			else
				commandSystem.terminal:addText(("Unable to make a GET request to \"%s\""):format(arguments.url))
			end
		end,
	},

	{
		name = "remoteSpy",
		description = "Executes a remote-spy script",
		process = function(self, arguments, commandSystem)
			commandSystem:executeCommand(commandSystem:findCommand("loadScript"), {
				"https://raw.githubusercontent.com/Nootchtai/FrostHook_Spy/master/Spy.lua"
			}, true)
		end
	},
	
	{
		name = "walkSpeed",
		description = "Sets the local character's speed",
		aliases = {"ws", "speed"},
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
		aliases = {"jp"},
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
		name = "bang",
		hidden = true, -- stfu
		description = "I'm sorry god",
		aliases = {"rape"},
		arguments = {
			{
				name = "victim",
				type = "player"
			},
			{
				name = "speed",
				type = "number",
				default = 3
			}
		},
		process = function(self, arguments, commandSystem)
			if commandSystem.cache:get("bang") then
				commandSystem.cache:remove("bang")
			end

			local character = localPlayer.Character
			if character then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoidRootPart and humanoid then
					if humanoid.RigType == Enum.HumanoidRigType.R6 then
						RunService.RenderStepped:Wait()
						commandSystem.cache:set("bang", true)

						local animation = Instance.new("Animation")
						animation.AnimationId = "rbxassetid://148840371"

						local animationTrack = humanoid:LoadAnimation(animation)
						animationTrack:Play(0.1, 1, 1)
						animationTrack:AdjustSpeed(arguments.speed == 0 and 3 or arguments.speed)

						local updateConnection
						updateConnection = RunService.RenderStepped:Connnect(function()
							if not commandSystem.cache:get("bang") then
								updateConnection:Disconnect()
								animationTrack:Stop()
								animationTrack:Destroy()
								animation:Destroy()
							end
							local victimCharacter = arguments.victim.Character
							if victimCharacter and victimCharacter.PrimaryPart then
								character:SetPrimaryPartCFrame(victimCharacter:GetPrimaryPartCFrame())
							end
						end)
					end
				end
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.cache:remove("bang")
		end
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
				commandSystem.terminal:addText("Your exploit does not support the firing of click-detectors")
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
			commandSystem:executeCommand(commandSystem:findCommand("loadScript"), {
				"https://ghostbin.co/paste/yb288/raw"
			}, true)
		end
	},

	{
		name = "console",
		description = "Loads the old Roblox console",
		aliases = {"vr"},
		process = function(self, arguments, commandSystem)
			commandSystem:executeCommand(commandSystem:findCommand("loadScript"), {
				"https://pastebin.com/raw/i35eCznS"
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
		name = "teleport",
		description = "Teleports the given player(s) to the destination",
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
					if character2 then
						character2:SetPrimaryPartCFrame(character1.PrimaryPart.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
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

						connections[target] = RunService.RenderStepped:Connect(function()
							if not commandSystem.cache:get("noclip") then
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
			commandSystem.cache:remove("noclip")
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
				commandSystem.terminal:addText("Your exploit does not have the ability to force mouse input")
			end
		end,
		reverseProcess = function(self, arguments, commandSystem)
			commandSystem.cache:get("autoClick"):Disconnect()
			commandSystem.cache:remove("autoClick")
		end
	},
	
	{
		name = "esp",
		description = "Toggles ESP",
		opposites = {"extraSensoryPerception"},
		arguments = {
			{
				name = "enabled",
				type = "boolean"
			},
		},
		process = function(self, arguments, commandSystem)
			if not commandSystem.cache:get("esp") then
				local esp = ESP.new()
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
}


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
ESP.__Index = ESP

function ESP:addCharacter(character, color)
	if character and not self.container:FindFirstChild(character.Name) then
		local espHolder = Instance.new("Folder", self.container)
		espHolder.Name = character.Name
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("BasePart") then
				local indicator = Instance.new("BoxHandleAdornment", espHolder)
				indicator.Name = child.Name
				indicator.Adornee = child
				indicator.AlwaysOnTop = true
				indicator.Transparency = self.visible and 0.3 or 1
				indicator.Color3 = color
			end
		end
	end
end

function ESP:removeCharacter(character)
	local espHolder = self.container:FindFirstChild(character) or self.container:FindFirstChild(character.Name)
	if espHolder then
		espHolder:Destroy()
	end
end

function ESP:addPlayer(player)
	self.connections[player.Name] = player.CharacterAdded:Connect(function(character)
		self:addCharacter(character)
	end)
end

function ESP:removePlayer(player)
	if player.Character then
		self:removeCharacter(player.Name)
	end
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


local MouseHover = {}
MouseHover.__index = MouseHover

function MouseHover:addElement(uiElement)
	self.connections[uiElement] = {
		mouseEnter = uiElement.MouseEnter:Connect(function()
			uiElement.MouseMoved:Connect(function(mouseX, mouseY)
				self.textLabel.Text = uiElement.Hover.Value
				
				local xBounds = self.textLabel.TextBounds.X
				local yBounds = self.textLabel.TextBounds.Y
				
				self.frame.Size = UDim2.new(0, xBounds+ self.padding*2, 0, yBounds + self.padding*2)
				
				local mouseOffset
				if self.frame.AbsoluteSize.Y <= 28 then
					mouseOffset = (self.frame.AbsoluteSize.Y * 2) - 5
				else
					mouseOffset = 60
				end
				
				if mouseX - self.frame.AbsoluteSize.X >= 0 then
					self.frame.Position = UDim2.new(
						0, mouseX - self.frame.AbsoluteSize.X,
						0, mouseY - self.frame.AbsoluteSize.Y/2 - mouseOffset
					)
				elseif mouseX - self.frame.AbsoluteSize.X <= 0 then
					self.frame.Position = UDim2.new(
						0, mouseX,
						0, mouseY - self.frame.AbsoluteSize.Y/2 - mouseOffset
					)
				end
			end)
		end)
	}
end

function MouseHover:build()
	local frame = Instance.new("Frame")
	local label = Instance.new("TextLabel", frame)
	
	frame.Name = "MouseLabel"
	frame.Size = UDim2.new()
	
	label.Name = "Label"
	label.Size = UDim2.new(1, -self.padding, 1, -self.padding)
	label.Position = UDim2.new(0.5, 0, 0.5, 0)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
end

function MouseHover:init()
	if not self.frame then
		self:build()
	end
end

function MouseHover.new(handler)
	local self = setmetatable({
		handler = handler,
		padding = 5,
		connections = {}
	}, MouseHover)
	
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

function Window:allocateSpace(size, maxCycles)
	size = self:toAbsolute(size or self.container.Size)
	maxCycles = maxCycles or 50
	
	local position = (camera.ViewportSize - size) / 2
	local incrementDelta = 5
	
	local function isTaken(position)
		for _, window in ipairs(self.handler.windows) do
			if window.AbsolutePosition == position then
				return true
			end
		end
		return false
	end
	
	local cycleIndex = 0
	while cycleIndex >= maxCycles or isTaken(position) do
		local updatedPosition = position + incrementDelta
		local endPosition = updatedPosition + size
		
		if endPosition.X > camera.ViewportSize.X then
			updatedPosition = Vector2.new(0, updatedPosition.Y)
		elseif endPosition.Y > camera.ViewportSize.Y then
			updatedPosition = Vector2.new(updatedPosition.X, 0)
		end
		
		position = updatedPosition
		cycleIndex += 1
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
		if not self.draggable or self.maximized then
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

	local closeCorner = Instance.new("UICorner", closeButton)
	local minimizeCorner = Instance.new("UICorner", minimizeButton)
	local maximizeCorner = Instance.new("UICorner", maximizeButton)

	closeButton.Name = "1"
	closeButton.Size = UDim2.new(0, 15, 0, 15)
	closeButton.BackgroundColor3 = Color3.fromRGB(252, 87, 83)
	closeButton.Text = ""

	minimizeButton.Name = "2"
	minimizeButton.Size = UDim2.new(0, 15, 0, 15)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(253, 188, 64)
	minimizeButton.Text = ""

	maximizeButton.Name = "3"
	maximizeButton.Size = UDim2.new(0, 15, 0, 15)
	maximizeButton.BackgroundColor3 = Color3.fromRGB(51, 199, 72)
	maximizeButton.Text = ""

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

function Dock:init()
	if not self.dock then
		self:build()
	end
end

function Dock.new(handler)
	local self = setmetatable({
		handler = handler,
		size = 27.5,
		elements = {}
	}, Dock)

	self:init()

	return self
end


local Terminal = {}
Terminal.class = Terminal
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
		self.content:GetPropertyChangedSignal("AbsoluteSize"):Connect(callbackProxy)
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
					descendant.TextSize += 2
				end
			end
		end
	end)
	self.inputBinder:bind({Enum.KeyCode.LeftControl, Enum.KeyCode.Minus}, function()
		if self.content then
			for _, descendant in ipairs(self.content:GetDescendants()) do
				if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
					descendant.TextSize -= 2
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
	print(text)
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
	end
	
	TweenService:Create(textLabel, TweenInfo.new(0.5), {
		TextTransparency = 0
	}):Play()

	return textLabel
end

function List:build()
	local window = self.handler:addWindow(self.name, UDim2.new(0, 250, 0, 300))
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

function List:init(initialData)
	if not self.window then
		self:build()
	end
	
	spawn(function() -- i know spawn sucks ass for performance but fight me skrub :p
		for _, item in ipairs(initialData) do
			self:addItem(unpack(item))
			wait(0.1)
		end
	end)
end

function List.new(handler, name, data)
	local self = setmetatable({
		handler = handler,
		name = name
	}, List)
	
	self:init(data or {})
	
	return self
end


local WindowHandler = {}
WindowHandler.__index = WindowHandler

function WindowHandler:addWindow(name, ...)
	local window = Window.new(self, name, ...)
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
		themeSyncer = ThemeSyncer.new(theme)
	}, WindowHandler)
	
	if syn then
		syn.protect_gui(self.gui)
	end
	
	self.gui.Parent = parent or playerGui
	self.gui.DisplayOrder = 9e9
	self.gui.IgnoreGuiInset = true
	self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

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

function Sandbox.new(environment)
	local self = setmetatable({
		tasks = {},
		environment = environment or {}
	}, Sandbox)

	return self
end


local Parser = {}
Parser.__index = Parser

function Parser:trim(str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end

function Parser:reconstructArguments(arguments, index)
	local segments = {}

	for index, argument in ipairs(arguments) do
		segments[index] = argument.raw
	end

	segments = {select(index or 1, unpack(segments))}
	return table.concat(segments, self.options.splitKey)
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

		local batchElements = batch.raw:split(self.options.splitKey)

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
			batchKey = "|",
			splitKey = " ",
			coreArgumentPrefix = "--",
			argumentSplitKey = ",",
			argumentParameterKey = "-"
		}
	}, Parser)

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
		self.notificationHandler:error(message)
	end
end

function CommandSystem:notify(message)
	if self.terminal then
		self.terminal:addText(message)
	else
		self.notificationHandler:notify(message)
	end
end

function CommandSystem:createList(name, listData)
	if self.terminal then
		for _, item in ipairs(listData) do
			self.terminal:addText(table.concat(item, " - "))
		end
	else
		List.new(self.windowHandler, name, listData)
	end
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
	
	return targets
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

		for _, argumentType in ipairs(self.argumentTypes) do
			for _, call in ipairs(argumentType.calls or {}) do
				if argument.type:lower() == call:lower() then
					local givenArgument = arguments[index]
					if index == #command.arguments and argumentType.expandable then
						givenArgument.raw = self.parser:reconstructArguments(arguments, index)
					end

					local success, response = pcall(argumentType.process, givenArgument, self)

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
	if command.requiresTool and not (backpack:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("HopperBin")) then
		return self:error("You must have a tool to use this command")
	end
	
	local task = Task.new(command[processType])
	task.yields = true
	task.thread = false
	task.errorHandler = function(err)
		self:error(("Unable to run command: %s"):format(tostring(err)))
	end
	
	local taskId = self.sandbox:addTask(task)
	local response = {task:run(command, arguments, self)}
	
	if not isNested then
		self.terminal:addPrompt(self.location)
	end
	
	return response
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
				
				if found then
					self.terminal:addText(tostring(result))
				end
			end
			
			if not found then
				self:error(("\"%s\" is not a valid command"):format(batch.command), true)
			end
		end
	end
end

function CommandSystem:handleCall(message)
	local tree = self.parser:parse(message)
	self:executeTree(tree)
end

function CommandSystem.new(terminal)
	local self = setmetatable({
		cache = Cache.new(),
		location = localPlayer,
		parser = Parser.new(),
		inputBinder = InputBinder.new(),
		sandbox = Sandbox.new(getfenv(0)), -- just gets the global environment, so chill dude
		commands = Commands or {},
		playerTypes = PlayerTypes,
		argumentTypes = ArgumentTypes,
	}, CommandSystem)
	
	local function callback(message)
		if self.parser:trim(message) ~= "" then
			self:handleCall(message)
		else
			self.terminal:addPrompt()
		end
	end

	self.windowHandler = terminal and terminal.handler or WindowHandler.new()
	self.terminal = terminal or Terminal.new(self.windowHandler, callback)
	self.terminal.defaultCallback = callback

	return self
end


-- you've made it this far, so might as well join our discord :D
-- https://discord.io/demonden

local commandSystem = CommandSystem.new()

pcall(function()
	commandSystem.windowHandler.gui.Parent = CoreGui
end)

-- if you were looking for any of that obfuscated getfenv stuff, you just got caught laking
-- this script doesnt have any of that stuff, so chill
-- i'm not that type of guy

-- SenslessDemon
