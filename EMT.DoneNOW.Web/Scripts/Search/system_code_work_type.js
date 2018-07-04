$(function () {
    $(".General").hide();
})
function AddCode(cateId) {
    window.open("../SysSetting/CostCodeManage.aspx?cateId=" + cateId, windowObj.costCode + windowType.add, 'left=0,top=0,location=no,status=no,width=400,height=350', false);
}
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
function Edit() {
    window.open("../SysSetting/CostCodeManage.aspx?id=" + entityid, windowObj.costCode + windowType.edit, 'left=0,top=0,location=no,status=no,width=400,height=350', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/CostCodeAjax.ashx?act=DeleteCode&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            }
            setTimeout(function () { history.go(0); }, 800);
        }
    })

}
function RightClickFunc() {

    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/CostCodeAjax.ashx?act=CheckCodeDelete&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data) {
                $("#DeleteLi").show();
            }
            else {
                $("#DeleteLi").hide();
            }
        },
    });
    ShowContextMenu();
}

function Exclude() {

    LayerConfirm("提示内容：此工作类型将会从当前活动的合同中排除（出现在例外因素中）。已创建工时不受影响。操作不能撤销，是否继续？", "是", "否", function () {
        $.ajax({
            type: "GET",
            url: "../Tools/CostCodeAjax.ashx?act=ExcludeContract&id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("排除成功！");
                }
                setTimeout(function () { history.go(0); }, 800);
            }
        })
    });
    
}