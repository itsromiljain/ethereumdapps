pragma solidity ^0.4.24;


contract Auction {
    // static
    address public owner;
    uint public startBlock;
    uint public endBlock;
    uint public bidIncrement;

    // state
    bool public canceled;
    address public highestBidder;
    mapping(address => uint256) public fundsByBidder;
    uint public highestBindingBid;
    bool ownerHasWithdrawn;

    function Auction(address _owner, uint _bidIncrement, uint _startBlock, uint _endBlock) {
        if (_startBlock >= _endBlock) revert();
        if (_startBlock < block.number) revert();
        if (_owner == 0) revert();

        owner = _owner;
        bidIncrement = _bidIncrement;
        startBlock = _startBlock;
        endBlock = _endBlock;
    }

    function placeBid() payable onlyAfterStart onlyBeforeEnd onlyNotCanceled onlyNotOwner returns (bool success) {
        // reject payments of 0 ETH
        if (msg.value == 0) revert();

        // calculate the user's total bid based on the current amount they've sent to the contract
        // plus whatever has been sent with this transaction
        uint newBid = fundsByBidder[msg.sender] + msg.value;

        // grab the previous highest bid (before updating fundsByBidder, in case msg.sender is the
        // highestBidder and is just increasing their maximum bid).
        uint highestBid = fundsByBidder[highestBidder];

        fundsByBidder[msg.sender] = newBid;

        if (newBid <= highestBid) {
             // if the user has overbid the highestBindingBid but not the highestBid, we simply
            // increase the highestBindingBid and leave highestBidder alone.

            // note that this case is impossible if msg.sender == highestBidder because you can never
            // bid less ETH than you've already bid.

            highestBindingBid = min(newBid + bidIncrement, highestBid);

        } else {
            // if msg.sender is already the highest bidder, they must simply be wanting to raise
            // their maximum bid, in which case we shouldn't increase the highestBindingBid.
            if(msg.sender != highestBidder) {
                highestBidder = msg.sender;
                // calculate highest binding bid
                highestBindingBid = min(newBid, highestBid + bidIncrement);
            }
            highestBid = newBid;
        }
        LogBid(msg.sender, newBid, highestBidder, highestBid, highestBindingBid);
        return true;
    }

    event LogBid(address bidder, uint bid, address higherBidder, uint highestBid, uint highetBindingBid);

    function min(uint a, uint b) private constant returns (uint) {
        if (a < b) return a;
        return b;
    }

    modifier onlyAfterStart {
        if (block.number < startBlock) revert();
        _;
    }

    modifier onlyBeforeEnd {
        if (block.number > endBlock) revert();
        _;
    }

    modifier onlyNotCanceled {
        if (block.number > endBlock) revert();
        _;
    }

    modifier onlyNotOwner {
        if (block.number > endBlock) revert();
        _;
    }


}