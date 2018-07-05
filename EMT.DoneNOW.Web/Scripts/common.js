
/**
 * ajax 加载数据
 * @param url 地址
 * @param data post数据
 * @param calBackFunction 回掉函数
 */
function requestData(url, data, calBackFunction) {
    url = "http://localhost:60242/" + url;
    $.ajax({
        type: "POST",
        url: url,
        data: data,
        dataType: "JSON",
        timeout: 30000,
        async: true,
        beforeSend : function(){
            //$("body").append(loadDialog);
        },
        success: function (json) {
            if (json != null && json.length == 2 && json[0] == "status=1") {
                LayerLoadClose();
                window.location.href = "/index.aspx";
                return;
            } else if (json != null && json.length == 2 && json[0] == "status=2"){
                LayerLoadClose();
                LayerMsg(json[1]);
                return;
            }
            calBackFunction(json);
        },
        error: function (XMLHttpRequest) {
            LayerMsg('系统错误');
        }
    });
}

/**
 * 日期字符串转换为日期类型
 * @param 日期时间（格式yyyy-MM-dd）
 */
function GetDateFromString(str) {
    var strs = str.split('-');
    var dt = new Date();
    dt.setFullYear(strs[0]);
    dt.setMonth(parseInt(strs[1]) - 1);
    dt.setDate(strs[2]);
    return dt;
}

/**
 * 比较两个日期时间（格式yyyy-MM-dd）
 * @param time1 时间1
 * @param time2 时间2
 * @returns time1大于time2返回true,否则返回false
 */
function compareTime(time1, time2) {
    var arr1 = time1.split("-");
    var arr2 = time2.split("-");
    var date1 = new Date(parseInt(arr1[0]), parseInt(arr1[1]) - 1, parseInt(arr1[2]), 0, 0, 0);
    var date2 = new Date(parseInt(arr2[0]), parseInt(arr2[1]) - 1, parseInt(arr2[2]), 0, 0, 0);
    if (date1.getTime() > date2.getTime()) {
        return true;
    } else {
        return false;
    }
}

// 校验电话格式
function checkPhone(str) {
    var re = /^0\d{2,3}-?\d{7,8}$/;
    if (re.test(str)) {
        return true;
    } else {
        return false;
    }
}

// 校验邮箱
function checkEmail(str) {
    //var re = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
    var re = '^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$';
    if (re.test(str)) {
        return true;
    } else {
        return false;
    }
}

// 校验邮编
function checkPostalCode(str) {
    var re = /^[1-9][0-9]{5}$/;
    if (re.test(str)) {
        return true;
    } else {
        return false;
    }
}
// 去除多余空格 可以更换第二个参数去替换别的
function Trim(str, is_global) {
    var result;
    result = str.replace(/(^\s+)|(\s+$)/g, "");
    if (is_global.toLowerCase() == "g") {
        result = result.replace(/\s/g, "");
    }
    return result;
}

function chooseCompany() {
    window.open("../Common/SelectCallBack.aspx?cat=728&field=ParentComoanyName", 'new', 'left=200,top=200,width=600,height=800', false);
    //window.open(url, "newwindow", "height=200,width=400", "toolbar =no", "menubar=no", "scrollbars=no", "resizable=no", "location=no", "status=no");
    //这些要写在一行
}
// 检查日期是否正确。正确返回true
function check(date) {
    return (new Date(date).getDate() == date.substring(date.length - 2));
}
// 保留两位小数
function toDecimal2(x) {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return "";
    }
    var f = Math.round(x * 100) / 100;
    var s = f.toString();
    var rs = s.indexOf('.');
    if (rs < 0) {
        rs = s.length;
        s += '.';
    }
    while (s.length <= rs + 2) {
        s += '0';
    }
    return s;
}
function toDecimal4(x) {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return "";
    }
    var f = Math.round(x * 10000) / 10000;
    var s = f.toString();
    var rs = s.indexOf('.');
    if (rs < 0) {
        rs = s.length;
        s += '.';
    }
    while (s.length <= rs + 4) {
        s += '0';
    }
    return s;
}

document.write("<script src='../Scripts/layer/layer.js' type='text/javascript'></script>");
// 加载弹层
function LayerLoad() {
    layer.msg("加载中", {
        icon: 16
        , shade: 0.6
        , time: 0
    });
}
// 关闭加载弹层
function LayerLoadClose() {
    layer.closeAll('dialog');
}
// 消息框
function LayerMsg(msg) {
    var index = layer.msg(msg, {
        time: 3000
    });
    layer.style(index, {
        width: 'auto',
        height: 'auto'
    });
}
// 弹层一个按钮
function LayerAlert(msg, btn, btnFunc) {
    layer.confirm(msg, {
        btn: [btn]
    },
        function (index) {
            btnFunc();
            layer.close(index);
        });
}
// 弹层两个按钮
function LayerConfirm(msg, btn1, btn2, btn1Func, btn2Func) {
    layer.confirm(msg, {
        btn: [btn1, btn2]
    },
        function (index) {
            btn1Func();
            layer.close(index);
        },
        function (index) {
            btn2Func();
            layer.close(index);
        });
}
// 弹层两个按钮，一个关闭
function LayerConfirmOk(msg, btn1, btn2, btn1Func) {
    layer.confirm(msg, {
        btn: [btn1, btn2]
    },
        function (index) {
            btn1Func();
            layer.close(index);
        },
        function (index) {
            layer.close(index);
        });
}


// 发送邮件 -- eamil代表接收人的地址
function Email(email) {
    location.href = "mailto:" + email + "";
}
// 返回个带0的整数
function returnNumber(param) {
    if (param < 10) {
        return "0" + param
    }
    return param;
}
function DateDiff(sDate1, sDate2) {    //sDate1和sDate2是2002-12-18格式  
    var aDate, oDate1, oDate2, iDays
    aDate = sDate1.split("-")
    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])    //转换为12-18-2002格式  
    aDate = sDate2.split("-")
    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24)    //把相差的毫秒数转换为天数  
    return iDays
}
function MonthDiff(date1, date2) {
    debugger;
    // 拆分年月日
    date1 = date1.split('-');
    // 得到月数
    totalMonth1 = parseInt(date1[0]) * 12 + parseInt(date1[1]);
    // 拆分年月日
    date2 = date2.split('-');
    // 得到月数
    totalMonth2 = parseInt(date2[0]) * 12 + parseInt(date2[1]);
    var m = Math.abs(totalMonth1 - totalMonth2);
    if (parseInt(date2[2]) >= parseInt(date1[2])) {
        m = m + 1;
    }
    return m;
}


var windowObj = {
    company: 'company',
    contact: 'contact',
    saleOrder: 'saleOrder',
    configurationItem: 'configurationItem',
    subscription: 'subscription',
    quote: 'quote',
    quoteItem: 'quoteItem',
    contract: 'contract',
    contractService : 'contractService',
    contractCost: "contractCost",
    contractCharge: 'contractCharge',
    contractNotRule: 'contractNotRule',
    notes: 'notes',
    todos: 'todos',
    attachment: 'attachment',
    holiday: 'holiday',
    holidaySet: 'holidaySet',
    invoice: 'invoice',
    inventoryLocation: 'inventoryLocation',
    inventoryOrder: 'inventoryOrder',
    inventoryItem: 'inventoryItem',
    inventoryItemSerailNum: 'inventoryItemSerailNum',
    inventoryOrderItem: 'inventoryOrderItem',
    project: 'project',
    projectReport:'projectReport',
    projectTeam: 'projectTeam',
    projectCalendar: 'projectCalendar',
    projectAttach: 'projectAttach',
    projectUdf: 'projectUdf',
    quoteEmailTmpl: 'quoteEmailTmpl',
    expense: "expense",
    expenseReport:"expenseReport",
    workEntry: "workEntry",
    task: "task",
    ticket: "ticket",
    service: "service",
    serviceBundle: "serviceBundle",
    workflow: "workflow",
    timeoffPolicy: "timeoffPolicy",
    masterTicket: 'masterTicket',
    serviceCall: "serviceCall",
    timeoffRequest: 'timeoffRequest',
    kbArticle: "kbArticle",
    select: "select",
    appointment: "appointment",
    resource: "resource",
    resourcePolicy: "resourcePolicy",
    contactGroup: "contactGroup",
    opportunity: "opportunity",
    contactActionTemp: "contactActionTemp",
    formTemp: "formTemp",
    general: "general",
    generalCate: "generalCate",
    resourceWorkGroup: "resourceWorkGroup",
    resourceApproval: "resourceApproval",
    queue: "queue",
    logo:"logo",
    board: "board", 
    CheckListLibrary: "CheckListLibrary",
    shareDashboard: "shareDashboard",
    costCode: "costCode",
    Region:"Region",
    sla: "sla",
    slaItem: "slaItem",
    saleQuota: "saleQuota",
    dataImport: "dataImport",
}
var windowType = {
    blank: '_blank',
    add: 'add',
    edit: 'edit',
    view: 'view',
    manage: 'manage',
}