// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashi, IAdapter} from "../providers/hashi/libraries/hashi/interfaces/IHashi.sol";

// Based on https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/Hashi.sol

contract HashiTest is IHashi {
    function checkHashWithThresholdFromAdapters(
        uint256 domain_,
        uint256 id_,
        uint256 threshold_,
        IAdapter[] calldata adapters_
    ) external view returns (bool) {
        if (threshold_ > adapters_.length || threshold_ == 0) revert InvalidThreshold(threshold_, adapters_.length);
        bytes32[] memory hashes = getHashesFromAdapters(domain_, id_, adapters_);

        for (uint256 i = 0; i < hashes.length; ) {
            if (i > hashes.length - threshold_) break;

            bytes32 baseHash = hashes[i];
            if (baseHash == bytes32(0)) {
                unchecked {
                    ++i;
                }
                continue;
            }

            uint256 num = 0;
            for (uint256 j = i; j < hashes.length; ) {
                if (baseHash == hashes[j]) {
                    unchecked {
                        ++num;
                    }
                    if (num == threshold_) return true;
                }
                unchecked {
                    ++j;
                }
            }

            unchecked {
                ++i;
            }
        }
        return false;
    }

    function getHashFromAdapter(
        uint256 domain_,
        uint256 id_,
        IAdapter adapter_
    ) external view returns (bytes32) {
        return adapter_.getHash(domain_, id_);
    }

    function getHashesFromAdapters(
        uint256 domain_,
        uint256 id_,
        IAdapter[] calldata adapters_
    ) public view returns (bytes32[] memory) {
        if (adapters_.length == 0) revert NoAdaptersGiven();
        bytes32[] memory hashes = new bytes32[](adapters_.length);
        for (uint256 i = 0; i < adapters_.length; ) {
            hashes[i] = adapters_[i].getHash(domain_, id_);
            unchecked {
                ++i;
            }
        }
        return hashes;
    }

    function getHash(
        uint256 domain_,
        uint256 id_,
        IAdapter[] calldata adapters_)
     external view returns (bytes32 hash) {
        if (adapters_.length == 0) revert NoAdaptersGiven();
        bytes32[] memory hashes = getHashesFromAdapters(domain_, id_, adapters_);
        hash = hashes[0];
        if (hash == bytes32(0)) revert HashNotAvailableInAdapter(adapters_[0]);
        for (uint256 i = 1; i < hashes.length; ) {
            if (hashes[i] == bytes32(0)) revert HashNotAvailableInAdapter(adapters_[i]);
            if (hash != hashes[i]) revert AdaptersDisagree(adapters_[i - 1], adapters_[i]);
            unchecked {
                ++i;
            }
        }
    }
}