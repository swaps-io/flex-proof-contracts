import { concatHex, Hex, keccak256 } from 'viem';

import { AsHex, asHex } from './hex.js';

// Logic of `EventsHashLib.sol`
export const calcEventsHash = (eventHashes: readonly AsHex[]): Hex => {
  const eventsData = concatHex(eventHashes.map((h) => asHex(h, 32)));
  const eventsHash = keccak256(eventsData);
  return eventsHash;
};
