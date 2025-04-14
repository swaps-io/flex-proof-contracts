import { Hex, keccak256 } from 'viem';

interface CalcHashiMessageHashParams {
  message: Hex,
}

// Logic of `MessageHashCalculator.sol`
export const calcHashiMessageHash = (params: CalcHashiMessageHashParams): Hex => {
  const messageHash = keccak256(params.message);
  return messageHash;
};
