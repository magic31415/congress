import React from 'react';
import getOrdinal from './ordinal'

export default class Bill extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			formattedDate: formatDate(props.enactedDate)
		}
	}

	render() {
		return (
			<div id="bill">
				<div className="container">
		    	<div className="row text-danger">
					  <h5 className="col text-left">{this.props.billNumber}</h5>
						<h5 className="col"></h5>
						<h5 className="col text-right">{this.state.formattedDate}</h5>
		    	</div>
		  	</div>
		  	<div className="pl-3 pb-2">
		   		<h2 className="text-dark mb-3" id="title">{this.props.title}</h2>
		   	</div>
	   	</div>
		);
	}
}

function formatDate(date) {
	if(!date) { return ""; }

	let year, month, day;
	[year, month, day] = date.split("-");

	let monthNames = ["January", "February", "March", "April",
	                  "May", "June", "July", "August",
	                  "September", "October", "November", "December"];

	return `Enacted on
	        ${monthNames[parseInt(month) - 1]}
	        ${getOrdinal(parseInt(day))},
	        ${year}`;
}
