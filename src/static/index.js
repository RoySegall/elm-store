// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed 

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.fullscreen();

app.ports.addItemToStorage.subscribe(function(item) {
  var items = localStorage.getItem('items');
  var decoded_items = items == "" ? [] : JSON.parse(items);
  decoded_items.push(item);

  localStorage.setItem('items', JSON.stringify(decoded_items))
});

app.ports.getItemsFromStorage.subscribe(function(item) {
});