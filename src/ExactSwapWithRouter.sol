// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

contract ExactSwapWithRouter {
    /**
     *  PERFORM AN EXACT SWAP WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using UniswapV2 router.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performExactSwapWithRouter(
        address weth,
        address usdc,
        uint256 deadline
    ) public {
        // your code start here
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = usdc;

        uint amountInMax = IERC20(weth).balanceOf(address(this));
        IERC20(weth).approve(router, amountInMax);

        uint256 amountOut = 1337 * 10 ** 6;

        address to = address(this);
        IUniswapV2Router(router).swapTokensForExactTokens(
            amountOut,
            amountInMax,
            path,
            to,
            deadline
        );
    }
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount of input tokens to swap.
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses. In our case, WETH and USDC.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    /////////////// Adding this function, think this is what we actually need?
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}
