// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

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
        // Do we not get refunded?  Getting error
        // [FAIL. Reason: revert: Did Not Swap Exact Amount Of WETH.]
        IERC20(weth).transfer(address(pool), 1 ether);
        IUniswapV2Pair(pool).swap(amount0Out, amount1Out, to, "");
    }
}
