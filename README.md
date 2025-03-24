# IPR Management Smart Contracts

This repository contains the smart contracts to tokenize and represent *data assets* as NFT on the DLT.  In detail, [**AssetFactory**](./contracts/AssetFactory.sol) is a factory contract that deploys instances of the [**Asset**](./contracts/Asset.sol) contract. Asset is an ERC-721 contract. When the tokenize function is invoked, the AssetFactory contract deploys a new Asset contract. Each Asset instance inherits the same properties and functionality defined in the Asset contract, but with unique values specific to each NFT. 
  

## Getting started  

### Requirements  

- `node` and `npm` 

### Installation  

Clone the repository and install the required packages:  
```sh
npm install
``` 

## Run

### Locally

Launch the Hardhat Network,a local Ethereum network node designed for development. More information [here](https://hardhat.org/).
```shell
npx hardhat node
```

In a different terminal in the same directory, run:

```shell
npx hardhat --network localhost faucet <address>
npx hardhat --network localhost run scripts/deploy.js
```

### External networks

#### Testnet iota-evm 
Before proceeding, make sure the address linked to your `PRIVATE_KEY` in the `.env` file has sufficient funds for transactions. If not, you can request testnet SMR tokens from the IOTA EVM Faucet: https://evm-toolkit.evm.testnet.iotaledger.net.

```shell
npx hardhat --network iota-evm-testnet run scripts/deploy.js  
```

(To view transactions on the explorer: https://explorer.evm.testnet.iotaledger.net)

## Usage  

More information [here](https://github.com/MODERATE-Project/trust-service) to use and interact with the smart contract


## Licensing  

[Apache-2.0](http://www.apache.org/licenses/LICENSE-2.0)