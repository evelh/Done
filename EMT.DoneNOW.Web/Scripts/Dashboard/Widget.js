
function RefreshWidget(id) {
    $("#widget" + id).children(".LoadingWidget").fadeIn();
    $("#widget" + id).children(".Content")[0].innerHTML = '';
    $("#widget" + id).children(".LoadingWidget").css('opacity', '');
    setTimeout(function () {
        requestData("/Tools/DashboardAjax.ashx?act=GetWidgetInfo&id=" + id, null, function (data) {
            if (data == null) return;
            $("#widget" + id).children(".Draggable").text(data.name);
            if (data.typeId == 2581) {
                CreateBar($("#widget" + id).children(".Content"), data);
            } else if (data.typeId == 2582) {

            } else if (data.typeId == 2583) {
                CreateGuage($("#widget" + id).children(".Content"), data);
            } else if (data.typeId == 2584) {
                CreateGrid($("#widget" + id).children(".Content"), data);
            } else if (data.typeId == 2585) {

            }
            $("#widget" + id).children(".LoadingWidget").fadeOut();
        })
    }, 500)
}

function DeleteWidget(id) {
    LayerConfirmOk("删除操作将不能恢复，是否继续?", "确定", "取消", function () {
        requestData("/Tools/DashboardAjax.ashx?act=DeleteWidget&id=" + id, null, function (data) {
            if (data != true)
                RefreshDashboard();
            else {
                $("#widget" + id).remove();
            }
        })
    })
}

$('input:radio[name="addWidgetType"]').click(function () {
    if ($('input:radio[name="addWidgetType"]:checked').val() == "1") {
        $("#addWidgetEntity").removeAttr("disabled");
        $("#addWidgetTypeSelect").removeAttr("disabled");
    } else {
        $("#addWidgetEntity").attr("disabled", "disabled");
        $("#addWidgetTypeSelect").attr("disabled", "disabled");
    }
})
var widgetEntityList;
var widgetTypeList;
function AddWidgetStep0() {
    ShowLoading();
    setTimeout(function () {
        requestData("/Tools/DashboardAjax.ashx?act=GetWidgetEntityList", null, function (data) {
            widgetEntityList = data;
            $("#addWidgetEntity").empty();
            $("#addWidgetEntity").unbind("change");
            for (var i = 0; i < data.length; i++) {
                $("#addWidgetEntity").append("<option value='" + data[i].id + "'>" + data[i].name + "</option>");
            }
            requestData("/Tools/DashboardAjax.ashx?act=GetWidgetTypeList", null, function (data) {
                widgetTypeList = data;
                WidgetEntityChange();
                $("#addWidgetEntity").change(function () { WidgetEntityChange();})
                HideLoading();
                $("#cover").show();
                $('#AddWidget').show();
            })
        })
    }, 200);
}
function WidgetEntityChange() {
    $("#addWidgetTypeSelect").empty();
    var ett;
    for (var i = 0; i < widgetEntityList.length; i++) {
        if (widgetEntityList[i].id == $("#addWidgetEntity").val()) {
            ett = widgetEntityList[i];
            break;
        }
    }
    for (var i = 0; i < ett.type.length; i++) {
        for (var j = 0; j < widgetTypeList.length; j++) {
            if (ett.type[i] == widgetTypeList[j].val) {
                $("#addWidgetTypeSelect").append("<option value='" + widgetTypeList[i].val + "'>" + widgetTypeList[i].show + "</option>");
                break;
            }
        }
    }
}
function BackAddWidgetStep0() {
    LayerConfirmOk("如果返回前一步，所有未保存的更改将会丢失，是否继续？", "确定", "取消", function () {
        $('#AddWidget').show();
        $('#AddWidgetBefore').hide();
    })
}
function AddWidgetStep1() {
    if ($('input:radio[name="addWidgetType"]:checked').val() == "1") {
        for (var i = 0; i < widgetEntityList.length; i++) {
            if (widgetEntityList[i].id == $("#addWidgetEntity").val()) {
                $("#addWidgetEntityName").text(widgetEntityList[i].name);
                break;
            }
        }
        var yidx = -60 * ThemeIdx - 1;
        $("#chartBasicVisual").empty();
        $("#chartAdvVisual").empty();
        $("#chartBasicVisual").append('<li class="ClickNow WidgetVisual" data-visual="2545" style="background-position:-61px ' + yidx + 'px" title="饼图"></li>');
        $("#chartBasicVisual").append('<li class="ClickNo WidgetVisual" data-visual="2546" style="background-position:0px ' + yidx + 'px" title="圆环图"></li>');
        $("#chartBasicVisual").append('<li class="ClickNo WidgetVisual" data-visual="2547" style="background-position:-481px ' + yidx + 'px" title="折线图"></li>');
        $("#chartBasicVisual").append('<li class="ClickNo WidgetVisual" data-visual="2548" style="background-position:-181px ' + yidx + 'px" title="条形图"></li>');
        $("#chartBasicVisual").append('<li class="ClickNo WidgetVisual" data-visual="2549" style="background-position:-121px ' + yidx + 'px" title="柱状图"></li>');
        $("#chartBasicVisual").append('<li class="ClickNo WidgetVisual" data-visual="2556" style="background-position:-421px ' + yidx + 'px" title="堆积面积图"></li>');
        $("#chartBasicVisual").append('<li class="ClickNo WidgetVisual" data-visual="2558" style="background-position:-541px ' + yidx + 'px" title="漏斗图"></li>');
        $("#chartAdvVisual").append('<li class="ClickNo WidgetVisual" data-visual="2553" style="background-position:-361px ' + yidx + 'px" title="分组柱状图"></li>');
        $("#chartAdvVisual").append('<li class="ClickNo WidgetVisual" data-visual="2552" style="background-position:-1021px ' + yidx + 'px" title="分组条形图"></li>');
        $("#chartAdvVisual").append('<li class="ClickNo WidgetVisual" data-visual="2551" style="background-position:-241px ' + yidx + 'px" title="堆积柱状图"></li>');
        $("#chartAdvVisual").append('<li class="ClickNo WidgetVisual" data-visual="2550" style="background-position:-901px ' + yidx + 'px" title="堆积条形图"></li>');
        $("#chartAdvVisual").append('<li class="ClickNo WidgetVisual" data-visual="2555" style="background-position:-301px ' + yidx + 'px" title="百分比堆积柱状图"></li>');
        $("#chartAdvVisual").append('<li class="ClickNo WidgetVisual" data-visual="2554" style="background-position:-961px ' + yidx + 'px" title="百分比堆积条形图"></li>');
        $("#chartAdvVisual").append('<li class="ClickNo WidgetVisual" data-visual="2557" style="background-position:-841px -1px" title="表格"></li>');
        $(".ClickNo").click(function () {
            ChooseVisual(this);
        })
        ChooseVisual($(".ClickNow"));
        requestData("/Tools/DashboardAjax.ashx?act=GetWidgetFilter&id=" + $("#addWidgetEntity").val(), null, function (data) {
            InitWidgetFilter(data);
        });
        $('#AddWidget').hide();
        $('#AddWidgetBefore').show();
    }
}
function AddWidgetFinish() {
    $("#addWidgetForm").submit(function () {
        jQuery.ajax({
            url: 'Tools/DashboardAjax.ashx?act=AddWidget',
            data: $('#addWidgetForm').serialize(),
            type: "POST",
            beforeSend: function () {
            },
            success: function (data) {
                LayerMsg(data);
            }
        });
        return false;
    })
    $("#addWidgetForm").submit();
}
function ChooseVisual(dom) {
    $(".ClickNow").removeClass("ClickNow").addClass("ClickNo").click(function () { ChooseVisual(this); });
    var type = $(dom).addClass("ClickNow").removeClass("ClickNo").unbind("click").data("visual");
    $("#wgtVisualType").val(type);
    if (type == 2545 || type == 2546 || type == 2557 || type == 2558) {
        $("#wgtShowAxis").prop("checked", false);
        $("#wgtShowAxis").attr("disabled", "disabled");
    } else {
        $("#wgtShowAxis").removeAttr("disabled");
        $("#wgtShowAxis").prop("checked", true);
    }
    if (type == 2547 || type == 2549 || type == 2556) {
        $("#wgtShowTrendline").removeAttr("disabled");
        $("#wgtShowTrendline").prop("checked", false);
    } else {
        $("#wgtShowTrendline").prop("checked", false);
        $("#wgtShowTrendline").attr("disabled", "disabled");
    }
    if (type == 2547 || type == 2548 || type == 2549) {
        $("#wgtShowTwoAxis").removeAttr("disabled");
        $("#wgtShowTwoAxis").prop("checked", false);
    } else {
        $("#wgtShowTwoAxis").prop("checked", false);
        $("#wgtShowTwoAxis").attr("disabled", "disabled");
    }
    if (type == 2545 || type == 2546 || type == 2556 || type == 2558) {
        $("#wgtReport2").attr("disabled", "disabled");
        $("#wgtReportType2").attr("disabled", "disabled");
    } else {
        $("#wgtReport2").removeAttr("disabled");
        $("#wgtReportType2").removeAttr("disabled");
    }
    if (type == 2545 || type == 2546 || type == 2547 || type == 2548 || type == 2549 || type == 2556 || type == 2558) {
        $("#wgtGroup2").attr("disabled", "disabled");
    } else {
        $("#wgtGroup2").removeAttr("disabled");
    }
}
function InitWidgetFilter(data) {
    var str = "<option value=''></option>";
    for (var i = 0; i < data.length; i++) {
        str += "<option value='" + data[i][0].description + "'>" + data[i][0].description + "</option>";
    }
    $(".wgtFilter").each(function () { $(this)[0].innerHTML = str; });
    //document.getElementById("wgtFilter1").innerHTML = str;
    //document.getElementById("wgtFilter2").innerHTML = str;
    //document.getElementById("wgtFilter3").innerHTML = str; 
    //document.getElementById("wgtFilter4").innerHTML = str;
    //document.getElementById("wgtFilter5").innerHTML = str;
    //document.getElementById("wgtFilter6").innerHTML = str;
    $(".wgtFilter").unbind("change").bind("change", function () {
        FilterChange($(this).data("val"));
    })
    $(".wgtOper").unbind("change").bind("change", function () {
        OperChange($(this).data("val"));
    })
    function FilterChange(idx) {
        var sltValue = $("#wgtFilter" + idx).val();
        if (sltValue == "") {
            //document.getElementById("def1oper" + idx).innerHTML = "<option>(选择一个操作符)</option>";
            //$("#def1val" + idx + "0").hide();
            //$("#def1val" + idx + "1").hide();
            //if (idx < 4 && $("#def1pro" + (idx + 1)).val() == "") {
            //    $("#def1pro" + (idx + 1)).attr("disabled", "disabled");
            //    $("#def1oper" + (idx + 1)).attr("disabled", "disabled");
            //}
            //if (idx > 0 && $("#def1pro" + (idx - 1)).val() == "") {
            //    $("#def1pro" + idx).attr("disabled", "disabled");
            //    $("#def1oper" + idx).attr("disabled", "disabled");
            //}
        } else {
            var str = "";
            for (var i = 0; i < data.length; i++) {
                if (data[i][0].description != sltValue) { continue; }
                for (var j = 0; j < data[i].length; j++) {
                    str += "<option value='" + data[i][j].operator_type_id + "'>" + data[i][j].operatorName + "</option>";
                }
                break;
            }
            $("#wgtFilter" + idx + "Oper")[0].innerHTML = str;
            OperChange(idx);
            //if (idx < 4) {
            //    $("#def1pro" + (idx + 1)).removeAttr("disabled");
            //    $("#def1oper" + (idx + 1)).removeAttr("disabled");
            //}
        }
    }
    function OperChange(idx) {
        if ($("#wgtFilter" + idx + "Oper").val() == "") { return; }
        var proValue = $("#wgtFilter" + idx).val();
        var operValue = $("#wgtFilter" + idx + "Oper").val();
        for (var i = 0; i < data.length; i++) {
            if (data[i][0].description != proValue) { continue; }
            for (var j = 0; j < data[i].length; j++) {
                if (operValue != data[i][j].operator_type_id) { continue; }
                var cdt = data[i][j];
                var sltVals = "";
                if (cdt.values != null) {
                    for (var k = 0; k < cdt.values.length; k++) {
                        sltVals += "<option value='" + cdt.values[k].val + "'>" + cdt.values[k].show + "</option>";
                    }
                }
                if (cdt.data_type == 820) {
                    $("#wgtFilter" + idx + "Val0").hide();
                    $("#wgtFilter" + idx + "Val1").hide();
                    $("#mlt" + idx).hide();
                } else if (cdt.data_type == 809) {
                    $("#wgtFilter" + idx + "Val0")[0].innerHTML = sltVals;
                    $("#wgtFilter" + idx + "Val0").show();
                    $("#wgtFilter" + idx + "Val1").hide();
                    $("#mlt" + idx).hide();
                } else if (cdt.data_type == 805 || cdt.data_type == 806) {
                    $("#wgtFilter" + idx + "Val0").hide();
                    $("#wgtFilter" + idx + "Val1").show();
                    $("#mlt" + idx).hide();
                } else if (cdt.data_type == 810) {
                    $("#mltslt" + idx)[0].innerHTML = sltVals;
                    $("#wgtFilter" + idx + "Val0").hide();
                    $("#wgtFilter" + idx + "Val1").hide();
                    $("#mlt" + idx).show();
                    $("#mltslt" + idx).change(function () {
                        $("#wgtFilter" + idx + "Val2").val($(this).val());
                    }).multipleSelect({
                        width: '100%'
                    })
                }
            }
            break;
        }
    }
}
$(".widgetSizeList").children().click(function () {
    $(this).addClass("widgetSizeListNow").siblings().removeClass("widgetSizeListNow");
})


function CreateBar(dom, data) {
    var str = '<div class="TableTotal">总计：  ' + data.totalCnt + '</div><div class="GaugeContainerCanvas" id="widget' + data.id + 'container0"></div>';
    dom[0].innerHTML = str;
    if (data.visualType == 2545)
        CreateWidgetPie(data.id, data.group1, data.report1);
    else if (data.visualType == 2546)
        CreateWidgetDoughnut(data.id, data.group1, data.report1, data.totalCnt);
    else if (data.visualType == 2547)
        CreateWidgetLine(data.id, data.group1, data.report1, data.report2);
    else if (data.visualType == 2556)
        CreateWidgetArea(data.id, data.group1, data.report1);
    else if (data.visualType == 2557)
        CreateWidgetGrid(dom, data);
    else if (data.visualType == 2558)
        CreateWidgetFunnel(data.id, data.group1, data.report1);
    else if (data.visualType == 2554 || data.visualType == 2555)
        CreateWidgetBarPercent(data);
    else if (data.isx == 1 || data.isy == 1)
        CreateWidgetBar(data);
}

function CreateWidgetBar(data) {
    var myChart = echarts.init(document.getElementById('widget' + data.id + 'container0'));

    var ser = new Array();
    if (data.group2 == null && data.report2 == null) {
        ser[0] = {
            data: data.report1,
            type: 'bar',
            itemStyle: {
                normal: {
                    color: function (params) {
                        return SelectTheme[params.dataIndex % SelectTheme.length];
                    },
                },

            },
        };
    } else if (data.report2 != null) {
        ser[0] = {
            data: data.report1,
            name: data.columns[0],
            type: 'bar',
            stack: data.isStack,
            itemStyle: {
                normal: {
                    color: SelectTheme[0],
                },

            },
        };
        ser[1] = {
            data: data.report2,
            name: data.columns[1],
            type: 'bar',
            stack: data.isStack,
            itemStyle: {
                normal: {
                    color: SelectTheme[1],
                },

            },
        };
    } else {
        for (var i = 0; i < data.report1.length; i++) {
            ser[i] = {
                data: data.report1[i],
                name: data.group2[i],
                type: 'bar',
                stack: data.isStack,
                itemStyle: {
                    normal: {
                        color: SelectTheme[i % SelectTheme.length],
                    },

                },
            };
        }
    }

    var option = {
        yAxis: data.isx == 1 ? {
            type: 'value'
        } : {
                type: 'category',
                data: data.group1,
            },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '12%',
            containLabel: true
        },
        xAxis: data.isx == 1 ? {
            type: 'category',
            data: data.group1,
        } : {
                type: 'value'
            },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'none'
            },
            backgroundColor: '#fff',
            borderWidth: 1,
            padding: [5, 10],
            textStyle: {
                color: '#000'
            }
        },
        series: ser
    };
    myChart.setOption(option);

    //点击事件
    myChart.on('click', function (params) {
        if (data.group2 == null) {
            WidgetClick(data.id, params.name, null);
        } else {
            WidgetClick(data.id, params.name, params.seriesName);
        }
    });
}

function CreateWidgetBarPercent(data) {
    var myChart = echarts.init(document.getElementById('widget' + data.id + 'container0'));
    var max = 1;
    for (var i = 0; i < data.report1.length; i++) {
        if (data.report1[i] != null && parseFloat(data.report1[i]) > max)
            max = parseFloat(data.report1[i]);
    }
    if (data.report2 != null) {
        for (var i = 0; i < data.report2.length; i++) {
            if (data.report2[i] != null && parseFloat(data.report2[i]) > max)
                max = parseFloat(data.report2[i]);
        }
    }
    var repPercent1 = new Array();
    var repPercent2 = new Array();
    for (var i = 0; i < data.report1.length; i++) {
        repPercent1[i] = data.report1[i];
        if (data.report1[i] != null)
            repPercent1[i] = parseFloat(data.report1[i]) * 100 / max;
    }
    if (data.report2 != null) {
        for (var i = 0; i < data.report2.length; i++) {
            repPercent2[i] = data.report2[i];
            if (data.report2[i] != null)
                repPercent2[i] = parseFloat(data.report2[i]) * 100 / max;
        }
    }
    var ser = new Array();
    if (data.group2 == null && data.report2 == null) {
        ser[0] = {
            data: repPercent1,
            type: 'bar',
            itemStyle: {
                normal: {
                    color: function (params) {
                        return SelectTheme[params.dataIndex % SelectTheme.length];
                    },
                },

            },
        };
    } else if (data.report2 != null) {
        ser[0] = {
            data: repPercent1,
            name: data.columns[0],
            type: 'bar',
            stack: data.isStack,
            itemStyle: {
                normal: {
                    color: SelectTheme[0],
                },

            },
        };
        ser[1] = {
            data: repPercent2,
            name: data.columns[1],
            type: 'bar',
            stack: data.isStack,
            itemStyle: {
                normal: {
                    color: SelectTheme[1],
                },

            },
        };
    } else {
        for (var i = 0; i < data.report1.length; i++) {
            ser[i] = {
                data: repPercent1[i],
                name: data.group2[i],
                type: 'bar',
                stack: data.isStack,
                itemStyle: {
                    normal: {
                        color: SelectTheme[i % SelectTheme.length],
                    },

                },
            };
        }
    }

    var option = {
        yAxis: data.isx == 1 ? {
            type: 'value'
        } : {
                type: 'category',
                data: data.group1,
            },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '12%',
            containLabel: true
        },
        xAxis: data.isx == 1 ? {
            type: 'category',
            data: data.group1,
        } : {
                type: 'value'
            },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'none'
            },
            formatter: function (params) {
                var str = params[0].name + ":" + params[0].value * max / 100;
                return str
            },
            backgroundColor: '#fff',
            borderWidth: 1,
            padding: [5, 10],
            textStyle: {
                color: '#000'
            }
        },
        series: ser
    };
    myChart.setOption(option);

    //点击事件
    myChart.on('click', function (params) {
        if (data.group2 == null) {
            WidgetClick(data.id, params.name, null);
        } else {
            WidgetClick(data.id, params.name, params.seriesName);
        }
    });
}

function CreateWidgetFunnel(id, group, data) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container0'));
    //实例化样式
    var dataStyle = {
        normal: {
            label: {
                show: false
            },
            labelLine: {
                show: false
            },
            borderColor: 'none',
            borderWidth: 0,
        }
    };
    
    var ser = new Array();
    for (var i = 0; i < data.length; i++) {
        ser[i] = {
            name: group[i],
            value: data[i],
            itemStyle: {
                color: SelectTheme[i % SelectTheme.length],
            },
            tooltip: {
                confine: false,
                backgroundColor: '#fff',
                borderColor: SelectTheme[i % SelectTheme.length],
                borderWidth: 1,
                padding: [5, 10],
                textStyle: {
                    color: '#000'
                }
            }
        };
    }
    

    //数据填充
    var option = {

        tooltip: {
            trigger: 'item',
            formatter: "{b}:{c} "
        },

        calculable: true,
        series: [{
            type: 'funnel',
            left: '10%',
            top: 30,
            bottom: 10,
            width: '80%',
            label: {
                normal: {
                    show: false,
                },
                emphasis: {
                    show: false,
                }
            },

            itemStyle: dataStyle,
            data: ser
        }]
    };
    myChart.setOption(option);
    
    myChart.on('click', function (params) {
        WidgetClick(id, params.name, null);
    });
}

function CreateWidgetPie(id, group, data) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container0'));
    //实例化样式
    var dataStyle = {
        normal: {
            label: {
                show: false
            },
            labelLine: {
                show: false
            },
        }
    };

    var ser = new Array();
    for (var i = 0; i < data.length; i++) {
        ser[i] = {
            name: group[i],
            value: data[i],
            itemStyle: {
                color: SelectTheme[i % SelectTheme.length],
                borderWidth: 2,
                borderColor: '#fff'
            },
            tooltip: {
                confine: false,
                backgroundColor: '#fff',
                borderColor: SelectTheme[i % SelectTheme.length],
                borderWidth: 1,
                padding: [5, 10],
                textStyle: {
                    color: '#000'
                }
            }
        };
    }

    //数据填充
    var option = {

        tooltip: {
            trigger: 'item',
            formatter: name
        },

        series: [{
            type: 'pie',
            hoverAnimation: false,
            itemStyle: dataStyle,
            data: ser
        }]
    };
    
    myChart.setOption(option);

    myChart.on('click', function (params) {
        WidgetClick(id, params.name, null);
    });
}

function CreateWidgetDoughnut(id, group, data, total) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container0'));
    var dataStyle = {
        normal: {
            label: {
                show: false
            },
            labelLine: {
                show: false
            },
        }
    };
    var ser = new Array();
    for (var i = 0; i < data.length; i++) {
        ser[i] = {
            name: group[i],
            value: data[i],
            itemStyle: {
                color: SelectTheme[i % SelectTheme.length],
                borderWidth: 2,
                borderColor: '#fff'
            },
            tooltip: {
                confine: false,
                backgroundColor: '#fff',
                borderColor: SelectTheme[i % SelectTheme.length],
                borderWidth: 1,
                padding: [5, 10],
                textStyle: {
                    color: '#000'
                }
            }
        };
    }

    //数据填充
    var option = {
        title: {
            text: total,
            x: 'center',
            y: 'center',
            textStyle: {
                fontWeight: 'normal',
                color: "#000",
                fontSize: 40
            }
        },
        tooltip: {
            trigger: 'item',
            formatter: name
        },

        series: [{
            type: 'pie',
            radius: ['50%', '80%'],
            hoverAnimation: false,
            itemStyle: dataStyle,
            data: ser
        }]
    };
    
    myChart.setOption(option);

    myChart.on('click', function (params) {
        WidgetClick(id, params.name, null);
    });
}

function CreateWidgetLine(id, group, data1, data2) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container0'));
    var ser = new Array();
    //data2 = [2, 4, 7, 2, 4];
    if (data2 != null) {
        ser = [{
            data: data1,
            type: 'line',
            itemStyle: {
                normal: {
                    color: SelectTheme[0],
                },

            },
        }, {
            data: data2,
            type: 'line',
            itemStyle: {
                normal: {
                    color: SelectTheme[1],
                },

            },
        }];
    } else {
        ser = [{
            data: data1,
            type: 'line',
            itemStyle: {
                normal: {
                    color: function (params) {
                        return SelectTheme[params.dataIndex % SelectTheme.length];
                    },
                },

            },
        }];
    }
    var option = {
        xAxis: {
            type: 'category',
            data: group
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '12%',
            containLabel: true
        },
        yAxis: {
            type: 'value'
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'none'
            },
            backgroundColor: '#fff',
            borderWidth: 1,
            padding: [5, 10],
            textStyle: {
                color: '#000'
            }
        },
        series: ser
    };
    myChart.setOption(option);

    myChart.on('click', function (params) {
        WidgetClick(id, params.name, null);
    });
}

function CreateWidgetArea(id, group, data) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container0'));
    var option = {
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: group
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '12%',
            containLabel: true
        },
        yAxis: {
            type: 'value'
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'none'
            },
            backgroundColor: '#fff',
            borderWidth: 1,
            padding: [5, 10],
            textStyle: {
                color: '#000'
            }
        },
        series: [{
            data: data,
            type: 'line',
            areaStyle: {
                normal: {}
            },
        }]
    };
    myChart.setOption(option);

    myChart.on('click', function (params) {
        WidgetClick(id, params.name, null);
    });
}

function CreateWidgetGrid(dom, data) {
    //str = '<div class="TableTotal"></div>';
    var str = '<div class="GaugeContainerTable"><table cellpadding="0" cellspacing="0" class="Table1">';
    if (data.gridHeader != null) {
        str += '<tr class="HeaderContainer">';
        for (var i = 0; i < data.gridHeader.length; i++) {
            str += '<td>' + data.gridHeader[i] + '</td>';
        }
        str += '</tr>';
    }
    for (var i = 0; i < data.gridData.length; i++) {
        str += '<tr>';
        for (var j = 0; j < data.gridData[i].length; j++) {
            str += '<td>' + data.gridData[i][j] + '</td>';
        }
        str += '</tr>';
    }
    str += '</table></div>';
    dom[0].innerHTML = str;
}

function CreateGuage(dom, data) {
    var cssName = ['one', 'two', 'three', 'four', 'five', 'six'];
    for (var i = 0; i < data.totalCnt; i++) {
        var str = '<div class="GaugeContainer-' + cssName[data.totalCnt - 1] + '"><div class="GaugeContainerCanvas"  id="widget' + data.id + 'container' + i + '"></div><div class="footertitle">' + data.guageList[i][1] + '</div></div>';
        dom[0].innerHTML += str;
    }
    
    $.each($('.WidgetShell'), function (i) {
        if ($('.WidgetShell').eq(i).data('size') > 1) {
            //two
            $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-two').css({
                'width': '50%',
                'height': '100%',
                'float': 'left',
            })
            //three
            $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-three').css({
                'width': '33.33%',
                'height': '100%',
                'float': 'left',
            })
            $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-three').children('.GaugeContainerCanvas').css({ 'width': '100%', 'height': '80%' })
            $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-three').children('.footertitle').css({ 'width': '100%', 'height': '20%', 'text-align': 'center', 'display': 'inline' })
            $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-three').children('.TableTotal').css({ 'width': '100%', 'height': '20%', 'text-align': 'center', 'display': 'inline' })
        }
        if ($('.WidgetShell').eq(i).data('size') == 3) {
            // four        
            $.each($('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-four'), function (j) {
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-four').eq(j).css({
                    'width': '33.33%',
                    'height': j == 0 || j == 1 ? '100%' : '50%',
                })

            })
            //five                    
            $.each($('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-five'), function (j) {
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-five').eq(j).css({
                    'width': '33.33%',
                    'height': j == 0 ? '100%' : '50%',
                    'left': j == 1 || j == 2 ? '33.33%' : j == 3 || j == 4 ? '66.66%' : 0,
                    'top': j == 1 || j == 3 ? 0 : j == 2 || j == 4 ? '50%' : 0,
                })
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-five').eq(j).children('.footertitle').css({
                    'width': '100%',
                    'height': '20%',
                    'display': 'inline',
                    'text-align': 'center',
                })
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-five').eq(j).children('.GaugeContainerCanvas').css({
                    'width': '100%',
                    'height': '80%',
                })
            })
            //six        
            $.each($('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-six'), function (j) {
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-six').eq(j).css({
                    'width': '33.33%',
                    'height': '50%',
                })
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-six').eq(j).children('.footertitle').css({
                    'width': '100%',
                    'height': '20%',
                    'display': 'inline',
                    'text-align': 'center',
                })
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-six').eq(j).children('.GaugeContainerCanvas').css({
                    'width': '100%',
                    'height': '80%',
                })
            })
        }
        if ($('.WidgetShell').eq(i).data('size') == 4) {
            // four        
            $.each($('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-four'), function (j) {
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-four').eq(j).css({
                    'width': '25%',
                    'height': '100%',
                })
            })
            //five                    
            $.each($('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-five'), function (j) {
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-five').eq(j).css({
                    'width': '25%',
                    'height': j == 0 || j == 1 || j == 2 ? '100%' : '50%',
                    'position': 'static'
                })
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-five').eq(j).children('.footertitle').css({
                    'width': '100%',
                    'height': '20%',
                    'display': 'inline',
                    'text-align': 'center',
                })
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-five').eq(j).children('.GaugeContainerCanvas').css({
                    'width': '100%',
                    'height': '80%',
                })
            })
            //six        
            $.each($('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-six'), function (j) {
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-six').eq(j).css({
                    'width': '25%',
                    'height': j == 0 || j == 1 ? '100%' : '50%',
                })
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-six').eq(j).children('.footertitle').css({
                    'width': '100%',
                    'height': '20%',
                    'display': 'inline',
                    'text-align': 'center',
                })
                $('.WidgetShell').eq(i).children('.Content').children('.GaugeContainer-six').eq(j).children('.GaugeContainerCanvas').css({
                    'width': '100%',
                    'height': '80%',
                })
            })
        }

    })

    for (var i = 0; i < data.totalCnt; i++) {
        if (data.guageType == 1)
            CreateWidgetGuageNeedle(data.id, data.guageList[i], i);
        else if (data.guageType == 2)
            CreateWidgetGuagePie(data.id, data.guageList[i], i);
        else if (data.guageType == 3)
            CreateWidgetGuageNumber(data.id, data.guageList[i], i);
    }
}

function CreateWidgetGuageNeedle(id, data, idx) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container' + idx));
    var prct = new Array();
    var min = parseInt(data[3][0]);
    var max = parseInt(data[3][data[3].length - 1]);
    var value = data[2];
    var valIdx = 0;
    for (var i = 0; i < data[3].length - 1; i++){
        var pct = parseFloat(parseInt(data[3][i + 1]) - min) / (max - min);
        prct[i] = [pct, SelectTheme[i % SelectTheme.length]];
        if (value < parseInt(data[3][i + 1]) && value >= parseInt(data[3][i]))
            valIdx = i;
    }
    if (value >= max)
        valIdx = prct.length - 1;
    var option = {
        tooltip: {
            formatter: "{b}:{c}"
        },
        series: [{
            type: "gauge",
            startAngle: 180,
            endAngle: 0,
            min: min,
            max: max,
            splitNumber: 100,
            center: ["50%", "50%"],
            axisLine: {
                lineStyle: {
                    width: 20, //柱子的宽度
                    color: prct
                    //color: [
                    //    [0.25, SelectTheme[0]],
                    //    [0.5, SelectTheme[1]],
                    //    [0.85, SelectTheme[2]],
                    //    [1, SelectTheme[3]]
                    //] //0.298是百分比的比例值（小数），还有对应两个颜色值
                },

            },
            axisLabel: {
                distance: -52,
                show: true,
                clickable: true,
                textStyle: {
                    color: ["#2d99e2",],
                    fontSize: 12,
                },
                formatter: function (e) {
                    if (e == min)
                        return min;
                    if (e == max)
                        return max;
                    for (var i = 0; i < prct.length; i++) {
                        if (parseInt(prct[i][0] * 100) * (parseFloat(max - min) / 100) + min == e) {
                            return data[3][i + 1];
                        }
                    }
                    return "";
                }
            },

            axisTick: {
                show: false,
            },
            splitLine: {
                show: false
            },
            pointer: {
                width: 8,
                lengthx: "110%",
            },
            detail: {
                formatter: '{value}',
                textStyle: {
                    fontSize: 16
                }
            },
            title: {
                show: false,
            },
            data: [

                {
                    name: data[1],
                    value: value,
                    itemStyle: {
                        //color: '#000',
                        color: SelectTheme[valIdx % SelectTheme.length],
                    },

                },

            ]
        }]
    }
    
    myChart.setOption(option);

    myChart.on('click', function (params) {
        WidgetClick(id, idx + 1, null);
    });
}

function CreateWidgetGuagePie(id, data, idx) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container' + idx));
    var min = parseInt(data[3][0]);
    var max = parseInt(data[3][data[3].length - 1]);
    var value = data[2];
    var valIdx = 0;
    var percent = 0;
    for (var i = 0; i < data[3].length - 1; i++) {
        percent = parseFloat(value - min) / (max - min);
        if (value < parseInt(data[3][i + 1]) && value >= parseInt(data[3][i]))
            valIdx = i;
    }
    if (value >= max)
        valIdx = data[3].length - 1;

    //实例化样式
    var dataStyle = {
        normal: {
            label: {
                show: false
            },
            labelLine: {
                show: false
            },
        }
    };
    var placeHolderStyle = {
        normal: {
            color: '#e6e6e6',
            label: {
                show: false
            },
            labelLine: {
                show: false
            }
        },
        
        emphasis: {
            color: '#e6e6e6'
        }
    };
    //数据填充
    var option = {
        color: [SelectTheme[valIdx % SelectTheme.length], SelectTheme[valIdx % SelectTheme.length]],
        title: {
            text: data[2],
            x: 'center',
            y: 'center',
            textStyle: {
                fontWeight: 'normal',
                color: SelectTheme[valIdx % SelectTheme.length],
                fontSize: 26
            }
        },
        tooltip: {
            formatter: "0-{c} "
        },

        series: [{
            type: 'pie',
            radius: ['70%', '90%'],
            hoverAnimation: false,
            itemStyle: dataStyle,
            data: [

                {
                    value: value - min,
                    itemStyle: {
                        color: SelectTheme[valIdx % SelectTheme.length],
                    },
                    tooltip: {
                        confine: false,
                        backgroundColor: '#fff',
                        color: SelectTheme[valIdx % SelectTheme.length],
                        borderColor: SelectTheme[valIdx % SelectTheme.length],
                        borderWidth: 1,
                        padding: [5, 10],
                        textStyle: {
                            color: SelectTheme[valIdx % SelectTheme.length]
                        }
                    }
                },
                {
                    value: max - min - value,
                    itemStyle: placeHolderStyle,
                    tooltip: {
                        show: false
                    }
                },

            ]
        }]
    };
    
    myChart.setOption(option);

    myChart.on('click', function (params) {
        WidgetClick(id, idx + 1, null);
    });
}

function CreateWidgetGuageNumber(id, data, idx) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container' + idx));
    var min = parseInt(data[3][0]);
    var max = parseInt(data[3][data[3].length - 1]);
    var value = data[2];
    var valIdx = 0;
    for (var i = 0; i < data[3].length - 1; i++) {
        if (value < parseInt(data[3][i + 1]) && value >= parseInt(data[3][i]))
            valIdx = i;
    }
    if (value >= max)
        valIdx = data[3].length - 1;
    //实例化样式
    var dataStyle = {
        normal: {
            label: {
                show: false
            },
            labelLine: {
                show: false
            },
        }
    };
    var placeHolderStyle = {
        normal: {
            color: '#e6e6e6',
            label: {
                show: false
            },
            labelLine: {
                show: false
            }
        },

        emphasis: {
            color: '#e6e6e6'
        }
    };
    //数据填充
    var option = {
        color: ['#e6e6e6', '#e6e6e6'],
        title: {
            text: data[2],
            x: 'center',
            y: 'center',
            textStyle: {
                fontWeight: 'normal',
                color: SelectTheme[valIdx % SelectTheme.length],
                fontSize: 26
            }
        },
        tooltip: {
            formatter: "0-{c} "
        },

        series: [{
            type: 'pie',
            radius: ['100%', '100%'],
            hoverAnimation: false,
            itemStyle: dataStyle,
            data: [

            ]
        }]
    };

    myChart.setOption(option);

    myChart.on('click', function (params) {
        WidgetClick(id, idx + 1, null);
    });
}

function CreateGrid(dom, data) {
    var str = '<div class="grid_fiex">';
    str += '<div class="ScrollingContentContainer"><table cellpadding="0" cellspacing="0" class="Table2">';
    if (data.gridHeader != null) {
        str += '<tr class="HeaderContainer">';
        for (var i = 0; i < data.gridHeader.length; i++) {
            str += '<td>' + data.gridHeader[i] + '</td>';
        }
        str += '</tr>';
    }
    for (var i = 0; i < data.gridData.length; i++) {
        str += '<tr>';
        for (var j = 0; j < data.gridData[i].length; j++) {
            str += '<td style="color: #666;">' + data.gridData[i][j] + '</td>';
        }
        str += '</tr>';
    };
    if (data.totalCnt == 0)
        str += '</table></div><div class="FooterContainer"><div class="RowStatus">0 - 0 / 0</div><div class="ShowAllButtonDiv"></div></div></div>';
    else
        str += '</table></div><div class="FooterContainer"><div class="RowStatus">1 - ' + data.gridData.length + ' / ' + data.totalCnt + '</div><div class="ShowAllButtonDiv"><a onclick="WidgetClick(' + data.id + ', null, null)">显示全部</a></div></div></div>';
    dom[0].innerHTML = str;
}
