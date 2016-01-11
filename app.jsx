

var App = React.createClass ({
    getInitialState: function() {
      return {counter: 1}
    },
    handleClick: function(){
      this.setState({counter: this.state.counter + 1 });
    },
    render: function() {
      return (
        <div className="text-center">
          <h1>World's Most Useless Button <button onClick={this.handleClick} className="btn btn-primary btn-lg">{this.state.counter}</button> </h1>
        
        </div>
      );
    }
});
    
ReactDOM.render( <App /> , document.getElementById('content') );