const path = require("path");
var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "cat elephant material eight wash fee property because early bag feature hole";
var tokenKey = "5aab509bdcff4a4d92719c77711919a0";
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
     development: {
      host: "localhost",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
     // gas: 8500000,           // Gas sent with each transaction (default: ~6700000)

      network_id: "*",       // Any network (default: none)
     },
     rinkeby:{
      host: "localhost",
      provider: function() {
        return new HDWalletProvider( mnemonic, "https://rinkeby.infura.io/v3/" + tokenKey);
      },
      network_id:4
      , gas : 6700000
      , gasPrice : 10000000000
   //   , from :"0xB0f997238155e9fc1F2d5Dc97AAE991ef3270A5f"
   //   ,
    },     
  },

};
