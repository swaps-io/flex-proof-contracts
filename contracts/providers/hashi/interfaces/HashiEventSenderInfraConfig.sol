// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct HashiEventSenderInfraConfig {
    address eventVerifier;
    uint256 receiveChain;
    address eventReceiver;
    address yaho;
    uint256 threshold;
    address[] reporters;
    address[] adapters;
}
