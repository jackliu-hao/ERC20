// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script,console} from "forge-std/Script.sol";
import { Bank} from "../src/Bank.sol";
import {BasicERC20} from "../src/BasicERC20.sol";

contract DeployedBank is Script {

    function run() external returns(Bank bank) {
        vm.startBroadcast();
        // 部署bank
        bank = new Bank();
        vm.stopBroadcast();
        console.log("bank address:",address(bank));
    }

}

contract DeployedBasicERC20 is Script {
    function run() external returns(BasicERC20 basicERC20) {
        vm.startBroadcast();

        basicERC20 = new BasicERC20(
            "haozaiERC20",
            "$HAOZAI",
            1000000000,
            18
        );
        vm.stopBroadcast();
        console.log("BasicERC20 address:",address(basicERC20));
    }
}