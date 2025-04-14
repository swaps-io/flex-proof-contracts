// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {ReceiptProofLib, ReceiptProof} from "../providers/hashi/proof/libraries/ReceiptProofLib.sol";

contract ReceiptProofLibTest {
    function test_decodeKnownProof(bytes32, string calldata, uint256, bytes calldata proof_, bytes calldata, bytes8, uint8) public pure {
        // Special `proof_` fixture expected - see `test/ReceiptProofLibTest.ts`.
        require(proof_.length == 4608, "Bad proof_.length");
        ReceiptProof calldata receiptProof = ReceiptProofLib.decode(proof_);
        require(receiptProof.chainId == 10, "Bad receiptProof.chainId");
        require(receiptProof.blockNumber == 127308333, "Bad receiptProof.blockNumber");
        require(receiptProof.blockHeader.length == 583, "Bad receiptProof.blockHeader.length");
        require(keccak256(receiptProof.blockHeader) == 0x4a95d1ff4f70678c282ef4c88aee8627798dc6957726bb27b16bf206875b5b7e, "Bad keccak256(receiptProof.blockHeader)");
        require(receiptProof.ancestralBlockNumber == 0, "Bad receiptProof.ancestralBlockNumber");
        require(receiptProof.ancestralBlockHeaders.length == 0, "Bad receiptProof.ancestralBlockHeaders.length");
        require(receiptProof.receiptProof.length == 3, "Bad receiptProof.receiptProof.length");
        require(keccak256(receiptProof.receiptProof[0]) == 0x3204fb2c7f9acb8cf2af0c7feeff761af2e86b687b42118a458a9810472ab2a7, "Bad keccak256(receiptProof.receiptProof[0])");
        require(keccak256(receiptProof.receiptProof[1]) == 0x43d1a97a67ace1b4fcf400c97b64833e363f929339269b5f08316efe15bb7442, "Bad keccak256(receiptProof.receiptProof[1])");
        require(keccak256(receiptProof.receiptProof[2]) == 0xe1af98a5d5db3b2b9beb67e7fe333e669b8bc7c73cac1b6c3f96d68670d87422, "Bad keccak256(receiptProof.receiptProof[2])");
        require(receiptProof.transactionIndex.length == 1, "Bad receiptProof.transactionIndex.length");
        require(keccak256(receiptProof.transactionIndex) == 0x60811857dd566889ff6255277d82526f2d9b3bbcb96076be22a5860765ac3d06, "Bad keccak256(receiptProof.transactionIndex)");
        require(receiptProof.logIndex == 4, "Bad receiptProof.logIndex");
    }
}
