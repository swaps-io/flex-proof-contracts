import { concatHex, Hex, keccak256 } from 'viem';

import { AsHex, asHex } from './hex.js';

export interface CalcHashiMessageIdParams {
  sourceChainId: AsHex,
  dispatcherAddress: AsHex,
  messageHash: AsHex,
}

// Logic of `MessageIdCalculator.sol`
export const calcHashiMessageId = (params: CalcHashiMessageIdParams): bigint => {
  const messageIdData = concatHex([
    asHex(params.sourceChainId, 32),
    asHex(params.dispatcherAddress, 32),
    asHex(params.messageHash, 32),
  ]);
  const messageId = BigInt(keccak256(messageIdData));
  return messageId;
};
