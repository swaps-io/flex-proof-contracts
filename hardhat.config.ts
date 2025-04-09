import { HardhatUserConfig } from 'hardhat/config';

import HardhatNodeTestRunner from '@nomicfoundation/hardhat-node-test-runner';
import HardhatViem from '@nomicfoundation/hardhat-viem';
import HardhatNetworkHelpers from '@nomicfoundation/hardhat-network-helpers';
import HardhatKeystore from '@nomicfoundation/hardhat-keystore';
import HardhatIgnitionViem from '@nomicfoundation/hardhat-ignition-viem';

const config: HardhatUserConfig = {
  plugins: [
    HardhatNodeTestRunner,
    HardhatViem,
    HardhatNetworkHelpers,
    HardhatKeystore,
    HardhatIgnitionViem,
  ],
  solidity: {
    profiles: {
      default: {
        version: '0.8.28',
        settings: {
          optimizer: {
            enabled: true,
            runs: 1_000_000,
          },
        },
      },
    },
    remappings: [
      'forge-std/=npm/forge-std@1.9.6/src/',
    ],
  },
  networks: {
    hardhatMainnet: {
      type: 'edr',
      chainType: 'l1',
    },
    hardhatOp: {
      type: 'edr',
      chainType: 'optimism',
    },
  },
};

export default config;
