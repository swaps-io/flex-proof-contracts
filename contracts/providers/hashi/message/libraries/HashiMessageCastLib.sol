// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IReporter, IAdapter} from "../../libraries/hashi/interfaces/IReporter.sol";

library HashiMessageCastLib {
    function asReporters(address[] memory addresses_) internal pure returns (IReporter[] memory reporters) {
        assembly { reporters := addresses_ }
    }

    function asAdapters(address[] memory addresses_) internal pure returns (IAdapter[] memory adapters) {
        assembly { adapters := addresses_ }
    }
}
