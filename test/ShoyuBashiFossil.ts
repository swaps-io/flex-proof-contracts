import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import { network } from 'hardhat';
import { Hex, zeroHash } from 'viem';

describe('ShoyuBashiFossil', async function () {
  const { viem } = await network.connect();

  const threshold = 2;
  const adapters = [ // 5
    await viem.deployContract('AdapterTest'),
    await viem.deployContract('AdapterTest'),
    await viem.deployContract('AdapterTest'),
    await viem.deployContract('AdapterTest'),
    await viem.deployContract('AdapterTest'),
  ];
  const sb = await viem.deployContract('ShoyuBashiFossil', [
    BigInt(threshold),
    adapters.map((adapter) => adapter.address),
  ]);

  const domain = 87654321n;
  const id = 111222333n;
  const hash = '0xe13ca52519d7d6c8be13907d86e9a8c9e2a5f6c16bb1b2a88437ebf64e386f9b';
  const hashAlt = '0x870383997aaecc86e573376e85ca0dd47f167590e95a8bec24289a48eb2a0398';

  async function setAdapter(index: number, hash: Hex) {
    const adapter = adapters[index];
    await adapter.write.setHash([domain, id, hash]);
  }

  async function resetAdapters() {
    for (let i = 0; i < adapters.length; i++) {
      await setAdapter(i, zeroHash);
    }
  }

  async function getThresholdHash() {
    return await sb.read.getThresholdHash([domain, id]);
  }

  it('Should reject 0/5', async function () {
    await resetAdapters();

    await assert.rejects(async () => {
      await getThresholdHash();
    });
  });

  it('Should reject 1/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);

    await assert.rejects(async () => {
      await getThresholdHash();
    });
  });

  it('Should allow 2/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hash);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hash);
  });

  it('Should allow 3/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hash);
    await setAdapter(3, hash);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hash);
  });

  it('Should allow 4/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hash);
    await setAdapter(3, hash);
    await setAdapter(0, hash);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hash);
  });

  it('Should allow 5/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hash);
    await setAdapter(3, hash);
    await setAdapter(0, hash);
    await setAdapter(2, hash);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hash);
  });

  it('Should reject 1/5 with alt 1/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hashAlt);

    await assert.rejects(async () => {
      await getThresholdHash();
    });
  });

  it('Should allow alt 1/5 with alt 2/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hashAlt);
    await setAdapter(0, hashAlt);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hashAlt);
  });

  it('Should reject 2/5 with alt 2/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hashAlt);
    await setAdapter(0, hashAlt);
    await setAdapter(2, hash);

    await assert.rejects(async () => {
      await getThresholdHash();
    });
  });

  it('Should allow 3/5 with alt 2/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hashAlt);
    await setAdapter(0, hashAlt);
    await setAdapter(2, hash);
    await setAdapter(3, hash);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hash);
  });

  it('Should allow alt 2/5 with alt 3/5', async function () {
    await resetAdapters();
    await setAdapter(1, hash);
    await setAdapter(4, hashAlt);
    await setAdapter(0, hashAlt);
    await setAdapter(2, hash);
    await setAdapter(3, hashAlt);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hashAlt);
  });

  it('Should allow alt 2/5 with alt 3/5 ordered', async function () {
    await resetAdapters();
    await setAdapter(0, hash);
    await setAdapter(1, hash);
    await setAdapter(2, hashAlt);
    await setAdapter(3, hashAlt);
    await setAdapter(4, hashAlt);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hashAlt);
  });

  it('Should allow 3/5 with alt 2/5 ordered', async function () {
    await resetAdapters();
    await setAdapter(0, hash);
    await setAdapter(1, hash);
    await setAdapter(2, hash);
    await setAdapter(3, hashAlt);
    await setAdapter(4, hashAlt);

    const sbHash = await getThresholdHash();
    assert.equal(sbHash, hash);
  });
});
