
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
        timeout: 20000,
        async: true,
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

//检测用户浏览器    不符合浏览器则跳转错误页面
function myBrowser() {
    var  userAgent  =  navigator.userAgent; //取得浏览器的userAgent字符串  
          var  isOpera  =  userAgent.indexOf("Opera")  >  -1; //判断是否Opera浏览器  
          var  isIE  =  userAgent.indexOf("compatible")  >  -1  &&  userAgent.indexOf("MSIE")  >  -1  &&  !isOpera; //判断是否IE浏览器  
          var  isEdge  =  userAgent.indexOf("Windows NT 6.1; Trident/7.0;")  >  -1  &&  !isIE; //判断是否IE的Edge浏览器  
          var  isFF  =  userAgent.indexOf("Firefox")  >  -1; //判断是否Firefox浏览器  
          var  isSafari  =  userAgent.indexOf("Safari")  >  -1  &&  userAgent.indexOf("Chrome")  ==  -1; //判断是否Safari浏览器  
          var  isChrome  =  userAgent.indexOf("Chrome")  >  -1  &&  userAgent.indexOf("Safari")  >  -1; //判断Chrome浏览器  

          if  (isIE)       {
                   var  reIE  =  new  RegExp("MSIE (\\d+\\.\\d+);");
                   reIE.test(userAgent);
                   var  fIEVersion  =  parseFloat(RegExp["$1"]);
                   if (fIEVersion  ==  7)
                   {
                       window.location.href = "../error.html";
                       return "IE7";
                   }
                   else  if (fIEVersion  ==  8)
                   { window.location.href = "../error.html"; return  "IE8"; }
                   else  if (fIEVersion  ==  9)
                   { window.location.href = "../error.html";  return  "IE9"; }
                   else  if (fIEVersion  ==  10)
                   {  return  "IE10"; }
                   else  if (fIEVersion  >=  11)
                   {  return  "IE11++"; }
                   else
                   { window.location.href = "../error.html";  return  "0" }//IE版本过低  
           }//isIE end  

           if  (isFF)  {   return  "FF"; }
           if  (isOpera)  {   return  "Opera"; }
           if (isSafari) { window.location.href = "../error.html";   return  "Safari"; }
           if  (isChrome)  {  return  "Chrome"; }
           if  (isEdge)  {  return  "Edge"; }
   }//myBrowser() end  

