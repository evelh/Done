$('.contenttitle ul li').eq(0).after('<li style="text-align:center;padding:0 8px;" onclick="Management()">知识库管理</li>');
function Add() {
    window.open("../ServiceDesk/AddRepository.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=800,height=700");
}
function Edit() {
    window.open("../ServiceDesk/AddRepository.aspx?id=" + entityid, "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=800,height=700");
}
function Management() {
    window.open("../ServiceDesk/ManageKnowledgebase.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=*,height=*");
}

function View() {
    window.open("../ServiceDesk/KnowledgebaseDetail?id=" + entityid, "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=*,height=*");
}

function ViewEntity(id){
    window.open("../ServiceDesk/KnowledgebaseDetail?id=" + id, "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=*,height=*");
}
function DeleteServiceBundle() {
    
    LayerConfirm("删除无法恢复，你想继续吗？", "是", "否", function () {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/KnowledgeAjax.ashx?act=DeleteArt&artId=" + entityid,
            dataType: 'json',
            success: function (data) {
                if (data) {
                    LayerMsg("删除成功！");
                } else {
                    LayerMsg("删除失败！");
                }
                history.go(0);
            },
        });
    }, function () { });
}