// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "lib/forge-std/lib/ds-test/src/test.sol";
import "src/RatioVault.sol";
import {MyNFT} from "src/MyNFT.sol";

contract RatioVaultTest is Test {
    RatioVault public ratio;
    MyNFT public nft;
    RatioVaultTest public test;

    address bob = vm.addr(111);
    address bill = vm.addr(222);

    function setUp() public {
        ratio = new RatioVault();
        nft = new MyNFT();
        vm.label(bob, "BOB");
        vm.deal(bob, 100 ether);
        vm.label(bill, "BILL");
        vm.deal(bill, 100 ether);
        vm.deal(address(this), 100 ether);
    }

    function testMint() public {
        nft.safeMint(bob, 1);
        nft.safeMint(bob, 2);
    }

    function testFailMint() public {
        nft.safeMint(bob, 1);
        nft.safeMint(bob, 1);
    }

    function testInit() public {
        nft.safeMint(bob, 1);
        nft.setApprovalForAll(address(test), true);
        vm.prank(address(bob));
        ratio.init(address(nft), 1, 100);
    }

    function testPutForSale() public {
        ratio.putForSale(100);
    }

    function testFailPutForSale() public {
        vm.expectRevert();
        ratio.putForSale(0);
    }

    function testFailPurchase() public {
        vm.prank(bob);
        ratio.putForSale(100);
        vm.prank(bill);
        ratio.purchase{value: 90 wei}();
    }

    function testPurchase() public {
        vm.prank(bob);
        ratio.putForSale(100);
        vm.prank(bill);
        ratio.purchase{value: 100 wei}();
    }

    function testRedeem() public {
        vm.prank(bob);
        ratio.putForSale(100);
        vm.prank(bill);
        ratio.purchase{value: 100 wei}();
        vm.prank(bob);
        ratio.redeem(100);
    }

    function testFailRedeem() public {
        vm.prank(bob);
        ratio.putForSale(100);
        vm.prank(bill);
        ratio.purchase{value: 100 wei}();
        vm.prank(bob);
        ratio.redeem(110);
    }
}
