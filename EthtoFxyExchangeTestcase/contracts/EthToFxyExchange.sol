 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title EthToFxyExchange
 * @dev A simple decentralized exchange contract allowing users to purchase FXY tokens using ETH.
 */

contract EthToFxyExchange {

    // FXY token contract interface
    IERC20 public fxyToken;
    // Contract owner address
    address public owner;
    uint256 public conversionRate; // Updated price of conversionRate
    uint256 public lastConversionRate; // Last updated conversion rate
    uint256 public initialConversionRate; // Initial conversion rate
      // Event emitted when tokens are purchased
     event TokensPurchased(address indexed buyer, uint256 ethAmount, uint256 fxyAmount);

     // Event emitted when tokens are withdrawn
     event TokensWithdrawn(address indexed user, uint256 ethAmount, uint256 fxyAmount);

     // Mapping to store user FXY token balances
     mapping(address => uint256) public userFxyBalances;

     // Define a mapping to store deposited Matic amounts for each user
     mapping(address => uint256) public userDepositedMaticAmounts;

    /**
     * @dev Constructor function to initialize the exchange.
     * @param _fxyTokenAddress The address of the FXY token contract.
     * @param _initialConversionRate The initial conversion rate for ETH to FXY.
     */

     constructor(address _fxyTokenAddress, uint256 _initialConversionRate) {
        fxyToken = IERC20(_fxyTokenAddress);
        owner = msg.sender;
        // conversionRate = _initialConversionRate;
        // lastConversionRate = _initialConversionRate;
         conversionRate = _initialConversionRate;
        lastConversionRate = _initialConversionRate;
        initialConversionRate = _initialConversionRate;
    }

      /**
     * @dev Function to allow the owner to update the conversion rate.
     * @param _newConversionRate The new conversion rate to be set.
     */

     function updateConversionRate(uint256 _newConversionRate) external {
        require(msg.sender == owner, "Only owner can update conversion rate");
        lastConversionRate = conversionRate; // Store the current rate before updating
        conversionRate = _newConversionRate;
    }

     /**
     * @dev Fallback function to handle incoming ETH transactions.
     * Users can send ETH to this contract to purchase FXY tokens.
     * The function calculates the corresponding FXY amount, transfers FXY tokens to the user,
     * updates their FXY balance, and records the received Matic amount for potential future withdrawals.
     */

     receive() external payable {
        uint256 ethAmount = msg.value;
        uint256 fxyAmount = (ethAmount * initialConversionRate) / 1e18;

        // Transfer FXY tokens to the buyer
        fxyToken.transfer(msg.sender, fxyAmount);

        // Update user FXY balance
        userFxyBalances[msg.sender] += fxyAmount;

        // Record the received matic amount for the user
       userDepositedMaticAmounts[msg.sender] += msg.value;

        // Emit event to log the purchase details
        emit TokensPurchased(msg.sender, ethAmount, fxyAmount);
    }

    /**
     * @dev Function to allow users to withdraw ETH and corresponding FXY tokens based on a specified deposit index.
     * The user must have previously deposited Matic to receive FXY tokens, and this function allows them to withdraw
     * the equivalent ETH amount based on the current conversion rate.
     * @param depositIndex The index of the deposit to be used for calculating the withdrawal amount.
     */

 function withdrawEthtofxy(address user, uint256 depositIndex, uint256 withdrawalAmount) external {
    // Ensure the caller is not the owner of the contract
    require(msg.sender != owner, "Owner cannot withdraw from this function");

    // Ensure the provided user address matches the sender's address
    require(user == msg.sender, "Invalid user address");


    // Ensure the deposit index is valid
    require(depositIndex < userDepositedMaticAmounts[msg.sender], "Invalid deposit index");

    // Ensure the user deposited enough Matic for the withdrawal
    require(userDepositedMaticAmounts[msg.sender] >= withdrawalAmount, "Insufficient deposited Matic amount");

    // Calculate the equivalent FXY amount based on the specified ETH withdrawal amount
    uint256 fxyWithdrawalAmount = (withdrawalAmount * lastConversionRate) / 1e18;

    // Transfer FXY tokens from the user to the contract
    fxyToken.transferFrom(msg.sender, address(this), fxyWithdrawalAmount);

         if (lastConversionRate != conversionRate) {

            // If updated, calculate ETH amount based on the new conversion rate
            // Ensure that the user deposited enough matic for the withdrawal
        //require(userDepositedMaticAmounts[msg.sender] >= depositIndex, "Insufficient deposited matic amount");

        payable(msg.sender).transfer((withdrawalAmount * conversionRate) / 1e18);
        
        } else {
            // If not updated, use the original deposit index for ETH transfer
            payable(msg.sender).transfer(withdrawalAmount);
        }

        // Update user FXY balance
        userFxyBalances[msg.sender] -= fxyWithdrawalAmount;

        emit TokensWithdrawn(msg.sender, withdrawalAmount, fxyWithdrawalAmount);
    }

    // Allow the owner to withdraw any ETH sent to the contract
    function withdrawEth() external {
        require(msg.sender == owner, "Only owner can withdraw ETH");
        payable(owner).transfer(address(this).balance);
    }
}