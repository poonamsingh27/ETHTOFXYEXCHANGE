const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("EthToFxyExchange", function () {
  let EthToFxyExchange;
  let ethToFxyExchange="0x16d561c75C26da07C0ADb27ACde3B6E2075D4848";
  let owner="0xdCe867155ec431Dba1Caa9c21f8567dBbe0472d4";
  let user="0xcDEEd618B32446e0dF0BD0F3a58CB41B262C13e7";

  const initialConversionRate = ethers.utils.parseUnits("1000000000000000000000000", "wei"); // 1 FXY = 1,000,000 wei
  console.log("initialConversionRate",initialConversionRate)
  const fxyTokenAddress = "0x3ADD0D140057303AeaA689C867Ca2eA3A7F844aD";
  const ethAmount = ethers.utils.parseEther("0.0001"); // 1 ETH
  console.log("ethAmount",ethAmount);

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();

    EthToFxyExchange = await ethers.getContractFactory("EthToFxyExchange");
    ethToFxyExchange = await EthToFxyExchange.deploy(fxyTokenAddress, "1000000000000000000000000");
    await ethToFxyExchange.deployed();
    //console.log(ethToFxyExchange.interface.fragments);
  });

//   console.log("ethToFxyExchange",ethToFxyExchange);
//   console.log("user",user);
//   console.log("owner",owner);

  it("should allow users to purchase FXY tokens", async function () {
    const ethAmount = ethers.utils.parseEther("0.0001"); // 0.0001 ETH
    try {
    // Send transaction and check Ether balance change
    await expect(() => user.sendTransaction({
      to: ethToFxyExchange.address,
      value: ethAmount,
      gasLimit: 2000000,
    })).to.changeEtherBalance(user, -ethAmount);

    expect(true).to.equal(false); // Force the test to fail
  } catch (error) {
    // Check if the revert reason is available and log it
    if (error.reason) {
      console.log("Revert Reason:", error.reason);
    }
  }

});

it("should allow the owner to update the conversion rate", async function () {
    const newConversionRate = ethers.utils.parseUnits("1200000", "wei"); 
    await expect(ethToFxyExchange.connect(owner).updateConversionRate(newConversionRate));
    expect(await ethToFxyExchange.lastConversionRate()).to.equal(initialConversionRate);
    expect(await ethToFxyExchange.conversionRate()).to.equal(newConversionRate);
  });

  
  it("should allow users to withdraw ETH and corresponding FXY tokens", async function () {
    const withdrawalAmount = ethers.utils.parseEther("0.0001"); // 0.5 ETH
    const depositIndex = 0; // Assuming you need to provide the deposit index
    
    const userAddress = "0xcDEEd618B32446e0dF0BD0F3a58CB41B262C13e7";
    await expect(ethToFxyExchange.connect(user).withdrawEthtofxy(userAddress,depositIndex,withdrawalAmount));
  });

});