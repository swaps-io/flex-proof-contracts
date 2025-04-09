import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import { network } from 'hardhat';

import { calcEventsHash } from './lib/calcEventsHash.js';

describe('EventsHashLibTest', async function () {
  const { viem } = await network.connect();
  const lib = await viem.deployContract('EventsHashLibTest');

  it('Should calc expected events hash', async function () {
    const hash = await lib.read.calc([
      [
        '0x73882357d2fd431bce5119513a20e7e5e45cfb0b6ff8d31e576c40c182b85e85',
        '0x1a44fb1eb8678588d1273f536f7bb0ceabb28d6055717fa481e13f81a540d5e4',
        '0x38edad5a3f4bc9706f8138a66b8b4ec73d5a1ee9aaf978c3706fa60c19235d09',
        '0xc0d1b4c1795e532b96fdfbfd8f4768636f53355319f32f486aa537d8c73fcf44',
      ],
    ]);
    assert.equal(hash, '0xfec6baeb2e2ab8008f0bca154411e1cf7ca6e7a5eab194436c250d319896cec7');
  });

  it('Should match offline events hash calc', async function () {
    const hash = calcEventsHash([
      '0x73882357d2fd431bce5119513a20e7e5e45cfb0b6ff8d31e576c40c182b85e85',
      '0x1a44fb1eb8678588d1273f536f7bb0ceabb28d6055717fa481e13f81a540d5e4',
      '0x38edad5a3f4bc9706f8138a66b8b4ec73d5a1ee9aaf978c3706fa60c19235d09',
      '0xc0d1b4c1795e532b96fdfbfd8f4768636f53355319f32f486aa537d8c73fcf44',
    ]);
    assert.equal(hash, '0xfec6baeb2e2ab8008f0bca154411e1cf7ca6e7a5eab194436c250d319896cec7');
  });
});
