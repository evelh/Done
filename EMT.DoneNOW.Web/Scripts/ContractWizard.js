$("#b0").on("click", function () {
    if ($("#currentPage").val() == 0) {
        if ($("#typeSelect").val() == "") {
            alert("请选择合同类型");
            return;
        }
        contractType = $("#typeSelect").val();
        $(".Workspace0").hide();
        SelectType();
        $(".Workspace1").show();
        $("#a0").show();
        $("#currentPage").val(1);
    } else if ($("#currentPage").val() == 1) {
        // TODO:检查必填项
        if ($("#currentPage").val() == 0) {
            $(".Workspace1").hide();
            $("#a0").show();
            $("#currentPage").val(3);
            $("#b0").click();
        } else {
            $(".Workspace1").hide();
            $(".Workspace3").show();
            $("#a0").show();
            $("#currentPage").val(3);
        }
    } else if ($("#currentPage").val() == 3) {
        if (contractType == 1199) {
            $(".Workspace3").hide();
            $(".Workspace4").show();
            $("#currentPage").val(4);
        } else {
            SetTimeReporting();
            $(".Workspace3").hide();
            $(".Workspace5").show();
            $("#currentPage").val(5);
        }
    } else if ($("#currentPage").val() == 4) {
        SetTimeReporting();
        $(".Workspace4").hide();
        $(".Workspace5").show();
        $("#currentPage").val(5);
    } else if ($("#currentPage").val() == 5) {
        if (contractType == 1199 || contractType == 1204) {
            $("#b0").hide();
            $("#c0").show();
            $(".Workspace5").hide();
            $(".Workspace8").show();
            $("#currentPage").val(8);
        } else {
            $(".Workspace5").hide();
            $(".Workspace6").show();
            $("#currentPage").val(6);
        }
    }
});
$("#a0").on("click",function(){
    $(".Workspace0").show();
    $(".Workspace1").hide();
});
$("#d0").on("click",function(){
    window.close();
});
$("#c0").on("click",function(){
    $(".Workspace6").show();
});
$("#all").on("click",function(){
    if($(this).is(":checked")){
        $(".grid input[type=checkbox]").prop('checked',true);
    }else{
        $(".grid input[type=checkbox]").prop('checked',false);
    }
});
$(".ImgLink").on("mousemove",function(){
    $(this).css("background","#fff");
});
$(".ImgLink").on("mouseout",function(){
    $(this).css("background","linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background","-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background","-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background","-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
});

$("#AddButton").on("mouseover",function(){
    $("#AddButton").css("background","#fff");
});
$("#AddButton").on("mouseout",function(){
    $("#AddButton").css("background","#f0f0f0");
});
$("#OkButton").on("mouseover",function(){
    $("#OkButton").css("background","#fff");
})
$("#OkButton").on("mouseout",function(){
    $("#OkButton").css("background","#f0f0f0");
})
$("#CancelButton").on("mouseover",function(){
    $("#CancelButton").css("background","#fff");
})
$("#CancelButton").on("mouseout",function(){
    $("#CancelButton").css("background","#f0f0f0");
})
function InitContact() {
    requestData("../Tools/CompanyAjax.ashx?act=contact&account_id=" + $("#companyNameHidden").val(), null, function (data) {
        $("#contactSelect").html(data);
    })
}
// 根据不同合同类型修改表单内容
function SelectType() {

}
// 设置工时表单
function SetTimeReporting() {

}
var contractType;
window.onload=function () {
    contractType = $("#contractType").val();
    if (contractType == 0) {
        $(".Workspace0").show();
        $("#currentPage").val(0);
    } else {
        $(".Workspace1").show();
        $("#currentPage").val(1);
    }
}
