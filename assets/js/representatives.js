import React from 'react';
import Rep from './rep';

export default class Representatives extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			parsedVotesHouse: [],
			parsedVotesSenate: [],
		}
		this.parseVotes();
	}

	// TODO simplify this
	parseVotes() {
		const allVotes = this.props.tallies;
		const senateVotes = allVotes["senate"];
		const houseVotes = allVotes["house"];
		let calculated = false;

		if(houseVotes) {
			if(houseVotes["rep_votes"]) {
				this.onLaterHouseVotes(this.calculatePositions(houseVotes, this.props.houseReps))
				calculated = true;
			}
		}

		if(senateVotes) {
			if(senateVotes["rep_votes"]) {
				this.onLaterSenateVotes(this.calculatePositions(senateVotes, this.props.senators))
				calculated = true;
			}
		}

		if(!calculated) {
			this.onFirstVotes();
		}
	}

	onFirstVotes() {
		this.props.channel.push("first-votes",
														{"votes": this.props.votes,
													   "senators": this.props.senatorNames,
													   "houseReps": this.props.houseRepNames
													  })
			.receive("ok", msg =>
				this.setState({
					parsedVotesHouse: this.calculatePositions(msg["house"], this.props.houseReps),
					parsedVotesSenate: this.calculatePositions(msg["senate"], this.props.senators),
				}))
	}

	// TODO these are hacks
	onLaterHouseVotes(votes) {
		this.props.channel.push("later-votes", {"votes": votes})
			.receive("ok", msg =>
				this.setState({parsedVotesHouse: votes}))
	}
	onLaterSenateVotes(votes) {
		this.props.channel.push("later-votes", {"votes": votes})
			.receive("ok", msg =>
				this.setState({parsedVotesSenate: votes}))
	}

	calculatePositions(allVotes, reps) {
		let votes = Array(reps.length).fill(null);

		if(allVotes) {
			$.each(reps, function(idx) {
				// TODO needs to handle cases when some reps dont vote
				votes[idx] = allVotes["rep_votes"][idx]["vote_position"];
			});
		}
		return votes;
	}

	renderRep(rep, position, state) {
		// console.log(rep["name"], position, state);
		return (
			<Rep
				rep={rep}
				position={position}
				state={state}
			/>
		);
	}

	createListOfReps(reps, votes) {
		return (
			reps.map((rep, idx) => {
				return (
					<li key={`${rep["id"]}-${votes[idx]}`}>
						{this.renderRep(rep, votes[idx], this.props.state)}
					</li>
				);
			})
		);
	}

	render() {
		return (
			<div className="row" id="representatives">
				<ul className="col rep-list" id="houseReps">
					{this.createListOfReps(this.props.houseReps, this.state.parsedVotesHouse)}
				</ul>
				<ul className="col rep-list" id="senators">
					{this.createListOfReps(this.props.senators, this.state.parsedVotesSenate)}
				</ul>
				<div className="col">&nbsp;</div>
			</div>
		);
	}
}
