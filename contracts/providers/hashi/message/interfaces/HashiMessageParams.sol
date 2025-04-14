// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

struct HashiMessageParams {
    uint256 targetChainId;
    uint256 threshold;
    address receiver;
    address[] reporters;
    address[] adapters;
}
