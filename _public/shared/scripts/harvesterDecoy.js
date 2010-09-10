function emAdr(_name, host) {
	host = host.split('/');
	document.location.href = 'mailto: '+_name+'@'+host[0]+'.'+host[1];
}