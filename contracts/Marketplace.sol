// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Marketplace is Ownable {
    // Struct to store details about a listing
    struct Listing {
        address seller;
        uint256 amount;
        uint256 pricePerToken; // Price in ETH for one token
        bool active;
    }

    // Mappings to store listings: propertyTokenAddress => sellerAddress => Listing details
    mapping(address => mapping(address => Listing)) public listings;

    // Events to log important actions on the blockchain
    event TokensListed(address indexed tokenAddress, address indexed seller, uint256 amount, uint256 pricePerToken);
    event TokensPurchased(address indexed tokenAddress, address indexed buyer, address indexed seller, uint256 amount, uint256 totalPrice);
    event ListingCancelled(address indexed tokenAddress, address indexed seller);
    event ListingUpdated(address indexed tokenAddress, address indexed seller, uint256 newAmount, uint256 newPricePerToken);


    // Constructor - Deployed by the owner of the marketplace (who can manage it if more functions are added)
    constructor() Ownable(msg.sender) {}

    /**
     * @dev Allows a seller to list their ERC20 tokens for sale.
     * @param _tokenAddress The address of the ERC20 token being listed (e.g., PropertyToken A, B, C).
     * @param _amount The number of tokens the seller wants to list.
     * @param _pricePerToken The price in Wei (ETH) for a single token.
     */
    function listForSale(address _tokenAddress, uint256 _amount, uint256 _pricePerToken) public {
        require(_amount > 0, "Amount must be greater than 0");
        require(_pricePerToken > 0, "Price per token must be greater than 0");

        IERC20 token = IERC20(_tokenAddress);

        // Check if the seller has enough tokens
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient token balance");

        // Get current listing details
        Listing storage currentListing = listings[_tokenAddress][msg.sender];
        bool isUpdate = currentListing.active; // Check if there's an existing active listing

        // If updating an existing listing, return the old tokens first
        if (isUpdate) {
            require(currentListing.amount > 0, "Invalid current listing amount"); // Should always be true if active
            // Transfer existing listed tokens back to the seller
            // This is crucial to prevent tokens from being locked if the amount is reduced or price changes.
            // If the new amount is less than the old amount, return the difference.
            if (_amount < currentListing.amount) {
                 uint256 tokensToReturn = currentListing.amount - _amount;
                 require(token.transfer(msg.sender, tokensToReturn), "Failed to return old tokens");
            }
            // If the new amount is greater, no tokens are returned, but the marketplace will need more approval.
            // This is handled by the frontend's approve call before listForSale.
        }

        // Transfer tokens from the seller to the marketplace contract
        // This will fail if the marketplace contract does not have approval for the _amount.
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer to marketplace failed. Check allowance.");

        // Update or create the listing
        currentListing.seller = msg.sender;
        currentListing.amount = _amount;
        currentListing.pricePerToken = _pricePerToken;
        currentListing.active = true;

        if (isUpdate) {
            emit ListingUpdated(_tokenAddress, msg.sender, _amount, _pricePerToken);
        } else {
            emit TokensListed(_tokenAddress, msg.sender, _amount, _pricePerToken);
        }
    }

    /**
     * @dev Allows a buyer to purchase tokens from an active listing.
     * @param _tokenAddress The address of the ERC20 token to buy.
     * @param _seller The address of the seller whose listing to buy from.
     * @param _amountToBuy The number of tokens the buyer wants to purchase.
     */
    function buyTokens(address _tokenAddress, address _seller, uint256 _amountToBuy) public payable {
        // Get the listing details
        Listing storage listing = listings[_tokenAddress][_seller];

        // Basic checks
        require(listing.active, "Listing is not active");
        require(_amountToBuy > 0, "Amount to buy must be greater than 0");
        require(listing.amount >= _amountToBuy, "Not enough tokens available in listing");

        // Calculate total cost in ETH (Wei)
        // Use multiplication before division to maintain precision
        uint256 totalPrice = (_amountToBuy * listing.pricePerToken) / (1 ether); // Assuming pricePerToken is in Wei (1 token = X Wei ETH)

        require(msg.value >= totalPrice, "Insufficient ETH sent");

        IERC20 token = IERC20(_tokenAddress);

        // 1. Transfer ETH from buyer to seller
        // Use call to avoid reentrancy issues with complex fallback functions, and handle potential failures.
        (bool ethSuccess, ) = payable(_seller).call{value: totalPrice}("");
        require(ethSuccess, "Failed to transfer ETH to seller");

        // 2. Transfer tokens from marketplace to buyer
        require(token.transfer(msg.sender, _amountToBuy), "Failed to transfer tokens to buyer");

        // Update the listing
        listing.amount -= _amountToBuy;

        // If all tokens are sold, deactivate the listing
        if (listing.amount == 0) {
            listing.active = false;
        }

        // If buyer sent more ETH than required, send back the change
        if (msg.value > totalPrice) {
            (bool changeSuccess, ) = payable(msg.sender).call{value: msg.value - totalPrice}("");
            require(changeSuccess, "Failed to return change to buyer");
        }

        emit TokensPurchased(_tokenAddress, msg.sender, _seller, _amountToBuy, totalPrice);
    }

    /**
     * @dev Allows a seller to cancel their listing.
     * @param _tokenAddress The address of the ERC20 token whose listing to cancel.
     */
    function cancelListing(address _tokenAddress) public {
        Listing storage listing = listings[_tokenAddress][msg.sender];

        require(listing.active, "No active listing found for this token by you");
        require(listing.amount > 0, "Listing has no tokens to return"); // Should not happen if active

        IERC20 token = IERC20(_tokenAddress);

        // Transfer remaining tokens back to the seller
        require(token.transfer(msg.sender, listing.amount), "Failed to return tokens to seller");

        // Deactivate the listing
        listing.active = false;
        listing.amount = 0; // Clear amount to prevent re-cancellation issues

        emit ListingCancelled(_tokenAddress, msg.sender);
    }
}