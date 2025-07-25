// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Lock {
    uint public unlockTime;
    address payable public owner;

    event Withdrawal(uint amount, uint when);

    constructor(uint _lockDuration) payable {
        require(_lockDuration > 0, "Lock duration must be greater than 0");
        unlockTime = block.timestamp + _lockDuration;
        owner = payable(msg.sender);
    }

    function withdraw() public {
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}