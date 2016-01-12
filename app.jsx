var rootURL = 'https://ghostreact.firebaseio.com/';

var Form = React.createClass({
  render: function() {
    return <form className="form-group">
      <div className="form-group">
        <label className="col-sm-2 control-label">Ghost Name</label>
          <div className="col-sm-10">
            <input
              placeholder="Name"
              type="text"
              className="form-control" />
          </div>
      </div>
      <div className="form-group">
        <label className="col-sm-2 control-label">Description</label>
          <div className="col-sm-10">
            <input
              placeholder="Description"
              type="text"
              className="form-control" />
          </div>
      </div>
      <div className="form-group">
        <label className="col-sm-2 control-label">Photo URL</label>
          <div className="col-sm-10">
            <input
              placeholder="Photo URL"
              type="text"
              className="form-control" />
          </div>
      </div>
      <div className="form-group">
        <div className="col-sm-offset-2 col-sm-10">
          <submit
            className="btn btn-default"
            type="submit">
            Report
          </submit>
        </div>
      </div>
    </form>
  }
});

var App = React.createClass({
  getInitialState: function() {
    return {
      ghosts: {},
    }
  },
  render: function() {
    return <div>
        <Form ghostsStore={this.state.ghosts} />
      </div>
  }
});
    
ReactDOM.render( <App /> , document.getElementById('content') );