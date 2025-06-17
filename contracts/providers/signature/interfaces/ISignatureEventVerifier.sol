// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {IEventVerifier} from "../../../interfaces/IEventVerifier.sol";

interface ISignatureEventVerifier is IEventVerifier {
    error InvalidSignatureProof(address recovered, address signer);

    function signer() external view returns (address);
}
