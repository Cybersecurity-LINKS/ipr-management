// SPDX-FileCopyrightText: 2024 Fondazione LINKS
//
// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.18;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IAsset {
    event NFTminted(
        address owner,
        string name, 
        string symbol,
        address factory
    );

    function initialize(
        address owner,
        address _factory,
        string memory _name, 
        string memory _symbol,
        string memory _did,
        string memory _tokenURI,
        string memory _license
    ) external returns(bool);


   function balanceOf(address caller) external view returns(uint256);

    function getCount() external view returns(uint256);
    function getMintedNfts() external view returns(address[] memory);
    function getCreatorMintedNfts(address _owner) external view returns(address[] memory);
    function getAssetContract() external view returns(address);

    function getLicense() external view returns(string memory);
    function getDid() external view returns(string memory);
}