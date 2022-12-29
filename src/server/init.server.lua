local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ProximityPrompt_Folder = ReplicatedStorage:WaitForChild("ProximityPrompt")
local PPManage_Folder = ProximityPrompt_Folder:WaitForChild("Manage")
local Add_Event = PPManage_Folder:WaitForChild("Add")
local General_Event = PPManage_Folder:WaitForChild("General")

local Prompt_Module = require(ProximityPrompt_Folder:WaitForChild("Prompt"))
local Node_Module = require(ProximityPrompt_Folder:WaitForChild("Node"))
local Script_Module = require(ProximityPrompt_Folder:WaitForChild("Script"))

Players.PlayerAdded:Connect(function(player)
    local Prompt = Prompt_Module()
    Prompt:SetObject(workspace.TestPart)
    Prompt:SetDistance(10)

    local Script = Script_Module()
    Prompt:SetScript(Script)

    local SingleNode = Node_Module("Single")
    local SingleNodeChoice = SingleNode:NewChoice("Test", 1)
    SingleNodeChoice:SetAction("General_Single")
    SingleNodeChoice:SetRedirect("Radial")
    Script:AttachNode(SingleNode)
    Script:SetDefault(SingleNode.name)

    local RadialNode = Node_Module("Radial")
    local RadialNodeChoice_F = RadialNode:NewChoice("Test 1", 1)
    RadialNodeChoice_F:SetAction("General_Radial_1")
    
    local RadialNodeChoice_S = RadialNode:NewChoice("Test 2", 1)
    RadialNodeChoice_S:SetAction("General_Radial_2")
    Script:AttachNode(RadialNode)

    Add_Event:FireClient(player, Prompt)
end)

General_Event.OnServerEvent:Connect(function(player, object, ...)
    local kwargs = {...}
    print(string.format('%s called %s', player.Name,  table.concat(kwargs, ", ")))
end)