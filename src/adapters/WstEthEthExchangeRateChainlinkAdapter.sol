// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.21;

import {IStEth} from "../interfaces/IStEth.sol";
import {AggregatorV3Interface} from "../interfaces/AggregatorV3Interface.sol";

import {ErrorsLib} from "../libraries/ErrorsLib.sol";

/// @title WstEthEthExchangeRateChainlinkAdapter
/// @author Morpho Labs
/// @custom:contact security@morpho.org
/// @notice wstETH/ETH exchange rate price feed.
/// @dev This contract should only be used as price feed for `ChainlinkOracle`.
contract WstEthEthExchangeRateChainlinkAdapter is AggregatorV3Interface {
    uint8 public constant decimals = 18;
    string public constant description = "wstETH/ETH exchange rate";

    IStEth public immutable ST_ETH;

    constructor(address stEth) {
        require(stEth != address(0), ErrorsLib.ZERO_ADDRESS);
        ST_ETH = IStEth(stEth);
    }

    /// @notice Reverts as no Chainlink aggregator is used.
    function version() external pure returns (uint256) {
        revert();
    }

    /// @notice Reverts as it's not necessary for the ChainlinkOracle contract.
    function getRoundData(uint80) external pure returns (uint80, int256, uint256, uint256, uint80) {
        revert();
    }

    function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80) {
        uint256 answer = ST_ETH.getPooledEthByShares(10 ** decimals);
        return (0, int256(answer), 0, 0, 0);
    }
}
