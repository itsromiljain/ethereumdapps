pragma solidity >=0.4.21 <0.6.0;
import './Counter.sol';

contract CounterFactory {
    
    Counter[] instantiatedCounters;
    
    mapping(address => Counter) counters;
    
    event LogCounterCreation(address, Counter);
      
    function createCounter() public {
        Counter counter = new Counter(msg.sender);
        counters[msg.sender] = counter;
        instantiatedCounters.push(counter);
        emit LogCounterCreation(msg.sender, counter);
    }
    
    function increment() public {
        counters[msg.sender].increment(msg.sender);
    }
    
    function getCount() public view returns(uint){
        return counters[msg.sender].getCount();
    }
    
    function getAllCounters() public view returns(Counter[] memory){
        return instantiatedCounters;
    }
    
}