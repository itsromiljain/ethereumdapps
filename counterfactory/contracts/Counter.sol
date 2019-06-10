pragma solidity >=0.4.21 <0.6.0;

contract Counter {
    
    address owner;
    
    uint count=0;
    
    constructor (address _owner) public {
        owner = _owner;
    }
    
     modifier isOwner(address _caller) {
        require(_caller == owner);
        _;
    }
    
    function increment(address caller) public isOwner(caller){
        count=count+1;
    }
    
    function getCount() public view returns(uint){
        return count;
    }
}
