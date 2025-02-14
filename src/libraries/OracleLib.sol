// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";



/**
 * @title OracleLib
 * @author Hanan Khan
 * @notice This library is used to check the Chainlink Oracle for stale data.
 * If a price is stale, the function will return, and render DSCEngine unusabe - this is by design.
 * 
 * We want the DSCEngine to freeze if price becomes stale.
 * 
 * 
 */

library OracleLib {
    error OracleLib__StalePrice();

    uint256 private constant TIMEOUT = 3 hours;

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed) public view returns (uint80, int256, uint256, uint256, uint80) {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answerInRound) = priceFeed.latestRoundData();
        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) revert OracleLib__StalePrice();
        return (roundId, answer, startedAt, updatedAt, answerInRound) ;
    }
}