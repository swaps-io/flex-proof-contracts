import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';

export default buildModule('EventVerifierRouter', (m) => {
  const account = m.getAccount(0);

  const router = m.contract('EventVerifierRouter', [account]);

  return { router };
});
