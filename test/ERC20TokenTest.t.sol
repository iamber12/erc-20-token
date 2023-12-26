// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {ERC20Token} from "../src/ERC20Token.sol";
import {DeployERC20Token} from "../script/DeployERC20Token.s.sol";

contract ERC20TokenTest is Test {
    ERC20Token public erc20Token;
    DeployERC20Token public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant INITIAL_SUPPLY = 100 ether;

    function setUp() public {
        deployer = new DeployERC20Token();
        erc20Token = deployer.run();

        vm.prank(address(msg.sender));
        erc20Token.transfer(bob, INITIAL_SUPPLY);
    }

    function testBobBalance() public {
        assertEq(INITIAL_SUPPLY, erc20Token.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initalAllowance = 1000;
        uint256 transferAmount = 500;

        //Bob approves Alice to spend tokens
        vm.prank(bob);
        erc20Token.approve(alice, initalAllowance);

        vm.prank(alice);
        erc20Token.transferFrom(bob, alice, transferAmount);

        assertEq(erc20Token.balanceOf(alice), transferAmount);
        assertEq(erc20Token.balanceOf(bob), INITIAL_SUPPLY - transferAmount);
    }
}