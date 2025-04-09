import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters, sliceHex } from 'viem';

import { AsHex, asHex } from './hex.js';

const EMITTER_VERIFIER_BIT = 1n << 255n;
const EMIT_EVENT_VERIFY_BIT = 1n << 254n;

export interface EncodeRouterProofParams {
  variant: AsHex,
  emitterVerifier?: boolean;
  emitEventVerify?: boolean;
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
        variant:
          hexToBigInt(asHex(params.variant, 32)) |
          (params.emitterVerifier ? EMITTER_VERIFIER_BIT : 0n) |
          (params.emitEventVerify ? EMIT_EVENT_VERIFY_BIT : 0n),
        relayChains: (params.relayChains ?? []).map((c) => hexToBigInt(asHex(c, 32))),
      },
    ],
  );
  const proof = sliceHex(proofStruct, 32);
  return proof;
};
