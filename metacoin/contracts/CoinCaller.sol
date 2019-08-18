pragma solidity >=0.4.0 <0.7.0;
import './MetaCoin.sol';

contract CoinCaller {
  
  struct transfer{
      MetaCoin metacoin;
      address recepient;
      uint amount;
      bool successful;
      uint balance;
  }

  mapping (uint => transfer) transfers;
  uint transferNumber;

  event LogDelegateCallReturnValue(bool _res);  
  event LogCoinCaller(address _recepient, uint _amount, bool _successful, uint _balance, uint _transferNo);
  event LogSenderBalance(uint senderBalance);

  function sendCoin(address metacoinContractAddress, address receiver, uint amount) public {
      transfer memory t = transfers[transferNumber];
      t.metacoin = MetaCoin(metacoinContractAddress);
      t.recepient = receiver;
      t.amount = amount;
      //t.successful = t.metacoin.sendCoin(receiver,amount);
      //(bool _res,) = metacoinContractAddress.call(abi.encodePacked(bytes4(keccak256("sendCoin(address,uint256)")), receiver, amount)); //This fails
      //(bool _res,) = metacoinContractAddress.delegatecall(abi.encodePacked(bytes4(keccak256("sendCoin(address,uint256)")), receiver, amount)); //This fails
      //(bool _res,) = metacoinContractAddress.call(abi.encodeWithSelector(bytes4(keccak256("sendCoin(address,uint256)")), receiver, amount));
      uint senderBalance = t.metacoin.getBalance(msg.sender);
      emit LogSenderBalance(senderBalance);
      (bool _res,) = metacoinContractAddress.delegatecall(abi.encodeWithSelector(bytes4(keccak256("sendCoin(address,uint256)")), receiver, amount));// This is also failing
      emit LogDelegateCallReturnValue(_res);
      //t.successful = t.metacoin.sendCoin(receiver,amount);
      t.successful = _res;
      t.balance = t.metacoin.balances(address(this));
      transferNumber++;
      emit LogCoinCaller(t.recepient, t.amount,t.successful, t.balance,transferNumber);
  }

}