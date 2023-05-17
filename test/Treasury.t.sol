// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "contracts/Treasury.sol";
import "contracts/Token.sol";

contract TreasuryTest is Test {
    Token private token;
    Treasury private treasury;

    address public owner;
    address public contractAddress;
    address public token_address;

    function setUp() public {
        token = new Token();
        token_address = address(token);

        owner = address(7);
        vm.startPrank(owner);

        treasury = new Treasury(token_address);
        contractAddress = address(treasury);

        vm.stopPrank();
    }

    function testInitializeOwner() public {
        assertEq(treasury.owner(), owner);
    }

    function testOwnerTransferOwnership() public {
        vm.prank(owner);
        treasury.transferOwnership(address(1));
        assertEq(address(1), treasury.owner());
    }

    function testNotOwnerTransferOwnership() public {
        vm.prank(address(1));
        vm.expectRevert("Ownable: caller is not the owner");
        treasury.transferOwnership(address(1));
        assertEq(owner, treasury.owner());
    }

    function testSuccessfulDeposit() public {
        vm.deal(address(1), 0.5 ether);
        vm.prank(address(1));
        treasury.deposit{value: 0.2 ether}();
        assertEq(contractAddress.balance, 0.2 ether);
        assertEq(address(1).balance, 0.3 ether);
    }

    function testInvalidDepositAmount() public {
        vm.deal(address(1), 0.5 ether);
        vm.prank(address(1));
        vm.expectRevert("Treasury: Deposit amount should be greater than zero");
        treasury.deposit{value: 0 ether}();
    }

    function testSuccessfulWithdraw() public {
        // supply contract with ether
        vm.deal(address(1), 0.5 ether);
        vm.prank(address(1));
        treasury.deposit{value: 0.5 ether}();

        vm.prank(owner);
        treasury.withdraw(0.4 ether, address(2));
        assertEq(contractAddress.balance, 0.1 ether);
        assertEq(address(2).balance, 0.4 ether);
    }

    function testNotOwnerWithdraw() public {
        vm.prank(address(1));
        vm.expectRevert("Ownable: caller is not the owner");
        treasury.withdraw(0.5 ether, address(2));
    }

    function testWithdrawReceiverZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert("Treasury: receiver is zero address");
        treasury.withdraw(0.5 ether, address(0));
    }

    function testWithdrawInvalidAmount() public {
        vm.prank(owner);
        vm.expectRevert("Treasury: Not enough balance to withdraw");
        treasury.withdraw(0.15 ether, address(1));
    }

    function testSuccessfulWithdrawAll() public {
        // supply contract with ether
        vm.deal(address(1), 0.8 ether);
        vm.prank(address(1));
        treasury.deposit{value: 0.8 ether}();
        assertEq(contractAddress.balance, 0.8 ether);

        vm.prank(owner);
        treasury.withdrawAll();
        assertEq(contractAddress.balance, 0 ether);
        assertEq(owner.balance, 0.8 ether);
    }

    function testNotOwnerWithdrawAll() public {
        vm.prank(address(1));
        vm.expectRevert("Ownable: caller is not the owner");
        treasury.withdrawAll();
    }

    function testWithdrawAllNoBalance() public {
        vm.prank(owner);
        vm.expectRevert("Treasury: No balance to withdraw");
        treasury.withdrawAll();
    }

    function testGetBalance() public {
        // supply contract with ether
        vm.deal(address(1), 0.8 ether);
        vm.prank(address(1));
        treasury.deposit{value: 0.8 ether}();

        assertEq(treasury.getBalance(), 0.8 ether);
    }





/////ADDED FUNCTIONS///////////
    function testGetTokenAddress() public {
    assertEq(treasury.getTokenAddress(), token_address);
}

describe("Treasury", function () {
  let treasury;
  let token;

  beforeEach(async function () {
    const Token = await ethers.getContractFactory("Token");
    token = await Token.deploy();
    await token.deployed();

    const Treasury = await ethers.getContractFactory("Treasury");
    treasury = await Treasury.deploy(token.address);
    await treasury.deployed();
  });

  it("returns the job application fee", async function () {
    const fee = await treasury.getJobApplicationFee();
    expect(fee).to.equal(100);
  });

  it("returns the platform fee", async function () {
    const fee = await treasury.getPlatformFee();
    expect(fee).to.equal(500);
  });

  it("returns the application withdrawal fee", async function () {
    const fee = await treasury.getApplicationWithdrawalFee();
    expect(fee).to.equal(50);
  });

  it("returns the placement withdrawal fee", async function () {
    const fee = await treasury.getPlacementWithdrawalFee();
    expect(fee).to.equal(250);
  });

  it("returns the upskill fee", async function () {
    const fee = await treasury.getUpskillFee();
    expect(fee).to.equal(1000);
  });

  it("returns the successful placement bonus", async function () {
    const bonus = await treasury.getSuccessfulPlacementBonus();
    expect(bonus).to.equal(10000);
  });

  it("returns the unsuccessful placement penalty", async function () {
    const penalty = await treasury.getUnsuccessfulPlacementPenalty();
    expect(penalty).to.equal(5000);
  });
});

}
