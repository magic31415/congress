import React from 'react';
import Representatives from './representatives';
import RepresentativesForm from './representativesForm';
import Bill from './bill';
import MoreBillInfo from './moreBillInfo';

export default class Congress extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			billNumber: "",
			senators: [],
			senatorNames: [],
			houseReps: [],
			houseRepNames: [],
			senatorVotes: [],
			houseRepVotes: [],
			revealedReps: false,
			hasReps: false,
			showExtra: false
		}
		this.onBillCount();
		this.onBill();
	}

	onBillCount() {
	this.props.channel.push("bill-count")
		.receive("ok", msg =>
			this.setState({billCount: msg["count"]}));
	}

	onReps(address, zip) {
		this.props.channel.push("reps", {address: address, zip: zip})
			.receive("ok", msg => {
				const senators = msg["senators"];
				const houseReps = msg["house-reps"];

				this.setState({senators: senators,
											 senatorNames: this.getNames(senators),
				               houseReps: houseReps,
				               houseRepNames: this.getNames(houseReps),
				               state: msg["state"],
				               district: msg["district"],
				               hasReps: true
				              })});
	}

	onBill() {
		this.props.channel.push("bill", {number: this.state.billNumber,
	                                   senators: this.state.senatorNames,
	                                   houseReps: this.state.houseRepNames
	                                  })
			.receive("ok", msg =>
				this.setState({billNumber: msg["number"],
					             title: msg["title"],
					             enactedDate: msg["enacted"],
	                     url: msg["congressdotgov_url"],
	                     vetoed: msg["vetoed"],
	                     votes: msg["votes"],
	                     tallies: msg["tallies"]
				              }));
	}

	getNames(reps) {
		if(!reps.length) {
			return [];
		}

		return reps.map(function (rep) {
			return rep["name"];
		});
	}

	pickRepresentativesModule() {
		if(this.state.hasReps) {
			return (
				<Representatives
			  	senators={this.state.senators}
			  	senatorNames={this.state.senatorNames} // TODO can these be calculated elsewhere
			  	houseReps={this.state.houseReps}
			  	houseRepNames={this.state.houseRepNames}
			  	state={this.state.state}
			  	tallies={this.state.tallies}
			  	votes={this.state.votes}
			  	channel={this.props.channel}
			  	key={"reps-" + this.state.billNumber}
				/>
			);
		}
		else if(this.state.revealedReps) {
			return (
				<RepresentativesForm
					onClick={(address, zip) => this.onReps(address, zip)}
				/>
			);
		}
		else {
			return (
				<button
					type="button"
				  className="btn btn-link"
				  id="see-how-voted-btn"
				  onClick={() => this.setState({revealedReps: true})}>
				  See how my representatives voted on this bill
    		</button>
    	);
		}
	}

	render() {
		const showExtra = this.state.showExtra;
		const visibility = showExtra ? "" : "invisible"

		return (
			<div className="text-center">
				<div className="p-4 bg-primary rounded mt-1 mb-1" id="top">
				  <h1>What happened under Trump?</h1>
				  <h6 id="total-bill-count">{this.state.billCount} Bills Enacted</h6>
				</div>

				<div className="border border-primary border-5 rounded p-2" id="box">
					<Bill
						billNumber={this.state.billNumber}
						enactedDate={this.state.enactedDate}
						title={this.state.title}
						key={"bill-" + this.state.billNumber}
					/>
					<MoreBillInfo
						url={this.state.url}
						tallies={this.state.tallies}
						vetoed={this.state.vetoed}
						visibility={visibility}
						key={"more-info-" + this.state.billNumber}
					/>
      		<div className={visibility}>
      			{this.pickRepresentativesModule()}
      		</div>
					<button
						type="button"
		        className="btn btn-link"
		        id="toggle-more-info"
		        onClick={() => this.setState({showExtra: !showExtra})}>
		        {(showExtra ? "Hide" : "Show") + " Additional Info"}
					</button>
				</div>

				<button
					type="button"
	        className="btn btn-danger btn-lg center-button mt-5"
	        id="what-else"
	        onClick={() => this.onBill()}>
	        What Else Happened?
				</button>
			</div>
		);
	}
}
