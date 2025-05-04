## Oracle of Delphi Token (ODEL) — Specification

### Purpose

ODEL is a utility token that functions as a **ticket**, **access credential**, or **proof-of-mint**. It is not a store of value, medium of exchange, or governance token. It exists solely to represent a permissioned or observable event: *someone minted a unit at a particular time*.

There is **no supply cap**, no transfer of funds into the contract, and no mechanism of payment enforced by the contract.

---

### Token Characteristics

* **Name**: Oracle of Delphi Token
* **Symbol**: ODEL
* **Decimals**: 0 (non-fractional units)
* **ERC-20 Standard**: Yes
* **Network**: Polygon-compatible (EVM)

---

### Functional Behavior

#### Minting

* **Function**: `mint(uint256 amount)`
* **Access**: Public
* **Effect**: Mints any quantity of ODEL to the caller.
* **Pricing**: A "mint price" is computed per token using one of two sources:

  * **Dynamic** (live on-chain price using Uniswap V3)
  * **Default** (fixed fallback price, e.g., 2 POL)
* **Note**: The price is **not enforced**. It is calculated, exposed via `getMintPrice()`, and intended for off-chain consumption (e.g., frontends, logging systems, analytics).

#### Owner Mint

* **Function**: `ownerMint(address to, uint256 amount)`
* **Access**: Contract owner only
* **Effect**: Mints tokens to any address

#### Burning

* **Function**: `burn(address from, uint256 amount)`
* **Access**: Contract owner only
* **Effect**: Burns tokens from any address without approval

#### Pricing

* **Function**: `getMintPrice()`
* **Purpose**: Computes the current reference price of one ODEL token which is currently the price of 2 pol
* **Implementation**:

  * If `useDefaultPrice == true`: returns the `defaultMintPrice` (e.g., 2e18)
  * Else: reads Uniswap V3 pool `slot0()` and computes price via `sqrtPriceX96^2 / 2^192`  (this should allow me to change the pricing by changing the pool it's pointed at. but we also need a modifier since we are specifying 2 pol.... so if it's .00001 btc, I want that flexibility
  * If the call fails (e.g. pool is broken): falls back to `defaultMintPrice`

#### Administration

* **Owner-only Functions**:

  * `setUniswapPool(address)` — Set or update the pricing oracle source
  * `setUseDefaultPrice(bool)` — Toggle between oracle pricing and fallback
  * `setDefaultMintPrice(uint256)` — Set the fallback price manually

#### ETH Handling

* ETH sent to the contract is rejected:

  * `receive()` and `fallback()` both revert.

---

### Economic Model

There is **no enforced payment model**, treasury logic, or token-based gating mechanism built into the smart contract. Instead:

* Users mint as many tokens as they want
* Pricing is 2 pol to mint 100... that's what I want... but why are you forcing me to take pol... I don't want to only take pol I want the equivelent of two pol
* Off-chain systems are expected to observe, analyze, or gate behavior based on mint counts or price reference
* The contract maintains no internal balances and cannot be drained or exploited financially.  Yes NO MONEY ON CONTRACT ALL MONEY GOES TO THE OWNER

---

### Summary

ODEL is a mint-tracked, price-referenced, owner-controlled ERC-20 credential. It enforces no monetary rules, no scarcity, and no treasury. It is an open, trackable record of mint activity, optionally priced according to market conditions but freely issued.
