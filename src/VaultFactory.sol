// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "node_modules/openzeppelin-contracts/token/ERC20/ERC20.sol";
import "node_modules/openzeppelin-contracts/token/ERC20/IERC20.sol";
import "node_modules/openzeppelin-contracts/access/Ownable.sol";
import "node_modules/openzeppelin-contracts/drafts/ERC20Permit.sol";
import "node_modules/openzeppelin-contracts/token/ERC721/ERC721Holder.sol";
import "src/InitializedProxy.sol";
import "src/RatioVault.sol";

contract VaultFactory is Ownable, CloneFactory, ERC721Holder {

  address public libraryAddress;

  event VaultCreated(address newVaultAddress);

  function setLibraryAddress(address _libraryAddress) public  {
    libraryAddress = _libraryAddress;
  }

  function createVault() public payable returns (address newVault) {
    address clone = createClone(libraryAddress);
    // RatioVault(clone).init(_collection);
    RatioVault(clone);
    emit VaultCreated(clone);
    return (clone);
  }
}


