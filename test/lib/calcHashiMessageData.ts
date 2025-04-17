import { concatHex, Hex, keccak256 } from 'viem';

import { AsHex, asHex } from './hex.js';

export interface CalcHashiMessageDataParams {
  eventHashes: readonly AsHex[],
}

// Logic of `HashiMessageDataLib.sol`
export const calcHashiMessageData = (params: CalcHashiMessageDataParams): Hex => {
  const eventsData = concatHex(params.eventHashes.map((h) => asHex(h, 32)));
  const eventsHash = keccak256(eventsData);
  return eventsHash;
};
