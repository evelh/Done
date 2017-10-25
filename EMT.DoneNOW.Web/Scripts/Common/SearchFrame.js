$("#SearchBtn").click(function () {
    var vals = $(".sl_cdt");

    var formbody = window.parent.frames["SearchBody"].contentWindow;
    if (formbody == undefined)
        formbody = window.parent.frames["SearchBody"].document;
    else
        formbody = formbody.document;
    var inner = "";
    for (var i = 0; i < vals.length; ++i) {
        if (vals[i].value == "")
            continue;
        inner += '<input type="hidden" name="con' + vals[i].name + '" value="' + vals[i].value + '" />';
    }
    formbody.getElementById("conditions").innerHTML = inner;
    formbody.getElementById("search_id").value = "";
    formbody.getElementById("form1").submit();
});

function OpenQuery(catId, typeId, groupId) {
    window.parent.parent.document.getElementById("PageFrame").src = "Common/SearchFrameSet.aspx?cat=" + catId + "&type=" + typeId + "&group=" + groupId;
    /*
    var formbody = window.parent.frames["SearchBody"];
    var formcondition = window.parent.frames["SearchCondition"];
    formbody.src = "SearchBodyFrame.aspx?cat=" + catId + "&type=" + typeId + "&group=" + groupId;
    formcondition.src = "SearchConditionFrame.aspx?cat=" + catId + "&show=1&type=" + typeId + "&group=" + groupId;
    */
}