<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddTaskAttach.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.AddTaskAttach" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>附件</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <style>
        .content label {
            width: 120px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server"  enctype="multipart/form-data">
        <div class="header">附件</div>
        <div class="header-title">
            <ul>
                <li id="SaveClose">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" />
                </li>
                <li id="SaveNew">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_new" runat="server" Text="保存并新增" OnClick="save_new_Click" />
                </li>
                <li id="Close">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" value="关闭" />
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 132px;">
            <div class="content clear">
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 690px;">
                        <tr>
                            <td>
                                <div class="FieldLabel">
                                    <label>类型</label>
                                    <asp:DropDownList ID="type_id" runat="server" Width="250px"></asp:DropDownList>
                                    <input type="hidden" name="old_file_path" id="old_file_path"/>
                                </div>
                            </td>
                        </tr>
                        <tr id="attTypeTr">
                            <td >
                                <div class="FieldLabel">
                                    <label>附件<span style='color: Red;'>*</span></label>
                                    <input type='file' id='att' name='attFile' style='width: 260px;' />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="FieldLabel">
                                    <label>
                                        名字
                                    </label>
                                    <input type="text" name="name" id="name" style='width:250px;'/>
                                </div>
                            </td>
                        </tr>

                    </table>

                </div>
            </div>



        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/index.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script>
    $("#uploadFile").change(function () {
        debugger;
        var name = $(this).val();
        $("#name").val(name);
    })

    $("#type_id").change(function () {
        if ($(this).val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.ATTACHMENT %>){
            $("#attTypeTr").html("<td class='FieldLabel' width='50%'><div><label>附件<span style='color: Red;'>*</span></label><input type='file' id='att' name='attFile' style='width:260px;' /></div></td>");
        } else if ($(this).val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.FILE_LINK %>){
            $("#attTypeTr").html("<td class='FieldLabel' width='50%'><div><label>文件/文件夹路径<span style='color: Red;'>*</span></label><input type='text' id='att' name='attLink' style='width:250px;' /></div></td>");
        } else if ($(this).val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.FOLDER_LINK %>){
            $("#attTypeTr").html("<td class='FieldLabel' width='50%'><div><label>文件/文件夹路径<span style='color: Red;'>*</span></label><input type='text' id='att' name='attLink' style='width:250px;' /></div></td>");
        } else if ($(this).val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.URL %>){
            $("#attTypeTr").html("<td class='FieldLabel' width='50%'><div><label>URL<span style='color: Red;'>*</span></label><input type='text' id='att' name='attLink' style='width:250px;' /></div></td>");
        }
        $("#att").change(function () {
            attChange();
        })
    })

    $("#att").change(function () {
        debugger;
        var f = document.getElementById("att").files;
        if (f[0].size > Number(10 * 1024*1024)) {
            LayerMsg("上传文件不能大于10M!");
            $(this).val("");
            return false;
        }

        //var file = document.getElementById("att");
        ////file.select();
        //var realPath = getPath(file);
        //alert(realPath);
        //$("#old_file_path").val(realPath);
        attChange();
    })

    function attChange() {
        if ($("#type_id").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.ATTACHMENT %>){
            var file = $('#att').get(0).files[0];
            if (file) {
                if ($("#name").val() == "") {
                    $("#name").val(file.name);
                }
            }
        } else {
            if ($("#name").val() == "") {
                $("#name").val($("#att").val());
            }
        }
    }

    $("#save_close").click(function () {
        debugger;
        var type_id = $("#type_id").val();
        if (type_id == "" || type_id == undefined || type_id == "0") {
            LayerMsg("请选择附件类型");
            return false;
        }
        if (type_id == "<%=EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.ATTACHMENT %>") {
            var att = $('#att').val();
            if (att == "") {
                LayerMsg("请选择附件");
                return false;
            }
         
        } else {
            var att = $('#att').val();
            if (att == "") {
                LayerMsg("请填写相关信息");
                return false;
            }
        }
     
      

        var name = $("#name").val();
        if (att == "") {
            LayerMsg("请填写附件名称");
            return false;
        }
        //alert($('#old_file_path').val());
        //return false;
        return true;
    })
    function getPath(obj) {
        if (obj) {
            if (window.navigator.userAgent.indexOf("MSIE") >= 1) {
                obj.select(); return document.selection.createRange().text;
            }
            else if (window.navigator.userAgent.indexOf("Firefox") >= 1) {
                if (obj.files) {
                    return obj.files.item(0).getAsDataURL();
                }
                return obj.value;
            }
            return obj.value;
        }
    } 
</script>
