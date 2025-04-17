// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IAdapter} from "@gnosis/hashi-evm/contracts/interfaces/IAdapter.sol";

contract AdapterTest is IAdapter {
    mapping(uint256 domain => mapping(uint256 id => bytes32)) _hashes;

    function getHash(uint256 domain_, uint256 id_) external view returns (bytes32) {
        return _hashes[domain_][id_];
    }

    function setHash(uint256 domain_, uint256 id_, bytes32 hash_) external {
        _hashes[domain_][id_] = hash_;
    }
}
