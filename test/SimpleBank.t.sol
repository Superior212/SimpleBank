// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank bank;

    function setUp() public {
        bank = new SimpleBank();
    }

    function testCreateAcct() public {
        bank.createAccount();

        uint256 balance = bank.getBalance();
        assertEq(balance, 0);
    }

    function testCreateAcctTwice() public {
        bank.createAccount();

        vm.expectRevert("Account already exists");
        bank.createAccount();
    }

    function testDeposit() public {
        bank.createAccount();

        bank.deposit{value: 1 ether}();

        uint256 balance = bank.getBalance();
        assertEq(balance, 1 ether);
    }

//   function testWithdraw() public {
//     bank.createAccount();
//     bank.deposit{value: 1 ether}();

//     console.log("Balance after deposit:", bank.getBalance());

//     bank.withdraw(0.5 ether);

//     console.log("Balance after withdrawal:", bank.getBalance());

//     uint256 balance = bank.getBalance();
//     assertEq(balance, 0.5 ether);
// }

    function testWithdrawInsufficientBal() public {
        bank.createAccount();
        bank.deposit{value: 0.5 ether}();

        vm.expectRevert("Insufficient balance");
        bank.withdraw(1 ether);
    }

    function testTransfer() public {
        address recipient = address(0x123);
        bank.createAccount();
        vm.prank(recipient);
        bank.createAccount();

        bank.deposit{value: 1 ether}();

        bank.transfer(recipient, 0.5 ether);

        uint256 senderBalance = bank.getBalance();
        assertEq(senderBalance, 0.5 ether);

        vm.prank(recipient);
        uint256 recipientBalance = bank.getBalance();
        assertEq(recipientBalance, 0.5 ether);
    }

    function testTransferInsufficientBal() public {
        address recipient = address(0x123);
        bank.createAccount();
        vm.prank(recipient);
        bank.createAccount();

        bank.deposit{value: 0.5 ether}();

        vm.expectRevert("Insufficient balance");
        bank.transfer(recipient, 1 ether);
    }

    function testTransferToZeroAddress() public {
        bank.createAccount();
        bank.deposit{value: 1 ether}();

        vm.expectRevert("Transfer to the zero address is not allowed");
        bank.transfer(address(0), 0.5 ether);
    }

   

}


