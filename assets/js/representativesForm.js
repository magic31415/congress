import React from 'react';

export default class RepresentativesForm extends React.Component {
	constructor(props) {
		super(props);
		this.handleAddressChange = this.handleAddressChange.bind(this);
		this.handleZipChange = this.handleZipChange.bind(this);

		this.state = {
			address: "",
			zip: "",
		};
	}

	handleAddressChange(event) {
		this.setState({address: event.target.value});
	}

	handleZipChange(event) {
		this.setState({zip: event.target.value});
	}

	isFormSubmittable() {
		return this.state.address.length > 2
		  && this.state.zip.length == 5
	}

	handleSubmit(event) {
		event.preventDefault();
	}

	render() {
		const enableButton = this.isFormSubmittable();
		const buttonClass = enableButton ? "btn btn-primary" : "btn";

		return (
			<div id="representatives-form">
				<div className="my-1" id="enter-info">
					Enter your address and zip code to see how your representatives voted
				</div>
				<div className="container">
		    	<div className="row">
		    		<div className="col-2">&nbsp;</div>
		    		<form className="col-8 px-0" onSubmit={this.handleSubmit}>
		    			<label className="col-6 px-0">
		    				Street Address:
		    				<input type="text"
		    							 name="address"
		    							 className="ml-1"
		    							 onChange={this.handleAddressChange}
		    							 value={this.state.address}
		    							 placeholder="938 Quincy Street"
		    				/>
		    			</label>
		    			<label className="col-3 px-0">
		    				Zip Code:
		    				<input type="text"
		    				       name="zip"
		    				       className="ml-1"
		    				       onChange={this.handleZipChange}
		    				       value={this.state.zip}
		    				       placeholder="19403"
		    				/>
		    			</label>
		    			<span className="col-3 px-0">
			    			<input type="submit"
			    						 className={buttonClass}
			    						 id="submit-address-btn"
			    			       disabled={!enableButton}
			    			       onClick={() =>
			    			       	this.props.onClick(this.state.address, this.state.zip)}
			    			       value="Submit"
			    			/>
			    		</span>
		        </form>
		        <div className="col-2">&nbsp;</div>
		      </div>
		    </div>
    	</div>
		);
	}
}
