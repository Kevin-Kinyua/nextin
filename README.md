# NextIn Network NFT Sale Contract

This repository contains the smart contract code for managing the sale of NextIn Network NFTs.

## Overview

The NextIn Network NFT Sale Contract allows for the sale of various NFT categories to users who wish to participate in the NextIn Network ecosystem. The contract supports the sale of seven different categories of NFTs, each with unique attributes, rewards, and benefits.

## Features

- **Sale Management**: The contract allows for the management of the sale process, including setting start and end times, sale price, and controlling the availability of tokens.
- **Purchase**: Users can purchase NFTs using different payment methods (USDT, ETH, BNB, etc.) during the sale period.
- **Minting and Burning**: The contract owner can mint additional tokens for any category or burn existing tokens as needed.
- **Royalty Payments**: Original NFT owners receive a royalty percentage when their NFTs are sold in any secondary market.
- **Owner Controls**: The contract owner has full control over the contract, including withdrawing funds, stopping/resuming the sale, setting metadata, and more.
- **Flexibility**: The contract is designed to provide flexibility in managing the sale process and adjusting parameters according to project requirements.

## Usage

1. **Deployment**: Deploy the contract on the Ethereum network of your choice.
2. **Configuration**: Customize contract parameters such as sale start/end times, sale price, token metadata, etc.
3. **Sale Management**: Start the sale, manage token availability, and stop the sale when necessary.
4. **Token Purchases**: Users can purchase NFTs during the sale period by sending the specified payment amount to the contract address.
5. **Reward Distribution**: Owners can distribute rewards and benefits to NFT holders based on predefined conditions and terms.
6. **Data Collection**: Collect information about NFT buyers to fulfill promised benefits and rewards.

## Security Considerations

- **Auditing**: Conduct a thorough security audit of the contract code to identify and mitigate potential vulnerabilities.
- **Testing**: Test the contract extensively on testnets before deploying it on the Ethereum mainnet.
- **Access Control**: Ensure that only authorized users have access to critical functions and owner privileges.
- **Secure Payments**: Implement secure payment processing mechanisms to prevent unauthorized access and ensure the safety of user funds.

## License

This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [OpenZeppelin](https://openzeppelin.com/): For providing audited and battle-tested smart contract libraries.
- Ethereum Community: For contributing to the development and adoption of decentralized technologies.


##  HARDHAT Functionality

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
