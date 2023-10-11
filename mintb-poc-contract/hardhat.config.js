require("@nomiclabs/hardhat-waffle");

module.exports = {
  networks: {
    bsctestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      chainId: 97,
      gasPrice: 10000000000,
      accounts: ['']
    }
  },
  solidity: "0.8.20",
};