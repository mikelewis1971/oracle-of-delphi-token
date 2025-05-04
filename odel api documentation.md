---

# Oracle of Delphi Token (ODEL) — API Reference

## Overview

The **Oracle of Delphi Token (ODEL)** is a minimal, transferable, and permissionless ERC-20 token on the Polygon network. It is designed to serve as an access token for oracle services. ODEL has:

* Fixed minting cost (default or pool-based)
* Zero decimals (indivisible)
* Transferability
* Owner-only burning rights
* Owner sweep of accidentally sent ERC-20/721 tokens

---

## Deployment

* **Contract address:** `0x8F5891c464b16BA388b360278f32C912a93d1787`
* **Network:** Polygon (POL)
* **Owner:** `0x0F6dbb5B71372aB1d77Ed67D1260083cF9f07476`

---

## Core Properties

| Property           | Type      | Description                                 |
| ------------------ | --------- | ------------------------------------------- |
| `RECEIVER`         | `address` | Hardcoded POL receiver (owner address)      |
| `useDefaultPrice`  | `bool`    | Toggle to switch between pool/default price |
| `defaultMintPrice` | `uint256` | Manual fallback mint price (in wei)         |
| `POL_UNISWAP_POOL` | `address` | Current Uniswap V3 pool used for pricing    |

---

## External Functions

### `mint(uint256 amount)`

Mints the specified number of ODEL tokens.

* **Payable:** Yes (must send correct amount of POL)
* **Validation:**

  * Must send `amount × getMintPrice()` in `msg.value`
* **Access:** Public

### `ownerMint(address to, uint256 amount)`

Mints tokens to any address without payment.

* **Access:** `onlyOwner`

### `burn(address from, uint256 amount)`

Burns tokens from the specified address.

* **Access:** `onlyOwner`

### `getMintPrice() → uint256`

Returns the current mint price based on:

* Uniswap V3 price if `useDefaultPrice == false`
* Otherwise, returns `defaultMintPrice`
* **Access:** Public, view-only

---

## Owner Controls

### `setUseDefaultPrice(bool status)`

Toggles the mint pricing source.

* **Access:** `onlyOwner`

### `setDefaultMintPrice(uint256 newPrice)`

Updates the fallback price in wei.

* **Access:** `onlyOwner`

### `setUniswapPool(address newPool)`

Changes the Uniswap pool used for live pricing.

* **Access:** `onlyOwner`

---

## Token Sweep Functions

### `sweepERC20(address tokenAddress)`

Sends any accidentally received ERC-20 tokens to the owner wallet.

* **Access:** `onlyOwner`

### `sweepERC721(address tokenAddress, uint256 tokenId)`

Sends accidentally received NFTs to the owner wallet.

* **Access:** `onlyOwner`

---

## ERC-20 Compatibility

Fully inherits from OpenZeppelin `ERC20`, providing:

* `transfer`
* `transferFrom`
* `approve`
* `allowance`
* `balanceOf`
* `totalSupply`

---

## Notes

* Tokens are indivisible (`decimals() = 0`).
* Only the owner can burn tokens.
* Contract is non-upgradable.
* No tokens are held in the contract; all POL is forwarded to the owner.
