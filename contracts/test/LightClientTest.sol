// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashiLightClient} from "../providers/hashi/receipt/interfaces/IHashiLightClient.sol";

contract LightClientTest is IHashiLightClient {
    mapping(uint256 blockNumber => bytes32) public headers;

    function setHeader(uint256 blockNumber_, bytes32 header_) external {
        headers[blockNumber_] = header_;
    }
}
