
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



