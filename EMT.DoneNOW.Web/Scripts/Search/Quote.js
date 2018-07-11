function Edit() {
    OpenWindow("../Quote/QuoteAddAndUpdate.aspx?id=" + entityid, windowObj.quote + windowType.edit);
}
function ViewOpp() {
    OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + entityid, windowType.blank);
}
function ViewCompany() {
    OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid, windowType.blank);
}
function LossQuote() {
    OpenWindow("../Quote/QuoteLost.aspx?id=" + entityid, windowObj.quote + windowType.manage);
}
function CloseQuote() {
    OpenWindow("../Quote/QuoteClose.aspx?id=" + entityid, windowObj.quote + windowType.manage);
}
function QuotePref() {
    OpenWindow("../Quote/PreferencesQuote.aspx?quote_id=" + entityid, windowType.blank);
}
function QuoteManage() {
    OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + entityid, windowObj.quote + windowType.view);
}
function DeleteQuote() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteAjax.ashx?act=delete&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
        }
    })
}
function View(id) {
    OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + id, windowObj.quote + windowType.view);
}
function Add() {
    OpenWindow("../Quote/QuoteAddAndUpdate.aspx", windowObj.quote + windowType.add);
}
function ViewQuote() {
    OpenWindow("../Quote/QuoteView.aspx?id=" + entityid, windowType.blank);
}
function CloseQuote() {
    if (CanCloseQuote(entityid)) {
        OpenWindow("../Quote/QuoteClose.aspx?id=" + entityid, windowObj.quote + windowType.manage);
    }
}
function CopyQuote() {
    OpenWindow("../Quote/QuoteAddAndUpdate.aspx?copy=1&id=" + entityid, windowObj.quote + windowType.edit);
}

$(".dn_tr").bind("contextmenu", function (event) {
    clearInterval(Times);
    var oEvent = event;
    entityid = $(this).data("val");
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
    var Top = $(document).scrollTop() + oEvent.clientY;
    var Left = $(document).scrollLeft() + oEvent.clientX;
    var winWidth = window.innerWidth;
    var winHeight = window.innerHeight;
    var menuWidth = menu.clientWidth;
    var menuHeight = menu.clientHeight;
    var scrLeft = $(document).scrollLeft();
    var scrTop = $(document).scrollTop();
    var clientWidth = Left + menuWidth;
    var clientHeight = Top + menuHeight;
    if (winWidth < clientWidth) {
        menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
    } else {
        menu.style.left = Left + "px";
    }
    if (winHeight < clientHeight) {
        menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
    } else {
        menu.style.top = Top + "px";
    }
    if (CanCloseQuote(entityid)) {
        // CloseQuote
        $("#CloQuoteMenu").click(function () {
            CloseQuote();
        })
        $("#CloQuoteMenu").css("color", "");
    }
    else {
        $("#CloQuoteMenu").removeAttr("onclick");
        //$("#CloQuoteMenu").unbind("click");
        $("#CloQuoteMenu").css("color","grey");
    }
    

    return false;
});
// // 校验是否可以进行关闭报价
function CanCloseQuote(objId)
{
    var result = false;
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteAjax.ashx?act=CanCloseQuote&objId=" + entityid,
        async: false,
        success: function (data) {
            if (data == "True") {
                result = true;
            }
        }
    })
    return result;
}
