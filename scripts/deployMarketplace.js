const hre = require("hardhat"); // Imports the Hardhat Runtime Environment

async function main() {
  // Get the first account from the Hardhat network.
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying Marketplace with the account:", deployer.address);

  // Get the ContractFactory for your Marketplace contract.
  const Marketplace = await hre.ethers.getContractFactory("Marketplace");

  // Deploy the Marketplace contract. It has no constructor arguments.
  const marketplace = await Marketplace.deploy();

  // Wait for the contract to be deployed and confirmed.
  await marketplace.waitForDeployment();

  // Log the deployed address. This is also crucial for your frontend.
  console.log(`Marketplace deployed to: ${marketplace.target}`);
}

// Recommended pattern for handling asynchronous operations and potential errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});