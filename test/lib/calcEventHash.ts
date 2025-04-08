import { concatHex, Hex, keccak256 } from 'viem';

import { AsHex, asHex } from './hex.js';

const EVENT_TYPE_HASH = '0xba547a928a5c301ff66788fd50849d5b685e0bd0b3147c4917984147f4248c04';

// Logic of `EventHashLib.sol`
export const calcEventHash = (
  chain: AsHex,
  emitter: AsHex,
  topics: readonly AsHex[],
  data: Hex,
): Hex => {
  const topicsData = concatHex(topics.map((t) => asHex(t, 32)));
  const topicsHash = keccak256(topicsData);
  const dataHash = keccak256(data);
  const eventData = concatHex([
    EVENT_TYPE_HASH,
    asHex(chain, 32),
    asHex(emitter, 32),
    topicsHash,
    dataHash,
  ]);
  const eventHash = keccak256(eventData);
  return eventHash;
};
