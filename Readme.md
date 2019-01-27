
## Project Title: Marketplace
 
#### Project summary:
This creates a decentralised marketplace where sellers can display products for sale and buyers can purchase products.

#### Project description and use cases:
##### User roles: 
* Owner 
* Admin
* StoreOwner
* User

##### Use cases:

* **Owner**: Owner can add and delete Admins for this marketplace
* **Admin**: Admins can add and delete store owners in marketplace
* **StoreOwner**: Store Owners can create and remove stores, add and remove products from an individual store and withdraw their sales proceeds.
* **End User**: User can buy purchase one or more products from a store.
* 

####Implementation - Smart Contracts:
##### List of smart contract files and description: 
###### Contracts folder: 
**1** Migrations.sol: Truffle generated contract
**2** Marketplace.sol : This is the main smart contract I've written as part of the final-project.
Marketplace.sol uses SafeMath contract library (open zeppelin), which is embedded into Marketplace.sol file.
###### Experimental folder:
**1** ContractWithOraclize.sol (it uses imported usingOraclize.sol library): Smart contract to demonstrate oraclize feature. IT gets ETH/BTC exchange rate to enable buyers to pay through crypro.
**2** marketplace.vy: Vyper contract for Sellers to auction their goods in marketplace. 

####Implementation - Front-end application:
Front-end application has been implemented in React. Following basic features have been implemented to demonstrate interoprability of front-end code with backend smart contract:
**1)** Call made to smart contract to get role of contract creator on startup- The role is displayed on UI on start-up.
**2)** Call made to smart contract to add Admin to marketplace. This call invokes send transaction to ethereum, and so triggers a confirmation box from metamask.
**3)** Call made to smart contract to get role of Admin : The address and role of Admin added is displayed on screen.

##### Other documents:
**1: avoiding_common_attacks.md:** How common security attacks have been avaoided in my implementation of Marketplace solidity smart contract
**2: design_pattern_decisions.md**: Lists the various design patterns adopted in the marketplace solidity smart contract.
**3: deployed_addresses.txt**: Contains the address at which the marketplace smart contract has been deployed in Rinkeby test network. 
Note: Those in experimental folder - Vyper and Oraclize smart contracts have not been deployed in Rinkeby and are written for experimental/demonstration purpose only.

##### Prerequisites:
**1** Start Ganache on port 8545
**2** Connect metamask to Ganache server at htt://localhost:8545


##### How to set it up?
**Step 1:** Clone the repo to local machine:
git clone https://github.com/PEshwar/Marketplace.git

**Step 2:**  Start up ganache (Gui or cli).
*This should successfully migrate contracts to a locally running ganache-cli test blockchain on port 8545. Please ensure to configure your ganache to run on port 8545*

**Step 3:** Compile contracts
truffle compile

**Step 4** Deploy contracts
truffle migrate (or truffle migrate --reset 'if you get out of gas error')

**Step 5** Test contract 
truffle test 
*note: 5 tests should pass*

**Step 6** cd client

**Step 7** npm run test

**Step 8** npm run start. Go to http://localhost:3000


###### Intermittent errors/debugging tips:
**1**: Sometime metamask does not show the confirmation window. This is intermittent issue with metamask.
**2**: If while deploying contract (with truffle migrate) out of gas error is obtained, run truffle migrate --reset. Then also check blocklimit in your ganache configuration.
**3**: If while running react app, metamask confirmation fails stating nonce does not match, then just change network id of ganache , restart ganache and reconnect metamask to ganache. And rerun truffle migrate and restart the client app.