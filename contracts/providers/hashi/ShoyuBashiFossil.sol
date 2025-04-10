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
        return _findThresholdHash(hashes);
    }

    function _findThresholdHash(bytes32[] memory hashes_) private view returns (bytes32) {
        bytes32 maxHash = bytes32(0);
        uint256 maxCount = 0;
        bool maxAmbiguous = false;
        for (uint256 i = 0; i < totalAdapters; i++) {
            bytes32 hash = hashes_[i];
            if (hash == bytes32(0) || hash == maxHash) {
                continue;
            }

            uint256 count = 0;
            for (uint256 j = 0; j < totalAdapters; j++) {
                if (hashes_[j] == hash) {
                    count++;
                }
            }

            if (count > maxCount) {
                maxHash = hash;
                maxCount = count;
                maxAmbiguous = false;
            } else if (count == maxCount) {
                maxAmbiguous = true;
            }
        }

        require(maxCount >= threshold && !maxAmbiguous, ThresholdNotMet());
        return maxHash;
    }
}
