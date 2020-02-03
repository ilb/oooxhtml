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

var toggleAnnotations = function (event) {
  var body = document.body || document.getElementsByTagName('body')[0];
  body.classList.toggle('with-annotations');
  event.currentTarget.classList.toggle('active');
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
    var css = '.settings-content { position: fixed; top: 0; right: 0; padding: 0.5rem; background: #fff; z-index: 21;' +
                '-moz-transform: translateX(100%); -webkit-transform: translateX(100%); transform: translateX(100%);' +
                'transition: all 0.1s ease-out;' +
              '}' +
              '.settings-content button { font-size: 1.3rem; height: 2.3rem; min-width: 2.3rem; cursor: pointer; margin: 0.1rem; }' +
              '.settings-content button.active { background-color: lightblue }' +
              '.settings:hover .settings-content { -moz-transform: none; -webkit-transform: none; transform: none; box-shadow: 0 0 20px rgba(23, 32, 30, 0.3); }' +
              '.settings-label { position: fixed; top: 0; right: 0; background: rgb(0,90,156); color: white; z-index: 20; font-size: 1.7rem; padding: 0.3rem 0.6rem; opacity: 0.7; }';
    var head = document.head || document.getElementsByTagName('head')[0];
    var style = document.createElement('style');

    style.type = 'text/css';
    style.appendChild(document.createTextNode(css));
    head.appendChild(style);
    console.log('editMenu styles appended');
  };

  var appendSettings = function() {
    var settings = document.createElementNS('http://www.w3.org/1999/xhtml','div');
    settings.className = 'settings';

    var settingsLabel = document.createElementNS('http://www.w3.org/1999/xhtml','div');
    settingsLabel.className = 'settings-label';
    settingsLabel.innerHTML = '\u2699';
    settings.appendChild(settingsLabel);

    var settingsContent = document.createElementNS('http://www.w3.org/1999/xhtml','div');
    settingsContent.className = 'settings-content';

    var editButton = document.createElement('button');
    editButton.innerHTML = '\u270e';
    editButton.setAttribute('title', 'Редактировать (alt+E)');
    editButton.setAttribute('onclick', 'editDoc()');
    settingsContent.appendChild(editButton);

    var historyButton = document.createElement('button');
    historyButton.innerHTML = '\u25f4';
    historyButton.setAttribute('title', 'История изменений (alt+H)');
    historyButton.setAttribute('onclick', 'openDocHistory()');
    settingsContent.appendChild(historyButton);

    var annotationsButton = document.createElement('button');
    annotationsButton.innerHTML = 'A';
    annotationsButton.setAttribute('title', 'Показать/скрыть аннотации');
    var hasAnnotation = document.querySelector('.annotation');
    annotationsButton.addEventListener('click', toggleAnnotations);
    settingsContent.appendChild(annotationsButton);
    if (hasAnnotation) {
      annotationsButton.click();
    } else {
      annotationsButton.setAttribute('disabled', 'disabled');
    }

    var helpButton = document.createElement('button');
    helpButton.innerHTML = '?';
    helpButton.setAttribute('title', 'Справка');
    helpButton.setAttribute('onclick', 'window.open("https://docs.ilb.ru/oooxhtml/readme.xhtml")');
    settingsContent.appendChild(helpButton);

    settings.appendChild(settingsContent);
    var body = document.body || document.getElementsByTagName('body')[0];
    body.appendChild(settings);
    console.log('settings created');
  };

  appendStyles();
  appendSettings();
}());
