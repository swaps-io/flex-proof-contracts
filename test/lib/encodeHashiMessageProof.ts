import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters, sliceHex } from 'viem';

import { asHex, AsHex } from './hex.js';

export interface EncodeHashiMessageProofParams {
  eventHashes: readonly AsHex[],
  eventIndex: AsHex,
  nonce: AsHex,
  yaho: AsHex,
  reporters: readonly AsHex[],
}

export const encodeHashiMessageProof = (params: EncodeHashiMessageProofParams): Hex => {
  const proofStruct = encodeAbiParameters(
    parseAbiParameters([
      'HashiMessageProof',
      'struct HashiMessageProof { bytes32[] eventHashes; uint256 eventIndex; uint256 nonce; address yaho; address[] reporters; }',
    ]),
    [
      {
        eventHashes: params.eventHashes.map((h) => asHex(h, 32)),
        eventIndex: hexToBigInt(asHex(params.eventIndex, 32)),
        nonce: hexToBigInt(asHex(params.nonce, 32)),
        yaho: asHex(params.yaho, 20),
        reporters: params.reporters.map((r) => asHex(r, 20)),
      },
    ],
  );
  const proof = sliceHex(proofStruct, 32);
  return proof;
};
