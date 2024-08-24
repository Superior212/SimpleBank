// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankScript is Script {
    SimpleBank public bank;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        bank = new SimpleBank();

        vm.stopBroadcast();
    }
}
