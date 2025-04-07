// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct HashiEventReceiverInfraConfig {
    uint256 sendChain;
    address eventSender;
    address yaru;
    uint256 threshold;
    address[] adapters;
}
