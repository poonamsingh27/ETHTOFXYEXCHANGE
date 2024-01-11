# EthToFxyExchange Smart Contract

# Overview

The EthToFxyExchange smart contract is a simple decentralized exchange that allows users 
to purchase FXY tokens using ETH. The contract is written in Solidity and utilizes the 
OpenZeppelin ERC-20 implementation for the FXY token.

# Contract Details

* FXY Token Interface: The contract interacts with the FXY token through the IERC20 interface.

* Owner: The contract owner has the authority to update the conversion rate and withdraw any ETH 
sent to the contract.

* Conversion Rates: The contract maintains the current and last conversion rates for ETH to FXY. 
The initial conversion rate is set during contract deployment.

* Events:
   1. TokensPurchased: Emitted when users purchase FXY tokens by sending ETH to the contract.
   2. TokensWithdrawn: Emitted when users withdraw ETH and corresponding FXY tokens based on a 
   specified deposit index.

# Functions

 # constructor

# Parameters:

  * _fxyTokenAddress: Address of the FXY token contract.
  * _initialConversionRate: Initial conversion rate for ETH to FXY.

# updateConversionRate

# Parameters:

* _newConversionRate: New conversion rate to be set.
* Access: Only the contract owner can update the conversion rate.

# receive

# Fallback Function:

* Handles incoming ETH transactions.
* Users can send ETH to the contract to purchase FXY tokens.

# withdrawEthtofxy

 The withdrawEthtofxy function in the EthToFxyExchange smart contract allows users to withdraw 
 ETH and corresponding FXY tokens based on a specified deposit index. Users must have previously 
 deposited Matic to receive FXY tokens. This function calculates the equivalent ETH amount 
 based on the current conversion rate and transfers the corresponding FXY tokens to the contract.

# Parameters:

* user: User address initiating the withdrawal.
* depositIndex: Index of the deposit used for calculating the withdrawal amount.
* withdrawalAmount: Amount of ETH to withdraw.

# Access:

* The function is externally callable.
* Only users (not the owner) can initiate ETH withdrawals based on their previous Matic 
deposits.


# withdrawEth (Owner)

# Access:
Only the contract owner can withdraw any ETH sent to the contract.

