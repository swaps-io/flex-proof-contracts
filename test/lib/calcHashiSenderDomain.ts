import { hexToBigInt } from 'viem';

import { asHex, AsHex } from './hex.js'

export interface CalcHashiSenderDomainParams {
  domain: AsHex;
}

export const calcHashiSenderDomain = (params: CalcHashiSenderDomainParams): bigint => {
  const senderDomain = hexToBigInt(asHex(params.domain, 32)) << 160n;
  return senderDomain;
};
