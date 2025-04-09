// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IAdapter} from "./libraries/hashi/interfaces/IAdapter.sol";

import {IShoyuBashiFossil} from "./interfaces/IShoyuBashiFossil.sol";

contract ShoyuBashiFossil is IShoyuBashiFossil {
    uint256 public immutable threshold;

    address[] private _adapters;

    constructor(uint256 threshold_, address[] memory adapters_) {
        threshold = threshold_;
        _adapters = adapters_;
    }

    function adapters() external view returns (address[] memory) {
        return _adapters;
    }

    function getThresholdHash(uint256 domain_, uint256 id_) external view returns (bytes32) {
        uint256 adaptersLength = _adapters.length;
        bytes32[] memory hashes = new bytes32[](adaptersLength);
        for (uint256 i = 0; i < adaptersLength; i++) {
            hashes[i] = IAdapter(_adapters[i]).getHash(domain_, id_);
        }

        revert(); // TODO: implement threshold logic
    }
}
