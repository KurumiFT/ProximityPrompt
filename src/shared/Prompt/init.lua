local Prompt = {}

local RunService = game:GetService("RunService")

local Player = game.Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local UI_Folder = script.Parent.UI
local Single_Frame = UI_Folder.Single
local Radial_Frame = UI_Folder.Radial


local function Constructor()
    local self = {}

    setmetatable(self, {__index = Prompt})
    return self
end

function Prompt:SetScript(script)
    self.script = script    
end

function Prompt:SetObject(obj: Part)
    self.object = obj
end

function Prompt:SetDistance(distance: number)
    self.distance = distance
end

function Prompt:GetNodeRenderType()
    if not self.script then return end
    if not self.script.ptr then return end
    if #self.script.ptr.choices == 0 then return end
    if #self.script.ptr.choices == 1 then return "Single" end
    return "Radial"
end

function Prompt:GetRenderFrame()
    local RenderType = self:GetNodeRenderType()
    assert(RenderType, "No script or no pointer")
    if RenderType == "Single" then
        local Returnable = {}
        
        local _SingleFrame = Single_Frame:Clone()
        _SingleFrame.ActivityLabel.Text = self.script.ptr.choices[1].display

        Returnable[_SingleFrame] = {choice = self.script.ptr.choices[1], offset = UDim2.new(0, 0, 0, 0)}
        return Returnable
    end

    if RenderType == "Radial" then
        local ChoiceFrames_Table = {}

        local Radius = CurrentCamera.ViewportSize.Y * .15
        local AnglePerChoce = 360 / #self.script.ptr.choices
        local CurrentAngle = -AnglePerChoce

        for _, choice in pairs(self.script.ptr.choices) do
            CurrentAngle += AnglePerChoce

            local _RadialFrame = Radial_Frame:Clone()
            _RadialFrame.ActivityLabel.Text = choice.display
            
            -- Calculate offset for radial choice
            local XOffset = math.cos(math.rad(CurrentAngle)) * Radius 
		    local YOffset = math.sin(math.rad(CurrentAngle)) * Radius

            ChoiceFrames_Table[_RadialFrame] = {choice = choice, offset = UDim2.new(0, XOffset, 0, YOffset)}
        end

        return ChoiceFrames_Table
    end
end

function Prompt:Unrender()
    if self.render_connection then
        self.render_connection:Disconnect()
    end
end

function Prompt:Render()
    assert(self.script, "No script")
    assert(self.script.default, "No default node in script")
    self.script:SetPointer(self.script.default) -- Set pointer to default 
    assert(self:GetNodeRenderType(), "No choices in node")
    self.render_connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not self.screen_gui then -- Render prompt
            self.screen_gui = Instance.new("ScreenGui", Player.PlayerGui)
            self.screen_gui.Name = string.format("Prompt%i", tick())

            self.render_data = self:GetRenderFrame()
            for frame, data in pairs(self.render_data) do
                frame.Parent = self.screen_gui
            end
        end
    end)
end

setmetatable(Prompt, {__call = Constructor})
return Prompt
