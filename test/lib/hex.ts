import { Hex, isHex, padHex, toHex } from 'viem';

export type AsHex = Parameters<typeof toHex>[0];

export const asHex = (value: AsHex, size: number): Hex => {
  if (isHex(value)) {
    return padHex(value, { size, dir: 'left' });
  }
  return toHex(value, { size });
};
