require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.28", // Match this with your contract's pragma
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      // Built-in local Hardhat network
    },
    ganache: {
      url: "http://127.0.0.1:7545", // Ganache RPC server
      accounts: {
        mnemonic: "test test test run run run real estate real estate real estate", // Replace with your actual Ganache mnemonic
      },
      chainId: 1337, // Default Ganache chain ID (can also be 5777 depending on version)
    },
  },
  paths: {
    sources: "./contracts",     // Location of your Solidity contracts
    artifacts: "./artifacts",   // Compiled output goes here
    cache: "./cache",           // Cache for build
    tests: "./test",            // Optional: test folder path
  },
};