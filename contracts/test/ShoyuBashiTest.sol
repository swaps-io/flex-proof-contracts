// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {ShoyuBashi} from "@gnosis/hashi-evm/contracts/ownable/ShoyuBashi.sol";

contract ShoyuBashiTest is ShoyuBashi {
    constructor(address owner_, address hashi_)
        ShoyuBashi(owner_, hashi_) {}
}
