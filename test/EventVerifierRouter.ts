import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import { network } from 'hardhat';
import { keccak256, parseEventLogs, stringToBytes, stringToHex } from 'viem';

import { calcEventHash } from './lib/calcEventHash.js';
import { joinProofs } from './lib/joinProofs.js';
import { encodeRouterProof } from './lib/encodeRouterProof.js';
import { asHex } from './lib/hex.js';
import { encodeReceiptProof } from './lib/encodeReceiptProof.js';
import { encodeSaveEventProof } from './lib/encodeSaveEventProof.js';
import { encodeHashiReceiveProof } from './lib/encodeHashiReceiveProof.js';
import { encodeHashiBatchReceiveProof } from './lib/encodeHashiBatchReceiveProof.js';
import { calcEventsHash } from './lib/calcEventsHash.js';
import { EVENT_VERIFY_SIGNATURE } from './lib/eventVerifySignature.js';

describe('EventVerifierRouter', async function () {
  const { viem } = await network.connect();
  const publicClient = await viem.getPublicClient();
  const [walletClient] = await viem.getWalletClients();
  const thisChain = BigInt(await publicClient.getChainId());

  // Router verification
  const routerOwner = walletClient.account.address;
  const router = await viem.deployContract('EventVerifierRouter', [routerOwner]);

  // Hashi block header verification [#100]
  const shoyuBashi = await viem.deployContract('ShoyuBashiTest');
  const hashiVerifier = await viem.deployContract('HashiEventVerifier', [
    shoyuBashi.address, // shoyuBashi
  ]);

  // Hashi message receive verification [#101, #102]
  const yaru = await viem.deployContract('YaruTest');
  const hashiReceiver = await viem.deployContract('HashiEventReceiver', [
    10n, // sendChain
    '0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef', // eventSender
    yaru.address, // yaru
    2n, // threshold
    [ // adapters
      '0xa1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1',
      '0xa2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2',
      '0xa3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3',
    ],
  ]);
  const hashiReceiveVerifier = await viem.deployContract('HashiEventReceiveVerifier', [
    hashiReceiver.address, // eventReceiver
  ]);
  const hashiBatchReceiveVerifier = await viem.deployContract('HashiBatchEventReceiveVerifier', [
    hashiReceiver.address, // eventReceiver
  ]);

  // Self verification
  const selfVerifier = await viem.deployContract('SelfEventVerifierTest', []);

  // Router setup
  await router.write.setChainVariantProvider([10n, 100n, hashiVerifier.address]);
  await router.write.setChainVariantProvider([10n, 101n, hashiReceiveVerifier.address]);
  await router.write.setChainVariantProvider([10n, 102n, hashiBatchReceiveVerifier.address]);
  await router.write.setChainVariantProvider([4321n, 101n, hashiReceiveVerifier.address]);
  await router.write.setChainRouter([4321n, '0xe0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0']);

  // Verifier test
  const test = await viem.deployContract('EventVerifierTest', [router.address]);

  it('Should verify event using Hashi receipt', async function () {
    // Based on:
    // - https://optimistic.etherscan.io/tx/0x218e42d1f4231e56f87e97fcdb8d1a503cb7991eee663c5b4987e23ac741277f#eventlog#87
    // - https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/test/proofs.ts#L66
    // - https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/test/05_HashiProver.spec.ts#L172

    const chain = 10n;
    const emitter = '0xb981b2c0C3DB52C316d30df76Cc48fD167Ed87eD';
    const topics = [
      keccak256(stringToBytes('EnabledModule(address)')),
      asHex('0x75cf11467937ce3F2f357CE24ffc3DBF8fD5c226', 32),
    ];
    const data = '0x';

    const eventHash = calcEventHash(chain, emitter, topics, data);

    const proof = joinProofs([
      encodeRouterProof({ variant: 100n }),
      encodeReceiptProof({
        chainId: 10n,
        blockNumber: 127308333n,
        blockHeader: '0xf90244a0f9ff0f83514b39d941c5b84e2f4f34b92e766bdc61de08a76dc9b14a71e73222a01dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347944200000000000000000000000000000000000011a0f1b09fb679e6b75e3169883ee999c4e4d3cd4bf95c6572e00ce730a2b732d711a02869278b132da65669ef8dd5a59e1cafb19432e63dd89b53ea61212d97cced4ea03204fb2c7f9acb8cf2af0c7feeff761af2e86b687b42118a458a9810472ab2a7b90100125b78c6f047983080c109c20003600080822088020460090f1ce4046c88533b0d0808083704d04840000072020c3324a15d404152906612503801016a6342cd0c40114c25c820cab225122d4054688a52a884101149061e116482455810080108a9030b62168280154002410082189003201c05237886e405451816294c4018cd24850788000608e011834c88001a281941b606cc3009402834280c0e804c1082108360108598ca8010614a111404202ed102208548408e00d0800018084124c230307608028494aa2903a60443410d90c0719000d4a3090102008e022060a603386ca14471050e298480116802316262182014708880488002b240005501e880840796922d840393870084018c3555846720fe1380a0be75f63a0e2efb12310fb91829a5b2252a882e508a674d7cb8c72eccb62a415688000000000000000082017ca056e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b4218080a0f0c257dfdcaf31ff962d00afaf90878fc0d01699b610ae334650a942eb716de0',
        ancestralBlockNumber: 0n,
        ancestralBlockHeaders: [],
        receiptProof: [
          '0xf851a043d1a97a67ace1b4fcf400c97b64833e363f929339269b5f08316efe15bb744280808080808080a0c6671ab0c8145b7e995558f60b59fc3ab0afd34db7ba64c70268da26e6f652078080808080808080',
          '0xf901f180a022532ca66e2a83977e663b41605e7e2df76bc896e12fc53dce0c5b95ed7f4367a0fd882e481b284515091c4eace0556fd4bf36261a282c4dbe14a9813af1a73504a04b64fbdf1b5db465262c0c4a07d8d1a69034fff72db3e02d6661743522b7c7d7a0f3e1c56f139f509c3bd8cc1546737d231ee006b4f760f9d754b1ce80b64ceb31a0095b2d77ffa53c424fe4cdaf377d3bea5129bc21e95046f267b0d429bf112405a0156430f22abbf89c225643a24d9a97a7fe5832d15df48ec934f56a5860431a8aa040c1f34f5f45ff6d5a717795fc90d520d5080994a10fc487af7a60557b367c5ca0dd8bd9a505b52c9249dc171eea453972bc5261f876553296c8a6186c20f4143da075f0a228baf7eea3111db5ca77d9901bd99109fa3c0d8d3c0e53280ea92e8ec7a0676127922e8aa2da69ca3fd4802d559275d6fd4f5f51f86801e0fcdbc65cdc0ea0e1af98a5d5db3b2b9beb67e7fe333e669b8bc7c73cac1b6c3f96d68670d87422a06ac3e127bdadf66bd1352a7666934c3ab258bb4483f2d9c285aeec2012fed133a0e64c4cb299540f0ca821a86fa4d0ffdd17ef4f997ad121ebec941cedaf2c9390a0977a40d5cb87002b9d8dbaf25667b3b0dd1bd089b49e6c5de4edc7fd2b45cf5fa064756251d84bca534b9408b1c3b5ed3b415bb06e52ac01d37b6c205ff54e7f4380',
          '0xf90ad720b90ad302f90acf01832fce87b9010000010000000400000000010000020000800000000000400100000000000000000000000000000000000000400000000000000000000000000000000000000000000010002400000000200000000000000000000010010008004000000000000000000200000000800500000000000000000008000100000000000000000000000800010000000200000000000000000008000002000000000000000004000000000080001000080800100000000000000000000000004000000000000000000000100004000000000000000000000000000000000000200000000080020000000010080000010008000000000800100060000000000000000000000000100000f909c4f85a94a8d3c1e744fcc68c893a32a9f19a49d5bc76fd0bf842a0ecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440a000000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c22680f9011b94a8d3c1e744fcc68c893a32a9f19a49d5bc76fd0bf842a0141df868a6331af528e38c83b7aa03edc19be66e37ae67f9285bf4f8e3c6a1a8a00000000000000000000000004e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec67b8c0000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000010000000000000000000000002dd68b007b46fbe91b9a7c3eda5a7a1063cb5b4700000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c22600000000000000000000000000000000000000000000000000000000000000010000000000000000000000009aa56119ab6bf672e22eea5c4735446101bd46d8f87a944e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec67f842a04f51faf6c4561ff95f067657e43439f0f856d97c04d9ec9070a6199ad418e235a0000000000000000000000000a8d3c1e744fcc68c893a32a9f19a49d5bc76fd0ba000000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c762f8799424f6f36a551fe6008fa80afcff1d6ace182ead2be1a0db3dd2da8ea81566d4f4c29c152977ba57d38e7eed4b61fb95dfaceb177409bab8400000000000000000000000009aa56119ab6bf672e22eea5c4735446101bd46d80000000000000000000000000000000000000000000000000000000000000001f85a94b981b2c0c3db52c316d30df76cc48fd167ed87edf842a0ecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440a000000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c22680f9011b94b981b2c0c3db52c316d30df76cc48fd167ed87edf842a0141df868a6331af528e38c83b7aa03edc19be66e37ae67f9285bf4f8e3c6a1a8a00000000000000000000000004e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec67b8c0000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000010000000000000000000000002dd68b007b46fbe91b9a7c3eda5a7a1063cb5b4700000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c22600000000000000000000000000000000000000000000000000000000000000010000000000000000000000007388755e0a5b867f30168ea89f2d42db2d5cb918f87a944e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec67f842a04f51faf6c4561ff95f067657e43439f0f856d97c04d9ec9070a6199ad418e235a0000000000000000000000000b981b2c0c3db52c316d30df76cc48fd167ed87eda000000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c762f8799424f6f36a551fe6008fa80afcff1d6ace182ead2be1a0db3dd2da8ea81566d4f4c29c152977ba57d38e7eed4b61fb95dfaceb177409bab8400000000000000000000000007388755e0a5b867f30168ea89f2d42db2d5cb9180000000000000000000000000000000000000000000000000000000000000001f85a94ca71fa74c9682518ff2489b902648e6c2745573bf842a0ecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440a000000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c22680f9011b94ca71fa74c9682518ff2489b902648e6c2745573bf842a0141df868a6331af528e38c83b7aa03edc19be66e37ae67f9285bf4f8e3c6a1a8a00000000000000000000000004e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec67b8c0000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000010000000000000000000000002dd68b007b46fbe91b9a7c3eda5a7a1063cb5b4700000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c2260000000000000000000000000000000000000000000000000000000000000001000000000000000000000000e44a29d8d2197e80085986953d52566d10eaacacf87a944e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec67f842a04f51faf6c4561ff95f067657e43439f0f856d97c04d9ec9070a6199ad418e235a0000000000000000000000000ca71fa74c9682518ff2489b902648e6c2745573ba000000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c762f8799424f6f36a551fe6008fa80afcff1d6ace182ead2be1a0db3dd2da8ea81566d4f4c29c152977ba57d38e7eed4b61fb95dfaceb177409bab840000000000000000000000000e44a29d8d2197e80085986953d52566d10eaacac0000000000000000000000000000000000000000000000000000000000000001f85a94de8507bb18616ce211638fb898e452f5486b916ef842a0ecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440a000000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c22680f9011b94de8507bb18616ce211638fb898e452f5486b916ef842a0141df868a6331af528e38c83b7aa03edc19be66e37ae67f9285bf4f8e3c6a1a8a00000000000000000000000004e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec67b8c0000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000010000000000000000000000002dd68b007b46fbe91b9a7c3eda5a7a1063cb5b4700000000000000000000000075cf11467937ce3f2f357ce24ffc3dbf8fd5c22600000000000000000000000000000000000000000000000000000000000000010000000000000000000000007e1306f8adf9125b3795dfefff35c1a80be5ebeef87a944e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec67f842a04f51faf6c4561ff95f067657e43439f0f856d97c04d9ec9070a6199ad418e235a0000000000000000000000000de8507bb18616ce211638fb898e452f5486b916ea000000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c762f8799424f6f36a551fe6008fa80afcff1d6ace182ead2be1a0db3dd2da8ea81566d4f4c29c152977ba57d38e7eed4b61fb95dfaceb177409bab8400000000000000000000000007e1306f8adf9125b3795dfefff35c1a80be5ebee0000000000000000000000000000000000000000000000000000000000000001',
        ],
        transactionIndex: '0x0b',
        logIndex: 4n,
      }),
    ]);

    // Enable block
    await shoyuBashi.write.setThresholdHash([
      10n, // domain
      127308333n, // id
      '0x4a95d1ff4f70678c282ef4c88aee8627798dc6957726bb27b16bf206875b5b7e', // hash
    ]);

    {
      const hash = await test.write.verifyEvent([
        chain,
        emitter,
        topics,
        data,
        proof,
      ]);

      const receipt = await publicClient.getTransactionReceipt({ hash });
      console.log(`Gas used: ${receipt.gasUsed}`);

      const logs = parseEventLogs({
        abi: test.abi,
        logs: receipt.logs,
        eventName: 'EventVerifyTest',
        args: {
          eventHash,
        },
      });
      assert.equal(logs.length, 1);
    }
  });

  it('Should verify event using Hashi receive', async function () {
    // Based on:
    // - https://optimistic.etherscan.io/tx/0x218e42d1f4231e56f87e97fcdb8d1a503cb7991eee663c5b4987e23ac741277f#eventlog#87

    const chain = 10n;
    const emitter = '0xb981b2c0C3DB52C316d30df76Cc48fD167Ed87eD';
    const topics = [
      keccak256(stringToBytes('EnabledModule(address)')),
      asHex('0x75cf11467937ce3F2f357CE24ffc3DBF8fD5c226', 32),
    ];
    const data = '0x';

    const eventHash = calcEventHash(chain, emitter, topics, data);

    const proof = joinProofs([
      encodeRouterProof({ variant: 101n }),
      encodeHashiReceiveProof(),
    ]);

    // Emulate receive
    await yaru.write.callJushin([
      hashiReceiver.address, // jushin
      123n, // messageId
      10n, // sourceChainId
      '0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef', // sender
      2n, // threshold
      [ // adapters
        '0xa1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1',
        '0xa2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2',
        '0xa3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3',
      ],
      eventHash, // data
    ]);

    {
      const hash = await test.write.verifyEvent([
        chain,
        emitter,
        topics,
        data,
        proof,
      ]);

      const receipt = await publicClient.getTransactionReceipt({ hash });
      console.log(`Gas used: ${receipt.gasUsed}`);

      const logs = parseEventLogs({
        abi: test.abi,
        logs: receipt.logs,
        eventName: 'EventVerifyTest',
        args: {
          eventHash,
        },
      });
      assert.equal(logs.length, 1);
    }
  });

  it('Should verify event using Hashi batch receive', async function () {
    // Based on:
    // - https://optimistic.etherscan.io/tx/0x218e42d1f4231e56f87e97fcdb8d1a503cb7991eee663c5b4987e23ac741277f#eventlog#87

    const chain = 10n;
    const emitter = '0xb981b2c0C3DB52C316d30df76Cc48fD167Ed87eD';
    const topics = [
      keccak256(stringToBytes('EnabledModule(address)')),
      asHex('0x75cf11467937ce3F2f357CE24ffc3DBF8fD5c226', 32),
    ];
    const data = '0x';

    const eventHash = calcEventHash(chain, emitter, topics, data);

    const eventHashes = [
      '0x60d40489eb54f749d1173907e28339d167c98ec029f440832be95a69846220e5',
      '0x58ce77cad226433cedd73c238b356f2d0671b5364f0fe8e07ffb37e9f087cd85',
      eventHash, // At `eventIndex`
      '0xa81e46a5f472258c8fcd1b34828c635bb708f51d25d760cd6f95b624b9d17a32',
      '0x43c9a5d635e874f9d308ed1ce42ba036d0392044c892531a99ca57c803430c1c',
      '0x82cfebc746a4609e989a924ff56320f66f97aa47a790b05b7ab80f737fd772ac',
      '0x388b5332e861875a9f88e44106c560bba63dcadcc3bc644f46813f459692da39',
    ];
    const eventIndex = 2;

    const eventsHash = calcEventsHash(eventHashes);

    const proof = joinProofs([
      encodeRouterProof({ variant: 102n }),
      encodeHashiBatchReceiveProof({ eventHashes, eventIndex }),
    ]);

    // Emulate batch receive
    await yaru.write.callJushin([
      hashiReceiver.address, // jushin
      123n, // messageId
      10n, // sourceChainId
      '0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef', // sender
      2n, // threshold
      [ // adapters
        '0xa1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1',
        '0xa2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2',
        '0xa3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3',
      ],
      eventsHash, // data
    ]);

    {
      const hash = await test.write.verifyEvent([
        chain,
        emitter,
        topics,
        data,
        proof,
      ]);

      const receipt = await publicClient.getTransactionReceipt({ hash });
      console.log(`Gas used: ${receipt.gasUsed}`);

      const logs = parseEventLogs({
        abi: test.abi,
        logs: receipt.logs,
        eventName: 'EventVerifyTest',
        args: {
          eventHash,
        },
      });
      assert.equal(logs.length, 1);
    }
  });

  it('Should verify event using self', async function () {
    const chain = thisChain;
    const emitter = selfVerifier.address;
    const topics = [
      keccak256(stringToBytes('ExpectedEvent(uint256)')),
      asHex(133713371337n, 32),
    ];
    const data = stringToHex('test-event-data');

    const eventHash = calcEventHash(chain, emitter, topics, data);

    const proof = joinProofs([
      encodeRouterProof({ variant: 0n, emitterVerifier: true }),
    ]);

    {
      const hash = await test.write.verifyEvent([
        chain,
        emitter,
        topics,
        data,
        proof,
      ]);

      const receipt = await publicClient.getTransactionReceipt({ hash });
      console.log(`Gas used: ${receipt.gasUsed}`);

      const logs = parseEventLogs({
        abi: test.abi,
        logs: receipt.logs,
        eventName: 'EventVerifyTest',
        args: {
          eventHash,
        },
      });
      assert.equal(logs.length, 1);
    }
  });

  it('Should verify relayed event', async function () {
    const chain = thisChain;
    const emitter = selfVerifier.address;
    const topics = [
      keccak256(stringToBytes('ExpectedEvent(uint256)')),
      asHex(133713371337n, 32),
    ];
    const data = stringToHex('test-event-data');

    const eventHash = calcEventHash(chain, emitter, topics, data);

    const proof = joinProofs([
      encodeRouterProof({ variant: 101n, relayChains: [4321n] }),
    ]);

    const relayEventHash = calcEventHash(
      4321n,
      '0xe0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0',
      [
        EVENT_VERIFY_SIGNATURE,
        eventHash,
      ],
      '0x',
    );

    // Emulate receive
    await yaru.write.callJushin([
      hashiReceiver.address, // jushin
      123n, // messageId
      10n, // sourceChainId
      '0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef', // sender
      2n, // threshold
      [ // adapters
        '0xa1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1',
        '0xa2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2',
        '0xa3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3',
      ],
      relayEventHash, // data
    ]);

    {
      const hash = await test.write.verifyEvent([
        chain,
        emitter,
        topics,
        data,
        proof,
      ]);

      const receipt = await publicClient.getTransactionReceipt({ hash });
      console.log(`Gas used: ${receipt.gasUsed}`);

      const logs = parseEventLogs({
        abi: test.abi,
        logs: receipt.logs,
        eventName: 'EventVerifyTest',
        args: {
          eventHash,
        },
      });
      assert.equal(logs.length, 1);
    }
  });
});
