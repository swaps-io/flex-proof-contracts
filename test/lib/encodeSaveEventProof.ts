import { encodeAbiParameters, Hex, parseAbiParameters, sliceHex } from 'viem';

export interface EncodeSaveEventProofParams {
  verify?: boolean;
  save?: boolean;
}

export const encodeSaveEventProof = (params: EncodeSaveEventProofParams): Hex => {
  const proofStruct = encodeAbiParameters(
    parseAbiParameters([
      'SaveEventProof',
      'struct SaveEventProof { uint256 flags; }',
    ]),
    [
      {
        flags: (params.verify ? 1n : 0n) | (params.save ? 2n : 0n),
      },
    ],
  );
  const proof = sliceHex(proofStruct, 32);
  return proof;
};
