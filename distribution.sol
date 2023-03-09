pragma solidity ^0.8.0;

contract Distribution {
    
    // Define variables to store information about the distribution
    
    address public owner;
    uint256 public totalAmount;
    uint256 public remainingAmount;
    mapping(address => uint256) public balances;
    
    // Define constructor to initialize the contract
    
    constructor(uint256 _totalAmount) {
        owner = msg.sender;
        totalAmount = _totalAmount;
        remainingAmount = _totalAmount;
    }
    
    // Define functions for distribution
    
    function distribute(address payable[] memory _receivers, uint256[] memory _amounts) public payable {
        require(msg.sender == owner, "Only owner can distribute tokens");
        require(_receivers.length == _amounts.length, "Invalid input");
        require(remainingAmount >= getTotalAmount(_amounts), "Insufficient balance");
        for (uint i = 0; i < _receivers.length; i++) {
            balances[_receivers[i]] += _amounts[i];
            remainingAmount -= _amounts[i];
            _receivers[i].transfer(_amounts[i]);
        }
    }
    
    // Define helper functions
    
    function getTotalAmount(uint256[] memory _amounts) private pure returns(uint256) {
        uint256 total = 0;
        for (uint i = 0; i < _amounts.length; i++) {
            total += _amounts[i];
        }
        return total;
    }
    
    // Define fallback function to receive payments
    
    receive() external payable {
        remainingAmount += msg.value;
    }
    
} 