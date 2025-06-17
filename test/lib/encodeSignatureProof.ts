import { Hex } from 'viem';

export interface EncodeSignatureProofParams {
  signature: Hex,
}

export const encodeSignatureProof = (params: EncodeSignatureProofParams): Hex => {
  return params.signature;
};
