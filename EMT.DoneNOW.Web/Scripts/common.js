
var isRemember = (window.localStorage.getItem("dn_isRemember") == "true") ? true : false;
var isLogin = (localStorage.getItem("dn_isLogin") == "true") ? true : false;
var token = localStorage.getItem("dn_token");

if (isLogin){
	localStorage.setItem("dn_isLogin",false);
	window.location.href="index.html";
}

/**
 * ajax 加载数据
 * @param url 地址
 * @param type GET/POST
 * @param data post数据
 * @param calBackFunction 回掉函数
 */
function requestData(url, type, data, calBackFunction, bAsync) {
    //$.ajaxSetup({
    //    headers: { 'dn-header': 'dn-request' }
    //});
    if(bAsync == null){
        bAsync = true;
    }
    url = "http://localhost:59895/" + url;
    $.ajax({
        type: type,
        url: url,
        data: data,
        dataType: "JSON",
        timeout: 20000,
        async: bAsync,
        beforeSend : function(){
            //$("body").append(loadDialog);
        },
        success : function(json){
            calBackFunction(json);
            //$("#LoadingDialog").remove();
        },
        error : function(XMLHttpRequest){
            //$("#LoadingDialog").remove();
            //console.log(XMLHttpRequest);
            alert('请检查网络');
        }
    });
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
    var re = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
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

