let catchRevert = require("./exceptionsHelpers.js").catchRevert
var SimpleBank = artifacts.require("SimpleBank");

contract("SimpleBank", accounts => {

    const owner = accounts[0];
    const aliceAddress = accounts[1];
    const bobAddress = accounts[2];
    const depositAmount =  web3.utils.toBN(5);
    const transferAmount = web3.utils.toBN(3);

    beforeEach(async() => {
        instance = await SimpleBank.new();
    });

    it("Accounts must be enrolled", async() => {
        await instance.enroll({from:aliceAddress})
        const aliceEnrolled = await instance.enrolled(aliceAddress, {from:aliceAddress})
        assert.equal(aliceEnrolled, true, "Account is enrolled")

    });

    it("Owner must be enrolled", async() => {
        const ownerEnrolled = await instance.enrolled(owner, {from:owner})
        assert.equal(ownerEnrolled, false, "Owner is not enrolled")
    });

    it("Correct amount must be deposited to only enrolled account", async() => {
        await instance.enroll({from:aliceAddress})
        await instance.deposit({from:aliceAddress, value:depositAmount})
        const balance = await instance.getBalance({from:aliceAddress}) 
        assert.equal(balance, depositAmount.toString(), "Balance matches")
    });

    it("Money should be deposited to only enrolled account", async() => {
        await instance.enroll({from:aliceAddress})
        const result = await instance.deposit({from:aliceAddress, value:depositAmount})

        const expectedEventResult = {address: aliceAddress, amount: depositAmount}

        const returnAddress = result.logs[0].args.accountAddress;
        const returnAmount = result.logs[0].args.amount.toNumber();

        assert.equal(returnAddress, expectedEventResult.address, "Address matches")
        assert.equal(returnAmount, expectedEventResult.amount, "Amount matches")
    });

    it("After withdrawl balance should be original balance", async() => {
        const expectedInitialAmount = 0
        await instance.enroll({from:aliceAddress})
        await instance.deposit({from:aliceAddress, value:depositAmount})
        await instance.withdraw(depositAmount, {from:aliceAddress})
        const balance = await instance.getBalance({from:aliceAddress})
        assert.equal(balance.toString(), expectedInitialAmount.toString(), "After withdrawl of deposit, Balance is same");
    });

    it("Should not be able to withdraw more than has been deposited", async() => {
        await instance.enroll({from:aliceAddress})
        await instance.deposit({from:aliceAddress, value:depositAmount})
        await catchRevert(instance.withdraw(depositAmount+1, {from:aliceAddress}))
    });

    it("Withdrawl amount, address & balance should match", async() => {
        const initialAmount = 0
        await instance.enroll({from:aliceAddress})
        await instance.deposit({from:aliceAddress, value:depositAmount})
        const result = await instance.withdraw(depositAmount, {from:aliceAddress})

        const expectedEventResult = {address:aliceAddress, withdrawAmount:depositAmount, balance: initialAmount}

        const returnAddress = result.logs[0].args.accountAddress
        const returnWithDrawAmount = result.logs[0].args.withdrawAmount.toNumber()
        const returnBalance = result.logs[0].args.newBalance.toNumber()

        assert.equal(expectedEventResult.address, returnAddress, "Address matches")
        assert.equal(expectedEventResult.withdrawAmount, returnWithDrawAmount, "Withdraw Amount matches")
        assert.equal(expectedEventResult.balance, returnBalance, "Balance matches")

    });

    it("Transfer should happen from Initiator to Receiver", async() => {
        await instance.enroll({from:aliceAddress})
        await instance.enroll({from:bobAddress})
        await instance.deposit({from:aliceAddress, value:depositAmount})
        const result = await instance.transfer(bobAddress, transferAmount, {from:aliceAddress})
        const returnBalance = await instance.getBalance({from:aliceAddress})

        const expectedEventResult = {fromAddress: aliceAddress, toAddress: bobAddress, amount: transferAmount}
        const expectedBalance = depositAmount-transferAmount

        const returnFromAddress = result.logs[0].args.fromAddress
        const returnToAddress = result.logs[0].args.ToAddress
        const returnTransferAmount = result.logs[0].args.amount.toNumber()

        assert(expectedEventResult.fromAddress, returnFromAddress, "From Address matches");
        assert(expectedEventResult.toAddress, returnToAddress, "To Address matches");
        assert(expectedEventResult.amount, returnTransferAmount, "amount matches");
        assert(returnBalance, expectedBalance, "balance matches");
    })
});