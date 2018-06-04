$(function () {
    $("#PrintLi").hide(); 
    $("#ExportLi").hide();
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

function NewTemp(typeId) {
    if (typeId != "") {
        window.open("../SysSetting/FormTemplateManage?formTypeId=" + typeId, windowType.formTemp + windowType.add, 'left=200,top=200,width=1280,height=800', false);
    }
}

function EditTemp() {
    window.open("../SysSetting/FormTemplateManage?id=" + entityid, windowType.formTemp + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}

function Active() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/FormTempAjax.ashx?act=ActiveTmpl&id=" + entityid +"&active=1",
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("激活成功");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}

function InActive() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/FormTempAjax.ashx?act=ActiveTmpl&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("失活成功");
            }
            setTimeout(function () { history.go(0); },800);
        },
    });
}

function Copy() {
    
    window.open("../SysSetting/FormTemplateManage?isCopy=1&id=" + entityid, windowType.formTemp + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function Delete() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/FormTempAjax.ashx?act=DeleteTmpl&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("删除成功");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}
function RightClickFunc() {

    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/FormTempAjax.ashx?act=GetTemp&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                if (data.is_active == "1") {
                    $("#LiActive").hide();
                    $("#LiInActive").show();
                }
                else {
                    $("#LiInActive").hide();
                    $("#LiActive").show();
                }
            }
            else {
                $("#LiActive").hide();
                $("#LiInActive").hide();
            }
        },
    });
    ShowContextMenu();
}