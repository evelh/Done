var s = ["province_id", "city_id", "district_id"];//三个select的id

function change(index) {
    var sel = $("#" + s[index]).val();
    var url = "Tools/AddressAjax.ashx?act=district&pid=" + sel;
    var initVal = $("#" + s[index + 1] + "Init") ? $("#" + s[index + 1] + "Init").val() : 0;
    if (index == 0) {
        $("#" + s[1]).empty();
        $("#" + s[1]).append($("<option>").val("").text("请选择"));
    }
    $("#" + s[2]).empty();
    $("#" + s[2]).append($("<option>").val("").text("请选择"));
    
    requestData(url, "", function (data) {
        if (data.code !== 0) {
            show_alert(data.msg);
        } else {
            for (i = 0; i < data.data.length; i++) {
                var option = $("<option>").val(data.data[i].val).text(data.data[i].show);
                $("#" + s[index + 1]).append(option);
            }
            if (initVal != undefined && initVal != 0) {
                $("#" + s[index + 1]).val(initVal);
                $("#" + s[index + 1] + "Init").val(0);
                if (index < 1)
                    change(1);
            }
        }
    })
}

function InitArea() {
    $("#" + s[0]).empty();
    $("#" + s[1]).empty();
    $("#" + s[2]).empty();
    $("#" + s[0]).append($("<option>").val("").text("请选择"));
    $("#" + s[1]).append($("<option>").val("").text("请选择"));
    $("#" + s[2]).append($("<option>").val("").text("请选择"));
    document.getElementById(s[0]).onchange = new Function("change(0)");
    document.getElementById(s[1]).onchange = new Function("change(1)");
    requestData("Tools/AddressAjax.ashx?act=district", "", function (data) {
        if (data.code !== 0) {
            show_alert(data.msg);
        } else {
            for (i = 0; i < data.data.length; i++) {
                var option = $("<option>").val(data.data[i].val).text(data.data[i].show);
                $("#" + s[0]).append(option);
            }

            var initVal = $("#" + s[0] + "Init") ? $("#" + s[0] + "Init").val() : 0;
            if (initVal != undefined && initVal != 0) {
                $("#" + s[0]).val(initVal);
                $("#" + s[0] + "Init").val(0);
                change(0);
            }
        }
    })
    
}
