// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IReporter, IAdapter} from "@gnosis/hashi-evm/contracts/interfaces/IReporter.sol";

struct HashiMessageParams {
    uint256 targetChainId;
    uint256 threshold;
    address receiver;
    IReporter[] reporters;
    IAdapter[] adapters;
}
