import { encodeAbiParameters, Hex, hexToBigInt, parseAbiParameters, sliceHex } from 'viem';

import { asHex, AsHex } from './hex.js';

export interface EncodeReceiptProofParams {
  chainId: AsHex,
  blockNumber: AsHex,
  blockHeader: Hex,
  ancestralBlockNumber: AsHex,
  ancestralBlockHeaders: readonly Hex[],
  receiptProof: readonly Hex[],
  transactionIndex: Hex,
  logIndex: AsHex,
}

export const encodeReceiptProof = (params: EncodeReceiptProofParams): Hex => {
  const proofStruct = encodeAbiParameters(
    parseAbiParameters([
      'ReceiptProof',
      'struct ReceiptProof { uint256 chainId; uint256 blockNumber; bytes blockHeader; uint256 ancestralBlockNumber; bytes[] ancestralBlockHeaders; bytes[] receiptProof; bytes transactionIndex; uint256 logIndex; }',
    ]),
    [
      {
        chainId: hexToBigInt(asHex(params.chainId, 32)),
        blockNumber: hexToBigInt(asHex(params.blockNumber, 32)),
        blockHeader: params.blockHeader,
        ancestralBlockNumber: hexToBigInt(asHex(params.ancestralBlockNumber, 32)),
        ancestralBlockHeaders: params.ancestralBlockHeaders,
        receiptProof: params.receiptProof,
        transactionIndex: params.transactionIndex,
        logIndex: hexToBigInt(asHex(params.logIndex, 32)),
      },
    ],
  );
  const proof = sliceHex(proofStruct, 32);
  return proof;
};
