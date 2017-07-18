$("#SearchBtn").click(function () {
    var vals = $(".sl_cdt");
    var formbody = window.parent.frames["SearchBody"].contentWindow.document;
    var inner = "";
    for (var i = 0; i < vals.length; ++i) {
        if (vals[i].value == "")
            continue;
        inner += '<input type="hidden" name="' + vals[i].name + '" value="' + vals[i].value + '" />';
    }
    formbody.getElementById("conditions").innerHTML = inner;
    formbody.getElementById("search_id").value = "";
    formbody.getElementById("form1").submit();
})