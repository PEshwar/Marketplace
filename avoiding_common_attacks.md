## List of common attacks avoided: 
* **Re-entrancy:** In Withdraw Balance function, the balance of store owner is zeroed before the transfer function is called. This is to prevent damage due to possible re-entrancy attacks.

* **Integer overflow and underflow:** This has been avoided using SAfeMath.sol from openZeppelin libary.

* **Unexpected calls:** Unexpected calls to the contract are disallowed (eg where function signatures don't match) by fallback function that throws error (revert) in such cases.

* **Timestamping / miner tampering** : block.number is used in place of block.timestamp in the code as miners can tamper with block timestamps.

* **Function exposure**: Every function checks if the caller of function (msg.sender) is authorized for that particular role. IF not, the program aborts.

* **Circuit breaker:**  Implemented circuit breaker to stop all operations of market place in case of emergencies.