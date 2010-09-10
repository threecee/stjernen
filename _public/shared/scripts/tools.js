function isInt(str) {
    return /^ *[1-9]+ *$/.test(str);
}
function check(el) {
    var val = el.value;
   
	if (val == '') {
		alert('Du må velge minst 1 vare');
		return false;
	}
	if (!val.match(/^\d+$/)) {
		alert('Ugyldig verdi');
		return false;
	}
	else {
		return true;
	}
}

function cartUpdate(id) {
    var form = document.forms("formCart"+id);
    if (!validateInt(form.count))
    	return false;
    else
    	form.op.value = "cart_update";
	    form.submit();
}

function cartRemove(id) {
    var form = document.forms("formCart"+id);
    form.op.value = "cart_remove";
    form.submit();
}