var NotarizedDocument = artifacts.require("NotarizedDocument");

contract('NotarizedDocument', async(accounts) => {
    it('', async() => {
        let expectedValue = true;

        let document = "HelloWorld";

        let instance = await NotarizedDocument.deployed()

        await instance.notarize(document, {from: accounts[0]})

        let returnedValue = await instance.checkDocument.call(document)

        assert.equal(returnedValue, expectedValue, "The documents should match")

    })
})