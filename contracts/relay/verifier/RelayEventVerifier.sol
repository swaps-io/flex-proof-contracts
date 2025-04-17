// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.26;

import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";

import {EventHashLib} from "../../libraries/EventHashLib.sol";

import {IRelayEventVerifier, IEventVerifier} from "./interfaces/IRelayEventVerifier.sol";

import {RelayProofLib, RelayProof} from "./libraries/RelayProofLib.sol";

contract RelayEventVerifier is IRelayEventVerifier, Ownable2Step, Multicall {
    bytes32 private constant EVENT_VERIFY_SIGNATURE = 0x6cd36dcc6f96864e428558cad95b6c499ce5ea37cfa95110af6c5239fbdf90cf; // keccak256("EventVerify(bytes32)")

    address public immutable override eventVerifier;
    mapping(uint256 chain => address) public override chainRelayEmitter;

    constructor(address eventVerifier_, address initialOwner_)
        Ownable(initialOwner_) {
        eventVerifier = eventVerifier_;
    }

    function setChainRelayEmitter(uint256 chain_, address emitter_) external override onlyOwner {
        address oldEmitter = chainRelayEmitter[chain_];
        require(emitter_ != oldEmitter, SameChainRelayEmitter(chain_, emitter_));
        chainRelayEmitter[chain_] = emitter_;
        emit ChainRelayEmitterUpdate(chain_, oldEmitter, emitter_);
    }

    function verifyEvent(
        uint256 chain_,
        address emitter_,
        bytes32[] memory topics_,
        bytes memory data_,
        bytes calldata proof_
    ) external override {
        RelayProof calldata relayProof = RelayProofLib.decode(proof_);
        for (uint256 i = 0; i < relayProof.relayChains.length; i++) {
            bytes32 eventHash = EventHashLib.calc(chain_, emitter_, topics_, data_);
            chain_ = relayProof.relayChains[i];
            emitter_ = chainRelayEmitter[chain_];
            require(emitter_ != address(0), NoChainRelayEmitter(chain_));
            topics_ = new bytes32[](2);
            topics_[0] = EVENT_VERIFY_SIGNATURE;
            topics_[1] = eventHash;
            data_ = '';
        }

        IEventVerifier(eventVerifier).verifyEvent(chain_, emitter_, topics_, data_, RelayProofLib.consume(proof_));
    }
}
