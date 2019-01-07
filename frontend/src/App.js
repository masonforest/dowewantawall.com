import React, { Component } from 'react';
import car from './car.png';
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faThumbsUp, faThumbsDown } from '@fortawesome/free-solid-svg-icons'
import logo from './logo.svg';
import './App.css';
library.add(faThumbsDown, faThumbsUp);
const API_URL = process.env.REACT_APP_API_URL;

class App extends Component {
  constructor () {
    super();
    this.state = {
      vote: null,
      yesVoteCount: null,
      noVoteCount: null,
    };
  }

  async componentDidMount() {
    if(window.location.pathname == "/oauth/callback") {
      const urlParams = new URLSearchParams(window.location.search);
      const oauthToken = urlParams.get('oauth_token');
      const oauthVerifier = urlParams.get('oauth_verifier');
      const vote = urlParams.get('state');
      await this.oauthCallback(oauthToken, oauthVerifier);
      await this.vote(vote);
      window.location.href = "/";
    } else {
      this.getVotes();
    }
  }

  getVotes = async () => {
    const response = await fetch(`${API_URL}/votes`);
    const {yes_vote_count, no_vote_count} = await response.json();
    this.setState({
      yesVoteCount: yes_vote_count,
      noVoteCount: no_vote_count,
    })
  }
  oauthCallback = async (oauthToken, oauthVerifier) => {
    const response = await fetch(`${API_URL}/oauth/callback`, {
      method: "POST",
      headers: {
            "Content-Type": "application/json",
      },
      credentials: "include",
      body: JSON.stringify({
        "oauth_token": oauthToken,
        "oauth_verifier": oauthVerifier,
      })
    });
    const user = await response.json();
  }

  async vote(choice) {
    await fetch(`${API_URL}/votes`, {
      method: "POST",
      headers: {
            "Content-Type": "application/json",
      },
      credentials: "include",
      body: JSON.stringify({choice})
    })
  }

  signInAndVote = async (choice) => {
    const response = await fetch(`${API_URL}/oauth/authentication_url?state=${choice}`)
    const url = await response.json();
    window.location.href = url;
  }

  render() {
    const {yesVoteCount, noVoteCount} = this.state;
    const totalVoteCount = yesVoteCount + noVoteCount;
    const yesPercentage = Math.round((yesVoteCount/totalVoteCount) * 100);
    const noPercentage = Math.round((noVoteCount/totalVoteCount) * 100);
    const answer = yesVoteCount > noVoteCount;
    return (
      <React.Fragment>
        <header>
          <h1>Should the United States build a wall on it&apos;s Southern border between itself and Mexico?</h1>
        </header>
        <section>
            <h2>Twitter Says:</h2>
            {answer ? 
              <div className="answer yes">Yes.</div>
            :
              <div className="answer no">No.</div>
            }
            <div>{yesPercentage}% of Twitter users who voted say <span className="yes">Yes</span></div>
            <div>{noPercentage}% of Twitter users who voted say <span className="no">No</span></div>
            <div>{totalVoteCount} votes total</div>
            <div className="warning"><i>WARNING: George Soros and the Dems are funding people and bots to vote "No". This poll is FAKE NEWS! </i>😉</div>
        </section>
        <section>
            <h2>Vote</h2>
            <FontAwesomeIcon onClick={() => this.signInAndVote(false)} icon="thumbs-down" className="vote-button no" />
            <FontAwesomeIcon onClick={() => this.signInAndVote(true)} icon="thumbs-up"  className="vote-button yes" />
        </section>
        {/*
        <section>
          <h2>Secured by the Blockchain</h2>

          <p>All votes will be recorded on the <a href="https://ethereum.org/">Ethereum</a> blockchain. Once cast votes can not be changed or censored by any person govronment or entity not even the programmer who built the application.</p>
        </section>
        */}
      </React.Fragment>
    );
  }
}

export default App;
