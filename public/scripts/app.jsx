var App = React.createClass({
  loadGhostsFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  handleGhostSubmit: function(ghost) {
    var ghosts = this.state.data;
    ghost.id = Date.now();
    var newGhosts = ghosts.concat([ghost]);
    this.setState({data: newGhosts});
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      type: 'POST',
      data: ghost,
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        // this.setState({data: comments});
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return { data: [] };
  },
  componentDidMount: function() {
    this.loadGhostsFromServer();
  },
  render: function() {
    return (
      <div>
        <div className="col-md-9">
          <h1>All Ghost Sightings</h1>
            <hr />
          <GhostList data={this.state.data} />
        </div>
        <div className="col-md-3">
          <h1>Report A Ghost</h1>
            <hr />
          <GhostForm onGhostSubmit={this.handleGhostSubmit} />
        </div>
      </div>
    )
  }
});

var GhostList = React.createClass({
  render: function() {
    var ghostNodes = this.props.data.map(function(ghost) {
      return (
        <Ghost
          name={ghost.name}
          key={ghost.id}
          description={ghost.description}
          photoUrl={ghost.photoUrl} />
      );
    });
    return(
      <div className="row">
        {ghostNodes}
      </div>
    );
  }
});

var GhostForm = React.createClass({
  getInitialState: function() {
    return { name: '', description: '', photoUrl: '' };
  },
  handleNameChange: function(e) {
    this.setState({name: e.target.value});
  },
  handleDescriptionChange: function(e) {
    this.setState({description: e.target.value});
  },
  handlePhotoUrlChange: function(e) {
    this.setState({photoUrl: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var name = this.state.name.trim();
    var description = this.state.description.trim();
    var photoUrl = this.state.photoUrl.trim();
    this.props.onGhostSubmit({name: name, description: description, photoUrl: photoUrl});
    this.setState({name: '', description: '', photoUrl: ''});
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
              onChange={this.handleNameChange}
              className="form-control"
              required />
        </div>
        <div className="form-group">
            <label className=" control-label">Description</label>
            <input
              type="text"
              placeholder="Description"
              value={this.state.description}
              onChange={this.handleDescriptionChange}
              className="form-control"
              required />
        </div>
        <div className="form-group">
            <label className=" control-label">Photo URL</label>
            <input
              type="text"
              placeholder="Photo URL"
              value={this.state.photoUrl}
              onChange={this.handlePhotoUrlChange}
              className="form-control" />
        </div>
        <div className="form-group">
          <button
            value="Post"
            className="btn btn-default"
            type="submit">
            Report
          </button>
        </div>
    </form>
    );
  }
});

var Ghost = React.createClass({
  render: function() {
    return (
      <div className="col-md-3">
        <div className="thumbnail">
          <img src={this.props.photoUrl} />
            <div className="caption">
              <h3>{this.props.name}</h3>
              <p>{this.props.description}</p>
            </div>
        </div>
      </div>
    )
  }
});

ReactDOM.render( <App url="/api/ghosts"/> , document.getElementById('content') );
