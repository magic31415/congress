import {Socket} from "phoenix"
export default socket

let socket = new Socket("/socket", {params: {token: window.userToken}});
socket.connect();
let channel = socket.channel("congress:bills", {});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) });

$("#what-else-button").click(getAnotherBill);
$("#toggle-more-info").click(toggleMoreInfo);
$("#see-how-voted-btn").click(seeHowRepsVoted);
$("#submit-address-btn").click(getRepsVotes);

$("#user_address").keyup(enableDisableSubmit);
$("#user_zip").keyup(enableDisableSubmit);

channel.on("bill", gotAnotherBill);
channel.on("bill-count", gotBillCount);
channel.on("tallies", gotTallies);
channel.on("reps", gotReps);

function seeHowRepsVoted() {
	$("#see-how-voted-btn").hide();//fadeOut();
	$("#enter-info").show();//fadeIn();
	$("#reps-votes").fadeIn();
	enableDisableSubmit();
}

function toggleMoreInfo() {
	let button = $("#toggle-more-info");
	let info_box = $("#more-info-box");

	if(info_box.css("display") == "none") {
		button.text("Hide Additional Info");
		info_box.fadeIn()
	}
	else {
		button.text("Show Additional Info");
		info_box.fadeOut()
	}
}

function enableDisableSubmit() {
	let submitButton = $("#submit-address-btn");

	if($("#user_address").val().length > 2
		   && $("#user_zip").val().length == 5) {
		submitButton.removeAttr("disabled");
		submitButton.addClass("btn-primary");
	}
	else {
		submitButton.attr("disabled", "disabled");
		submitButton.removeClass("btn-primary");
	}
}

function getRepsVotes() {
	channel.push("reps", {address: $("#user_address").val(),
		                    zip: $("#user_zip").val()});
}

function gotReps(msg) {
	console.log(msg)

	$("#reps-votes").fadeOut();
	$("#enter-info").fadeOut();
	$("#my-reps").fadeIn()

	populateRepInfo(msg, "senator1")
	populateRepInfo(msg, "senator2")
	populateRepInfo(msg, "house-rep")
}

function populateRepInfo(msg, office) {
	let district = (office == "house-rep") ? " Dist. " + msg["district"] : ""

	$("#" + office).text(`${msg[office]["name"]} (${msg[office]["party"]}-${msg["state"]}${district})`);
	$("#" + office).addClass("text-" + getPartyColor(msg[office]["party"]))
}

function getPartyColor(party) {
	switch(party) {
    case "D":
        return "primary";
        break;
    case "R":
        return "danger";
        break;
    default:
        return "independent";
	}
}

// TODO bad
function parseSenator(num) {
	return $("#senator" + num).text().split(" (")[0];
}

// TODO bad
function parseHouseRep() {
	return $("#house-rep").text().split(" (")[0];
}

function getAnotherBill() {	
	// number will be blank the first time
	channel.push("bill", {number: $("#bill-number").text(), // TODO bad
		                    reps: {senator1: parseSenator("1"),
                               senator2: parseSenator("2"),
                               house_rep: parseHouseRep()}});
	$("#whole-box").fadeOut();
}

function gotAnotherBill(bill) {
	// console.log(bill);

	$("#bill-number").text(bill["number"]);
	$("#title").text(bill["title"]);
	$("#enacted-date").text(parseEnactedDate(bill["enacted"]));
	$("#text-link").attr("href", bill["congressdotgov_url"] + "/text");
	handleVeto(bill["vetoed"]);
	parseVote("", "senate");
	parseVote("", "house");
	$("#senator1-vote").text("");
	$("#senator2-vote").text("");
	$("#house-rep-vote").text("");

	$("#whole-box").fadeIn();
}

function parseEnactedDate(date) {
	let year, month, day, m, d;
	[year, m, d] = date.split("-");
	day = parseInt(d, 10);

	switch(m) {
	  case "01": month = "January";
	      break;
	  case "02": month = "February";
	      break;
	  case "03": month = "March";
	      break;
	  case "04": month = "April";
	      break;
	  case "05": month = "May";
	      break;
	  case "06": month = "June"; 
	      break;
	  case "07": month = "July";
	      break;
	  case "08": month = "August";
	      break;
	  case "09": month = "September";
	      break;
	  case "10": month = "October";
	      break;
	  case "11": month = "November";
	      break;
	  case "12": month = "December";
	      break;
	}
	return `Enacted on ${month} ${day}, ${year}`
}

function gotTallies(msg) {
	console.log(msg)
	parseVote(msg["tallies"], "senate");
	parseVote(msg["tallies"], "house");
}

// TODO refactor
function parseVote(tallies, chamber) {
	let votes = tallies[chamber];

	if(votes) {
		$(`#${chamber}-vote`).text(`${votes["total"]["yes"]}-${votes["total"]["no"]}`);

		if (votes["rep_votes"].length) {
			let offices = (chamber == "senate") ? ["senator1", "senator2"] : ["house-rep"];

			$.each(offices, function(idx, office) {
				$(`#${office}-vote`).text(getVoteSymbol(votes["rep_votes"][idx]["vote_position"]));
			});
		}
	}
	else {
		$("#" + chamber + "-vote").text("");
	}
}

function getVoteSymbol(vote_position) {
		switch(vote_position) {
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

function handleVeto(isVeto) {
	let element = $("#president");
	element.addClass(isVeto ? "text-danger" : "text-success");
	element.text((isVeto ? "Vetoed" : "Signed") + " by President Trump");
}

function getBillCount() {
	channel.push("bill-count");
}

function gotBillCount(msg) {
	$("#total-bill-count").text(msg["count"] + " Bills Enacted")
}

$(document).ready(function() {
	getBillCount();
	getAnotherBill();
});
