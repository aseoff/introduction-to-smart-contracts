// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./TokenPayable.sol";

/*
  By default, the owner of an Ownable contract is the account that deployed it.
*/
contract Treasury is Ownable, TokenPayable {
    constructor(address _token) TokenPayable(_token) {}

    // Function to deposit Ether into the contract
    function deposit() external payable {
        require(
            msg.value > 0,
            "Treasury: Deposit amount should be greater than zero"
        );

        // The balance of the contract is automatically updated
    }

    // Function to withdraw Ether from the contract to specified address
    function withdraw(uint256 amount, address receiver) external onlyOwner {
        require(
            address(receiver) != address(0),
            "Treasury: receiver is zero address"
        );
        require(
            address(this).balance >= amount,
            "Treasury: Not enough balance to withdraw"
        );

        (bool send, ) = receiver.call{value: amount}("");
        require(send, "To receiver: Failed to send Ether");
    }

    // Function to allow the owner to withdraw the entire balance
    function withdrawAll() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Treasury: No balance to withdraw");

        (bool send, ) = msg.sender.call{value: balance}("");
        require(send, "To owner: Failed to send Ether");
    }

    // Function to get the contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // TokenPayable functions
    function approveToken(uint256 _amount) external onlyOwner {
        _approveToken(_amount);
    }

    function getTokenBalance() external view returns (uint256) {
        return _getTokenBalance();
    }

    function depositToken(uint256 _amount) external {
        _depositToken(_amount);
    }

    function withdrawToken(
        uint256 _amount,
        address _receiver
    ) external onlyOwner {
        _withdrawToken(_amount, _receiver);
    }

    function withdrawAllToken() external onlyOwner {
        _withdrawAllToken();
    }





/////ADDED FUNCTIONS///////////

    // Function to get the token address
    function getTokenAddress() public view returns (address) {
    return address(token);
}

// return the fee for submitting a job application in wei
function getJobApplicationFee() external view returns (uint256) {
  return 100; 
}

// return the platform fee for each successful job placement in wei
function getPlatformFee() external view returns (uint256) {
  return 500; 
}

function getApplicationWithdrawalFee() external view returns (uint256) {
  return 50; // return the fee for withdrawing a job application in wei
}

function getPlacementWithdrawalFee() external view returns (uint256) {
  return 250; // return the fee for withdrawing a job placement in wei
}

function getUpskillFee() external view returns (uint256) {
  return 1000; // return the fee for accessing upskilling resources in wei
}

function getSuccessfulPlacementBonus() external view returns (uint256) {
  return 10000; // return the bonus for successful job placements in wei
}

function getUnsuccessfulPlacementPenalty() external view returns (uint256) {
  return 5000; // return the penalty for unsuccessful job placements in wei
}


}
