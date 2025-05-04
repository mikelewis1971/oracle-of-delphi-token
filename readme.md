
##![odel token sml](https://github.com/user-attachments/assets/224ff27c-f9dc-420b-99bf-d4a3e38cf90a)
 📜 Oracle of Delphi Token (ODEL)

**"The token that knows its worth."**

---

### 🧠 Overview

`ODEL` is a minimalist yet powerful ERC-20 token deployed on **Polygon (POL)**. Designed for transparency and price awareness, ODEL uses **real-time Uniswap V3 pricing** to dynamically adjust its mint price. If oracle pricing fails, it defaults to a fixed, owner-controlled fallback.

This is not a hype coin. It’s an economic experiment in **open minting**, **owner-governed burning**, and **fully external pricing logic** — with no treasury, no vault, and no tokens held by the contract itself.

---

### ⚙️ Contract Details

| Property       | Value                                                                                                                      |
| -------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Name           | Oracle of Delphi Token                                                                                                     |
| Symbol         | `ODEL`                                                                                                                     |
| Decimals       | `0` (non-divisible; one token = one ticket)                                                                                |
| Deployed On    | Polygon                                                                                                                    |
| Token Contract | [`0x8F5891c464b16BA388b360278f32C912a93d1787`](https://polygonscan.com/address/0x8F5891c464b16BA388b360278f32C912a93d1787) |
| Owner Address  | `0x0F6dbb5B71372aB1d77Ed67D1260083cF9f07476` (hardcoded in contract)                                                       |
| Pricing Source | 20000000000000000  For real... That's the price... and that's only 2/100th of a pol...                                     |

---

Special Note: These are expensive to mint and much cheaper to buy on my contract after the Oracle has been cast.  

You mint for 20000000000000000 and you get your oracle and can buy the same coin right back for 50% off. 
20000000000000000 to mint ----->  10000000000000000 to buy 


### 💰 Minting Logic

* **Anyone can mint.**
* The token price is set based on:

  * Real-time Uniswap V3 pricing (if enabled), OR
  * A default price (set initially to **2 POL**).
* Payment is made in native POL.
* Funds are **immediately forwarded** to the owner address — nothing stays on the contract.

#### Example:

```solidity
mint(3);
// If POL price is $0.25 and default mint price is 2 POL,
// user sends 3 * 2 POL = 6 POL.
```

---

### 🔥 Burning Logic

* Only the **owner** can burn tokens.
* Burning reduces the total supply.
* There is **no public burn function** — supply control rests with the creator.

---

### 🔄 Transfer Logic

ODEL is a fully standard ERC-20 token:

* Can be transferred by users who hold it.
* Can be used in wallets, markets, or DApps that accept standard ERC-20 tokens.
* Minted tokens are **owned by the minter** with no restrictions or time locks.

---

### 🧼 Sweep Functions

To prevent accidental fund losses:

* **`sweepERC20()`**: Transfers any ERC-20 sent to the contract back to the owner.
* **`sweepERC721()`**: Transfers any ERC-721 NFT back to the owner.
* Only callable by the owner.

---

### 🧠 Oracle Pricing Logic

Currently the Pricing is set at approxiately 2/100th's of a Polygon Pol.  You pay
gas fees on Polygon anyway so this makes it convenient. Anyone who forks this can
set the pricing to any pool or fraction of a pool if you are using usdc.

ODEL reads from a Uniswap V3 POL/USDC pool to calculate mint price:

```solidity
price = (sqrtPriceX96)^2 / 2^192;
```

If the oracle fails (e.g., empty pool, unavailable), it falls back to the default price.

Owner can:

* Toggle between **oracle-based pricing** and **default fallback**.
* Change the fallback mint price.
* Change the Uniswap pool address (to e.g., POL/DAI, POL/USDT).

---

### 🧪 Functions Summary

| Function                                 | Description                                       |
| ---------------------------------------- | ------------------------------------------------- |
| `mint(uint256 amount)`                   | Mints tokens based on current pricing (POL only). |
| `ownerMint(address to, uint256 amount)`  | Mints any amount to any address (owner only).     |
| `burn(address from, uint256 amount)`     | Burns any user’s tokens (owner only).             |
| `setUseDefaultPrice(bool)`               | Toggles between oracle pricing and static price.  |
| `setDefaultMintPrice(uint256)`           | Updates the fallback price.                       |
| `setUniswapPool(address)`                | Changes the pool used for oracle pricing.         |
| `sweepERC20(address token)`              | Withdraws any ERC-20 sent to the contract.        |
| `sweepERC721(address token, uint256 id)` | Withdraws any ERC-721 NFT.                        |

---

### 🧩 Use Cases

* **Ticketing**: Each ODEL token can represent a seat, entry, or access slot.
* **Signal token**: The price oracle can reflect market interest in POL-based economies.
* **NFT pairing**: Combine with metadata to reflect tiers, entry rights, or mint access.
* **Open economic experiments**: Allow users to mint at market-based costs without treasury risk.

---

### ❌ What ODEL Is *Not*

* Not backed by any DAO, treasury, or protocol.
* No rebasing, staking, reflections, or emissions.
* No airdrops, sales, or premines.
* Not deflationary or inflationary — it's just a fixed-function economic printer.

---

### 🧱 Solidity Stack

* Solidity `^0.8.29`
* OpenZeppelin:

  * `ERC20.sol`
  * `Ownable.sol`
  * `IERC20.sol`, `IERC721.sol`

---

### ✅ Auditability & Simplicity

* All addresses (owner, receiver, oracle pool) are **hardcoded** in the contract.
* Nothing is upgradeable. Nothing is obfuscated.
* All ETH/POL is swept to the owner immediately — the contract **never holds assets**.

---

### 📂 Repo Structure

```bash
oracle-of-delphi-token/
│
├── contracts/
│   └── OracleTokenSimple.sol
│
├── metadata/
│   ├── tokenlist.json
│   └── logo.png
│
├── docs/
│   └── api.md
├── README.md
└── LICENSE
```

---

