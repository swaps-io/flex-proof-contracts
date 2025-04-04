// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {RLPWriter} from "@eth-optimism/contracts-bedrock/src/libraries/rlp/RLPWriter.sol";

library RlpEventLib {
    function encode(
        address emitter_,
        bytes32[] memory topics_,
        bytes memory data_
    ) internal pure returns (bytes memory) {
        bytes[] memory eventList = new bytes[](3);
        eventList[0] = RLPWriter.writeAddress(emitter_);
        eventList[1] = _writeBytes32List(topics_);
        eventList[2] = RLPWriter.writeBytes(data_);
        return RLPWriter.writeList(eventList);
    }

    function _writeBytes32List(bytes32[] memory items_) private pure returns (bytes memory) {
        bytes[] memory itemList = new bytes[](items_.length);
        for (uint256 i = 0; i < items_.length; i++) {
            itemList[i] = RLPWriter.writeBytes(abi.encode(items_[i]));
        }
        return RLPWriter.writeList(itemList);
    }
}
