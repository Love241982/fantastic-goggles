// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentReceiver {
    address public owner;

    event PaymentReceived(address from, uint256 amount);
    event Withdrawn(address to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to receive Ether
    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    // Withdraw the balance of the contract to the owner
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No Ether available to withdraw");

        payable(owner).transfer(balance);
        emit Withdrawn(owner, balance);
    }

    // Change the owner of the contract
    function changeOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner must be a valid address");
        owner = newOwner;
    }
}