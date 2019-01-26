import React, { Component } from "react";

class AddressForm extends React.Component {
    constructor(props) {
      super(props);
      this.state = {Address: ''};
  
      this.handleChange = this.handleChange.bind(this);
      this.handleSubmit = this.handleSubmit.bind(this);
    }
  
    handleChange(event) {
      this.setState({Address: event.target.value});
    }
  
    handleSubmit(event) {
      alert('Address submitted was: ' + this.state.Address);
      event.preventDefault();
        this.props.handleAddAddress(this.state.Address);
    }
  
    render() {
      return (
        <form onSubmit={this.handleSubmit}>
          <label>
            Enter account address for Admin role:
            <input type="text" value={this.state.value} onChange={this.handleChange} />
          </label>
          <input type="submit" value="Add as Admin" />
        </form>
      );
    }
  }
export default AddressForm;