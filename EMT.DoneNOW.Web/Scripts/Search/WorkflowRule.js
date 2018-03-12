function Add() {
    window.open("../SysSetting/WorkflowRule.aspx", windowObj.workflow + windowType.add, 'left=0,top=0,location=no,status=no,width=1010,height=750', false);
}
function Edit() {
    window.open("../SysSetting/WorkflowRule.aspx?id=" + entityid, windowObj.workflow + windowType.edit, 'left=0,top=0,location=no,status=no,width=1010,height=750', false);
}
function Delete() {
    requestData("../Tools/WorkflowRuleAjax.ashx?act=deleteRule&id=" + entityid, null, function (data) {
        if (data == true)
            window.location.reload();
    })
}
function SetActive() {
    requestData("../Tools/WorkflowRuleAjax.ashx?act=setActive&id=" + entityid, null, function (data) {
        if (data == true)
            window.location.reload();
    })
}
function SetInactive() {
    requestData("../Tools/WorkflowRuleAjax.ashx?act=setInactive&id=" + entityid, null, function (data) {
        if (data == true)
            window.location.reload();
    })
}