// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";

import {RlpEventLib} from "./RlpEventLib.sol";

contract RlpEventLibTest is Test {
  function test_encodeKnownEvent() public pure {
    // Event:
    // - Emitter: 0xb981b2c0C3DB52C316d30df76Cc48fD167Ed87eD
    // - Topics:
    //   - #0: 0xecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440 (event signature - keccak256("EnabledModule(address)"))
    //   - #1: 0x00000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c226 (address 0x75cf11467937ce3F2f357CE24ffc3DBF8fD5c226)
    // - Data: 0x
    //
    // Expected RLP:
    // - Bytes: 0xf85a94b981b2c0c3db52c316d30df76cc48fd167ed87edf842a0ecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440a000000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c22680
    // - Hash: 0x91e7296d9168806cdb2d6c65b61c00fd78904ec70dbc08acbe066f2d85beb2de
    //
    // Based on:
    // - https://optimistic.etherscan.io/tx/0x218e42d1f4231e56f87e97fcdb8d1a503cb7991eee663c5b4987e23ac741277f#eventlog#87
    // - https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/test/proofs.ts#L66
    // - https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/test/05_HashiProver.spec.ts#L172

    address emitter = 0xb981b2c0C3DB52C316d30df76Cc48fD167Ed87eD;
    bytes32[] memory topics = new bytes32[](2);
    topics[0] = 0xecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440;
    topics[1] = 0x00000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c226;
    bytes memory data = '';

    bytes memory rlpEvent = RlpEventLib.encode(emitter, topics, data);
    require(keccak256(rlpEvent) == 0x91e7296d9168806cdb2d6c65b61c00fd78904ec70dbc08acbe066f2d85beb2de);
  }

  function test_encodeEmptyEvent() public pure {
    address emitter = 0x0000000000000000000000000000000000000000;
    bytes32[] memory topics = new bytes32[](0);
    bytes memory data = '';

    // Expected RLP:
    // - Bytes: 0xd7940000000000000000000000000000000000000000c080
    // - Hash: 0xdbf77a9a53040e3812e90331d97fe28c8195c2ad9a71f0ce2f5aa0a76b5d43a2

    bytes memory rlpEvent = RlpEventLib.encode(emitter, topics, data);
    require(keccak256(rlpEvent) == 0xdbf77a9a53040e3812e90331d97fe28c8195c2ad9a71f0ce2f5aa0a76b5d43a2);
  }

  function test_encodeLargeEvent() public pure {
    address emitter = 0xE14648dAB5a8b28fD6C31dA0Bb66a9EE5125ac71;
    bytes32[] memory topics = new bytes32[](4);
    topics[0] = 0x4847c93f29260c3566935839a5ce1243a503144a9fcd36a4da13f45b66416de4;
    topics[1] = 0x948990d5252e964c58d58207d2bc14c8367f61346f9bda2abd8c0988749c4345;
    topics[2] = 0x3b60c930bcf7516295ddf1284339d2dbc4a94b1ffa4e7735adee93c461ccdeaf;
    topics[3] = 0x2bc9ea778dd9869d2d81ba5112ae605e0e16ba93b60d914075b1199ddf28e1d3;
    bytes memory data = hex"6fc2a1643aa2b0ee87d33550748bb58a280356e88328fc9c799dc01220fd35e15dbcd39da97827821ab002283dfebf5b1d34acb5843ba8fc6daaea1596c7a8b1f9e974dce44c88d94f017342776d1642";

    // Expected RLP:
    // - Bytes: 0xf8ed94e14648dab5a8b28fd6c31da0bb66a9ee5125ac71f884a04847c93f29260c3566935839a5ce1243a503144a9fcd36a4da13f45b66416de4a0948990d5252e964c58d58207d2bc14c8367f61346f9bda2abd8c0988749c4345a03b60c930bcf7516295ddf1284339d2dbc4a94b1ffa4e7735adee93c461ccdeafa02bc9ea778dd9869d2d81ba5112ae605e0e16ba93b60d914075b1199ddf28e1d3b8506fc2a1643aa2b0ee87d33550748bb58a280356e88328fc9c799dc01220fd35e15dbcd39da97827821ab002283dfebf5b1d34acb5843ba8fc6daaea1596c7a8b1f9e974dce44c88d94f017342776d1642
    // - Hash: 0xf4fa6fa23b0af9cac354b06be1e741c52bd186b8ad23217d9083aaf8c104c36a

    bytes memory rlpEvent = RlpEventLib.encode(emitter, topics, data);
    require(keccak256(rlpEvent) == 0xf4fa6fa23b0af9cac354b06be1e741c52bd186b8ad23217d9083aaf8c104c36a);
  }
}
