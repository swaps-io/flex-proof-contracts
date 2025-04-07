// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IJushin} from "../libraries/hashi/interfaces/IJushin.sol";

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

interface IHashiEventReceiver is IJushin, IEventVerifier {
    function yaro() external view returns (address);
}
