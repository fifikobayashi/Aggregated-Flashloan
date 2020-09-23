require('dotenv').config();
var HDWalletProvider = require("truffle-hdwallet-provider");
module.exports = {
     networks: {
       development: {
         host: "127.0.0.1",
         port: 7545,
         network_id: "7775"
       },
       ropsten: {
         provider: function() {
           return new HDWalletProvider(process.env.ROPSTEN_PRTK, process.env.ROPSTEN_PROVIDER)
         },
         network_id: 3,
         gas: 4000000      //make sure this gas allocation isn't over 4M, which is the max
      }
    }
};
