import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters } from 'viem';

import { AsHex, asHex } from './hex.js';

export interface EncodeRouterProofParams {
  variant: AsHex,
}

export const encodeRouterProof = (params: EncodeRouterProofParams): Hex => {
  const proof = encodeAbiParameters(
    parseAbiParameters([
      'RouterProof',
      'struct RouterProof { uint256 variant; }',
    ]),
    [
      {
        variant: hexToBigInt(asHex(params.variant, 32)),
      },
    ],
  );
  return proof;
};
