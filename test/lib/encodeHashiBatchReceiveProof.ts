import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters, sliceHex } from 'viem';

import { asHex, AsHex } from './hex.js';

export interface EncodeHashiBatchReceiveProofParams {
  eventHashes: readonly AsHex[],
  eventIndex: AsHex,
}

export const encodeHashiBatchReceiveProof = (params: EncodeHashiBatchReceiveProofParams): Hex => {
  const proofStruct = encodeAbiParameters(
    parseAbiParameters([
      'HashiBatchReceiveProof',
      'struct HashiBatchReceiveProof { bytes32[] eventHashes; uint256 eventIndex; }',
    ]),
    [
      {
        eventHashes: params.eventHashes.map((h) => asHex(h, 32)),
        eventIndex: hexToBigInt(asHex(params.eventIndex, 32)),
      },
    ],
  );
  const proof = sliceHex(proofStruct, 32);
  return proof;
};
