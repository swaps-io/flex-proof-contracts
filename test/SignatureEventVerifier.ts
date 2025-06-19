import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import { network } from 'hardhat';

import { encodeSignatureProof } from './lib/encodeSignatureProof.js';
import { EVENT_PRIMARY_TYPE, EVENT_TYPES } from './lib/eventTypes.js';
import { EVENT_SIGNATURE_DOMAIN } from './lib/eventSignatureDomain.js';
import { privateKeyToAccount } from 'viem/accounts';

describe('SignatureEventVerifier', async function () {
  const { viem } = await network.connect();
  const [signerClient] = await viem.getWalletClients();

  const verifier = await viem.deployContract('SignatureEventVerifier', [
    signerClient.account.address, // signer
  ]);

  it('Should encode valid event signature proof', async function () {
    const chain = 1337n;
    const emitter = '0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef';
    const topics = [
      '0x0101010101010101010101010101010101010101010101010101010101010101',
      '0x2020202020202020202020202020202020202020202020202020202020202020',
    ] as const;
    const data = '0xabcdef0000000011110000000000000440000000000000000058000000000000181000000542';

    const signature = await signerClient.signTypedData({
      types: EVENT_TYPES,
      primaryType: EVENT_PRIMARY_TYPE,
      domain: EVENT_SIGNATURE_DOMAIN,
      message: {
        chain,
        emitter,
        topics,
        data,
      },
    });
    const proof = encodeSignatureProof({ signature });

    await verifier.read.verifyEvent([
      chain,
      emitter,
      topics,
      data,
      proof,
    ]);
  });

  it('Should produce expected event signature proof', async function () {
    const chain = 1337n;
    const emitter = '0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef';
    const topics = [
      '0x0101010101010101010101010101010101010101010101010101010101010101',
      '0x2020202020202020202020202020202020202020202020202020202020202020',
    ] as const;
    const data = '0xabcdef0000000011110000000000000440000000000000000058000000000000181000000542';

    const signerAccount = privateKeyToAccount('0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef');
    const signature = await signerAccount.signTypedData({
      types: EVENT_TYPES,
      primaryType: EVENT_PRIMARY_TYPE,
      domain: EVENT_SIGNATURE_DOMAIN,
      message: {
        chain,
        emitter,
        topics,
        data,
      },
    });
    const proof = encodeSignatureProof({ signature });
    assert.equal(
      proof,
      '0xc425ebc20208fc02e2df97f6300dbc46a19738844ee58d3c835654ce84cab7cf' +
      '2eed1e446df4bd842b572f548bbd572110158fd43c61cf838ddfc1dcca7c51f71c',
    );
  });
});
