import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters, sliceHex } from 'viem';

import { AsHex, asHex } from './hex.js';

export interface EncodeRelayProofParams {
  relayChains: readonly AsHex[],
}

export const encodeRelayProof = (params: EncodeRelayProofParams): Hex => {
  const proofStruct = encodeAbiParameters(
    parseAbiParameters([
      'RelayProof',
      'struct RelayProof { uint256[] relayChains; }',
    ]),
    [
      {
        relayChains: params.relayChains.map((c) => hexToBigInt(asHex(c, 32))),
      },
    ],
  );
  const proof = sliceHex(proofStruct, 64);
  return proof;
};
