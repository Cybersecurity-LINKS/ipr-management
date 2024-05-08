// SPDX-FileCopyrightText: 2024 Fondazione LINKS
//
// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Asset is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable {
    
    address private factory;
    string private license;
    string private assetId; 
    string private did; 

    event NFTminted(
        address owner,
        string name, 
        string symbol,
        address factory
    );  

    modifier onlyAssetOwner() {
        require(msg.sender == ownerOf(1), "Not the asset (NFT) owner!");
        _;
    }

    modifier onlyFactory() {
        require(msg.sender == factory, "Not the Factory address!");
        _;
    }

    // ONLY FACTORY
    function initialize(
        address owner,
        address _factory,
        string memory _name, 
        string memory _symbol,
        string memory _proofId, // temporarily used as token URI content
        string memory _did,
        string memory _assetId,
        string memory _license
    ) external initializer returns(bool) {
        require(owner != address(0), "Invalid NFT owner: zero address not valid!");

        __ERC721_init(_name, _symbol);
        __ERC721URIStorage_init();
        factory = _factory;

        require(msg.sender == _factory, "Not the Factory address!");

        _safeMint(owner, 1);
        _setTokenURI(1, _proofId);
        license = _license;
        did = _did;
        assetId = _assetId;
        
        emit NFTminted(owner, _name, _symbol, factory);
        return true;
    }

    function getAssetOwner() external view returns (address owner) {
        return ownerOf(1);
    }

    function getLicense() external view returns(string memory) {
        return license;
    }

    function getDid() external view returns(string memory) {
        return did;
    }

    function getAssetId() external view returns(string memory) {
        return assetId;
    }

    // The following functions are overrides required by Solidity.

    // function _burn(uint256 id) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) onlyServiceOwner {
    //     super._burn(id);
    // }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721URIStorageUpgradeable, ERC721Upgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function balanceOf(address caller) public view override(ERC721Upgradeable, IERC721) returns(uint256) {
        return super.balanceOf(caller);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721URIStorageUpgradeable, ERC721Upgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev fallback function
     *      this is a default fallback function in which receives
     *      the collected ether.
     */
    fallback() external payable {}

    /**
     * @dev receive function
     *      this is a default receive function in which receives
     *      the collected ether.
     */
    receive() external payable {}
}