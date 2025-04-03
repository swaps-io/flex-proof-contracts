// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {RLPWriter} from "@eth-optimism/contracts-bedrock/src/libraries/rlp/RLPWriter.sol";

library RlpEventLib {
    function encode(
        address emitter_,
        bytes32[] memory topics_,
        bytes memory data_
    ) internal pure returns (bytes memory rlpEvent) {
        // TODO: implement RLP encoding of event
        // rlpEvent = RLPWriter.writeList([
        //     RLPWriter.writeAddress(emitter_),
        //     RLPWriter.writeList([
        //         RLPWriter.writeUint(topic)
        //         for topic in topics_
        //     ]),
        //     RLPWriter.writeBytes(data_),
        // ]);
    }
}
