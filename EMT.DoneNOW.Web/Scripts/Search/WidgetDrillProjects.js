$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


function EditObject() {
    window.open("../Project/ProjectAddOrEdit.aspx?id=" + entityid, windowObj.project + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
}
function ViewProject() {
    window.open("../Project/ProjectView.aspx?id=" + entityid, '_blank', 'left=200,top=200,width=1080,height=800', false);
}
function NewAddNote() {
    window.open("../Project/TaskNote.aspx?project_id=" + entityid, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}
function AddCalendar() {
    window.open("../Project/ProjectCalendar.aspx?project_id=" + entityid, windowObj.projectCalendar + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}
function ViewFinancials() {
    window.open("../Project/ProjectFinancials.aspx?id=" + entityid,'_blank', 'left=200,top=200,width=1080,height=800', false);
}

function Delete() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProjectAjax.ashx?act=DeletePro&project_id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg("删除项目成功！");
                    setTimeout(function () { self.parent.window.close(); }, 1000)

                } else if (data.result == false) {
                    LayerMsg("该项目不能被删除，因为有一个或多个时间条目，费用，费用，服务预定，备注，附件，里程碑！");
                }
            }
            setTimeout(function () { self.parent.location.reload(); }, 1000)
        },
    });
}
