pragma solidity ^0.5.0;

contract SimpleBank {

    mapping (address => uint) private balances;
    
    mapping (address => bool) public enrolled;

    address public owner;
    
    event LogEnrolled(address accountAddress);

    event LogDepositMade(address accountAddress, uint amount);

    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    event LogTransfer(address fromAddress, address toAddress, uint amount);

    constructor() public {
        owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool){
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        require(enrolled[msg.sender] == true);
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user   
    function withdraw(uint withdrawAmount) public returns (uint) {
           require(balances[msg.sender] >= withdrawAmount);
           balances[msg.sender]-= withdrawAmount;
           msg.sender.transfer(withdrawAmount);
           emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
           return balances[msg.sender];
    }
    
    /// @notice Transfer Ether to other user's account
    /// @param receiverAddress Address of the receiver
    /// @param amount amount to be transferred
    /// @return balance remaining after transfer
    function transfer(address payable receiverAddress, uint amount) public returns(uint){
        require(enrolled[msg.sender] == true);
        require(enrolled[receiverAddress] == true);
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        balances[receiverAddress] += amount;
        emit LogTransfer(msg.sender, receiverAddress, amount);
        return balances[msg.sender];
    }

}