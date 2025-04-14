// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IHashiLightClientShoyuBashi} from "./interfaces/IHashiLightClientShoyuBashi.sol";
import {IHashiLightClient} from "./interfaces/IHashiLightClient.sol";

contract HashiLightClientShoyuBashi is IHashiLightClientShoyuBashi {
    uint256 public immutable chain;
    address public immutable lightClient;

    constructor(uint256 chain_, address lightClient_) {
        chain = chain_;
        lightClient = lightClient_;
    }

    function getThresholdHash(uint256 domain_, uint256 id_) external view returns (bytes32 header) {
        require(domain_ == chain, LightClientChainMismatch(chain, domain_)); // HashiProverLib: `domain_` ~ chain
        header = IHashiLightClient(lightClient).headers(id_); // HashiProverLib: `id_` ~ block number
        require(header != bytes32(0), LightClientMissingHeader(id_));
    }
}
