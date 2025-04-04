# Hashi Libraries

Based on [gnosis/hashi](https://github.com/gnosis/hashi) repo ([d6a3d5f](https://github.com/gnosis/hashi/tree/d6a3d5f5a881d0646cff63f4c980854070cbb6f1)):

- 📂 [`interfaces`](https://github.com/gnosis/hashi/tree/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/interfaces)
  - 📄 [`IAdapter`](https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/interfaces/IAdapter.sol)
  - 📄 [`IHashi`](https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/interfaces/IHashi.sol)
  - 📄 [`IShoyuBashi`](https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/interfaces/IShoyuBashi.sol)
  - 📄 [`IShuSho`](https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/interfaces/IShuSho.sol)
- 📂 [`prover`](https://github.com/gnosis/hashi/tree/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/prover)
  - 📄 [`HashiProverLib.sol`](https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/prover/HashiProverLib.sol)
  - 📄 [`HashiProverStructs.sol`](https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/packages/evm/contracts/prover/HashiProverStructs.sol)

The Hashi libraries require pragma version [patch](https://github.com/gnosis/hashi/blob/d6a3d5f5a881d0646cff63f4c980854070cbb6f1/patches/%40eth-optimism%2Bcontracts-bedrock%2B0.17.3.patch)
for `@eth-optimism/contracts-bedrock` (v1.7.3), which is also [ported](../../../../patches/@eth-optimism-contracts-bedrock-npm-0.17.3-e7ff7d2c90.patch) to this repo.
