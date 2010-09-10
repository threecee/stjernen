var descriptionChanged = false;

function Trim(strValue){
	return LTrim(RTrim(strValue));
}

function LTrim(strValue){
	var LTRIMrgExp = /^\s*/;
	return strValue.replace(LTRIMrgExp, '');
}

function RTrim(strValue){
	var RTRIMrgExp = /\s*$/;
	return strValue.replace(RTRIMrgExp, '');
}

function validateUserinput(form){
	var status = true;

	getFields();
	
	for (var i=0; i < form.length; i++) {
		if (validateInput[form.elements[i].name]) {
			if (!validateInput[form.elements[i].name].pattern.test(Trim(form.elements[i].value))) {
				document.getElementById("msg_" + form.elements[i].name).innerHTML = validateInput[form.elements[i].name].error;
				document.getElementById("msg_" + form.elements[i].name).style.display = "block";
				document.getElementById(form.elements[i].name).className = document.getElementById(form.elements[i].name).className + " error";
				status = false;
			} else {
				var cls = document.getElementById(form.elements[i].name).className;
				cls = cls.split(" ");
				document.getElementById(form.elements[i].name).className = cls[0];
				document.getElementById("msg_" + form.elements[i].name).style.display = "none";
			}
		}
	}
	return status;
}