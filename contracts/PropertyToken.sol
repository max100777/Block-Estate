// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // Specifies the Solidity compiler version

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // Imports OpenZeppelin's ERC20 standard contract
import "@openzeppelin/contracts/access/Ownable.sol";   // Imports OpenZeppelin's Ownable contract for access control

// This contract represents a single virtual property, e.g., "Virtual Apartment A"
// It inherits functionality from ERC20 (for token behavior) and Ownable (for ownership management).
contract PropertyToken is ERC20, Ownable {
    // Constructor: This function runs only once when the contract is deployed.
    // It initializes the token with a name, symbol, and total supply.
    // The deployer of this contract (msg.sender) will become the owner (from Ownable)
    // and will initially receive all of the minted tokens.
    constructor(
        string memory name_,           // The name of the token (e.g., "Virtual Apartment A")
        string memory symbol_,         // The symbol of the token (e.g., "VA_A")
        uint256 initialSupply_         // The total number of tokens to mint initially.
                                       // For example, 1,000,000 tokens could represent a $1M property
                                       // divided into 1 million $1 fractional shares.
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        // _mint is an internal function from the ERC20 contract.
        // It creates new tokens and assigns them to a specific address.
        // Here, all the initial supply is minted to the contract deployer (msg.sender).
        _mint(msg.sender, initialSupply_);
    }

    // You can add more functions later if needed, e.g., for updating property metadata
    // or allowing the owner to pause transfers (if inheriting Pausable from OpenZeppelin).
}