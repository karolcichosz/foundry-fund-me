// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { FundMe } from "../src/FundMe.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
  function run() external returns (FundMe) {
    // Before startBroadcast -> Not a "real" tx
    HelperConfig helperConfig = new HelperConfig();
    address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

    // After startBroadcasr -> Real tx
    vm.startBroadcast(); //this makes funder msg.sender
    FundMe fundMe = new FundMe(ethUsdPriceFeed);
    vm.stopBroadcast();

    return fundMe;
  }
}
