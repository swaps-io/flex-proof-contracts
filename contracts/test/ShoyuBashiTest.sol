// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IMinShoyuBashi} from "../providers/hashi/interfaces/IMinShoyuBashi.sol";

contract ShoyuBashiTest is IMinShoyuBashi {
    mapping(uint256 domain => mapping(uint256 id => bytes32)) thresholdHash;

    function getThresholdHash(uint256 domain_, uint256 id_) external view returns (bytes32) {
        return thresholdHash[domain_][id_];
    }

    function setThresholdHash(uint256 domain_, uint256 id_, bytes32 hash_) external {
        thresholdHash[domain_][id_] = hash_;
    }
}
