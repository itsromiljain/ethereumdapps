pragma solidity >=0.4.0 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleBank.sol";

contract TestSimpleBank {

    SimpleBank simpleBankInstance = SimpleBank(DeployedAddresses.SimpleBank());

    address accountAddress = address(this);

    function testEnroll() public {
        bool returnValue = simpleBankInstance.enroll();
        bool expectedValue = simpleBankInstance.enrolled(accountAddress);
        Assert.equal(returnValue, expectedValue, "Account should be enrolled");
    }

    function testDeposit() public {
        uint returnBalance = simpleBankInstance.deposit();
        uint expectedBalance = simpleBankInstance.getBalance();
        Assert.equal(returnBalance, expectedBalance, "Account Balance should match after Deposit");
    }

    function testWithdraw() public {
        uint withdrawAmount = 10;
        uint returnBalance = simpleBankInstance.withdraw(withdrawAmount);
        uint expectedBalance = simpleBankInstance.getBalance();
         Assert.equal(returnBalance, expectedBalance, "Account Balance should match after withdrawl");
    }

}