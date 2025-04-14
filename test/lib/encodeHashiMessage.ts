import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters } from 'viem';

import { asHex, AsHex } from './hex.js';

export interface EncodeHashiMessageParams {
  nonce: AsHex,
  targetChainId: AsHex,
  threshold: AsHex,
  sender: AsHex,
  receiver: AsHex,
  data: Hex,
  reporters: readonly AsHex[],
  adapters: readonly AsHex[],
}

export const encodeHashiMessage = (params: EncodeHashiMessageParams): Hex => {
  const message = encodeAbiParameters(
    parseAbiParameters([
      'Message',
      'struct Message { uint256 nonce; uint256 targetChainId; uint256 threshold; address sender; address receiver; bytes data; address[] reporters; address[] adapters; }',
    ]),
    [
      {
        nonce: hexToBigInt(asHex(params.nonce, 32)),
        targetChainId: hexToBigInt(asHex(params.targetChainId, 32)),
        threshold: hexToBigInt(asHex(params.threshold, 32)),
        sender: asHex(params.sender, 20),
        receiver: asHex(params.receiver, 20),
        data: params.data,
        reporters: params.reporters.map((r) => asHex(r, 20)),
        adapters: params.adapters.map((r) => asHex(r, 20)),
      },
    ],
  );
  return message;
};
