// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts@1.2.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
                                  
    /**
    * @dev Get price feed of ETH/USD from a Chainlink data feed oracle
    * 
    * @return The current price of ETH in USD as a uint256
    */
    function getPrice() internal view returns(uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306 // ETH/USD price feed contract
        );
        
        // Get last price feed
        (,int256 answer,,,) = dataFeed.latestRoundData();

        // Get decimals for that data feed
        uint8 conversionFactor = 18 - dataFeed.decimals();

        //return uint256(answer * 1e10); // Convert from 8 to 18 decimals
        return uint256(answer) * 10**conversionFactor; // Convert from dataFeed.decimals() to 18 decimals
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    } 
}