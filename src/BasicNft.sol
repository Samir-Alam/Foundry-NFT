// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private _tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    constructor() ERC721("Dogie", "Dog") {
        _tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[_tokenCounter] = tokenUri;
        _safeMint(msg.sender, _tokenCounter);
        _tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
