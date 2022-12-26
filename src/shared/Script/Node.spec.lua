return function ()
    local NodeModule = require(script.Parent.Parent.Node)
    local ScriptModule = require(script.Parent)

    describe("Node manage test", function()
        it("add node", function()
            local _Script = ScriptModule()
            local _Node = NodeModule("Test")
            _Script:AttachNode(_Node)

            expect(#_Script.nodes).to.equal(1)
        end)

        it("search node by name", function()
            local _Script = ScriptModule()
            local _Node = NodeModule("Test")
            _Script:AttachNode(_Node)

            expect(_Script:GetNode(_Node.name)).to.equal(_Node)
        end)

        it("remove node by name", function()
            local _Script = ScriptModule()
            local _Node = NodeModule("Test")
            _Script:AttachNode(_Node)
            _Script:RemoveNode(_Node.name)
            
            expect(#_Script.nodes).to.equal(0)
        end)

        it("set pointer", function()
            local _Script = ScriptModule()
            local _Node1 = NodeModule("Test1");_Script:AttachNode(_Node1)
            _Script:SetPointer(_Node1.name)
            expect(_Script.ptr).to.equal(_Node1)
        end)

        it("set default", function()
            local _Script = ScriptModule()
            local _Node1 = NodeModule("Test1");_Script:AttachNode(_Node1)
            _Script:SetDefault(_Node1.name)
            expect(_Script.default).to.equal(_Node1.name)
        end)
    end)
end