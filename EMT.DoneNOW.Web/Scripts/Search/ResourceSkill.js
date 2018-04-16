$("#noData").hide(); $("#SelectLi").hide();
$("#SearchTable").append("<tr id='addData'><td><select id='selCate'></select></td><td></td><td><select id='selLevel'></select></td><td><input id='desc' type='text'/></td><td><input type='button' value='保存' onclick='SaveNew()' /></td></tr>");
$("#addData").hide();
requestData("/Tools/SysSettingAjax.ashx?act=GetSkillCates&type=1", null, function (data) {
    if (data != null) {
        var opt = "";
        for (var i = 0; i < data.length; i++) {
            opt += "<option value='" + data[i].val + "'>" + data[i].show + "</option>";
        }
        $("#selCate").html(opt);
    }
})
requestData("/Tools/SysSettingAjax.ashx?act=GetDics&id=59", null, function (data) {
    if (data != null) {
        var opt = "";
        for (var i = 0; i < data.length; i++) {
            opt += "<option value='" + data[i].val + "'>" + data[i].show + "</option>";
        }
        $("#selLevel").html(opt);
    }
})
function Add() {
    $("#addData").show();
}
function Delete(id) {
    requestData("/Tools/ResourceAjax.ashx?act=DeleteSkill&id=" + id, null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}
function SaveNew() {
    requestData("/Tools/ResourceAjax.ashx?act=AddSkills&resId=" + $("input[name='con2677']").val() + "&cate=" + $("#selCate").val() + "&level=" + $("#selLevel").val() + "&desc=" + $("#desc").val(), null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}