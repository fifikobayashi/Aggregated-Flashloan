# Aggregated Flashloans

![](https://raw.githubusercontent.com/fifikobayashi/Aggregated-Flashloan/master/img/Kollateral.PNG)

## Overview

This is a working Truffle project you can build upon which draws on flash liquidity from multiple flash lenders within a single transaction. This template uses the [Kollateral](https://www.kollateral.co/) protocol which handles the aggregation of liquidity from multiple flash-loan-enabled pools such as [DyDx](https://docs.dydx.exchange/#introduction) and [Aave](https://aave.com/flash-loans).

Please note this template assumes prior experience with truffle development/deployment, dotenv usage, infura endpoints...etc If you're not familiar I highly recommend undertaking a corresponding tutorial beforehand, as most of the errors you encounter can be resolved with prior study.

## Setup

1. Clone the repo.
~~~
git clone https://github.com/fifikobayashi/Aggregated-Flashloan
cd Aggregated-Flashloan
~~~
2. Install the Kollateral solidity library.
~~~
npm install @kollateral/contracts
~~~
3. Install dotenv and hdwallet provider so you can hide your private key and Infura IDs within your own .env file.
~~~
npm install dotenv
npm install --save truffle-hdwallet-provider
~~~
4. Create a .env file in the root of your project folder.
~~~
touch .env
~~~
Then edit the .env file and add the following two lines, along with your Infura ID and private key (no quotes). 

***IMPORTANT*** Make sure you learn how to use .gitignore to exclude this .env file when publishing your code to github. There have been many incidents, as recently as last week where someone accidentally uploaded their env file containing their private keys onto Github and got their accounts emptied within minutes.
~~~
ROPSTEN_PROVIDER=https://ropsten.infura.io/v3/YOUR_INFURA_ID
ROPSTEN_PRTK=YOUR_PRIVATE_KEY
~~~

## Deployment
1. Compile the project
~~~
truffle compile
~~~
2. Deploy the project. (*note:* if you're on Node14 please see troubleshooting section below re: callback error)

Initial deployment:
~~~
truffle migrate --network ropsten
~~~

Subsequent deployments thereafter:
~~~
truffle migrate --network ropsten --reset
~~~
3. When deployment completes, take note of the contract address and send some Ether to it so it can cover the aggregation fee plus the native flash loan fees. See Fees below for more info.

## Execution
1. Pop into the ropsten console
~~~
truffle console --network ropsten
~~~
2. Execute the aggregated flash loan function by calling the invoke() function while in console mode:
~~~
AggregatedFlashloans.deployed().then(function(instance){return instance.invoke()});
~~~
3. A successful execution of this code looks like [this in console](https://raw.githubusercontent.com/fifikobayashi/Aggregated-Flashloan/master/img/truffledeploymentsuccess.PNG) and [like this on Etherscan](https://ropsten.etherscan.io/tx/0xea618ad3f036ce8be01ac72b7693102333839c78c002127fb9fe36223a47e052).
4. Once you're done playing with this, while still in console mode, you can withdraw the ether from the contract by calling:
~~~
AggregatedFlashloans.deployed().then(function(instance){return instance.WithdrawBalance()});
~~~


## Fees

Kollateral currently charges 6bps on the flash liquidity that is sourced. In addition, you also need to factor in the native fees from each pool you aggregate from, such as Aave's 9bps flash fee and DyDx's 3 wei.
If there is not enough funds on the contract to repay the loan + fees then the TX will be reverted.

## Trouble shooting
* If you keep getting a *Callback was already called* error when deploying contracts via Truffle/Infura/Node14, it's because ganache-cli's internal core is not yet node v14 compatible, so just use 'truffle migrate --network ropsten --skipDryRun'.
* Failed Tx with *ExternalCaller: insufficient ether balance* - this means you forgot to send some ether to this contract to cover the aggregation and flash loan fees. 
* Failed Tx with *Invoker: not enough liquidity* - this means you're asking for too much liquidity than the aggregate pools can handle at this point in time, particularly prevalent in testnets with limited liquidity. Reduce your flash amount.

<br /><br />
If you found this useful and would like to send me some gas money: 
```
0xef03254aBC88C81Cb822b5E4DCDf22D55645bCe6
```
Thanks, @fifikobayashi.
