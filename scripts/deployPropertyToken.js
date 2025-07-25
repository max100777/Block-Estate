const hre = require("hardhat"); // Imports the Hardhat Runtime Environment

async function main() {
  // Get the first account from the Hardhat network (which will be one of Ganache's accounts).
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying PropertyToken with the account:", deployer.address);

  // Define the initial supply for your PropertyToken.
  // parseEther converts a human-readable Ether string into its Wei equivalent (10^18).
  // This means "1000000" becomes 1,000,000 * 10^18 tokens.
  const initialSupply = hre.ethers.parseEther("1000000"); // 1 million tokens for a simulated property

  // Get the ContractFactory for your PropertyToken.
  // This is an abstraction used to deploy new smart contracts.
  const PropertyToken = await hre.ethers.getContractFactory("PropertyToken");

  // Deploy the PropertyToken contract.
  // Pass the constructor arguments: name, symbol, initialSupply.
  const propertyToken = await PropertyToken.deploy("Virtual Apartment A", "VA_A", initialSupply);

  // Wait for the contract to be deployed and confirmed on the blockchain.
  await propertyToken.waitForDeployment();

  // Log the address where the contract was deployed. This address is crucial for your frontend.
  console.log(`PropertyToken deployed to: ${propertyToken.target}`);
}

// Recommended pattern for handling asynchronous operations and potential errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1; // Exit with a non-zero code to indicate an error.
});