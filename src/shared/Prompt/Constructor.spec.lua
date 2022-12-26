return function ()
    local PromptModule = require(script.Parent)

    describe("Constructor test", function()

        it("__call", function()
            PromptModule()
        end)

        it("return table", function()
            expect(PromptModule()).to.be.ok()
        end)
    end)
end
