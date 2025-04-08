// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IJushin} from "../libraries/hashi/interfaces/IJushin.sol";

interface IHashiEventReceiver is IJushin {
    function sendChain() external view returns (uint256);

    function eventSender() external view returns (address);

    function yaru() external view returns (address);

    function threshold() external view returns (uint256);

    function adaptersHash() external view returns (bytes32);

    function eventHashReceived(bytes32 eventHash) external view returns (bool);
}
