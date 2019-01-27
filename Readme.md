
## Project Title: Marketplace
 
#### Section 1: Project summary:
This creates a decentralised marketplace where sellers can display products for sale and buyers can purchase products.

#### Section 2: Project description and use cases:
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


#### Section 3: Implementation - Smart Contracts:

###### Contracts folder: 
* **1** Migrations.sol: Truffle generated contract
* **2** Marketplace.sol : This is the main smart contract I've written as part of the final-project.
Marketplace.sol uses SafeMath contract library (open zeppelin), which is embedded into Marketplace.sol file.
###### Experimental folder:
* **1** ContractWithOraclize.sol (it uses imported usingOraclize.sol library): Smart contract to demonstrate oraclize feature. IT gets ETH/BTC exchange rate to enable buyers to pay through crypro.
* **2** marketplace.vy: Vyper contract for Sellers to auction their goods in marketplace. 

#### Section 4: Implementation - Front-end application:
Front-end application has been implemented in React. Following basic features have been implemented to demonstrate interoprability of front-end code with backend smart contract:
* **1)** Call made to smart contract to get role of contract creator on startup- The role is displayed on UI on start-up.
* **2)** Call made to smart contract to add Admin to marketplace. This call invokes send transaction to ethereum, and so triggers a confirmation box from metamask.
* **3)** Call made to smart contract to get role of Admin : The address and role of Admin added is displayed on screen.

#### Section 5: Other documents:
* **1: avoiding_common_attacks.md:** How common security attacks have been avaoided in my implementation of Marketplace solidity smart contract
* **2: design_pattern_decisions.md**: Lists the various design patterns adopted in the marketplace solidity smart contract.
* **3: deployed_addresses.txt**: Contains the address at which the marketplace smart contract has been deployed in Rinkeby test network. 
* **Note**: Those in experimental folder - Vyper and Oraclize smart contracts have not been deployed in Rinkeby and are written for experimental/demonstration purpose only.

#### Section 6: Prerequisites:
* **1** Install Ganache and metamask plug-in for browser.
* **2** Start Ganache on port 8545
* **3** Connect metamask to Ganache server at http://localhost:8545
* **4** Import atleast the first ganache account into Metamask (using private key import) and verify that the balance on metamask for the account is the same as that shown in ganache.


#### Section 7: How to set it up?
**Step 1:** Clone the repo to local machine:
* git clone https://github.com/PEshwar/Marketplace.git

**Step 2:**  Start up ganache (Gui or cli).
* Please ensure to configure your ganache to run on port 8545*

**Step 3:** Compile contracts
* truffle compile

**Step 4** Deploy contracts
* truffle migrate (or truffle migrate --reset 'if you get out of gas error')

**Step 5** Test contract 
* truffle test 
*note: 5 tests should pass*

**Step 6** 
* cd client 
* npm install 

**Step 7** 
* **npm run test**
* This will start up server and show that 1 test has passed. You can abort server with Ctrl-C.

**Step 8** 
* npm run start. 
* Go to http://localhost:3000 (if browser window does not automatically open). 
* Note: Ensure testing is done on browser where metamask plug=in is installed.

#### Section 8: How to test DApp?
* **Current Ethereum account**: On startup screen verify that the account schown  on screen is the same as the account selected on metamask. If metamask account selection is changed, the corresponding value should change in UI
* **Owner Details**: This would show the account from which contract was deployed. It defaults to first account in ganache. You will see the role for this account would be marked as **Owner**. (as per contract constructor logic)

* **Admin Details**: 
* You would see an input box to enter account of admin to add to marketplace. You can select any of the accounts from Ganache (except  the first one from which contract was deployed), and enter the value in input box, and press button 'Add as admin'. Ensure that before pressing the  ' Add as Admin' button, metamask account selected is the owner of the contract. (Otherwise error will be thrown).
* You should see metamask confirmation window popup, as this is a transaction to ethereum. Click 'Confirm' in the window.
* You should see a metamask popup saying transaction is confirmed, and the admin account you added will be shown on screen under **Admin details** with the role marked as 'Admin' 
* If you encounter error in this step, do one or all of the following:
    * refresh browser
    * select another ethereum network (eg mainnet or riknkeby) in metamask and switch it back to custom rpc(http://localhost:8545)
    * restart ganache, and redeploy contract with **truffle migrate --reset**
    * Restart the dev server (react)


#### Section 9: Intermittent errors/debugging tips:
* **1**: Sometime metamask does not show the confirmation window. This is intermittent issue with metamask.
* **2**: If while deploying contract (with truffle migrate) out of gas error is obtained, run truffle migrate --reset. Then also check blocklimit in your ganache configuration.
* **3**: If while running react app, metamask confirmation fails stating nonce does not match, then just change network id of ganache , restart ganache and reconnect metamask to ganache. And rerun truffle migrate and restart the client app.