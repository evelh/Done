﻿$("#noData").hide(); $("#SelectLi").hide();
$('.contenttitle ul li').eq(0).before('<li style="text-align:center;padding:0 8px;" onclick="Add()">新增</li>');
function Add() {
    window.open("../SysSetting/ResourceAssPolicyEdit.aspx?resId=" + $("input[name='con2672']").val(), windowObj.resourcePolicy, 'left=0,top=0,location=no,status=no,width=450,height=240', false);
}
function Edit() {
    window.open("../SysSetting/ResourceAssPolicyEdit.aspx?resId=" + $("input[name='con2672']").val() + "&id=" + entityid, windowObj.resourcePolicy, 'left=0,top=0,location=no,status=no,width=450,height=240', false);
}
function Delete() {
    LayerConfirm("您确定要解除此策略的员工吗？\r将此员工与该策略分离将导致系统重新计算员工姓名目前的假期余额（根据参加工作时间计算）。 你确定你要这么做吗？", "确定", "取消", function () {
        requestData("/Tools/TimeoffPolicyAjax.ashx?act=disassociateResource&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            }
        })
    }, function () { })
}