/* global privilegedAPI */

var privapi = privapi || {};

privapi.openLibreOffice = function (file_) {
  if (!window.privilegedAPI || !privilegedAPI.availiable()) { alert('Not available!'); return false; }
  var file = file_ || ''; var cmd = null;
  if (navigator.userAgent.indexOf('Windows') > 0) { // mozilla only
    cmd = '"${ProgramFiles}\\LibreOffice 5\\program\\soffice.exe" ' + file;
  } else {
    cmd = '/usr/bin/libreoffice ' + file;
  }
  console.log('cmd:', cmd);

  privilegedAPI.exec(
    cmd,
    function (res) { console.log('EXEC_SUCCESS_CALLBACK:', res); },
    function (res) { console.log('EXEC_ERROR_CALLBACK:', res); }
  );
};

var getHeadURL = function () {
  var headURLElem = document.querySelector('meta[name="HeadURL"]');
  var headURL = headURLElem && headURLElem.getAttribute('content');
  console.log('headURL', headURL);
  return (headURL || '').replace(/(^\$HeadURL:\s+)(.*)(\s\$)/, '$2');
};

var editDoc = function () {
  var headURL = getHeadURL();
  if (headURL) { privapi.openLibreOffice(headURL); }
};

var openDocHistory = function () {
  var headURL = getHeadURL();
  if (headURL) { window.open(headURL.replace('/repos/', '/viewvc/').replace('svn.net.ilb', 'svn.ilb'), '_blank'); }
};

(function(){
  document.addEventListener('keydown', function(event) {
    if (event.altKey || event.metaKey) {
      const key = String.fromCharCode(event.which).toLowerCase();
      switch (key) {
        case 'e':
          event.preventDefault();
          editDoc();
          break;
        case 'h':
          event.preventDefault();
          openHistory();
          break;
        default:
      }
    }
  }, false);

  var appendStyles = function() {
    var css = '.edit-menu { position: fixed; top: 1rem; right: 1rem; opacity: 0.8; transition: all 0.3s ease-out; z-index: 100; }' +
              '.edit-menu:hover { opacity: 1; }' +
              '.edit-menu button { font-size: 1.3rem; height: 2.3rem; min-width: 2.3rem }';
    var head = document.head || document.getElementsByTagName('head')[0];
    var style = document.createElement('style');

    style.type = 'text/css';
    style.appendChild(document.createTextNode(css));
    head.appendChild(style);
    console.log('editMenu styles appended');
  };

  var appendEditMenu = function() {
    var editMenu = document.createElement('div');
    editMenu.className = 'edit-menu';

    var editButton = document.createElement('button');
    editButton.innerHTML = '\u270e';
    editButton.setAttribute('title', 'Редактировать (alt+E)');
    editButton.setAttribute('onclick', 'editDoc()');
    editMenu.appendChild(editButton);

    var historyButton = document.createElement('button');
    historyButton.innerHTML = '\u25f4';
    historyButton.setAttribute('title', 'История изменений (alt+H)');
    historyButton.setAttribute('onclick', 'openDocHistory()');
    editMenu.appendChild(historyButton);

    var helpButton = document.createElement('button');
    helpButton.innerHTML = '?';
    helpButton.setAttribute('title', 'Справка');
    helpButton.setAttribute('onclick', 'window.open("https://docs.ilb.ru/oooxhtml/readme.xhtml")');
    editMenu.appendChild(helpButton);

    var body = document.body || document.getElementsByTagName('body')[0];
    body.appendChild(editMenu);
    console.log('editMenu created');
  };

  appendStyles();
  appendEditMenu();
}());
