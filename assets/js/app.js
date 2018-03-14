import "phoenix_html";
import {Socket} from "phoenix";
"use strict";

import React from 'react';
import ReactDOM from 'react-dom';
import Congress from "./congress";

let socket = new Socket("/socket", {params: {token: window.userToken}});
socket.connect();

let channel = socket.channel("congress:bills", {});

channel.join()
	.receive("ok", state0 => {
  	console.log("Joined successfully", state0);
  	ReactDOM.render(<Congress state={state0} channel={channel} />,
  		              document.getElementById("root"));
  })
  .receive("error", resp => {
  	console.log("Unable to join", resp);
  });
