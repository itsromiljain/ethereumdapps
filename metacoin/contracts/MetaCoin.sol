pragma solidity >=0.4.21 <0.6.0;

import "./ConvertLib.sol";

// This is a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
    mapping (address => uint) public balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event BeforeCheck(address indexed _from, uint senderBalance, uint256 _value);
    event AfterCheck(address indexed _from, uint256 _value);
    event LogGetBalance(address _addr1, address _addr2);

    constructor(uint initialBalance) public {
        balances[msg.sender] = initialBalance;
        //balances[tx.origin] = initialBalance;
    }

    function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
        //emit BeforeCheck(msg.sender, balances[msg.sender], amount);
        emit BeforeCheck(msg.sender, getBalance(address(msg.sender)), amount);
        if (balances[msg.sender] < amount) return false;
        emit AfterCheck(msg.sender, amount);
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    /*function getBalanceInEth(address addr) public view returns(uint) {
        return ConvertLib.convert(getBalance(addr),2);
    }

    function getBalance(address addr) public view returns(uint) {
        return balances[addr];
    }*/

    function getBalanceInEth(address addr) public returns(uint) {
        return ConvertLib.convert(getBalance(addr),2);
    }

    function getBalance(address addr) public returns(uint) {
        emit LogGetBalance(msg.sender, addr);
        return balances[addr];
    }
}
