import { concatHex, Hex, keccak256 } from 'viem';

import { AsHex, asHex } from './hex.js';

export interface CalcEventsHashParams {
  eventHashes: readonly AsHex[],
}

// Logic of `EventsHashLib.sol`
export const calcEventsHash = (params: CalcEventsHashParams): Hex => {
  const eventsData = concatHex(params.eventHashes.map((h) => asHex(h, 32)));
  const eventsHash = keccak256(eventsData);
  return eventsHash;
};
