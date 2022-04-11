# Layer v2-1 Contract Documentation

# Minting

## Private functions

---

### `mint`

```
(mint (all-token-data {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}))
```

### Description

The most fundamental `mint` function. Takes in a tuple `all-token-data` that contains all necesarry information for minting. The function calculates royalties, populates the relevant data maps, and mints the token to the `minter` principal with `token-id` token ID. All other `mint` functions call this one.

### Parameters

- `all-token-data`: tuple:
  - `token-id`: uint
  - `minter`: principal
  - `metadata`: string-ascii 256
  - `data`: tuple:
    - `price`: uint
    - `for-sale`: bool
  - `royalties`: optional list of up to 5 royalty tuples:
    - `address`: principal
    - `percentage`: uint

### Returns

- On success: `token-id`
- On error: `error-id`

---

### `mint-transfer`

```
(mint-transfer (file {all-token-data: {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}, recipient: principal}))
```

### Description

Mints and immediately tranfsers NFT. Accepts `all-token-data` tuple and calls the `mint` function. Upon successful mint transfers NFT to `recipient`.

### Parameters

- `file`: tuple:
  - `all-token-data`: tuple (see `mint` params)
  - `recipient`: principal

### Returns

- On success: `token-id`
- On error: `error-id`

---

### `mint-pay`

```
(mint-pay (file {all-token-data: {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}, buyer: principal}))
```

### Description

Mints and immediately executes the purchase flow. Accepts `all-token-data` tuple and calls the `mint` function. Upon successful mint executes `pay-transfer` flow which transfers STX from admin to `minter` argument and transfers the minted NFT from `minter` to `buyer`. (Note `pay-transfer` function automatically changes `for-sale` bool in `token-data` map to `false`)

### Parameters

- `file`: tuple:
  - `all-token-data`: tuple (see `mint` params)
  - `buyer`: principal

### Returns

- On success: `token-id`
- On error: `error-id`

---

### `mint-admin`

```
(mint-admin (file {all-token-data: {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}, post-mint: (optional {recipient: principal, is-purchase: bool})}))
```

### Description

Function that depending on the arguments will call one of `mint`, `mint-transfer`, or `mint-pay` functions. Information about the NFT is supplied by the `all-token-data` argument. `post-mint` argument provides information about which minting flow to execute:

- No `post-mint` tuple (`none` provided in argument) will **only mint** NFT by invoking the `mint` function.
- `post-mint` provided, with `is-purchase` set to `false` will invoke the `mint-transfer` flow.
- `post-mint` provided, with `is-purchase` set to `true` will invoke the `mint-pay` flow.

### Parameters

- `file`: tuple:
  - `all-token-data`: tuple (see `mint` params)
  - `post-mint`: optional tuple:
    - `recipient`: principal
    - `is-purchase`: bool

### Returns

- On success: `token-id`
- On error: `error-id`

---

### `mint-edition`

```
(mint-edition (token-id uint) (all-token-data (response {minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))} uint)))
```

### Description

Essentially just mints the NFT, same as `mint` function, but tailored for `mint-editions` flow. For more info see `mint-editions` function descripiton.

### Parameters

- `token-id`: uint
- `all-token-data`: response tuple (see `mint` params) uint

### Returns

- On success: `token-id`
- On error: `error-id`

---

## Public functions

---

### `mint-many`

```
(mint-many (files (list 500 {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))})))
```

### Description

Callable only by admin. Takes a list of up to 500 `all-token-data` tuples and attempts to mint each one. Returns a list of responses corresponding to each `mint` function invokation to provide info on whether a particular attempt to mint failed or was successful.

### Parameters

- `files`: list of up to 500 tuples:
  - Tuple corresponds to params of the `mint` function. See `all-token-data` tuple description in `mint` function params.

### Returns

List of responses from each `mint` call. Successful mints return (ok `token-id`). Failed mints return (err `error-id`).

---

### `mint-transfer-many`

```
(mint-transfer-many (files (list 500 {all-token-data: {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}, recipient: principal})))
```

### Description

Callable only by admin. Same as `mint-many` function but invokes `mint-transfer` function for each tuple in the list.

### Parameters

- `files`: list of up to 500 tuples:
  - Tuple corresponds to params of the `mint-transfer` function.

### Returns

List of responses from each `mint-transfer` call. Successful mints return (ok `token-id`). Failed mints return (err `error-id`).

---

### `mint-pay-many`

```
(mint-pay-many (files (list 500 {all-token-data: {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}, buyer: principal})))
```

### Description

Callable only by admin. Same as `mint-many` function but invokes `mint-pay` function for each tuple in the list.

### Parameters

- `files`: list of up to 500 tuples:
  - Tuple corresponds to params of the `mint-pay` function.

### Returns

List of responses from each `mint-pay` call. Successful mints return (ok `token-id`). Failed mints return (err `error-id`).

---

### `mint-admin-many`

```
(mint-admin-many (files (list 500 {all-token-data: {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}, post-mint: (optional {recipient: principal, is-purchase: bool})})))
```

### Description

Callable only by admin. Same as `mint-many` function but invokes `mint-admin` function for each tuple in the list.

### Parameters

- `files`: list of up to 500 tuples:
  - Tuple corresponds to params of the `mint-admin` function.

### Returns

List of responses from each `mint-admin` call. Successful mints return (ok `token-id`). Failed mints return (err `error-id`).

---

### `mint-editions`

```
(mint-editions (edition-ids (list 10000 uint)) (all-token-data {minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}))
```

### Description

Callable only by admin. Accepts a list of up to 10000 token IDs and one `all-token-data` tuple. For each token ID the function will mint a new NFT with data supplied by `all-token-data` tuple.

### Parameters

- `edition-ids`: list of up to 10000 uint:
- `all-token-data`: tuple (see `mint` params)

### Returns

List of responses from each `mint-edition` call. Successful mints return (ok `token-id`). Failed mints return (err `error-id`).

---

---

# Sales, purchases, and transfers

## Private functions

---

### `pay`

```
(pay (token-id uint) (token-price uint) (token-owner principal))
```

### Description

Internal function that retrieves royalties and owner's share from contract maps and pays those percentages out from tx-sender based on the token price supplied in the argument. Owner percentage is paid out to the provided `token-owner` argument.

### Parameters

- `token-id`: uint
- `token-price`: uint
- `token-owner`: principal

### Returns

- On success: `token-id`
- On error: `error-id`

---

### `pay-transfer`

```
(pay-transfer (token-id uint) (token-price uint) (token-owner principal) (token-recipient principal))
```

### Description

Internal function that transfers an NFT from `tx-sender` to `token-recipient` and then invokes the `pay` internal function.

### Parameters

- `token-id`: uint
- `token-price`: uint
- `token-owner`: principal
- `token-recipient`: principal

### Returns

- On success: `token-id`
- On error: `error-id`

---

### `complete-sale`

```
(complete-sale (sale-datum {token-id: uint, token-owner: principal, token-recipient: (optional principal), token-price: uint}))
```

### Description

Internal function that completes a sale. If no `token-recipient` argument is supplied then it executes the `pay` function. If one is supplied, then `pay-transfer` is executed.

### Parameters

- `sale-datum`: tuple:
  - `token-id`: uint
  - `token-owner`: principal
  - `token-recipient`: optional principal
  - `token-price`: uint

### Returns

- On success: `token-id`
- On error: `error-id`

---

## Public functions

---

### `complete-sale-many`

```
(complete-sale-many (sale-data (list 500 {token-id: uint, token-owner: principal, token-recipient: (optional principal), token-price: uint})))
```

### Description

Callable only by admin. Accepts a list of up to 500 `sale-datum` arguments and calls the `complete-sale` function for each one and returns a list of call responses.

### Parameters

- `sale-data`: list 500 tuples:
  - Tuple corresponds to params of the `complete-sale` function.

### Returns

List of responses from each `complete-sale` call. Successful calls return (ok `token-id`). Failed mints return (err `error-id`)

---

### `purchase`

```
(purchase (token-id uint))
```

### Description

Executes the purchase flow if the token specified to `token-id` is set as `for-sale`. Tx-sender pays token-owner and royalties and in turn receives the NFT associated to the `token-id`. Note: all successful purchases automatically set `for-sale` to `false`.

### Parameters

- `token-id`: uint

### Returns

- On success: `true`
- On error: `error-id`

---

### `lock-stx-in-escrow`

```
(lock-stx-in-escrow (token-id uint) (price uint) (memo (string-ascii 100)))
```

### Description

Funciton necessary for completing STX purchases for lazy-minted NFTs. Transfers `price` amount from tx-sender to admin. This will in turn trigger the `mint-pay` flow in heylayer's backend which is called by admin.

### Parameters

- `token-id`: uint
- `price`: uint
- `memo`: string-ascii 100

### Returns

- On success: `token-id`
- On error: `error-id`

---

### `transfer`

```
(transfer (token-id uint) (owner principal) (recipient principal))
```

### Description

SIP-009 function that will transfer `token-id` from `owner` to `recipient`. Only executes if `tx-sender` is equal to `owner` argument and is the owner returned by the internal `nft-get-owner?` function. Note: successful transfers automatically set `for-sale` to `false`.

### Parameters

- `token-id`: uint
- `owner`: principal
- `recipient`: principal

### Returns

- On success: `true`
- On error: `error-id`

---

### `transfer-many`

```
(transfer-many (transfer-data (list 500 {token-id: uint, recipient: principal})))
```

### Description

Accepts a list of up to 500 tuples and calls the `transfer` function for each one and returns a list of call responses. Useful for transferring multiple NFTs in one call. `owner` argument that is eventually passed to the `transfer` function is always `tx-sender`.

### Parameters

- `transfer-data`: list of 500 tuples:
  - `token-id`: uint
  - `recipient`: principal
    Note: params don't directly correspond to the `transfer` function because of the format specified in SIP-009, so an internal helper function `transfer-many-helper` desctructures the tuple to `transfer` function compliant arguments.

### Returns

List of responses from each `transfer` call. Successful calls return (ok `true`). Failed mints return (err `error-id`)

---

### `set-token-price-data`

```
(set-token-price-data (token-id uint) (price uint) (for-sale bool))
```

### Description

Only callable by token-owner. Populates the `token-data` map entry associated with `token-id` with the provided `price` and `for-sale` params.

### Parameters

- `token-id`: uint
- `price`: uint
- `for-sale`: bool

### Returns

- On success: `true`
- On error: `error-id`

---

---

# Heylayer admin functions

---

### `transfer-stx`

```
(transfer-stx (transfer-datum {amount: uint, recipient: principal, memo: (optional (string-ascii 100))}))
```

### Description

Transfers STX worth `amount` from `tx-sender` to `recipient` and prints the optional `memo` arg.

### Parameters

- `transfer-datum`: tuple
  - `amount`: uint
  - `recipient`: principal
  - `memo`: optional string-ascii 100

### Returns

- On success: `amount`
- On error: `error-id`

---

### `transfer-stx-many`

```
(transfer-stx-many (transfer-data (list 500 {amount: uint, recipient: principal, memo: (optional (string-ascii 100))})))
```

### Description

Wrapper function that does multiple `transfer-stx` invocations in one call.

### Parameters

- `transfer-data`: list of up to 500 `trasnfer-datum` tuples
  - Tuples correspond to params of the `transfer-stx` function.

### Returns

List of responses from each `transfer-stx` call. Successful calls return (ok `amount`). Failed mints return (err `error-id`)

---

### `delete-token`

```
(delete-token (token-id uint))
```

### Description

Only callable by admin. If admin is owner of the NFT the the token gets deleted and all of its associated map entries are erased.

### Parameters

- `token-id`: uint

### Returns

- On success: `token-id`
- On error: `error-id`

---

### `delete-token-many`

```
(delete-token-many (token-ids (list 500 uint)))
```

### Description

Wrapper function that does multiple `delete-token` invocations in one call.

### Parameters

- `token-ids`: list of up to 500 uints

### Returns

List of responses from each `delete-token` call. Successful calls return (ok `token-id`). Failed mints return (err `error-id`)

---

```
(change-admin (new-admin principal))
```

```
(set-admin-fee (fee uint))
```

```
(validate-auth (challenge-token (string-ascii 500))) (ok true))
```
