import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters, sliceHex } from 'viem';

import { asHex, AsHex } from './hex.js';

export interface EncodeHashiMessageProofParams {
  batchHashes?: readonly AsHex[],
  batchIndex?: AsHex,
  nonce: AsHex,
  reporters: readonly AsHex[],
  adapters: readonly AsHex[],
}

export const encodeHashiMessageProof = (params: EncodeHashiMessageProofParams): Hex => {
  const proofStruct = encodeAbiParameters(
    parseAbiParameters([
      'HashiMessageProof',
      'struct HashiMessageProof { bytes32[] batchHashes; uint256 batchIndex; uint256 nonce; address[] reporters; address[] adapters; }',
    ]),
    [
      {
        batchHashes: (params.batchHashes ?? []).map((h) => asHex(h, 32)),
        batchIndex: hexToBigInt(asHex(params.batchIndex ?? 0n, 32)),
        nonce: hexToBigInt(asHex(params.nonce, 32)),
        reporters: params.reporters.map((r) => asHex(r, 20)),
        adapters: params.adapters.map((r) => asHex(r, 20)),
      },
    ],
  );
  const proof = sliceHex(proofStruct, 32);
  return proof;
};
