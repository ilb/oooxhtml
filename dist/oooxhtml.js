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
    var head = document.head || document.getElementsByTagNameNS('http://www.w3.org/1999/xhtml','head')[0];
    var style = document.createElementNS('http://www.w3.org/1999/xhtml','style');

    style.type = 'text/css';
    style.appendChild(document.createTextNode(css));
    head.appendChild(style);
    console.log('editMenu styles appended');
  };

  var appendEditMenu = function() {
    var editMenu = document.createElementNS('http://www.w3.org/1999/xhtml','div');
    editMenu.className = 'edit-menu';

    var editButton = document.createElementNS('http://www.w3.org/1999/xhtml','button');
    editButton.innerHTML = '\u270e';
    editButton.setAttribute('title', 'Редактировать (alt+E)');
    editButton.setAttribute('onclick', 'editDoc()');
    editMenu.appendChild(editButton);

    var historyButton = document.createElementNS('http://www.w3.org/1999/xhtml','button');
    historyButton.innerHTML = '\u25f4';
    historyButton.setAttribute('title', 'История изменений (alt+H)');
    historyButton.setAttribute('onclick', 'openDocHistory()');
    editMenu.appendChild(historyButton);

    var helpButton = document.createElementNS('http://www.w3.org/1999/xhtml','button');
    helpButton.innerHTML = '?';
    helpButton.setAttribute('title', 'Справка');
    helpButton.setAttribute('onclick', 'window.open("https://docs.ilb.ru/oooxhtml/readme.xhtml")');
    editMenu.appendChild(helpButton);

    var body = document.body || document.getElementsByTagNameNS('http://www.w3.org/1999/xhtml','body')[0];
    body.appendChild(editMenu);
    console.log('editMenu created');
  };

  appendStyles();
  appendEditMenu();
}());
;(function(){
  var makeRequest = function (args) {
    var url = args.url,
        request = args.request,
        method = args.method,
        accept = args.accept,
        contentType = args.contentType;

    return new Promise(function(resolve, reject) {
      var xhr = new XMLHttpRequest();
      xhr.withCredentials = true;
      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
          if (xhr.status === 200 || xhr.status === 204) {
            resolve(xhr.responseText || '');
          } else {
            var error = xhr.responseText || xhr.response;
            error = typeof error === 'string' ? error : error.statusText || error.data || error.message || 'Внутренняя ошибка приложения'
            reject(error);
          }
        }
      };
      xhr.open(method || 'GET', url, true);
      if (contentType) { xhr.setRequestHeader('Content-type', contentType); }
      // xhr.setRequestHeader('Accept', accept || 'application/json');
      xhr.send(method === 'POST' ? JSON.stringify(request) : null);
    });
  };

  var appendStyles = function() {
    var css = '.sidebar-menu { position: fixed; top: 0; left: 0rem; min-width: 20rem; max-width: 90vw; overflow: auto; height: 100vh; ' +
                'padding: 1rem 1rem 1rem 2rem; border: 1px solid black; background: #fff; box-sizing: border-box; font-size: 1rem;' +
                '-moz-transform: translateX(-100%); -webkit-transform: translateX(-100%); transform: translateX(-100%);' +
                'transition: all 0.1s ease-out;' +
              '}' +
              '.sidebar:hover .sidebar-menu { -moz-transform: none; -webkit-transform: none; transform: none; }' +
              '.sidebar-label { position: fixed; top: 0; left: 0; background: rgb(0,90,156); color: white; z-index: 1; font-size: 1.3rem; padding: 0.6rem; opacity: 0.8; }' +
              '.sidebar .current { background: lightblue }' +
              '.sidebar-dir-btn { background: white; border: 0; outline: none; width: 1.5rem; height: 1rem; }';
    var head = document.head || document.getElementsByTagNameNS('http://www.w3.org/1999/xhtml','head')[0];
    var style = document.createElementNS('http://www.w3.org/1999/xhtml','style');

    style.type = 'text/css';
    style.appendChild(document.createTextNode(css));
    head.appendChild(style);
    console.log('sidebar styles appended');
  };

  var appendSidebar = function() {
    var sidebar = document.createElementNS('http://www.w3.org/1999/xhtml','div');
    sidebar.className = 'sidebar';

    var sidebarLabel = document.createElementNS('http://www.w3.org/1999/xhtml','div');
    sidebarLabel.className = 'sidebar-label';
    sidebarLabel.innerHTML = '\u2630';
    sidebar.appendChild(sidebarLabel);

    var sidebarMenu = document.createElementNS('http://www.w3.org/1999/xhtml','div');
    sidebarMenu.className = 'sidebar-menu';
    sidebarMenu.innerHTML = 'Loading...';
    sidebar.appendChild(sidebarMenu);
    var body = document.body || document.getElementsByTagNameNS('http://www.w3.org/1999/xhtml','body')[0];
    body.appendChild(sidebar);
    console.log('sidebar created');
  };

  var highlightCurrent = function(content) {
    var anchors = content && content.querySelectorAll && content.querySelectorAll('a');
    var currentUrl = location.href.replace('?', '#').split('#')[0];
    if (anchors && anchors.length) {
      [].forEach.call(anchors, function (anchor) {
        if (decodeURIComponent(anchor.href) === decodeURIComponent(currentUrl)) {
          var tr = anchor.parentNode.parentNode;
          if (tr.tagName.toLowerCase() === 'tr') {
            tr.classList.add('current');
          }
        }
      });
    }
  };

  var parseContent = function(table, parent) {
    console.log('parseContent', table);
    if (!table || !table.querySelectorAll) { return table; }
    var menuElems = [];
    var trs = table.querySelectorAll('tr');
    [].forEach.call(trs, function (tr) {
      var tds = tr.querySelectorAll('td');
      if (!tds || tds.length < 3) { return; }
      var a = tds[0].querySelector('a');
      if (!a) { return; }
      menuElems.push({
        link: (parent && parent.href && !/^\//.test(a.href)) ? parent.href + a.getAttribute('href') : a.href,
        name: (a.textContent || a.innerText || '').trim(),
        description: tds[3] && (tds[3].textContent || tds[3].innerText || '').trim()
      });
    });

    if (!menuElems.length) { return table; }
    menuElems = menuElems.filter(function(el) {
      return el && el.link && el.name && (el.name.toLowerCase() !== 'parent directory' || !parent);
    });
    if (!menuElems.length) { menuElems.push({ name: 'Пустой каталог' }); }
    var newMenu = document.createElementNS('http://www.w3.org/1999/xhtml','ul');
    newMenu.style.listStyleType = 'none';
    var currentUrl = location.href.replace('?', '#').split('#')[0];
    menuElems.forEach(function(menuElem, index) {
      var li = document.createElementNS('http://www.w3.org/1999/xhtml','li');
      if (index === 0 && menuElem.name.toLowerCase() === 'parent directory') {
        li.style.marginLeft = '-1rem';
        menuElem.name = 'Родительский каталог';
      }
      if (/\/$/.test(menuElem.name)) {
        var button = document.createElementNS('http://www.w3.org/1999/xhtml','button');
        button.className = 'sidebar-dir-btn';
        button.innerHTML = '+';
        // button.setAttribute('onclick', 'openSidebarDir()');
        button.addEventListener('click', openSidebarDir);
        li.appendChild(button);
        li.style.marginLeft = '-1.5rem';
      }

      var anchor = document.createElementNS('http://www.w3.org/1999/xhtml',menuElem.link ? 'a' : 'span');
      anchor.setAttribute('href', menuElem.link);
      anchor.innerHTML = (menuElem.description || menuElem.name).replace(/\/$/, '');
      li.appendChild(anchor);

      if (decodeURIComponent(menuElem.link) === decodeURIComponent(currentUrl)) {
        li.classList.add('current');
      }
      newMenu.appendChild(li);
    });
    return newMenu;
  };

  var openSidebarDir = function(e) {
    var button = e.target;
    var nextText = button.innerHTML === '+' ? '-' : '+';
    button.innerHTML = '\u00b7\u00b7\u00b7';
    button.setAttribute('disabled', 'disabled');

    var subtree = button.parentNode.querySelector('.sidebar-subtree');
    if (subtree) { subtree.parentNode.removeChild(subtree); }
    if (nextText === '-') {
      var link = button.parentNode.querySelector('a');
      var url = link.href;
      var subtree = document.createElementNS('http://www.w3.org/1999/xhtml','div');
      subtree.className = 'sidebar-subtree';
      loadContent({
        url: url,
        onsuccess: function (content) {
          console.log('content', content);
          subtree.appendChild(content);
          var parsedContent = parseContent(subtree.parentNode.querySelector('.sidebar-subtree > table'), link);
          console.log('parsedContent', parsedContent);
          if (parsedContent) {
            subtree.innerHTML = '';
            subtree.appendChild(parsedContent);
          }
          button.removeAttribute('disabled', 'disabled');
          button.innerHTML = nextText;
        },
        onerror: function(err) {
          subtree.innerHTML = err;
          button.removeAttribute('disabled', 'disabled');
          button.innerHTML = nextText;
        }});
        button.parentNode.appendChild(subtree);
    } else {
      button.removeAttribute('disabled', 'disabled');
      button.innerHTML = nextText;
    }
  };

  var loadContent = function(args) {
    var url = args.url,
        onsuccess = args.onsuccess,
        onerror = args.onerror;
    makeRequest({ url: url })
      .then(function(response) {
        if (!response) { onerror('No content'); return; }
        var parser = new DOMParser();
        var doc = parser.parseFromString(response, 'text/html');
        var docHeadURL = doc.querySelector('meta[name="HeadURL"]');
        var sidebarContent = null;
        if (docHeadURL) { // probably index.xhtml
          var currentHeadURL = document.querySelector('meta[name="HeadURL"]');
          if (currentHeadURL && currentHeadURL.content && currentHeadURL.content === docHeadURL.content) { // if headURLs equal - remove sidebar
            var sidebar = document.querySelector('.sidebar');
            sidebar.parentNode.removeChild(sidebar)
            console.log('removing sidebar');
            return;
          }
          sidebarContent = document.createElementNS('http://www.w3.org/1999/xhtml','div');
          sidebarContent.innerHTML = doc.querySelector('body').innerHTML;
          var scripts = sidebarContent.querySelectorAll('script');
          [].forEach.call(scripts, function (script) { script.parentNode.removeChild(script); });
        } else {
          var table = doc.querySelector('table');
          sidebarContent = table;
        }

        if (sidebarContent) {
          onsuccess(sidebarContent);
        } else {
          onerror('Empty sidebarContent!!!');
        }
      })
      .catch(function(error) {
        onerror('Can\'t create tree:<br/>' + error);
        console.log('sidebar content NOT filled');
      });
  }

  var fillSidebarContent = function() {
    var contentDiv = document.querySelector('.sidebar .sidebar-menu');
    if (!contentDiv) { return false; }
    var url = location.href.split('/').slice(0, -1).join('/');
    contentDiv.innerHTML = '';
    loadContent({
      url: url,
      onsuccess: function (content) {
        contentDiv.appendChild(content);
        highlightCurrent(contentDiv);
        var parsedContent = parseContent(contentDiv.parentNode.querySelector('.sidebar-menu > table'));
        console.log('parsedContent', parsedContent);
        if (parsedContent) {
          contentDiv.innerHTML = '';
          contentDiv.appendChild(parsedContent);
        }
      },
      onerror: function(err) {
        contentDiv.innerHTML = err;
      }});
  };

  appendStyles();
  appendSidebar();
  fillSidebarContent();
}());
