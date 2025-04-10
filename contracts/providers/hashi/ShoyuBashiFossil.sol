// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IAdapter} from "./libraries/hashi/interfaces/IAdapter.sol";

import {IShoyuBashiFossil} from "./interfaces/IShoyuBashiFossil.sol";

contract ShoyuBashiFossil is IShoyuBashiFossil {
    uint256 public immutable threshold;
    uint256 public immutable totalAdapters;

    address[] private _adapters;

    constructor(uint256 threshold_, address[] memory adapters_) {
        require(adapters_.length > 0);
        require(threshold_ > 0 && threshold_ <= adapters_.length);
        threshold = threshold_;
        totalAdapters = adapters_.length;
        _adapters = adapters_;
    }

    function adapters() external view returns (address[] memory) {
        return _adapters;
    }

    function getThresholdHash(uint256 domain_, uint256 id_) external view returns (bytes32) {
        bytes32[] memory hashes = new bytes32[](totalAdapters);
        for (uint256 i = 0; i < totalAdapters; i++) {
            hashes[i] = IAdapter(_adapters[i]).getHash(domain_, id_);
        }

        // Threshold check is based on `ShuSo._getThresholdHash` implementation
        for (uint256 i = 0; i < totalAdapters; i++) {
            if (i > totalAdapters - threshold) break;

            bytes32 baseHash = hashes[i];
            if (baseHash == bytes32(0)) continue;

            uint256 num = 0;
            for (uint256 j = i; j < totalAdapters; j++) {
                if (baseHash == hashes[j]) {
                    num++;
                    if (num == threshold) return hashes[i];
                }
            }
        }
        revert ThresholdNotMet();
    }
}
