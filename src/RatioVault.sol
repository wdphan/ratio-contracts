// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

/// @title A simulator for trees
/// @author William Phan
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.

contract RatioVault is ERC20, ERC20Permit, ERC721Holder {

    /// @dev This contract inherits from IERC721 and implements a collection of tokens
    IERC721 public collection;

    /// @dev The ID of the token
    uint256 public tokenId;

    /// @dev Boolean indicating whether the token has been initialized
    bool public initialized = false;

    /// @dev Boolean indicating whether the token is for sale
    bool public forSale = false;

    /// @dev Price of the token
    uint256 public salePrice;

    /// @dev Boolean indicating whether the token can be redeemed
    bool public canRedeem = false;

    /// @dev Constructor for the MyToken contract
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {}

    /// @notice Initializes the contract with a specified token and amount
    /// @dev Initializes the contract with a specified token and amount
    /// @param _collection address of the ERC721 collection contract
    /// @param _tokenId uint256 ID of the NFT to be used in the contract
    /// @param _amount uint256 the amount of NFTs to be held by the contract
    function init(address _collection, uint256 _tokenId, uint256 _amount) external {
        require(!initialized, "Already initialized");
        require(_amount > 0, "Amount needs to be more than 0");
        collection = IERC721(_collection);
        collection.safeTransferFrom(msg.sender, address(this), _tokenId);
        tokenId = _tokenId;
        initialized = true;
        _mint(msg.sender, _amount);
    }

    /// @notice Puts the NFT for sale
    /// @param price uint256 the price of the NFT
    function putForSale(uint256 price) external {
        salePrice = price;
        forSale = true;
    }

    /// @notice Purchases the NFT
    function purchase() external payable {
        require(forSale, "Not for sale");
        require(msg.value >= salePrice, "Not enough ether sent");
        collection.transferFrom(address(this), msg.sender, tokenId);
        forSale = false;
        canRedeem = true;
    }

    /// @notice Redeems the amount of NFTs for ether
    /// @dev Redeems the amount of NFTs for ether
    /// @param _amount uint256 amount of NFTs to be redeemed
    function redeem(uint256 _amount) external {
        require(canRedeem, "Redemption not available");
        uint256 totalEther = address(this).balance;
        uint256 toRedeem = _amount * totalEther / totalSupply();

        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(toRedeem);
    }
}