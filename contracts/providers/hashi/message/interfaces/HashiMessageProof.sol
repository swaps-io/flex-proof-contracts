// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IReporter} from "@gnosis/hashi-evm/contracts/interfaces/IReporter.sol";

struct HashiMessageProof {
    bytes32[] eventHashes;
    uint256 eventIndex;
    uint256 nonce;
    address yaho;
    IReporter[] reporters;
}
