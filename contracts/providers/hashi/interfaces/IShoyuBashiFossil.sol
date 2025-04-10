// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IMinShoyuBashi} from "./IMinShoyuBashi.sol";

interface IShoyuBashiFossil is IMinShoyuBashi {
    error ThresholdNotMet();

    function threshold() external view returns (uint256);

    function totalAdapters() external view returns (uint256);

    function adapters() external view returns (address[] memory);
}
