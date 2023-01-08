// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
// import "lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol";
import "src/InitializedProxy.sol";
import "src/RatioVault.sol";

contract VaultFactory is Ownable, CloneFactory {

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


