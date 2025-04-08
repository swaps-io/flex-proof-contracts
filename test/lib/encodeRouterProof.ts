import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters, sliceHex } from 'viem';

import { AsHex, asHex } from './hex.js';

export interface EncodeRouterProofParams {
  variant: AsHex,
  relayChains?: readonly AsHex[],
}

export const encodeRouterProof = (params: EncodeRouterProofParams): Hex => {
  const proofStruct = encodeAbiParameters(
    parseAbiParameters([
      'RouterProof',
      'struct RouterProof { uint256 variant; uint256[] relayChains; }',
    ]),
    [
      {
        variant: hexToBigInt(asHex(params.variant, 32)),
        relayChains: (params.relayChains ?? []).map((c) => hexToBigInt(asHex(c, 32))),
      },
    ],
  );
  const proof = sliceHex(proofStruct, 32);
  return proof;
};
