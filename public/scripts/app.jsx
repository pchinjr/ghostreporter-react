var App = React.createClass({
  mixins: [ReactFireMixin],
  
  handleGhostSubmit: function(ghost) {
    this.firebaseRefs["data"].push(ghost);
  },
  getInitialState: function() {
    return { 
      data: []
    };
  },
  
  componentWillMount: function() {
    var firebaseRef = new Firebase('https://ghostreact.firebaseio.com/ghosts');
    this.bindAsArray(firebaseRef, 'data');
  },
  
  render: function() {
    return (
      <div>
        <div className="col-md-9">
          <h1>All Ghost Sightings</h1>
            <hr />
          <GhostList ghosts={this.state.data} />
        </div>
        <div className="col-md-3">
          <h1>Report A Ghost</h1>
            <hr />
          <GhostForm onGhostSubmit={this.handleGhostSubmit} />
        </div>
      </div>
    );
  }
});

var GhostList = React.createClass({
  render: function() {
    var ghostNodes = this.props.ghosts.map(function (ghost, index) {
      return (
        <Ghost
          name={ghost.name}
          key={index}
          description={ghost.description}
          photo={ghost.photo} />
      );
    });
    return <div className="row">{ghostNodes}</div>;
  }
});

var Ghost = React.createClass({
  render: function() {
    return (
      <div className="col-md-3">
        <div className="thumbnail">
          <img src={this.checkPhoto()} />
            <div className="caption">
              <h3>{this.props.name}</h3>
              <p>{this.props.description}</p>
            </div>
        </div>
      </div>
    );
  },
  checkPhoto: function() {
    if(this.props.photo === "") {
      return "http://www.nerdist.com/wp-content/uploads/2010/06/ghostbusters_logo-1-338x300.jpg";
    } else {
      return this.props.photo;
    }
  }
});

var GhostForm = React.createClass({
  getInitialState: function() {
    return { 
      name: '', 
      description: '', 
      photo: '' 
    };
  },
  handleInputChange: function(key) {
    return function(event) {
      var state = {};
      state[key] = event.target.value;
      this.setState(state);
    }.bind(this);
  },
  handleSubmit: function(e) {
    e.preventDefault();
    this.props.onGhostSubmit({
      name: this.state.name,
      description: this.state.description,
      photo: this.state.photo,
      done: false
    });
    this.setState({name: "", description: "", photo: ""});
  },
  render: function() {
    return (
      <form className="form-group col-md-6" onSubmit={this.handleSubmit}>
        <div className="form-group">
            <label className=" control-label">Ghost Name</label>
            <input
              type="text"
              placeholder="Name"
              value={this.state.name}
              onChange={this.handleInputChange('name')}
              className="form-control"
              required />
        </div>
        <div className="form-group">
            <label className=" control-label">Description</label>
            <input
              type="text"
              placeholder="Description"
              value={this.state.description}
              onChange={this.handleInputChange('description')}
              className="form-control"
              required />
        </div>
        <div className="form-group">
            <label className=" control-label">Photo URL</label>
            <input
              type="text"
              placeholder="Photo URL"
              value={this.state.photo}
              onChange={this.handleInputChange('photo')}
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
    );
  }
});



ReactDOM.render( <App /> , document.getElementById('content') );
