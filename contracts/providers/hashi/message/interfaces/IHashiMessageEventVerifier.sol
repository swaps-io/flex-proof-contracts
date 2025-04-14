// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../../interfaces/IEventVerifier.sol";

interface IHashiMessageEventVerifier is IEventVerifier {
    error TODO(); // TODO

    function chain() external view returns (uint256);

    function sender() external view returns (address);

    function yaho() external view returns (address);

    function hashi() external view returns (address);

    function threshold() external view returns (uint256);

    function adaptersHash() external view returns (bytes32);
}
