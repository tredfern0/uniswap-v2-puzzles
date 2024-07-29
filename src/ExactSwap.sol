// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

import "forge-std/console.sol";
contract ExactSwap {
    /**
     *  PERFORM AN SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performExactSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        // your code start here
        uint amount0Out = 1337 * 10 ** 6;
        uint amount1Out = 0;
        address to = address(this);

        // We need to calculate on our own how much WETH to swap for 1337 USDC

        (uint256 x, uint256 y, ) = IUniswapV2Pair(pool).getReserves();

        // Uniswap calculation:
        // From https://github.com/Uniswap/v2-periphery/blob/master/contracts/libraries/UniswapV2Library.sol
        uint numerator = y * (amount0Out) * (1000);
        uint denominator = (x - amount0Out) * 997;
        uint amountInLib = (numerator / denominator) + 1;

        ///// our calc
        // Derivation (our 'in' token here is y), we want to solve for delta_y given we know delta_x:
        // (x + x_delta) * (y + y_delta * .997) = x * y
        // (y + y_delta * .997) = x * y / (x + x_delta)
        // y_delta * .997 = (x * y / (x + x_delta)) - y
        // y_delta = ((x * y / (x + x_delta)) - y) * 1000 / 997
        // This was short by a couple tokens!
        // uint amountAlt = ((((x * y) / (x - 1337 * 10 ** 6)) - y) * 1000) / 997;

        // Trying to derive formula used in test calc from our last formula above:
        // y_delta = ((x * y / (x + x_delta)) - y) * 1000 / 997
        // y_delta = y * ((x / (x + x_delta)) - 1) * 1000 / 997
        // y_delta = (y * 1000) * ((x / (x + x_delta)) - 1) / 997
        // y_delta = (y * 1000) / (1 / ((x / (x + x_delta)) - 1)) / 997
        // Substitution from wolframalpha: 1 / ((x / (x + x_delta)) - 1) = -(x/x_delta) - 1
        // y_delta = (y * 1000) / (-(x / x_delta) - 1) / 997
        // y_delta = (y * 1000) / ((x / -x_delta) - 1) / 997
        // y_delta = (y * 1000) / (((x / -x_delta) - 1) * 997)
        // This also works...
        // uint amountIn = (y * 1000) / ((x / (1337 * 10 ** 6) - 1) * 997);

        IERC20(weth).transfer(address(pool), amountInLib);
        IUniswapV2Pair(pool).swap(amount0Out, amount1Out, to, "");
    }
}
