





$("#CreateNoteLi").on("mouseover", function () {
    $(this).css("background", "white");
    $(this).css("border-bottom", "none");
    $("#D1").show();
});
$("#CreateNoteLi").on("mouseout", function () {
    $("#D1").hide();
    $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("border-bottom", "1px solid #BCBCBC");
});
$("#D1").on("mouseover", function () {
    $(this).show();
    $("#CreateNoteLi").css("background", "white");
    $("#CreateNoteLi").css("border-bottom", "none");
});
$("#D1").on("mouseout", function () {
    $(this).hide();
    $("#CreateNoteLi").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#CreateNoteLi").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#CreateNoteLi").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#CreateNoteLi").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#CreateNoteLi").css("border-bottom", "1px solid #BCBCBC");
});



$("#CreateTodoLi").on("mouseover", function () {
    $(this).css("background", "white");
    $(this).css("border-bottom", "none");
    $("#D2").show();
});
$("#CreateTodoLi").on("mouseout", function () {
    $("#D2").hide();
    $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("border-bottom", "1px solid #BCBCBC");
});
$("#D2").on("mouseover", function () {
    $(this).show();
    $("#CreateTodoLi").css("background", "white");
    $("#CreateTodoLi").css("border-bottom", "none");
});
$("#D2").on("mouseout", function () {
    $(this).hide();
    $("#CreateTodoLi").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#CreateTodoLi").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#CreateTodoLi").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#CreateTodoLi").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#CreateTodoLi").css("border-bottom", "1px solid #BCBCBC");
});

$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked", true);
    }
    else {
        $(".IsChecked").prop("checked", false);
    }
})

function AddToGroup() {
    
    var groupId = "";  
    if ($("input[name = 'con3949']").val() != undefined) {
        groupId = $("input[name = 'con3949']").eq(0).val();
    }
    var contactId = $("#ContactIdHidden").val();
    if (groupId != "" && contactId != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ContactAjax.ashx?act=AddContactsToGroup&ids=" + contactId + "&groupId=" + groupId,
            async: false,
            success: function (data) {
                if (data) {
                    LayerMsg("添加成功！");
                }
                else {
                    LayerMsg("添加失败！");
                }
                setTimeout(function () { history.go(0); }, 800)
            }
        })
    }
    
}

function ContactCallBack() {
    var groupId = "";
    if ($("input[name = 'con3949']").val() != undefined) {
        groupId = $("input[name = 'con3949']").eq(0).val();
    }
     // 查找带回
    window.open("../Common/SelectCallBack.aspx?cat=1661&field=ContactId&muilt=1&callBack=AddToGroup&con3959=" + groupId, 'groupContactSelect', 'left=200,top=200,width=600,height=800', false);
}



function Remove() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length-1);
    }
    var groupId = "";
    if ($("input[name = 'con3949']").val() != undefined) {
        groupId = $("input[name = 'con3949']").eq(0).val();
    }
    if (ids != "" && groupId!="") {
        $.ajax({
            type: "GET",
            url: "../Tools/ContactAjax.ashx?act=RemoveContactFromGroup&ids=" + ids + "&groupId=" + groupId,
            async: false,
            success: function (data) {
                if (data) {
                    LayerMsg("移除成功！");
                }
                else {
                    LayerMsg("移除失败！");
                }
                setTimeout(function () { history.go(0); }, 800)
            }
        })
    } else {
        LayerMsg("请选择要移除的联系人！");
    }
}

function CreateNoteSelect() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);

    }
    var groupId = "";
    if ($("input[name = 'con3949']").val() != undefined) {
        groupId = $("input[name = 'con3949']").eq(0).val();
    }
    if (ids != "" && groupId != "") {
        window.open("../Contact/ExecuteContact.aspx?ids=" + ids + "&chooseType=note", "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }
   
    
}

function CreateNoteAll() {
    var ids = "";
    $(".IsChecked").each(function () {
        ids += $(this).val() + ',';
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
    }
    var groupId = "";
    if ($("input[name = 'con3949']").val() != undefined) {
        groupId = $("input[name = 'con3949']").eq(0).val();
    }
    if (ids != "" && groupId != "") {
        window.open("../Contact/ExecuteContact.aspx?ids=" + ids + "&chooseType=note", "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }

}

function CreateTodoSelect() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);

    }
    var groupId = "";
    if ($("input[name = 'con3949']").val() != undefined) {
        groupId = $("input[name = 'con3949']").eq(0).val();
    }
    if (ids != "" && groupId != "") {
        window.open("../Contact/ExecuteContact.aspx?ids=" + ids + "&chooseType=todo", "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }
}

function CreateTodoAll() {
    var ids = "";
    $(".IsChecked").each(function () {
        ids += $(this).val() + ',';
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
    }
    var groupId = "";
    if ($("input[name = 'con3949']").val() != undefined) {
        groupId = $("input[name = 'con3949']").eq(0).val();
    }
    if (ids != "" && groupId != "") {
        window.open("../Contact/ExecuteContact.aspx?ids=" + ids + "&chooseType=todo", "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }
}


function CreateNoteSingle() {
    window.open("../Contact/ExecuteContact.aspx?ids=" + entityid + "&chooseType=note", "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function CreateTodoSingle() {
    window.open("../Contact/ExecuteContact.aspx?ids=" + entityid + "&chooseType=todo", "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function RemoveSingle() {
    var groupId = "";
    if ($("input[name = 'con3949']").val() != undefined) {
        groupId = $("input[name = 'con3949']").eq(0).val();
    }
    if (groupId != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ContactAjax.ashx?act=RemoveContactFromGroup&ids=" + entityid + "&groupId=" + groupId,
            async: false,
            success: function (data) {
                if (data) {
                    LayerMsg("移除成功！");
                }
                else {
                    LayerMsg("移除失败！");
                }
                setTimeout(function () { history.go(0); }, 800)
            }
        })
    }
}