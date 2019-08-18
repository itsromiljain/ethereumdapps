pragma solidity >=0.4.21 <0.6.0;

contract SimplePaymentChannel {
    
    address payable public sender;
    
    address payable public recipient;
    
    uint256 public expiration;
    
    
    constructor (address payable _recipient, uint256 duration) payable public {
        sender = msg.sender;
        recipient = _recipient;
        expiration = now + duration;
    }
    
    function isValidSignature(uint256 amount, bytes memory signature) internal view returns(bool){
        
        bytes32 hash = keccak256(abi.encodePacked(this, amount));
        
        bytes32 message = prefixed(hash);
        
        return recoverSignature(message, signature) == sender;
        
    } 
    
    function prefixed(bytes32 hash) internal pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
    
    function recoverSignature(bytes32 message, bytes memory signature) internal pure returns(address){
       (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
       
       return ecrecover(message, v, r, s);
    }
    
    function splitSignature(bytes memory signature) internal pure returns(uint8 v, bytes32 r, bytes32 s){
        require (signature.length == 65);
        
        assembly {
            r := mload(add(signature,32))
            s := mload(add(signature,64))
            v := byte(0, mload(add(signature,96)))
        }
        return (v,r,s);
    }
    
    // Call by recipient
    function close(uint256 amount, bytes memory signature) public {
        require(msg.sender == recipient);
        require (isValidSignature(amount, signature));
        
        recipient.transfer(amount);
        selfdestruct(sender);
    }
    
    // claimTimeout
    function claimTimeout() public {
        require (expiration > now);
        selfdestruct(sender);
    }
    
    // Call by sender
    function extend(uint256 newExpiration) public {
        require(msg.sender == sender);
        require(newExpiration > expiration);
        expiration = newExpiration;
    }
}