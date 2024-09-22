# Foundry Fund Me

- [Getting Started](#getting-started)
  - [Requirements](#requirements)
- [Usage](#usage)
  - [Deploy](#deploy)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
- [Deployment to a testnet or mainnet](#deployment-to-a-testnet-or-mainnet)
  - [Scripts](#scripts)
    - [Withdraw](#withdraw)
  - [Estimate gas](#estimate-gas)
- [Formatting](#formatting)
- [Additional Info:](#additional-info)

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

# Usage

## Deploy

```[bash]
forge script script/DeployFundMe.s.sol
```

## Testing

We talk about 4 test tiers in the video.

1. Unit
2. Integration
3. Forked
4. Staging

This repo covers #1 and #3.

```[bash]
forge test
```

or

```[bash]
forge test --match-test testFunctionName
```

or

```[bash]
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```[bash]
forge coverage
```

# Deployment to a testnet or mainnet

1. Setup environment variables

You'll want to set your `SEPOLIA_RPC_URL` as an environment variable. You can add it to a `.env` file, similar to what you see in `.env.example`.

- `SEPOLIA_RPC_URL`: This is the URL of the Sepolia testnet node you're working with. You can get set up with one for free from [Alchemy](https://alchemy.com/?a=673c802981).

Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

2. Import and set up your account using **cast wallet**:
   Instead of using private keys in plain text, you can securely manage accounts with **cast wallet**.

   First, import your private key securely using:

```[bash]
cast wallet import defaultKey --interactive
cast wallet list
```

Once imported, you can use your account safely in any script.

3. Get testnet ETH

Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH. You should see the ETH show up in your wallet.

4. Deploy

```[bash]
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --account defaultKey --sender $SENDER --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvv
```

## Scripts

After deploying to a testnet or local net, you can run the scripts.

Using **cast** with a locally deployed contract example:

```[bash]
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --account defaultKey
```

or

```[bash]
forge install Cyfrin/foundry-devops --no-commit
forge script script/Interactions.s.sol --rpc-url $SEPOLIA_RPC_URL --account defaultKey --sender $SENDER --broadcast -vvvv
```

### Withdraw

```[bash]
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()" --account defaultKey
```

## Estimate gas

You can estimate how much gas things cost by running:

```[bash]
forge snapshot

```

And you'll see an output file called `.gas-snapshot`.

# Formatting

To run code formatting:

```[bash]
forge fmt
```

# Additional Info:

Chainlink-brownie-contracts is an official repo. The repository is owned and maintained by the Chainlink team for this very purpose and receives releases from the proper Chainlink release process. You can see it's still the `smartcontractkit` organization as well.

https://github.com/smartcontractkit/chainlink-brownie-contracts
