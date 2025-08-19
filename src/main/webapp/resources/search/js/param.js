let param={
		index_key : "",
		pQuery_tmp : ""
}

var getParameter = function (name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
function sendPost(action) {
    var form = document.createElement('form');
    form.setAttribute('method', 'post'); //GET 전환 가능
    form.setAttribute('action', action);
    document.charset = "utf-8";
    for ( var key in param) {
        var hiddenField = document.createElement('input');
        hiddenField.setAttribute('type', 'hidden'); //값 입력
        hiddenField.setAttribute('name', key);
        hiddenField.setAttribute('value', param[key]);
        form.appendChild(hiddenField);
    }
    document.body.appendChild(form);
    form.submit();
}
