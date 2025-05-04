
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IUniswapV3Pool {
    function slot0() external view returns (
        uint160 sqrtPriceX96,
        int24,
        uint16,
        uint16,
        uint16,
        uint8,
        bool
    );
}

contract OracleTokenSimple is ERC20, Ownable {
    address public constant RECEIVER = 0x0F6dbb5B71372aB1d77Ed67D1260083cF9f07476;
    
    address public uniswapPool = 0xA374094527e1673A86dE625aa59517c5dE346d32; // POL/USDC pool on Polygon
    bool public useDefaultPrice = true;
    uint256 public defaultMintPrice = 2e18; // 2 POL (assuming 18 decimals)

    constructor() ERC20("Oracle of Delphi Token", "ODEL") Ownable(RECEIVER) {}

    receive() external payable {}
    fallback() external payable {}

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function mint(uint256 amount) external payable {
        require(amount > 0, "Amount must be greater than zero");
        uint256 totalCost = getMintPrice() * amount;
        require(msg.value >= totalCost, "Insufficient POL sent");

        payable(RECEIVER).transfer(msg.value);
        _mint(msg.sender, amount);
    }

    function ownerMint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    function getMintPrice() public view returns (uint256) {
        if (useDefaultPrice) {
            return defaultMintPrice;
        } else {
            try IUniswapV3Pool(uniswapPool).slot0() returns (
                uint160 sqrtPriceX96,
                int24,
                uint16,
                uint16,
                uint16,
                uint8,
                bool
            ) {
                uint256 priceX96 = uint256(sqrtPriceX96) * uint256(sqrtPriceX96);
                uint256 price = priceX96 / (2 ** 192);
                return price;
            } catch {
                return defaultMintPrice;
            }
        }
    }

    // ADMIN CONTROLS

    function setUseDefaultPrice(bool status) external onlyOwner {
        useDefaultPrice = status;
    }

    function setDefaultMintPrice(uint256 newPrice) external onlyOwner {
        defaultMintPrice = newPrice;
    }

    function setUniswapPool(address newPool) external onlyOwner {
        require(newPool != address(0), "Invalid pool address");
        uniswapPool = newPool;
    }

    function sweepERC20(address tokenAddress) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No ERC20 tokens to sweep");
        token.transfer(RECEIVER, balance);
    }

    function sweepERC721(address tokenAddress, uint256 tokenId) external onlyOwner {
        IERC721 token = IERC721(tokenAddress);
        require(token.ownerOf(tokenId) == address(this), "Contract does not own this token");
        token.safeTransferFrom(address(this), RECEIVER, tokenId);
    }
}
