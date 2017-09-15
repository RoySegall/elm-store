// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed
config = require("../config/config.json");

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.fullscreen({
  'items': getItemsFromStorage(),
  'accessToken':  getAccessToken(),
  'loggedInUser' : getLoggedUserFromStorage(),
  'backendAddress' : config.backend_address
});

function getAccessToken() {
  let
    access_token = localStorage.getItem('access_token') || '',
    expires = localStorage.getItem('expires') || '',
    refresh_token = localStorage.getItem('refresh_token') || '';

  let ts = Math.floor(Date.now() / 1000);

  if (ts > expires) {
    $.ajax({
      url: "http://fiddle.jshell.net/favicon.png",
    })
      .done(function( data ) {
        if ( console && console.log ) {
          console.log( "Sample of data:", data.slice( 0, 100 ) );
        }
      });
  }

  return access_token;
}

function getItemsFromStorage() {
  var items = localStorage.getItem('items');
  return items == "" || items == null ? [] : JSON.parse(items);
}

function getLoggedUserFromStorage() {
  var logged = localStorage.getItem('logged_in_user');
  return logged == "" || logged == null ? {'id': '', 'username': '', 'image': ''} : JSON.parse(logged);
}

app.ports.logOut.subscribe(function() {
  localStorage.removeItem('items');
  localStorage.removeItem('logged_in_user');
  localStorage.removeItem('access_token');
});

app.ports.addItemToStorage.subscribe(function(item) {
  var items = localStorage.getItem('items');
  var decoded_items = items == null || items == "" ? [] : JSON.parse(items);
  decoded_items.push(item);

  localStorage.setItem('items', JSON.stringify(decoded_items))
});


app.ports.setItemInLocalStorage.subscribe(function(items) {
  localStorage.setItem('items', JSON.stringify(items))
});

app.ports.removeItemsFromStorage.subscribe(function() {
  localStorage.setItem('items', "")
});

app.ports.removeItemsFromCart.subscribe(function(item) {

  var decoded_items = JSON.parse(localStorage.getItem('items'));
  var new_items = [];

  var arrayLength = decoded_items.length;
  for (var i = 0; i < arrayLength; i++) {
    if (decoded_items[i].id == item.id) {
      continue;
    }

    new_items.push(decoded_items[i])
  }

  localStorage.setItem('items', JSON.stringify(new_items))
});

app.ports.setAccessToken.subscribe(function(successLogin) {
  localStorage.setItem('access_token', successLogin.token.token);
  localStorage.setItem('refresh_token', successLogin.token.refreshToken);
  localStorage.setItem('expire', successLogin.token.expire);

  var loggedInUser = {
    'id': successLogin.id,
    'username': successLogin.username,
    'image': successLogin.image
  };

  localStorage.setItem('logged_in_user', JSON.stringify(loggedInUser));
});
