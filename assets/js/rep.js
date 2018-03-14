import React from 'react';
import getOrdinal from './ordinal'

export default class Rep extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			partyColor: this.getPartyColor(),
			positionSymbol: this.getPositionSymbol()
		};
	}

	getPartyColor() {
		switch(this.props.rep["party"]) {
	    case "D":
        return "text-primary";
        break;
	    case "R":
	      return "text-danger";
        break;
	    default:
        return "text-independent";
		}
	}

	getPositionSymbol() {
		switch(this.props.position) {
	    case "Yes":
        return " 👍";
        break;
	    case "No":
        return " 👎";
        break;
	    default:
        return "";
		}
	}

 	getDistrictInfo() {
 		const rep = this.props.rep;

		if(rep["role"] == "Representative") {
			const districtName = rep["at_large"] ? "At-large" : getOrdinal(rep["district"]);
			return `, ${districtName} District`;
		}
		else {
			return "";
		}
 	}

	render() {
		const rep = this.props.rep;
		const districtInfo = this.getDistrictInfo();
		const classes = "ml-1 " + this.state.partyColor

		return (
			<h6>
				{rep["name"]}
				<span className={classes}>({rep["party"]}-{this.props.state}{districtInfo})</span>
				<span>{this.state.positionSymbol}</span>
			</h6>
		);
	}
}
