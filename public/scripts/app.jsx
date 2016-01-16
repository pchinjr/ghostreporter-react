var App = React.createClass({
  mixins: [ReactFireMixin],
  
  getInitialState: function() {
    return { 
      ghosts: {}
    };
  },
  
  componentWillMount: function() {
    var firebaseRef = new Firebase('https://ghostreact.firebaseio.com/ghosts/');
    this.bindAsObject(firebaseRef, 'ghosts');
  },
  
  render: function() {
    return (
      <div>
        <div className="col-md-9">
          <h1>All Ghost Sightings</h1>
            <hr />
          <GhostList ghosts={this.state.ghosts} />
        </div>
        <div className="col-md-3">
          <h1>Report A Ghost</h1>
            <hr />
          <GhostForm ghostsStore={this.firebaseRefs.ghosts} />
        </div>
      </div>
    )
  }
});

var GhostList = React.createClass({
  render: function() {
    console.log(this.props.ghosts);
    return <div className="row">
      <Ghost
        name={'Slimer'}
        description={'spud'}
        photo={'//cageme.herokuapp.com/300/300'}
        />
        
    </div>
  },
  // renderList: function() {
  //   var children = [];
    
  //     for(var index in this.props.ghosts) {
  //       var ghost = this.props.ghosts[index];
  //       ghost.index = index;
  //       children.push(
  //         <Ghost
  //           name={ghost.name}
  //           key={ghost.index}
  //           description={ghost.description}
  //           photo={ghost.photo}
  //         />
  //         )
  //     }
  //       return children;
  //     }
});

var Ghost = React.createClass({
  // getInitialState: function() {
  //   return {
  //     name: this.props.ghost.name,
  //     description: this.props.ghost.description,
  //     photo: this.props.ghost.photo,
  //   }
  // },
  // componentWillMount: function() {
  //   this.fb = new Firebase('https://ghostreact.firebaseio.com/ghosts/' + this.props.ghost.index);
  // },
  render: function() {
    return (
      <div className="col-md-3">
        <div className="thumbnail">
          <img src={this.props.photo} />
            <div className="caption">
              <h3>{this.props.name}</h3>
              <p>{this.props.description}</p>
            </div>
        </div>
      </div>
    )
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
    this.props.ghostsStore.push({
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
