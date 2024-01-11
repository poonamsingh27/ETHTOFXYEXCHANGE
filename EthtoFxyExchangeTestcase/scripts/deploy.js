const { ethers } = require("hardhat");

async function deployEthToFxyExchangeContract() {
  // Replace these addresses and values with your actual values
  const FXYTokenAddress = "0x3add0d140057303aeaa689c867ca2ea3a7f844ad";
  const initialConversionRate = "1000000000000000000000000";

  // Get the contract factories
  const EthToFxyExchange = await ethers.getContractFactory("EthToFxyExchange");
  //const ERC20Burnable = await ethers.getContractFactory("ERC20Burnable"); // Make sure you have ERC20Burnable contract

  // Deploy the ERC20Burnable contract
  //const fxyToken = await ERC20Burnable.attach(fxyTokenAddress);

  // Deploy the FXYStaking contract
  const ethToFxyExchange = await EthToFxyExchange.deploy(
    FXYTokenAddress,
    initialConversionRate
  );

  await ethToFxyExchange.deployed();

  console.log("EthToFxyExchange contract deployed to:", ethToFxyExchange.address);
}

deployEthToFxyExchangeContract();