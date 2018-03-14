import React from 'react';

export default class MoreBillInfo extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			presClass: (props.vetoed ? "text-danger" : "text-success") + " col",
			presText: (props.vetoed ? "Vetoed" : "Signed") + " by President Trump",
		}
	}

	parseTotalVote(chamber) {
		if(this.props.tallies) {
			const chamberVotes = this.props.tallies[chamber];
			return chamberVotes ?
				` ${chamberVotes["total"]["yes"]}-${chamberVotes["total"]["no"]}` : "";
		}
	}

	render() {
		return (
			<div className={this.props.visibility} id="more-bill-info">
				<h5><a href={this.props.url} target="_blank">View Full Text</a></h5>
				<div className="container">
	        <div className="row text-success">
	          <h6 className="col">Passed in House{this.parseTotalVote("house")}</h6>
	          <h6 className="col">Passed in Senate{this.parseTotalVote("senate")}</h6>
	          <h6 className={this.state.presClass}>{this.state.presText}</h6>
	        </div>
	      </div>
			</div>
		);
	}
}
