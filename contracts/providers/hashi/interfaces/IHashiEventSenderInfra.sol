// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

interface IHashiEventSenderInfra {
    function eventVerifier() external view returns (address);

    function receiveChain() external view returns (uint256);

    function eventReceiver() external view returns (address);

    function yaho() external view returns (address);

    function threshold() external view returns (uint256);

    function reporters() external view returns (address[] memory);

    function adapters() external view returns (address[] memory);
}
