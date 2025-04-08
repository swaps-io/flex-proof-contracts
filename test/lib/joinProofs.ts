import { concatHex, Hex } from 'viem';

export const joinProofs = (proofs: readonly Hex[]): Hex => {
  return concatHex(proofs);
};
