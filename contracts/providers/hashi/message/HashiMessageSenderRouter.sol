// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";

import {IHashiMessageSenderRouter} from "./interfaces/IHashiMessageSenderRouter.sol";

contract HashiMessageSenderRouter is IHashiMessageSenderRouter, Ownable2Step, Multicall {
    mapping(uint256 domain => address) public override domainSender;

    constructor(address initialOwner_)
        Ownable(initialOwner_) {}

    function setDomainSender(uint256 domain_, address sender_) external override onlyOwner {
        address oldSender = domainSender[domain_];
        require(sender_ != oldSender, SameDomainSender(domain_, sender_));
        domainSender[domain_] = sender_;
        emit DomainSenderUpdate(domain_, oldSender, sender_);
    }
}
