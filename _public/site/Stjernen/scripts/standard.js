//Function for expanding or collapsing a chosen tag in the XSL template
 function expand(thistag) {
      if(document.getElementById(thistag)){
      styleObj = document.getElementById(thistag).style;
      if (styleObj.display=='none') {styleObj.display = '';}
      else {styleObj.display = 'none';}
      }
}
function externalLinks(){
	if (!document.getElementsByTagName) return;
	var anchors = document.getElementsByTagName("a");
	for(var i=0;i<anchors.length; i++){
		var anchor = anchors[i];
		if(anchor.getAttribute("href") && anchor.getAttribute("rel") == "external"){
			anchor.target = "_blank";
		}
	}
}

function forumValidator() {
    var ok=true;
    if (document.formPosting['author'].value === '') {
      ok=false;
    }
    if (document.formPosting['title'].value === '') {
      ok=false;
    }
    if (document.formPosting['body'].value === '') {
      ok=false;
    }
    if (!ok) {
      alert("Manglende felter.");
      return false;
   }
}

function reportThread(page, key, cat) {
  newwindow=window.open('page?id='+page+'&key='+key+'&cat='+cat, 'name', 'height=250,width=500');
  if (window.focus) {
    newwindow.focus();
  }
  return false;
}

function postingPreview(page) {
  createCookie('postingAuthor', document.getElementById("author").value);
  createCookie('postingEmail', document.getElementById("email").value);
  createCookie('postingTitle', document.getElementById("title").value);
  createCookie('postingBody', document.getElementById("body").value);
  newwindow=window.open('page?id='+page, 'name', 'height=450,width=700,scrollbars=yes');
  if (window.focus) {
    newwindow.focus();
  }
  return false;
}

function addTag(myValue1, myValue2) {
  myField = document.getElementById("body");
  //IE
  if (document.selection) {
    myField.focus();
    sel = document.selection.createRange();
    sel.text = myValue1+sel.text+myValue2;
    myField.focus();
  }
  //MOZILLA/NETSCAPE
  else if (myField.selectionStart || myField.selectionStart == '0') {
    var startPos = myField.selectionStart;
    var endPos = myField.selectionEnd;
    myField.value = myField.value.substring(0, startPos)
    + myValue1 + myField.value.substring(myField.selectionStart, myField.selectionEnd)
    + myValue2 +myField.value.substring(endPos, myField.value.length);
    //myField.selectionStart = startPos+3;
    //myField.selectionEnd = endPos + myValue1.length + startPos;
    myField.focus();
  } else {
    myField.value += myValue1+myValue2;
  }
}

// Cookie-funksjoner
function createCookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
  } else var expires = "";
  document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
      if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
  }
  return null;
}

function eraseCookie(name) {
  createCookie(name,"",-1);
}

function openFunction(obj) {
  selInd =   obj.selectedIndex;
  func = obj.options[selInd].value;
  top.location.href = 'javascript:'+func;
  obj.selectedIndex = 0;  
}

function goTarget(url) {
  window.open(url);
}