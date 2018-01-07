$(function () {
    $("#PrintLi").hide();
    $("#ExportLi").hide();
})
// 右键菜单-查看项目
function ViewProject() {
    window.open("../Project/ProjectView.aspx?id=" + entityid, '_blank', 'left=200,top=200,width=900,height=800', false);
}
// 点击查看项目
function View(id) {
    window.open("../Project/ProjectView.aspx?id=" + id, '_blank', 'left=200,top=200,width=900,height=800', false);
}
// 新增项目
function AddProject(type_id, isFromTemp)
{
    var account = "";
    
    if ($("input[name = 'con630']").val() != undefined) {
        account = $("input[name = 'con630']").val();
    }
    if (isFromTemp == undefined || isFromTemp == null)
        isFromTemp = "";
    window.open('../Project/ProjectAddOrEdit?type_id=' + type_id + "&isFromTemp=" + isFromTemp + "&account_id=" + account, windowObj.project + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

