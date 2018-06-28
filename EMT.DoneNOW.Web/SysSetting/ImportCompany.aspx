<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImportCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.ImportCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>导入</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>
<body>
    <div class="header">导入</div>
    <div class="header-title" style="min-width: 500px;">
        <ul>
            <li id="Import">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -208px -32px;" class="icon-1"></i>
                <input type="button" value="导入" />
            </li>
            <li id="Cancle">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <input type="button" value="取消" />
            </li>
        </ul>
    </div>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div style="border:1px solid #d3d3d3;margin:0 10px 12px 10px;padding:4px 0 4px 0;width:836px;">
            <div style="align-items:center;display:flex;overflow:hidden;padding:2px 4px 8px 6px;position:relative;text-overflow:ellipsis;white-space:nowrap;">导入<%=cate==(int)EMT.DoneNOW.DTO.DicEnum.DATA_IMPORT_CATE.COMPANY_CONTACT?"客户和/或联系人":cate==(int)EMT.DoneNOW.DTO.DicEnum.DATA_IMPORT_CATE.CONFIGURATION?"配置项":"" %></div>
            <%if (cate == (int)EMT.DoneNOW.DTO.DicEnum.DATA_IMPORT_CATE.COMPANY_CONTACT){ %>
            <div style="color:#666;font-size:12px;line-height:16px;margin-top:-4px;padding:0 28px 8px 28px;">从一个.csv文件导入客户和/或联系人。如果在导入时匹配到客户或联系人已存在，可以跳过或更新已有数据。客户通过客户名称+客户电话匹配，联系人通过客户名称+客户电话+姓+名+电子邮件匹配。</div>
            <%} else if (cate == (int)EMT.DoneNOW.DTO.DicEnum.DATA_IMPORT_CATE.CONFIGURATION) { %>
            <div style="color:#666;font-size:12px;line-height:16px;margin-top:-4px;padding:0 28px 8px 28px;">从一个.csv文件导入配置项。如果在导入时匹配到配置项已存在，可以跳过或更新已有数据。配置项通过产品名称+客户名称+序列号匹配，或者通过配置项ID匹配。</div>
            <%} %>
            <div style="padding:12px 28px;width:390px;">
                <div>
                    <a style="background:none;border:none;color:#376597;display:inline;font-size:12px;height:auto;padding:0;vertical-align:inherit;display:inline-block;margin-bottom:10px;cursor:pointer;" onclick="DownloadTmp()">下载导入模板</a>
                </div>
                <div>
                    <div><label>文件<span style="color:red;">*</span></label></div>
                    <div><input type="file" name="importFile" /></div>
                </div>
                <div>
                    <div><span style="color:#4f4f4f;display:inline-block;font-weight:700;margin-right:5px;">如果匹配到已存在：</span></div>
                    <div>
                        <input type="radio" id="findLeft" name="findOper" checked="checked" value="0" />
                        <label for="findLeft" style="color:#333;cursor:pointer;font-size:12px;">不更新</label>
                    </div>
                    <div>
                        <input type="radio" id="findUpdate" name="findOper" value="1" />
                        <label for="findUpdate" style="color:#333;cursor:pointer;font-size:12px;">更新已有数据</label>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <div style="display:none;">
        <a id="down" download="<%=cate==(int)EMT.DoneNOW.DTO.DicEnum.DATA_IMPORT_CATE.COMPANY_CONTACT?"客户联系人":cate==(int)EMT.DoneNOW.DTO.DicEnum.DATA_IMPORT_CATE.CONFIGURATION?"配置项":"" %>导入模板.csv" href="#">download</a>
    </div>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script>
        $("#Cancle").click(function () {
            window.history.go(-1);
        })
        $("#Import").click(function () {
            LayerLoad();
            $("#form1").submit();
        })
        function DownloadTmp() {
            requestData("/Tools/SysSettingAjax.ashx?act=GetDataImportFields&cate=<%=cate%>", null, function (data) {
                var str1 = '';
                $.each(data, function (idx) {
                    str1 += data[idx] + ',';
                })

                if (str1 != '')
                    str1 = str1.substr(0, str1.length - 1); 

                str1 = encodeURIComponent(str1);
                
                $("#down").attr("href", "data:text/csv;charset=utf-8,\ufeff" + str1);
                document.getElementById("down").click();
                
            })
        }
        
    </script>
</body>
</html>
