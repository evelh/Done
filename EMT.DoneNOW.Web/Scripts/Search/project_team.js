$(function () {
    $(".General").hide();
})
function Add() {
    var project_id = $("#id").val();
    if (project_id != "") {
        // windowObj.projectTeam + windowType.add
        OpenWindow("../Project/ProjectTeamManage.aspx?project_id=" + project_id, windowObj.quote + windowType.add);
    }
}

function Edit() {
    OpenWindow("../Project/ProjectTeamManage.aspx?id=" + entityid, windowObj.quote + windowType.edit);
}
// 删除员工
function DeleteRes() {
    var project_id = $("#id").val();
    if (project_id != "") {
        var alertMsg = "移除不能恢复，是否继续？";
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=ResIsInTask&team_id=" + entityid + "&project_id=" + project_id,
            async: false,
            //dataType: "json",
            success: function (data) {
                if (data == "True") {
                    alertMsg = "该团队成员关联了任务，如果确认删除，则会从任务中移除该成员。移除不能恢复，是否继续？";
                }
            }
        })
        LayerConfirm(alertMsg, "是", "否", function () { DeleteTeam(entityid); }, function () { });

    }
 

}
// 删除联系人
function DeleteCon() {
    LayerConfirm("移除不能恢复，是否继续？", "是", "否", function () { DeleteTeam(entityid); }, function () { });
}
// 删除成员
function DeleteTeam(team_id) {
    var project_id = $("#id").val();
    if (project_id != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=DelProTeam&team_id=" + entityid + "&project_id=" + project_id,
            async: false,
            success: function (data) {
                if (data == "True") {
                   
                }
                history.go(0);
            }
        })
    }
}

function FindSmilar() {

}

function ReconcileProject() {
    var project_id = $("#id").val();
    if (project_id != "") {
        LayerConfirm("执行此操作后没有分配任务/问题的内部员工，将会被从团队中移除，是否继续？", "是", "否", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=ReconcileProject&project_id=" + project_id,
                async: false,
                //dataType: "json",
                success: function (data) {
                    if (data == "True") {
                        LayerMsg("删除成功！");
                    }
                    history.go(0);
                }
            })
        }, function () { });
        
     
    }
}



$(".dn_tr").bind("contextmenu", function (event) {
    clearInterval(Times);
    var oEvent = event;
    entityid = $(this).data("val");

    $.ajax({
        type: "GET",
        url: "../Tools/ProjectAjax.ashx?act=GetSinProTeam&team_id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                debugger;
                if (data.resource_id == null || data.resource_id == "") {
                    $("#EditTeamMenu").hide();
                    $("#SmilarMenu").hide();
                    $("#DeleteConMenu").hide();
                    $("#DeleteResMenu").show();
                } else {
                    $("#EditTeamMenu").show();
                    $("#SmilarMenu").show();
                    $("#DeleteConMenu").show();
                    $("#DeleteResMenu").hide();
                }
            }
        }
    })


        (function () {
            menu.style.display = "block";
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 1000);
        }());
    menu.onmouseenter = function () {
        clearInterval(Times);
        menu.style.display = "block";
    };
    menu.onmouseleave = function () {
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    };
    var Top = $(document).scrollTop() + oEvent.clientY;
    var Left = $(document).scrollLeft() + oEvent.clientX;
    var winWidth = window.innerWidth;
    var winHeight = window.innerHeight;
    var menuWidth = menu.clientWidth;
    var menuHeight = menu.clientHeight;
    var scrLeft = $(document).scrollLeft();
    var scrTop = $(document).scrollTop();
    var clientWidth = Left + menuWidth;
    var clientHeight = Top + menuHeight;
    if (winWidth < clientWidth) {
        menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
    } else {
        menu.style.left = Left + "px";
    }
    if (winHeight < clientHeight) {
        menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
    } else {
        menu.style.top = Top + "px";
    }


    return false;
});

