// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import { DeployFundMe } from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
  FundMe fundMe;

  address USER = makeAddr("user");
  uint256 constant SENT_VALUE = 0.1 ether;
  uint256 constant STARTING_BALANCE = 10 ether;
  uint256 constant GAS_PRICE = 1;

  function setUp() external {
    // us -> FundMeTest -> Fundme
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();

    vm.deal(USER, STARTING_BALANCE); //give user some eth
  }

  modifier funded() {
    vm.prank(USER);
    fundMe.fund{ value: SENT_VALUE }();
    _;
  }

  function testMinDollarIsFive() public view {
    assertEq(fundMe.MINIMUM_USD(), 5e18);
  }

  function testOwnerIsMsgSender() public view {
    assertEq(fundMe.getOwner(), msg.sender);
  }

  function testFriceFeedVersionIsAccurate() public view {
    assertEq(fundMe.getVersion(), 4);
  }

  function testFundFailsWithoutEnoughEth() public {
    vm.expectRevert(); //the next line should revert
    fundMe.fund();
  }

  function testFundUpdatesFundedDataStructure() public funded {
    uint256 amontFunded = fundMe.getAddressToAmountFunded(USER);
    assertEq(amontFunded, SENT_VALUE);
  }

  function testAddsFunderToArrayOfDFunders() public funded {
    address funder = fundMe.getFunder(0);
    assertEq(funder, USER);
  }

  function testOnlyOwnerCanWithdraw() public funded {
    vm.expectRevert();
    vm.prank(USER);
    fundMe.withdraw();
  }

  function testWithdrawWithTheSingleFunder() public funded {
    // Arrange
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    // Act
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();

    // Assert
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFundMeBalance = address(fundMe).balance;

    assertEq(endingFundMeBalance, 0);
    assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
  }

  function testWithdrawFromMultipleFunders() public funded {
    // Arrange
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
      hoax(address(i), SENT_VALUE);
      fundMe.fund{ value: SENT_VALUE }();
    }

    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    // Act
    uint256 gasStart = gasleft();
    vm.txGasPrice(GAS_PRICE);
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();

    uint256 gasEnd = gasleft();
    uint256 gasCost = (gasStart - gasEnd) * tx.gasprice;
    console.log(gasCost);
    console.log(tx.gasprice);

    // Assert
    assertEq(address(fundMe).balance, 0);
    assertEq(
      startingOwnerBalance + startingFundMeBalance,
      fundMe.getOwner().balance
    );
  }

  function testWithdrawFromMultipleFundersCheaper() public funded {
    // Arrange
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
      hoax(address(i), SENT_VALUE);
      fundMe.fund{ value: SENT_VALUE }();
    }

    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    // Act
    uint256 gasStart = gasleft();
    vm.txGasPrice(GAS_PRICE);
    vm.prank(fundMe.getOwner());
    fundMe.cheaperWithdraw();

    uint256 gasEnd = gasleft();
    uint256 gasCost = (gasStart - gasEnd) * tx.gasprice;
    console.log(gasCost);
    console.log(tx.gasprice);

    // Assert
    assertEq(address(fundMe).balance, 0);
    assertEq(
      startingOwnerBalance + startingFundMeBalance,
      fundMe.getOwner().balance
    );
  }
}
