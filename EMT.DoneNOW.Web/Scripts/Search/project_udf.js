$(function () {
    $(".General").hide();

})

$("#options").on("mouseover", function () {
    $(this).css("background", "white");
    $(this).css("border-bottom", "none");
    $("#D1").show();
});
$("#options").on("mouseout", function () {
    $("#D1").hide();
    $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("border-bottom", "1px solid #BCBCBC");
});
$("#D1").on("mouseover", function () {
    $(this).show();
    $("#options").css("background", "white");
    $("#options").css("border-bottom", "none");
});
$("#D1").on("mouseout", function () {
    $(this).hide();
    $("#options").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#options").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#options").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#options").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#options").css("border-bottom", "1px solid #BCBCBC");
});



$("#tools").on("mouseover", function () {
    $(this).css("background", "white");
    $(this).css("border-bottom", "none");
    $("#D2").show();
});
$("#tools").on("mouseout", function () {
    $("#D2").hide();
    $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("border-bottom", "1px solid #BCBCBC");
});
$("#D2").on("mouseover", function () {
    $(this).show();
    $("#tools").css("background", "white");
    $("#tools").css("border-bottom", "none");
});
$("#D2").on("mouseout", function () {
    $(this).hide();
    $("#tools").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#tools").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#tools").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#tools").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#tools").css("border-bottom", "1px solid #BCBCBC");
});

function View(colName) {
    debugger;
    var project_id = $("#id").val();
    window.open("../Project/ProjectUdf.aspx?colName=" + colName + "&object_id=" + project_id + "&object_type=project", windowObj.projectUdf + windowType.edit, 'left=200,top=200,width=400,height=600', false);
}

// 编辑项目
function EditProject() {
    var project_id = $("#id").val();
    window.open("../Project/ProjectAddOrEdit?id=" + project_id, windowObj.project + windowType.edit , 'left=200,top=200,width=600,height=800', false);
}
// 新增日历条目
function AddProCalendar() {
    var project_id = $("#id").val();
    window.open("../Project/ProjectCalendar.aspx?project_id=" + project_id, windowObj.projectCalendar + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}
// 新增项目备注
function AddProjectNote() {
    var project_id = $("#id").val();
    window.open("../Project/TaskNote.aspx?project_id=" + project_id, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}
// 完成项目
function CompleteProject() {
    var project_id = $("#id").val();
    window.open("../Project/ProjectCompleteWizard.aspx?id=" + project_id, windowObj.project + windowType.manage, 'left=200,top=200,width=1080,height=800', false);
}
// 保存为模板
function SaveAsTemp() {
    var project_id = $("#id").val();
    window.parent.location.href = "../Project/ProjectView?type=ScheduleTemp&id=" + project_id;
}
// 从商机复制
function CopyFromOppo() {
    var project_id = $("#id").val();
    //window.parent.location.href = "../Project/CopyUdfToProject?project_id=" + project_id;
    window.open("../Project/CopyUdfToProject.aspx?project_id=" + project_id, windowObj.projectUdf + windowType.blank, 'left=200,top=200,width=480,height=500', false);
}
// 删除项目
function DeleteProject() {
    var project_id = $("#id").val();
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProjectAjax.ashx?act=DeletePro&project_id=" + project_id,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result == "True") {
                    LayerMsg("删除项目成功！");
                    window.close();
                    self.parent.location.reload();
                } else if (data.result == "False") {
                    LayerMsg("该项目不能被删除，因为有一个或多个时间条目，费用，费用，服务预定，备注，附件，里程碑！");
                }
            }
       
        },
    });
}
