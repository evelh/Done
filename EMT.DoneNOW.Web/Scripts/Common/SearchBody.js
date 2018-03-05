
var entityid;
var menu = document.getElementById("menu");
var menu_i2_right = document.getElementById("menu-i2-right");
var Times = 0;
var oEvent;

$(".dn_tr").bind("contextmenu", function (event) {
    entityid = $(this).data("val");
    oEvent = event;
    if (typeof (RightClickFunc) != 'undefined') {
        RightClickFunc();
    }
    else {
        ShowContextMenu();
    }
    return false;
});

function ViewEntity(id) {
    if (typeof (View) != 'undefined') {
        View(id);
    }
}

function ShowContextMenu() {
    clearInterval(Times);
    (function () {
        menu.style.display = "block";
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    }());
    menu.onmouseenter = function () {
        clearInterval(Times);
        menu.style.display = "block";
    };
    menu.onmouseleave = function () {
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    };
    var Left = $(document).scrollLeft() + oEvent.clientX;
    var Top = $(document).scrollTop() + oEvent.clientY;
    var winWidth = window.innerWidth;
    var winHeight = window.innerHeight;
    var menuWidth = menu.clientWidth; 
    var menuHeight = menu.clientHeight;
    var scrLeft = $(document).scrollLeft();
    var scrTop = $(document).scrollTop();
    var clientWidth = Left + menuWidth;
    var clientHeight = Top + menuHeight;
    var rightWidth = winWidth - oEvent.clientX;
    var bottomHeight = winHeight - oEvent.clientY;
    if (winWidth < clientWidth && rightWidth < menuWidth) {
        menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
    } else {
        menu.style.left = Left + "px";
    }
    if (winHeight < clientHeight && bottomHeight < menuHeight) {
        menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
    }else {
        menu.style.top = Top + "px";
    }

}

document.onclick = function () {
    menu.style.display = "none";
}

function OpenWindow(winname,target) {
    window.open(winname, target, 'left=0,top=0,width=900,height=750,resizable=yes', false);
    //window.open(winname, "_blank", "toolbar=yes, location=yes,directories=no,status=no, menubar=yes, scrollbars=yes,resizable=no, copyhistory=yes, width=600, height=600,top=150,left=300")
}

//实现点击document，自定义菜单消失
document.onclick = function () {
    menu.style.display = "none";
}

function ChangePageSize(num) {
    $("#page_size").val(num);
    $("#form1").submit();
}

function ChangePage(num) {
    $("#page_num").val(num);
    $("#form1").submit();
}

$(".page input").blur(function () {
    var page = $(this).val();
    var crtpage = $("#page_num").val();
    if (page == crtpage)
        return;
    ChangePage(page);
});

// 修改排序列
function ChangeOrder(para) {
    var order = $("#order").val();
    var orderStr = order.split(" ");
    if (para == orderStr[0]) {
        if (orderStr[1] == "asc")
            $("#order").val(para + " desc");
        else
            $("#order").val(para + " asc");
    } else {
        $("#order").val(para + " asc");
    }
    $("#form1").submit();
}



// 导出Execl 相关
$("#ExportLi").click(function () {
    debugger;
    var search = document.getElementById("SearchTable");
    if (search != undefined && search != null && search != "") {
        method1("SearchTable");
    }
    
})
var idTmr;
function getExplorer() {
    var explorer = window.navigator.userAgent;
    //ie
    if (explorer.indexOf("MSIE") >= 0) {
        return 'ie';
    }
    //firefox
    else if (explorer.indexOf("Firefox") >= 0) {
        return 'Firefox';
    }
    //Chrome
    else if (explorer.indexOf("Chrome") >= 0) {
        return 'Chrome';
    }
    //Opera
    else if (explorer.indexOf("Opera") >= 0) {
        return 'Opera';
    }
    //Safari
    else if (explorer.indexOf("Safari") >= 0) {
        return 'Safari';
    }
}
var fileDonwTime = new Date().toISOString().replace(/[\-\:\.]/g, ""); //自定义excel文件名
//var fileName = parent.window.frames["SearchCondition"].getElementsByClassName("header")[0].html; // $(".header").eq(0).html();
var fileName = $(parent.frames["SearchCondition"]).find(".header").eq(0).text();    // 给导出的文件 添加名称
if (fileName != "" && fileName != null && fileName != undefined) {
    fileDonwTime = fileName + " " + fileDonwTime;
}
function method1(tableid) {//整个表格拷贝到EXCEL中
    if (getExplorer() == 'ie') {
        var curTbl = document.getElementById(tableid);
        var oXL = new ActiveXObject("Excel.Application");

        //创建AX对象excel
        var oWB = oXL.Workbooks.Add();
        //获取workbook对象
        var xlsheet = oWB.Worksheets(1);
        //激活当前sheet
        var sel = document.body.createTextRange();
        sel.moveToElementText(curTbl);
        //把表格中的内容移到TextRange中
        sel.select();
        //全选TextRange中内容
        sel.execCommand("Copy");
        //复制TextRange中内容 
        xlsheet.Paste();
        //粘贴到活动的EXCEL中      
        oXL.Visible = true;
        //设置excel可见属性

        try {
            
            var fname = oXL.Application.GetSaveAsFilename(fileDonwTime+".xls", "Excel Spreadsheets (*.xls), *.xls");
        } catch (e) {
            print("Nested catch caught " + e);
        } finally {
            oWB.SaveAs(fname);

            oWB.Close(savechanges = false);
            //xls.visible = false;
            oXL.Quit();
            oXL = null;
            //结束excel进程，退出完成
            //window.setInterval("Cleanup();",1);
            idTmr = window.setInterval("Cleanup();", 1);

        }
    }
    else {
        tableToExcel(tableid)
    }
}
function Cleanup() {
    window.clearInterval(idTmr);
    CollectGarbage();
}
var tableToExcel = (function () {
    var uri = 'data:application/vnd.ms-excel;base64,',
        template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="Content-Type" charset=utf-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
        base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) },
        format = function (s, c) {
            return s.replace(/{(\w+)}/g,
                function (m, p) { return c[p]; })
        }
    return function (table, name) {
        if (!table.nodeType) table = document.getElementById(table)
        var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
        //window.location.href = uri + base64(format(template, ctx))
        a = document.createElement("a");
        a.download = fileDonwTime;
        a.href = uri + base64(format(template, ctx));

        document.body.appendChild(a);

        a.click();

        document.body.removeChild(a);
    }
})()
// 导出Execl 结束