// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";

contract AddLiquid {
    /**
     *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 WETH.
     *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
     *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
     *
     */
    function addLiquidity(
        address usdc,
        address weth,
        address pool,
        uint256 usdcReserve,
        uint256 wethReserve
    ) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        // your code start here

        // see available functions here: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol
        // These values are passed in already
        // (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = pair
        //     .getReserves();

        // Multiply pool balances by 10**36 to improve math logic.  Surely there's a better way?
        uint usdcBalOurs = 1000 * 10 ** 6;
        uint wethBalOurs = 1 ether;

        /*
        General math we want:
        usdcDeposit / wethDeposit = usdcReserve / wethReserve
        So:
        usdcDeposit = (usdcReserve / wethReserve) * wethDeposit
        wethDeposit = (wethReserve / usdcReserve ) * usdcDeposit

        We can multiply numerator on right side by 10**32 to get more precision, then divide on the right to balance

        But then unless pool ratio perfectly matches our ratio, one of the deposit amounts well be
        greater than our balance, we can handle this by going with the smaller amount

        Example:
        usdcReserve = 47*10**6
        wethReserve = 80*10**18
        usdcBalOurs = 1000*10**6
        wethBalOurs = 1*10**18
        usdcDeposit = (usdcReserve * 10**32 / wethReserve) * wethBalOurs
        wethDeposit = (wethReserve * 10**32 / usdcReserve ) * usdcBalOurs
        usdcDeposit /= 10**32
        wethDeposit /= 10**32
        >>> usdcDeposit/usdcReserve
        0.0125
        >>> wethDeposit/wethReserve
        21.27659574468085

        # Because our wethDeposit amount is excessive, use the calculated
        # usdcDeposit amount, and round wethDeposit down to wethBalOurs
        */

        uint usdcDeposit = ((usdcReserve * 10 ** 32) / wethReserve) *
            wethBalOurs;
        uint wethDeposit = ((wethReserve * 10 ** 32) / usdcReserve) *
            usdcBalOurs;
        usdcDeposit /= 10 ** 32;
        wethDeposit /= 10 ** 32;
        if (usdcDeposit > usdcBalOurs) {
            usdcDeposit = usdcBalOurs;
        } else if (wethDeposit > wethBalOurs) {
            wethDeposit = wethBalOurs;
        }

        IUniswapV2Pair(weth).transfer(pool, wethDeposit);
        IUniswapV2Pair(usdc).transfer(pool, usdcDeposit);

        address to = msg.sender;
        pair.mint(to);
    }
}
