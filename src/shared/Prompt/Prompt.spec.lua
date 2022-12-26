return function()
    local RunService = game:GetService("RunService")

    local PromptModule = require(script.Parent)
    local ScriptModule = require(script.Parent.Parent.Script)
    local NodeModule = require(script.Parent.Parent.Node)

    local function stepsWait(count: number)
        for i = 1, count do
            RunService.Heartbeat:Wait()
        end
    end

    describe("Base render logic test", function()
        local _Prompt

        beforeEach(function()
            _Prompt = PromptModule()
        end)

        it("set script", function()
            local _Script = ScriptModule()
            _Prompt:SetScript(_Script)
            expect(_Prompt.script).to.equal(_Script)
        end)

        it("set object", function()
            _Prompt:SetObject(workspace.Baseplate)
            expect(_Prompt.object).to.equal(workspace.Baseplate)
        end)

        it("set distance", function()
            _Prompt:SetDistance(10)
            expect(_Prompt.distance).to.equal(10)
        end)

        it("render without script", function()
            expect(function()
                _Prompt:Render()
            end).to.throw()
        end)

        it("render without default node", function()
            local _Script = ScriptModule()
            _Prompt:SetScript(_Script)
            expect(function()
                _Prompt:Render()
            end).to.throw()
        end)

        it("render without choices in node", function()
            local _Script = ScriptModule()
            local _Node = NodeModule("Test")
            _Script:AttachNode(_Node)
            _Script:SetDefault(_Node.name)
            _Prompt:SetScript(_Script)
            expect(function()
                _Prompt:Render()
            end).to.throw()
        end)
    end)

    describe("Render test", function()
        local _Prompt, _Script, _SingleNode, _RadialNode
        

        afterEach(function()
            _Prompt:Unrender()
        end)

        beforeEach(function()
            _Prompt = PromptModule()
            _Script = ScriptModule()
            _SingleNode = NodeModule("Single")    
            _SingleNode:NewChoice("Test")
            _RadialNode = NodeModule("Radial")    
            _RadialNode:NewChoice("Test")
            _RadialNode:NewChoice("Test")
            _Script:AttachNode(_SingleNode)
            _Script:AttachNode(_RadialNode)
            _Script:SetDefault(_SingleNode.name)
            _Prompt:SetScript(_Script)
        end)

        it("render set connection", function()
            _Prompt:Render()
            expect(_Prompt.render_connection).to.be.ok()
        end)

        it("single frame instance", function()
            _Prompt:Render()
            expect(_Prompt:GetRenderFrame()).to.be.ok()
        end)

        it("radial frame instance", function()
            _Script:SetDefault(_RadialNode.name)
            _Prompt:Render()
            expect(_Prompt:GetRenderFrame()).to.be.ok()
        end)

        it("render create screen gui / game", function()
            _Prompt:Render()

            stepsWait(2)
            expect(_Prompt.screen_gui).to.be.ok()
        end)

        it("render add frames into screen gui / game", function()
            _Prompt:Render()

            stepsWait(2)
            expect(#_Prompt.screen_gui:GetChildren() > 0).to.be.ok()
        end)
    end)
end