// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

interface IHashStorage {
    function hasHashStore(bytes32 hash) external view returns (bool);
}
