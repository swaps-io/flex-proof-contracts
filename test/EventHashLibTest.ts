import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import { network } from 'hardhat';

import { calcEventHash } from './lib/calcEventHash.js';

describe('EventHashLibTest', async function () {
  const { viem } = await network.connect();
  const lib = await viem.deployContract('EventHashLibTest');

  it('Should calc expected event hash', async function () {
    // Type hash calc:
    // - Type: "Event(uint256 chain,address emitter,bytes32[] topics,bytes data)"
    // - Hash: 0xba547a928a5c301ff66788fd50849d5b685e0bd0b3147c4917984147f4248c04
    const hash = await lib.read.calc([
      13371337133713371337n, // 0x000000000000000000000000000000000000000000000000b99088475af9b0c9
      '0x4242424242424242424242424242424242424242', // 0x0000000000000000000000004242424242424242424242424242424242424242
      [ // 0xed97dd5478fde5b7f5a1330b5ff89a599d51145aa62a8cfec0fdbf3f50d2088c
        '0x57949f7660111eb5ff4546c91bc5e7220c8c44367f671728233ff67a93d4b6fb',
        '0x68f4ed09cc4dd62fdaedda5e18d61f92ebaccdae113aa493e12ec730473bba2f',
        '0xe9611032ed20b631cc65c0687ae79d069040b4d71e1f17014fde6e43e21e3fb8',
      ],
      '0x0123456789abcdef', // 0x0c3d72390ac0ce0233c551a3c5278f8625ba996f5985dc8d612a9fc55f1de15a
    ]);
    assert.equal(hash, '0x6ba22fad9f9be89da32392d1df40f5a0b82c430085752d2894944be5eaac310c');
  });

  it('Should match offline hash calc', async function () {
    const hash = calcEventHash(
      13371337133713371337n, // chain
      '0x4242424242424242424242424242424242424242', // emitter
      [ // topics
        '0x57949f7660111eb5ff4546c91bc5e7220c8c44367f671728233ff67a93d4b6fb',
        '0x68f4ed09cc4dd62fdaedda5e18d61f92ebaccdae113aa493e12ec730473bba2f',
        '0xe9611032ed20b631cc65c0687ae79d069040b4d71e1f17014fde6e43e21e3fb8',
      ],
      '0x0123456789abcdef', // data
    );
    assert.equal(hash, '0x6ba22fad9f9be89da32392d1df40f5a0b82c430085752d2894944be5eaac310c');
  });
});
