// SPDX-FileCopyrightText: 2024 Fondazione LINKS
//
// SPDX-License-Identifier: Apache-2.0

const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {

  let contracts = {}

  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());

  const Asset = await ethers.deployContract("Asset");
  contracts.Asset = await Asset.getAddress();
  console.log("Asset SC address:", contracts.Asset);

  const AssetFactory = await ethers.deployContract("AssetFactory",  [contracts.Asset] );
  contracts.AssetFactory = await AssetFactory.getAddress();
  console.log("AssetFactory SC address:", contracts.AssetFactory);

  const json = JSON.stringify(contracts, null, 2);
  try {
    await fs.promises.writeFile('contracts.json', json)
    console.log("Addresses file correctly generated. Have a look at ./contracts.json");
    process.exit(0);
  } catch (error) {
    console.log("Error in writing addresses file!", error);
    process.exit(1);
  }

}

main();