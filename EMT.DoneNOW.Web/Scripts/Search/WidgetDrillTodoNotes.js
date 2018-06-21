$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


function Edit() {
    if (isTodo == "") {
        window.open("../Activity/Notes.aspx?id=" + entityid, windowObj.notes + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    }
    else {
        window.open("../Activity/Todos.aspx?id=" + entityid, windowObj.todos + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    }
}

function View() {
    window.open("../Activity/ViewActivity.aspx?id=" + entityid, '_blank', 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}

function SetScheduled() {
    requestData("../Tools/ActivityAjax.ashx?act=NoteSetScheduled&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}
function FinishTodo() {
    requestData("../Tools/ActivityAjax.ashx?act=TodoComplete&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}

function ViewCompany() {
    window.open('../Company/ViewCompany.aspx?src=com_activity&id=' + entityid, '_blank', 'left=200,top=200,width=1200,height=1000', false);
}
function ViewOpportunity() {
    window.open('../Opportunity/ViewOpportunity.aspx?id=' + opportunity_id, '_blank', 'left=200,top=200,width=1200,height=1000', false);
}

function Delete() {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + entityid, null, function (data) {
            if (data == true) {
                LayerAlert("删除成功", "确定", function () {
                    window.location.reload();
                })
            }
            else {
                LayerMsg("删除失败");
            }
        })
    }, function () { })
}




var isTodo = "";
var opportunity_id = "";
function RightClickFunc() {

    // new 状态可以完成
    isTodo = "";
    $("#TransTodoMenu").hide();
    $("#CompleteTodoMenu").hide();
    $("#ShowOppoMenu").hide();
    
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ActivityAjax.ashx?act=GetActivity&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.cate_id == "30") {
                    isTodo = "1";
                }
                if (data.opportunity_id != "") {
                    $("#ShowOppoMenu").show();
                    opportunity_id = data.opportunity_id;
                }
            }
        },
    });
    if (isTodo == "") {
        $("#TransTodoMenu").show();
    }
    else {
        $("#CompleteTodoMenu").show();
    }

    ShowContextMenu();
}
