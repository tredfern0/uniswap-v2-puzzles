// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract SimpleSwap {
    /**
     *  PERFORM A SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap any amount of WETH for USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        // your code start here
        uint256 amount0Out = 100;
        uint256 amount1Out = 0;
        address to = address(this);
        bytes memory data;

        // Do we need to calculate exact amount?  Think we'll get refunded?
        uint wethDeposit = 1 ether;
        IUniswapV2Pair(weth).transfer(pool, wethDeposit);
        IUniswapV2Pair(pool).swap(amount0Out, amount1Out, to, data);
    }
}
