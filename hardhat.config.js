require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

task("faucet", "Sends ETH and tokens to an address")
  .addPositionalParam("receiver", "The address that will receive them")
  .setAction(async ({ receiver }, { ethers }) => {
    if (network.name === "hardhat") {
      console.warn(
        "You are running the faucet task with Hardhat network, which" +
          "gets automatically created and destroyed every time. Use the Hardhat" +
          " option '--network localhost'"
      );
    }

    const [sender] = await ethers.getSigners();

    const tx2 = await sender.sendTransaction({
      to: receiver,
      value: ethers.WeiPerEther,
    });
    let rc = await tx2.wait();
    console.log(rc)
    console.log(`Transferred 1 ETH to ${receiver}`);
  });


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  settings: {
    optimizer: {
      enabled: true,
      runs: 1,
    },
  },
  networks: {
    'iota-evm-testnet': {
      url: 'https://json-rpc.evm.testnet.iotaledger.net',
      chainId: 1075,
      accounts: [process.env.PRIVATE_KEY],
    }
  }
};
