// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract MoodNft is ERC721, Ownable {
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error MoodNft__CantFlipMoodIfNotOwner();

    enum NFTState {
        HAPPY,
        SAD
    }

    uint256 private _tokenCounter;
    string private _sadSvgUri;
    string private _happySvgUri;

    mapping(uint256 => NFTState) private _tokenIdToState;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(
        string memory sadSvgUri,
        string memory happySvgUri
    ) ERC721("Mood NFT", "MN") {
        _tokenCounter = 0;
        _sadSvgUri = sadSvgUri;
        _happySvgUri = happySvgUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, _tokenCounter);
        _tokenCounter = _tokenCounter + 1;
        emit CreatedNFT(_tokenCounter);
    }

    function flipMood(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (_tokenIdToState[tokenId] == NFTState.HAPPY) {
            _tokenIdToState[tokenId] = NFTState.SAD;
        } else {
            _tokenIdToState[tokenId] = NFTState.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        string memory imageURI = _happySvgUri;

        if (_tokenIdToState[tokenId] == NFTState.SAD) {
            imageURI = _sadSvgUri;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getHappySVG() public view returns (string memory) {
        return _happySvgUri;
    }

    function getSadSVG() public view returns (string memory) {
        return _sadSvgUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return _tokenCounter;
    }
}