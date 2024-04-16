// SPDX-FileCopyrightText: 2024 Fondazione LINKS
//
// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

import "../interfaces/IAsset.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract AssetFactory is Ownable {

    uint256 private count; // counter of deployed NFT
    address private assetContract;

    address[] public assets; 
    mapping(address => address) public assetToOwner;
    mapping(address => uint) ownerAssetCount;

    struct AssetData {
        string name;
        string symbol;
        string proofId;
        string did;
        string license; // as SPDX
    }

    event AssetContractUpdated (address indexed _assetContract);
    event NftMinted (
        address istanceAddress,
        address assetContract,
        address owner,
        string name,
        string symbol,
        string proofId
    );

    constructor (address _assetContract) Ownable(msg.sender) {
        count = 0;
        updateAssetContract(_assetContract);
    }

    function tokenize (AssetData memory _assetData) public returns(address instanceAddr) {
        require(msg.sender != address(0), "address(0) cannot be an owner");

        instanceAddr = Clones.clone(assetContract);
        require(instanceAddr != address(0), "Failed to deploy new instance of Asset contract");
        
        assets.push(instanceAddr);
        assetToOwner[instanceAddr] = msg.sender;
        ownerAssetCount[msg.sender]++;
        count += 1;
        
        IAsset asset = IAsset(instanceAddr);
        require(asset.initialize(
            msg.sender,
            address(this),
            _assetData.name,
            _assetData.symbol,
            _assetData.proofId,
            _assetData.did,
            _assetData.license
        ) == true, "Factory: Could not initialize New NFT contract");
        require(asset.balanceOf(msg.sender) == 1, "NFT not minted");
        
        emit NftMinted(instanceAddr, assetContract, msg.sender, _assetData.name, _assetData.symbol, _assetData.proofId);

    }

    function updateAssetContract(address _assetContract) internal onlyOwner {

        require(_assetContract != address(0), "Address(0) NOT allowed");
        require(isContract_(_assetContract), "Provided address is NOT a valid contract address");

        assetContract = _assetContract;

        emit AssetContractUpdated(_assetContract);
    }

    // Address.isContract has been deprecated from openzeppelin v5.x
    function isContract_(address account) internal view onlyOwner returns (bool){
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    // get the number of the created nfts
    function getCount() external view returns(uint256) {
        return count;
    }

    function getAssets() external view returns(address[] memory) {
        return assets;
    }

    function getCreatorMintedNfts(address _owner) external view returns(address[] memory) {

        address[] memory ownerAssets = new address[](ownerAssetCount[_owner]);
        uint256 j = 0;

        for(uint256 i = 0; i < count; i++) {
            if(_owner == assetToOwner[assets[i]]){
                ownerAssets[j] = assets[i];
                j++;
            }    
        }        
        return ownerAssets;
    }

    function getAssetContract() external view returns(address) {
        return assetContract;
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
