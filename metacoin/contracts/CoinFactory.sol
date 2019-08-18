pragma solidity >=0.4.0 <0.7.0;
import './MetaCoin.sol';

contract CoinFactory {

    mapping(uint => MetaCoin) metacoins;
    MetaCoin[] contractInstances;
    uint contractNumber;

    
    function createCoin(uint initialBalance) public return (address){
        MetaCoin metacoin = new MetaCoin(initialBalance);
        metacoins[contractNumber] = metacoin;
        contractInstances.push(metacoin);
        contractNumber++;
        return metacoins[contractNumber];
    }
}