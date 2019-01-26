import React, { Component } from "react";
import MarketplaceContract from "./contracts/Marketplace.json";
import getWeb3 from "./utils/getWeb3";
import AddressForm from "./components/AddressForm.js";
import "./App.css";

class App extends Component {
  state = { 
    ownerAddress: null, 
    ownerRole: null,
    adminAddress :null,
    adminRole: null,
    web3: null, 
    accounts: null, 
    contract: null 
  };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = MarketplaceContract.networks[networkId];
      const instance = new web3.eth.Contract(
        MarketplaceContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  handleAddAddress = async (address) =>  {
    const {contract,accounts,web3} = this.state;
    this.setState({adminAddress : address});
    await contract.methods.addAdmin(address).send({ from: accounts[0] });
   // Get the role from the contract.
   const response1 = await contract.methods.roles(address).call();
   console.log(web3.utils.hexToAscii(response1))
   // Update state with the result.
   this.setState({ adminRole: web3.utils.hexToAscii(response1) }); 
  }


  runExample = async () => {
    const { accounts, contract, web3 } = this.state;

    // Stores a given value, 5 by default.
   // await contract.methods.set(51).send({ from: accounts[0] });

    //Get the owner address from the contract
    const response1 = await contract.methods.owner().call();
    console.log("1st account is",accounts[0])
    // Get the role from the contract.
    const response2 = await contract.methods.roles("0xF0A8D33fFd9c990304d8A45D7555B07538c00B5e").call();
    console.log(web3.utils.hexToAscii(response2))
    // Update state with the result.
    this.setState({ ownerAddress: response1, ownerRole: web3.utils.hexToAscii(response2) });
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
     
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of 5 (by default).
        </p>
     
        <div>Account is: {this.state.ownerAddress}, Role is: {this.state.ownerRole}</div>
        <div>Account is: {this.state.adminAddress}, Role is: {this.state.adminRole}</div>

        <br></br>
        <AddressForm handleAddAddress={this.handleAddAddress}></AddressForm>
      </div>
    );
  }
}

export default App;
