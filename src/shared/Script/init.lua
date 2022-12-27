local Script = {}

local function Constructor()
    local self = {}
    self.nodes = {}
    self.callbacks = {Pointer = Instance.new('BindableEvent')}
    self.connections = {}
    setmetatable(self, {__index = Script})
    return self
end

function Script:AttachNode(node)
    table.insert(self.nodes, node)
end

function Script:GetNode(name: string)
    for _, v in ipairs(self.nodes) do
        if v.name == name then return v end
    end
end

function Script:AttachCallback(name: string, callback)
    assert(self.callbacks[name], "This callback doesnt exist")

    self.connections[name] = self.callbacks[name].Event:Connect(callback)
end

function Script:RemoveCallback(name: string)
    if self.connections[name] then
        self.connections[name]:Disconnect()
        self.connections[name] = nil
    end
end

function Script:RemoveNode(name: string)
    local Node = self:GetNode(name)
    if not Node then return end
    table.remove(self.nodes, table.find(self.nodes, Node))
end

function Script:SetDefault(name: string)
    self.default = name
end

function Script:ProceedAction(choice)
    if choice.redirect then
        self:SetPointer(choice.redirect) 
    end
end

function Script:SetPointer(name: string)
    local Node = self:GetNode(name)
    if not Node then return end
    self.ptr = Node
    self.callbacks['Pointer']:Fire()
end

setmetatable(Script, {__call = Constructor})

return Script