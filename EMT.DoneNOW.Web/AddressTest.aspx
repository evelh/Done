<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddressTest.aspx.cs" Inherits="EMT.DoneNOW.Web.AddressTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        #Select1 {
            width: 128px;
        }
        #Select2 {
            width: 143px;
        }
        #Select3 {
            width: 131px;
        }
    </style>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input id="AreaProvinceInit" value='5' type="hidden" />
            <input id="AreaCityInit" value='6' type="hidden" />
            <input id="AreaCountyInit" value='8' type="hidden" />
            <select id="AreaProvince" name="D1">
            </select>
            <select id="AreaCity" name="D2">
            </select>
            <select id="AreaCounty" name="D3">
            </select>
            <script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
            <script type="text/javascript">
                $(document).ready(function () {
                    InitArea();
                });
            </script>
        </div>
    </form>
</body>
</html>
