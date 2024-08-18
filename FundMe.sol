// Get fund from users
// Withdraw funds
// Set minim funding value ins USd

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimunUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable  {
        // allow user to send money
        // have a minimum $ sent of 5 USD
        require(msg.value.getConversionRate() >= minimunUsd, "Didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public {
        // transfer
        //payable(msg.sender).transfer(address(this).balance);

        // send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send failed");

        // call
        (bool callSuccess, /*bytes memory dataReturned*/) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) 
        {
            address funderAddress = funders[funderIndex];
            addressToAmountFunded[funderAddress] = 0;
        }
        
        funders = new address[](0);
    } 
}