## Document Title: Design pattern decisions
 
#### Design patterns:
This project uses the following design patterns:
* **Withdrawal from contracts** : This is also called the withdrwaal pattern where funds are sent to another contracts/address  only after the effects (eg reduction of contract balances) are made in calling contract. In this project, withdrawal pattern is used where the store owner can call a function to withdraw his funds (from sales proceeds) rather than the contract sending (or 'pushing') the funds to the store owner.
* **Restricting access** : Restricting who can make changes to contract state (or which parts of contract state). Every function in this contract whic modifies state has restricted access. For example, only the owner of contract can create and remove admins. Only Admin roles can create and delete store owners. Only the store owners can create and remove stores, and create and remove products from indivifdual stores. Also, only store owners can withdraw their own fund balances.
*  **Contract self-destruction** : There is a  function in contract to self-destruct contract and tranfer any outstanding balances on contract back to owner of contract. This can be used in situations where the contract code needs to be decommissioned.
* **Circuit breaker:**  Implemented circuit breaker to stop all operations of market place in case of emergencies. See function contractPaused in Marketplace.sol

#### Patterns not used: 
* **State Machine:** Did not find it particularly suitable for this contract.
* **Commit/Reveal:** The commit/reveal design pattern is best used when a user’s actions or choices might influence another user’s actions or choices, such as a vote, or a move in a game. Not suitable for marketplace contract.
* **Speed bumps/action throttling:** This design pattern can be used to throttle user actions. But did not find any benefit of this pattern for marketplace contract. 

### Miscellaneous
marketplace.vy is a contract for Storeowners to conduct auctions o their products, where buyers can bid on them, and product is sold to highest bidder.