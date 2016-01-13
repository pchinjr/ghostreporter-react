var App = React.createClass({
  getInitialState: function() {
    return { ghosts: [] };
  },
  handleGhostSubmit: function(e) {
    e.preventDefault();
    this.setState({ghost: ghost});
  },
  render: function() {
    return <div>
        <h1>All Ghost Sightings</h1>
        <hr />
        <GhostList ghosts={this.state.ghosts} />
        <h1>Report A Ghost</h1>
        <hr />
        <GhostForm handleGhostSubmit={this.handleGhostSubmit} />
      </div>
  }
});

var GhostList = React.createClass({
  render: function() {
    return <div>
      {Ghost}
    </div>
  }
});

var GhostForm = React.createClass({
  getInitialState: function() {
    return{ name: '' };
  },
  // handleSubmit: function(event) {
  //   event.preventDefault();
  //   var name = this.state.name;
  //   this.props.onCommentSubmit({name: name});
  // },
  render: function() {
    return <form className="form-group col-md-6" onSubmit={this.props.handleSubmit}>
        <div className="form-group">
            <label className=" control-label">Ghost Name</label>
            <input
              placeholder="Name"
              htmlFor="name"
              className="form-control" />
        </div>
        <div className="form-group">
          <button
            className="btn btn-default"
            type="submit">
            Report
          </button>
        </div>
    </form>
  }
});

var Ghost = React.createClass({
  render: function() {
    return <li>
      Slimer
    </li>
  }
});

ReactDOM.render( <App /> , document.getElementById('content') );
