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
        if ($("#name").val() == "") {
            alert("请填写合同名称!");
            return;
        }
        if ($("#account_id").val() == "") {
            alert("请选择公司名称!");
            return;
        }
        if ($("#start_date").val() == "") {
            alert("请填写开始日期!");
            return;
        }
        //if ($("#name").val() == "") {
        //    alert("请填写合同名称!");
        //    return;
        //}

        if ($("#cnt").val() == 0) {
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
        if ($("#bill_post_type_id").val() == "") {
            alert("请选择工时计费");
            return;
        }
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
    } else if ($("#currentPage").val() == 6) {
        if (contractType == 1201) {
            $(".Workspace6").hide();
            $(".Workspace7").show();
            $("#currentPage").val(7);
        } else {
            $("#b0").hide();
            $("#c0").show();
            $(".Workspace6").hide();
            $(".Workspace8").show();
            $("#currentPage").val(8);
        }
    } else if ($("#currentPage").val() == 7) {
        $("#b0").hide();
        $("#c0").show();
        $(".Workspace7").hide();
        $(".Workspace8").show();
        $("#currentPage").val(8);
    }
});
$("#a0").on("click",function(){
    if ($("#currentPage").val() == 3) {
        $("#a0").hide();
        $(".Workspace3").hide();
        $(".Workspace1").show();
        $("#currentPage").val(1);
    } else if ($("#currentPage").val() == 4) {
        if ($("#cnt").val() == 0) {
            $("#a0").hide();
            $(".Workspace4").hide();
            $(".Workspace1").show();
            $("#currentPage").val(1);
        } else {
            $(".Workspace4").hide();
            $(".Workspace3").show();
            $("#currentPage").val(3);
        }
    } else if ($("#currentPage").val() == 5) {
        $(".Workspace5").hide();
        if (contractType == 1199) {
            $(".Workspace4").show();
            $("#currentPage").val(4);
        } else {
            if ($("#cnt").val() == 0) {
                $("#a0").hide();
                $(".Workspace1").show();
                $("#currentPage").val(1);
            } else {
                $(".Workspace3").show();
                $("#currentPage").val(3);
            }
        }
    } else if ($("#currentPage").val() == 6) {
        $(".Workspace6").hide();
        $(".Workspace5").show();
        $("#currentPage").val(5);
    } else if ($("#currentPage").val() == 7) {
        $(".Workspace7").hide();
        $(".Workspace6").show();
        $("#currentPage").val(6);
    } else if ($("#currentPage").val() == 8) {
        $(".Workspace8").hide();
        $("#c0").hide();
        $("#b0").show();
        if (contractType == 1201) {
            $(".Workspace7").show();
            $("#currentPage").val(7);
        } else if (contractType == 1199 || contractType == 1204) {
            $(".Workspace5").show();
            $("#currentPage").val(5);
        } else {
            $(".Workspace6").show();
            $("#currentPage").val(6);
        }
    }
});
$("#d0").on("click",function(){
    window.close();
});
$("#c0").on("click", function () {
    $("#form1").submit();
    $("#a0").hide();
    $("#c0").hide();
    $("#d0").show();
    $(".Workspace8").hide();
    $(".Workspace9").show();
    $("#currentPage").val(9);
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
    $.ajax({
        type: "GET",
        url: "../Tools/CompanyAjax.ashx?act=contact&account_id=" + $("#companyNameHidden").val(),
        success: function (data) {
            if (data != "") {
                $("#contactSelect").html(data).removeAttr("disabled");
            }
        },
    });

    //requestData("../Tools/CompanyAjax.ashx?act=contactList&account_id=" + $("#companyNameHidden").val(), null, function (data) {
    //    $("#contactSelect").text(data);
    //})
}
// 根据不同合同类型修改表单内容
function SelectType() {

}
// 设置工时表单
function SetTimeReporting() {

}
function getRadio(index) {
    if (index == 1) {
        $("#occurrences").attr("disabled", "disabled");
        $("#end_date").removeAttr("disabled");
    } else if (index == 2) {
        $("#end_date").attr("disabled", "disabled");
        $("#occurrences").removeAttr("disabled");
    }
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
