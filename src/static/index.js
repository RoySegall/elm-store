// pull in desired CSS/SASS files
require( './styles/main.scss' );
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );
var config = require("../config/config.json");

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.fullscreen({
  'items': getItemsFromStorage(),
  'accessToken':  getAccessToken(),
  'loggedInUser' : getLoggedUserFromStorage(),
  'backendAddress' : config.backend_address
});

function getAccessToken() {
  var
    access_token = localStorage.getItem('access_token') || '',
    expires = localStorage.getItem('expire') || '',
    refresh_token = localStorage.getItem('refresh_token') || '';

  let ts = Math.floor(Date.now() / 1000);

  if (expires == '') {
    // No expires so this is an anonymous user.
    return refresh_token;
  }

  if (ts > expires) {
    $.ajax({
      url: config.backend_address + "/api/user/token_refresh",
      method: "POST",
      data: {'refresh_token': refresh_token}
    })
      .fail(function(data) {
        console.error("The backend thrown an error: " + data.responseJSON.message);
      })
      .done(function(data) {
        var token = data.data.Token;

        access_token = token.Token;

        localStorage.setItem('access_token', token.Token);
        localStorage.setItem('refresh_token', token.RefreshToken);
        localStorage.setItem('expire', token.Expire);
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

app.ports.changeCheckoutStep.subscribe(function(step) {
  var hide_selector, show_selector;

  switch (step) {
    case 1:
      hide_selector = ".credit_card";
      show_selector = ".checkout_items";
      break;

    case 2:
      hide_selector = ".checkout_items";
      show_selector = ".credit_card";
      break;
  }

  $(hide_selector).addClass("fadeOutLeft animated");

  setTimeout(function() {
    $(hide_selector).css("display", "none");
    $(show_selector).css("display", "block").addClass("fadeInLeft animated");
    $(hide_selector).removeClass("fadeOutLeft animated");
  }, 300);

  // sleep(3, show_selector, hide_selector);
});

function sleep(ms, show_selector, hide_selector) {
  setTimeout(sleepFunc, ms * 1000);
  // $(show_selector);
}

function sleepFunc() {
  console.log('foo');
}
