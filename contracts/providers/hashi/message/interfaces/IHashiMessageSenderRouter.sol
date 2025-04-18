// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

interface IHashiMessageSenderRouter {
    error SameDomainSender(uint256 domain, address sender);
    error NoDomainSender(uint256 domain);

    event DomainSenderUpdate(uint256 indexed domain, address oldSender, address newSender);

    function domainSender(uint256 domain) external view returns (address);

    function setDomainSender(uint256 domain, address sender) external; // Only owner
}
