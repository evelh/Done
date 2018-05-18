
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
function GeneralAddWidgetForm(type) {
    if (type == 2581) {
        return '<div class="normal">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '常规'
            + '</div>'
            + '<div class="Column">'
            + '<div class="item">'
            + '<p>小窗口标题<span style="color: red;">*</span></p>'
            + '<input type="text" name="addWidgetName" id="addWidgetName">'
            + '<input type="hidden" id="wgtVisualType" name="wgtVisualType" />'
            + '</div>'
            + '<div class="item" style="line-height: 20px;">'
            + '<p>对象</p>'
            + '<span id="addWidgetEntityName"></span>'
            + '</div>'
            + '<div class="item" style="width: 100%;height: 90px;">'
            + '<p>描述</p>'
            + '<textarea id="wgtDesc" name="wgtDesc" style="width: 100%;height: 45px;resize: none;"></textarea>'
            + '</div>'
            + '<div>'
            + '<div class="item" style="width: 100%;height: auto;">'
            + '<p>常规图形类型</p>'
            + '<ul class="CustomLayoutContainer" id="chartBasicVisual">'
            + '</ul>'
            + '</div>'
            + '<div class="item" style="width: 100%;height: auto;">'
            + '<p>高级图形类型</p>'
            + '<ul class="CustomLayoutContainer" id="chartAdvVisual">'
            + '</ul>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="normal">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '数据'
            + '</div>'
            + '<div class="Column">'
            + '<div class="item">'
            + '<p>统计对象<span style="color: red;">*</span></p>'
            + '<select id="wgtReport1" name="wgtReport1">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>统计类型</p>'
            + '<select id="wgtReportType1" name="wgtReportType1">'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>第二个统计对象</p>'
            + '<select id="wgtReport2" name="wgtReport2">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>统计类型</p>'
            + '<select id="wgtReportType2" name="wgtReportType2">'
            + '</select>'
            + '</div>'
            + '<div class="item" style="height: 20px;">'
            + '<input type="checkbox" id="wgtShowTwoAxis" name="wgtShowTwoAxis" style="margin-top: 2px;">'
            + '<label for="wgtShowTwoAxis">显示左右两个纵坐标</label>'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>分组条件<span style="color: red;">*</span></p>'
            + '<select id="wgtGroup1" name="wgtGroup1">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>第二个分组条件</p>'
            + '<select id="wgtGroup2" name="wgtGroup2">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="height: 20px;">'
            + '<input type="checkbox" id="wgtShowBlank" name="wgtShowBlank" style="margin-top: 2px;">'
            + '<label for="wgtShowBlank">分组条件取值包括“空”</label>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="normal">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '过滤'
            + '</div>'
            + '<div class="Column">'
            + '<div class="item">'
            + '<p>过滤条件1</p>'
            + '<select id="wgtFilter1" name="wgtFilter1" data-val="1" class="wgtFilter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="1" id="wgtFilter1Oper" name="wgtFilter1Oper" class="wgtOper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtFilter1ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件2</p>'
            + '<select id="wgtFilter2" name="wgtFilter2" data-val="2" class="wgtFilter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="2" id="wgtFilter2Oper" name="wgtFilter2Oper" class="wgtOper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtFilter2ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件3</p>'
            + '<select id="wgtFilter3" name="wgtFilter3" data-val="3" class="wgtFilter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="3" id="wgtFilter3Oper" name="wgtFilter3Oper" class="wgtOper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtFilter3ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件4</p>'
            + '<select id="wgtFilter4" name="wgtFilter4" data-val="4" class="wgtFilter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="4" id="wgtFilter4Oper" name="wgtFilter4Oper" class="wgtOper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtFilter4ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件5</p>'
            + '<select id="wgtFilter5" name="wgtFilter5" data-val="5" class="wgtFilter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="5" id="wgtFilter5Oper" name="wgtFilter5Oper" class="wgtOper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtFilter5ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件6</p>'
            + '<select id="wgtFilter6" name="wgtFilter6" data-val="6" class="wgtFilter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="6" id="wgtFilter6Oper" name="wgtFilter6Oper" class="wgtOper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtFilter6ValDiv"></div>'
            + '</div><p style="clear:both;"></p>'
            + '</div>'
            + '</div>'
            + '<div class="normal">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '选项'
            + '</div>'
            + '<div class="Column">'
            + '<div class="item">'
            + '<p>显示</p>'
            + '<select name="wgtShowType" id="wgtShowType">'
            + '<option value="2741">前5</option>'
            + '<option value="2742">前10</option>'
            + '<option value="2743">前25</option>'
            + '<option value="2744">最后5</option>'
            + '<option value="2745">最后10</option>'
            + '<option value="2746">最后25</option>'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>排序方式</p>'
            + '<select name="wgtSortType" id="wgtSortType">'
            + '<option value="2770">统计字段升序</option>'
            + '<option value="2771">统计字段降序</option>'
            + '<option value="2772">分组字段升序</option>'
            + '<option value="2773">分组字段降序</option>'
            + '</select>'
            + '</div>'
            + '<div class="item" style="height: 20px;">'
            + '<input type="checkbox" id="wgtDisplayOth" name="wgtDisplayOth" style="margin-top: 2px;">'
            + '<label for="wgtDisplayOth">剩余的合在一起显示，名称为“其他”</label>'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item" style="height: 30px;">'
            + '<input type="checkbox" id="wgtShowAxis" name="wgtShowAxis" checked="checked" style="margin-top: 2px;">'
            + '<label for="wgtShowAxis">显示轴标签</label>'
            + '</div>'
            + '<div class="item" style="height: 30px;">'
            + '<input type="checkbox" id="wgtShowTrendline" name="wgtShowTrendline" style="margin-top: 2px;">'
            + '<label for="wgtShowTrendline">显示趋势线</label>'
            + '</div>'
            + '<div class="item" style="height: 30px;">'
            + '<input type="checkbox" id="wgtShowTitle" name="wgtShowTitle" style="margin-top: 2px;">'
            + '<label for="wgtShowTitle">显示图例/标题</label>'
            + '</div>'
            + '<div class="item" style="height: 30px;">'
            + '<input type="checkbox" id="wgtShowTotal" name="wgtShowTotal" style="margin-top: 2px;">'
            + '<label for="wgtShowTotal">显示总计</label>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="normal">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '布局/大小'
            + '</div>'
            + '<div class="Column">'
            + '<div class="item" style="width: 100%;height: auto;">'
            + '<p>宽度   <a style="color: #ccc;font-weight: normal;font-size: 11px;">(小窗口占用的列数)</a><input type="hidden" id="wgtSize" name="wgtSize" value="2" /></p>'
            + '<ul class="widgetSizeList">'
            + '<li title="1列" data-val="1"></li>'
            + '<li title="2列" data-val="2" class="widgetSizeListNow"></li>'
            + '<li title="3列" data-val="3"></li>'
            + '<li title="4列" data-val="4"></li>'
            + '</ul>'
            + '</div>'
            + '</div>'
            + '</div>';
    }
    else if (type == 2582) {

    }
    else if (type == 2583) {
        return '<div class="normal">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '常规'
            + '</div>'
            + '<div class="Column">'
            + '<div class="item">'
            + '<p>小窗口标题<span style="color: red;">*</span></p>'
            + '<input type="text" name="addWidgetName" id="addWidgetName">'
            + '<input type="hidden" id="wgtVisualType" name="wgtVisualType" />'
            + '</div>'
            + '<div class="item" style="line-height: 20px;">'
            + '<p>对象</p>'
            + '<span id="addWidgetEntityName"></span>'
            + '</div>'
            + '<div class="item" style="width: 100%;height: 90px;">'
            + '<p>描述</p>'
            + '<textarea id="wgtDesc" name="wgtDesc" style="width: 100%;height: 45px;resize: none;"></textarea>'
            + '</div>'
            + '<div>'
            + '<div class="item" style="width: 100%;height: auto;">'
            + '<p>图形类型</p>'
            + '<ul class="CustomLayoutContainer" id="chartBasicVisual">'
            + '</ul>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="normal">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '子图表 1'
            + '</div>'
            + '<div class="Column">'
            + '<div class="item">'
            + '<p>统计对象<span style="color: red;">*</span></p>'
            + '<select id="wgtSub1Report1" name="wgtSub1Report1">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>统计类型</p>'
            + '<select id="wgtSub1ReportType1" name="wgtSub1ReportType1">'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>标签</p>'
            + '<input type="text" id="wgtSub1Label" name="wgtSub1Label" />'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>分段目标值</p>'
            + '<select id="wgtSub1BreakType" name="wgtSub1BreakType">'
            + '<option value="">指定分段值</option>'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>分段数</p>'
            + '<select id="wgtSub1BreakCnt" name="wgtSub1BreakCnt">'
            + '<option value="1">1</option>'
            + '<option value="2">2</option>'
            + '<option value="3" selected="selected">3</option>'
            + '<option value="4">4</option>'
            + '<option value="5">5</option>'
            + '</select>'
            + '</div>'
            + '<div class="item" style="width:705px;">'
            + '<p>分段数</p>'
            + '<input type="text" name="wgtSub1BP0" id="wgtSub1BP0" value="10" style="width:60px;">'
            + '<input type="text" name="wgtSub1BP1" id="wgtSub1BP1" value="20" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub1BP2" id="wgtSub1BP2" value="30" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub1BP3" id="wgtSub1BP3" value="40" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub1BP4" id="wgtSub1BP4" value="50" style="width:60px;margin-left:10px;display:none;">'
            + '<input type="text" name="wgtSub1BP5" id="wgtSub1BP5" value="60" style="width:60px;margin-left:10px;display:none;">'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>过滤条件1</p>'
            + '<select id="wgtSub1Filter1" name="wgtSub1Filter1" data-val="1" class="wgtSub1Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="1" id="wgtSub1Filter1Oper" name="wgtSub1Filter1Oper" class="wgtSub1Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub1Filter1ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件2</p>'
            + '<select id="wgtSub1Filter2" name="wgtSub1Filter2" data-val="2" class="wgtSub1Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="2" id="wgtSub1Filter2Oper" name="wgtSub1Filter2Oper" class="wgtSub1Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub1Filter2ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件3</p>'
            + '<select id="wgtSub1Filter3" name="wgtSub1Filter3" data-val="3" class="wgtSub1Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="3" id="wgtSub1Filter3Oper" name="wgtSub1Filter3Oper" class="wgtSub1Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub1Filter3ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件4</p>'
            + '<select id="wgtSub1Filter4" name="wgtSub1Filter4" data-val="4" class="wgtSub1Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="4" id="wgtSub1Filter4Oper" name="wgtSub1Filter4Oper" class="wgtSub1Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub1Filter4ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件5</p>'
            + '<select id="wgtSub1Filter5" name="wgtSub1Filter5" data-val="5" class="wgtSub1Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="5" id="wgtSub1Filter5Oper" name="wgtSub1Filter5Oper" class="wgtSub1Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub1Filter5ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件6</p>'
            + '<select id="wgtSub1Filter6" name="wgtSub1Filter6" data-val="6" class="wgtSub1Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="6" id="wgtSub1Filter6Oper" name="wgtSub1Filter6Oper" class="wgtSub1Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub1Filter6ValDiv"></div>'
            + '</div><p style="clear:both;"></p>'
            + '</div>'
            + '</div>'


            + '<div class="normal" style="background: rgb(242, 242, 242);">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '子图表 2'
            + '</div>'
            + '<div class="Column" style="display: none;">'
            + '<div class="item">'
            + '<p>统计对象<span style="color: red;">*</span></p>'
            + '<select id="wgtSub2Report1" name="wgtSub2Report1">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>统计类型</p>'
            + '<select id="wgtSub2ReportType1" name="wgtSub2ReportType1">'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>标签</p>'
            + '<input type="text" id="wgtSub2Label" name="wgtSub2Label" />'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>分段目标值</p>'
            + '<select id="wgtSub2BreakType" name="wgtSub2BreakType">'
            + '<option value="">指定分段值</option>'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>分段数</p>'
            + '<select id="wgtSub2BreakCnt" name="wgtSub2BreakCnt">'
            + '<option value="1">1</option>'
            + '<option value="2">2</option>'
            + '<option value="3" selected="selected">3</option>'
            + '<option value="4">4</option>'
            + '<option value="5">5</option>'
            + '</select>'
            + '</div>'
            + '<div class="item" style="width:705px;">'
            + '<p>分段数</p>'
            + '<input type="text" name="wgtSub2BP0" id="wgtSub2BP0" value="10" style="width:60px;">'
            + '<input type="text" name="wgtSub2BP1" id="wgtSub2BP1" value="20" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub2BP2" id="wgtSub2BP2" value="30" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub2BP3" id="wgtSub2BP3" value="40" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub2BP4" id="wgtSub2BP4" value="50" style="width:60px;margin-left:10px;display:none;">'
            + '<input type="text" name="wgtSub2BP5" id="wgtSub2BP5" value="60" style="width:60px;margin-left:10px;display:none;">'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>过滤条件1</p>'
            + '<select id="wgtSub2Filter1" name="wgtSub2Filter1" data-val="1" class="wgtSub2Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="1" id="wgtSub2Filter1Oper" name="wgtSub2Filter1Oper" class="wgtSub2Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub2Filter1ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件2</p>'
            + '<select id="wgtSub2Filter2" name="wgtSub2Filter2" data-val="2" class="wgtSub2Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="2" id="wgtSub2Filter2Oper" name="wgtSub2Filter2Oper" class="wgtSub2Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub2Filter2ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件3</p>'
            + '<select id="wgtSub2Filter3" name="wgtSub2Filter3" data-val="3" class="wgtSub2Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="3" id="wgtSub2Filter3Oper" name="wgtSub2Filter3Oper" class="wgtSub2Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub2Filter3ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件4</p>'
            + '<select id="wgtSub2Filter4" name="wgtSub2Filter4" data-val="4" class="wgtSub2Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="4" id="wgtSub2Filter4Oper" name="wgtSub2Filter4Oper" class="wgtSub2Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub2Filter4ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件5</p>'
            + '<select id="wgtSub2Filter5" name="wgtSub2Filter5" data-val="5" class="wgtSub2Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="5" id="wgtSub2Filter5Oper" name="wgtSub2Filter5Oper" class="wgtSub2Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub2Filter5ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件6</p>'
            + '<select id="wgtSub2Filter6" name="wgtSub2Filter6" data-val="6" class="wgtSub2Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="6" id="wgtSub2Filter6Oper" name="wgtSub2Filter6Oper" class="wgtSub2Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub2Filter6ValDiv"></div>'
            + '</div><p style="clear:both;"></p>'
            + '</div>'
            + '</div>'


            + '<div class="normal" style="background: rgb(242, 242, 242);">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '子图表 3'
            + '</div>'
            + '<div class="Column" style="display: none;">'
            + '<div class="item">'
            + '<p>统计对象<span style="color: red;">*</span></p>'
            + '<select id="wgtSub3Report1" name="wgtSub3Report1">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>统计类型</p>'
            + '<select id="wgtSub3ReportType1" name="wgtSub3ReportType1">'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>标签</p>'
            + '<input type="text" id="wgtSub3Label" name="wgtSub3Label" />'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>分段目标值</p>'
            + '<select id="wgtSub3BreakType" name="wgtSub3BreakType">'
            + '<option value="">指定分段值</option>'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>分段数</p>'
            + '<select id="wgtSub3BreakCnt" name="wgtSub3BreakCnt">'
            + '<option value="1">1</option>'
            + '<option value="2">2</option>'
            + '<option value="3" selected="selected">3</option>'
            + '<option value="4">4</option>'
            + '<option value="5">5</option>'
            + '</select>'
            + '</div>'
            + '<div class="item" style="width:705px;">'
            + '<p>分段数</p>'
            + '<input type="text" name="wgtSub3BP0" id="wgtSub3BP0" value="10" style="width:60px;">'
            + '<input type="text" name="wgtSub3BP1" id="wgtSub3BP1" value="20" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub3BP2" id="wgtSub3BP2" value="30" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub3BP3" id="wgtSub3BP3" value="40" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub3BP4" id="wgtSub3BP4" value="50" style="width:60px;margin-left:10px;display:none;">'
            + '<input type="text" name="wgtSub3BP5" id="wgtSub3BP5" value="60" style="width:60px;margin-left:10px;display:none;">'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>过滤条件1</p>'
            + '<select id="wgtSub3Filter1" name="wgtSub3Filter1" data-val="1" class="wgtSub3Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="1" id="wgtSub3Filter1Oper" name="wgtSub3Filter1Oper" class="wgtSub3Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub3Filter1ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件2</p>'
            + '<select id="wgtSub3Filter2" name="wgtSub3Filter2" data-val="2" class="wgtSub3Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="2" id="wgtSub3Filter2Oper" name="wgtSub3Filter2Oper" class="wgtSub3Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub3Filter2ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件3</p>'
            + '<select id="wgtSub3Filter3" name="wgtSub3Filter3" data-val="3" class="wgtSub3Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="3" id="wgtSub3Filter3Oper" name="wgtSub3Filter3Oper" class="wgtSub3Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub3Filter3ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件4</p>'
            + '<select id="wgtSub3Filter4" name="wgtSub3Filter4" data-val="4" class="wgtSub3Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="4" id="wgtSub3Filter4Oper" name="wgtSub3Filter4Oper" class="wgtSub3Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub3Filter4ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件5</p>'
            + '<select id="wgtSub3Filter5" name="wgtSub3Filter5" data-val="5" class="wgtSub3Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="5" id="wgtSub3Filter5Oper" name="wgtSub3Filter5Oper" class="wgtSub3Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub3Filter5ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件6</p>'
            + '<select id="wgtSub3Filter6" name="wgtSub3Filter6" data-val="6" class="wgtSub3Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="6" id="wgtSub3Filter6Oper" name="wgtSub3Filter6Oper" class="wgtSub3Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub3Filter6ValDiv"></div>'
            + '</div><p style="clear:both;"></p>'
            + '</div>'
            + '</div>'


            + '<div class="normal" style="background: rgb(242, 242, 242);">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '子图表 4'
            + '</div>'
            + '<div class="Column" style="display: none;">'
            + '<div class="item">'
            + '<p>统计对象<span style="color: red;">*</span></p>'
            + '<select id="wgtSub4Report1" name="wgtSub4Report1">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>统计类型</p>'
            + '<select id="wgtSub4ReportType1" name="wgtSub4ReportType1">'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>标签</p>'
            + '<input type="text" id="wgtSub4Label" name="wgtSub4Label" />'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>分段目标值</p>'
            + '<select id="wgtSub4BreakType" name="wgtSub4BreakType">'
            + '<option value="">指定分段值</option>'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>分段数</p>'
            + '<select id="wgtSub4BreakCnt" name="wgtSub4BreakCnt">'
            + '<option value="1">1</option>'
            + '<option value="2">2</option>'
            + '<option value="3" selected="selected">3</option>'
            + '<option value="4">4</option>'
            + '<option value="5">5</option>'
            + '</select>'
            + '</div>'
            + '<div class="item" style="width:705px;">'
            + '<p>分段数</p>'
            + '<input type="text" name="wgtSub4BP0" id="wgtSub4BP0" value="10" style="width:60px;">'
            + '<input type="text" name="wgtSub4BP1" id="wgtSub4BP1" value="20" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub4BP2" id="wgtSub4BP2" value="30" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub4BP3" id="wgtSub4BP3" value="40" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub4BP4" id="wgtSub4BP4" value="50" style="width:60px;margin-left:10px;display:none;">'
            + '<input type="text" name="wgtSub4BP5" id="wgtSub4BP5" value="60" style="width:60px;margin-left:10px;display:none;">'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>过滤条件1</p>'
            + '<select id="wgtSub4Filter1" name="wgtSub4Filter1" data-val="1" class="wgtSub4Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="1" id="wgtSub4Filter1Oper" name="wgtSub4Filter1Oper" class="wgtSub4Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub4Filter1ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件2</p>'
            + '<select id="wgtSub4Filter2" name="wgtSub4Filter2" data-val="2" class="wgtSub4Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="2" id="wgtSub4Filter2Oper" name="wgtSub4Filter2Oper" class="wgtSub4Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub4Filter2ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件3</p>'
            + '<select id="wgtSub4Filter3" name="wgtSub4Filter3" data-val="3" class="wgtSub4Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="3" id="wgtSub4Filter3Oper" name="wgtSub4Filter3Oper" class="wgtSub4Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub4Filter3ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件4</p>'
            + '<select id="wgtSub4Filter4" name="wgtSub4Filter4" data-val="4" class="wgtSub4Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="4" id="wgtSub4Filter4Oper" name="wgtSub4Filter4Oper" class="wgtSub4Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub4Filter4ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件5</p>'
            + '<select id="wgtSub4Filter5" name="wgtSub4Filter5" data-val="5" class="wgtSub4Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="5" id="wgtSub4Filter5Oper" name="wgtSub4Filter5Oper" class="wgtSub4Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub4Filter5ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件6</p>'
            + '<select id="wgtSub4Filter6" name="wgtSub4Filter6" data-val="6" class="wgtSub4Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="6" id="wgtSub4Filter6Oper" name="wgtSub4Filter6Oper" class="wgtSub4Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub4Filter6ValDiv"></div>'
            + '</div><p style="clear:both;"></p>'
            + '</div>'
            + '</div>'


            + '<div class="normal" style="background: rgb(242, 242, 242);">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '子图表 5'
            + '</div>'
            + '<div class="Column" style="display: none;">'
            + '<div class="item">'
            + '<p>统计对象<span style="color: red;">*</span></p>'
            + '<select id="wgtSub5Report1" name="wgtSub5Report1">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>统计类型</p>'
            + '<select id="wgtSub5ReportType1" name="wgtSub5ReportType1">'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>标签</p>'
            + '<input type="text" id="wgtSub5Label" name="wgtSub5Label" />'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>分段目标值</p>'
            + '<select id="wgtSub5BreakType" name="wgtSub5BreakType">'
            + '<option value="">指定分段值</option>'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>分段数</p>'
            + '<select id="wgtSub5BreakCnt" name="wgtSub5BreakCnt">'
            + '<option value="1">1</option>'
            + '<option value="2">2</option>'
            + '<option value="3" selected="selected">3</option>'
            + '<option value="4">4</option>'
            + '<option value="5">5</option>'
            + '</select>'
            + '</div>'
            + '<div class="item" style="width:705px;">'
            + '<p>分段数</p>'
            + '<input type="text" name="wgtSub5BP0" id="wgtSub5BP0" value="10" style="width:60px;">'
            + '<input type="text" name="wgtSub5BP1" id="wgtSub5BP1" value="20" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub5BP2" id="wgtSub5BP2" value="30" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub5BP3" id="wgtSub5BP3" value="40" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub5BP4" id="wgtSub5BP4" value="50" style="width:60px;margin-left:10px;display:none;">'
            + '<input type="text" name="wgtSub5BP5" id="wgtSub5BP5" value="60" style="width:60px;margin-left:10px;display:none;">'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>过滤条件1</p>'
            + '<select id="wgtSub5Filter1" name="wgtSub5Filter1" data-val="1" class="wgtSub5Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="1" id="wgtSub5Filter1Oper" name="wgtSub5Filter1Oper" class="wgtSub5Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub5Filter1ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件2</p>'
            + '<select id="wgtSub5Filter2" name="wgtSub5Filter2" data-val="2" class="wgtSub5Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="2" id="wgtSub5Filter2Oper" name="wgtSub5Filter2Oper" class="wgtSub5Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub5Filter2ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件3</p>'
            + '<select id="wgtSub5Filter3" name="wgtSub5Filter3" data-val="3" class="wgtSub5Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="3" id="wgtSub5Filter3Oper" name="wgtSub5Filter3Oper" class="wgtSub5Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub5Filter3ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件4</p>'
            + '<select id="wgtSub5Filter4" name="wgtSub5Filter4" data-val="4" class="wgtSub5Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="4" id="wgtSub5Filter4Oper" name="wgtSub5Filter4Oper" class="wgtSub5Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub5Filter4ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件5</p>'
            + '<select id="wgtSub5Filter5" name="wgtSub5Filter5" data-val="5" class="wgtSub5Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="5" id="wgtSub5Filter5Oper" name="wgtSub5Filter5Oper" class="wgtSub5Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub5Filter5ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件6</p>'
            + '<select id="wgtSub5Filter6" name="wgtSub5Filter6" data-val="6" class="wgtSub5Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="6" id="wgtSub5Filter6Oper" name="wgtSub5Filter6Oper" class="wgtSub5Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub5Filter6ValDiv"></div>'
            + '</div><p style="clear:both;"></p>'
            + '</div>'
            + '</div>'


            + '<div class="normal" style="background: rgb(242, 242, 242);">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '子图表 6'
            + '</div>'
            + '<div class="Column" style="display: none;">'
            + '<div class="item">'
            + '<p>统计对象<span style="color: red;">*</span></p>'
            + '<select id="wgtSub6Report1" name="wgtSub6Report1">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>统计类型</p>'
            + '<select id="wgtSub6ReportType1" name="wgtSub6ReportType1">'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>标签</p>'
            + '<input type="text" id="wgtSub6Label" name="wgtSub6Label" />'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>分段目标值</p>'
            + '<select id="wgtSub6BreakType" name="wgtSub6BreakType">'
            + '<option value="">指定分段值</option>'
            + '</select>'
            + '</div>'
            + '<div class="item">'
            + '<p>分段数</p>'
            + '<select id="wgtSub6BreakCnt" name="wgtSub6BreakCnt">'
            + '<option value="1">1</option>'
            + '<option value="2">2</option>'
            + '<option value="3" selected="selected">3</option>'
            + '<option value="4">4</option>'
            + '<option value="5">5</option>'
            + '</select>'
            + '</div>'
            + '<div class="item" style="width:705px;">'
            + '<p>分段数</p>'
            + '<input type="text" name="wgtSub6BP0" id="wgtSub6BP0" value="10" style="width:60px;">'
            + '<input type="text" name="wgtSub6BP1" id="wgtSub6BP1" value="20" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub6BP2" id="wgtSub6BP2" value="30" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub6BP3" id="wgtSub6BP3" value="40" style="width:60px;margin-left:10px;">'
            + '<input type="text" name="wgtSub6BP4" id="wgtSub6BP4" value="50" style="width:60px;margin-left:10px;display:none;">'
            + '<input type="text" name="wgtSub6BP5" id="wgtSub6BP5" value="60" style="width:60px;margin-left:10px;display:none;">'
            + '</div>'
            + '<div class="item" style="width:705px;height: 1px ;background: #E4E4E4; "></div>'
            + '<div class="item">'
            + '<p>过滤条件1</p>'
            + '<select id="wgtSub6Filter1" name="wgtSub6Filter1" data-val="1" class="wgtSub6Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="1" id="wgtSub6Filter1Oper" name="wgtSub6Filter1Oper" class="wgtSub6Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub6Filter1ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件2</p>'
            + '<select id="wgtSub6Filter2" name="wgtSub6Filter2" data-val="2" class="wgtSub6Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="2" id="wgtSub6Filter2Oper" name="wgtSub6Filter2Oper" class="wgtSub6Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub6Filter2ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件3</p>'
            + '<select id="wgtSub6Filter3" name="wgtSub6Filter3" data-val="3" class="wgtSub6Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="3" id="wgtSub6Filter3Oper" name="wgtSub6Filter3Oper" class="wgtSub6Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub6Filter3ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件4</p>'
            + '<select id="wgtSub6Filter4" name="wgtSub6Filter4" data-val="4" class="wgtSub6Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="4" id="wgtSub6Filter4Oper" name="wgtSub6Filter4Oper" class="wgtSub6Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub6Filter4ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件5</p>'
            + '<select id="wgtSub6Filter5" name="wgtSub6Filter5" data-val="5" class="wgtSub6Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="5" id="wgtSub6Filter5Oper" name="wgtSub6Filter5Oper" class="wgtSub6Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub6Filter5ValDiv"></div>'
            + '</div>'
            + '<div class="item">'
            + '<p>过滤条件6</p>'
            + '<select id="wgtSub6Filter6" name="wgtSub6Filter6" data-val="6" class="wgtSub6Filter">'
            + '</select>'
            + '<div class="cancel"></div>'
            + '</div>'
            + '<div class="item" style="padding-top:16px;height: 34px; ">'
            + '<div style="position:relative;float: left;margin-right: 10px;margin-top: 6px;"><select style="float: left;width: 125px;" data-val="6" id="wgtSub6Filter6Oper" name="wgtSub6Filter6Oper" class="wgtSub6Oper"></select></div>'
            + '<div style="width: 180px;position:relative;float: left;height: 24px;margin-top: 6px;" id="wgtSub6Filter6ValDiv"></div>'
            + '</div><p style="clear:both;"></p>'
            + '</div>'
            + '</div>'

            + '<div class="normal">'
            + '<div class="heading">'
            + '<div class="toogle" onclick="Toogle(this)">'
            + '<div class="Vertical"></div>'
            + '<div class="Horizontal"></div>'
            + '</div>'
            + '布局/大小'
            + '</div>'
            + '<div class="Column">'
            + '<div class="item" style="width: 100%;height: auto;">'
            + '<p>宽度   <a style="color: #ccc;font-weight: normal;font-size: 11px;">(小窗口占用的列数)</a><input type="hidden" id="wgtSize" name="wgtSize" value="2" /></p>'
            + '<ul class="widgetSizeList">'
            + '<li title="1列" data-val="1"></li>'
            + '<li title="2列" data-val="2" class="widgetSizeListNow"></li>'
            + '<li title="3列" data-val="3"></li>'
            + '<li title="4列" data-val="4"></li>'
            + '</ul>'
            + '</div>'
            + '</div>'
            + '</div>';
    }
    else if (type == 2584) {

    }
    else if (type == 2585) {

    }
    return '';
}
function AddWidgetStep1() {
    $("#addWgtContent").empty();
    if ($('input:radio[name="addWidgetType"]:checked').val() == "1") {
        var showType = $("#addWidgetTypeSelect").val();
        $("#addWgtContent")[0].innerHTML = GeneralAddWidgetForm(showType);
        for (var i = 0; i < widgetEntityList.length; i++) {
            if (widgetEntityList[i].id == $("#addWidgetEntity").val()) {
                $("#addWidgetEntityName").text(widgetEntityList[i].name);
                break;
            }
        }
        if (showType == 2581) {
            var yidx = -60 * ThemeIdx - 1;
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
                InitWidgetFilter(data, "");
            });
            requestData("/Tools/DashboardAjax.ashx?act=GetWidgetReport&id=" + $("#addWidgetEntity").val(), null, function (data) {
                InitWidgetReporton(data);
            });
            requestData("/Tools/DashboardAjax.ashx?act=GetWidgetGroupby&id=" + $("#addWidgetEntity").val(), null, function (data) {
                InitWidgetGroupby(data);
            });
        }
        else if (showType == 2583) {
            var yidx = -60 * ThemeIdx - 1;
            $("#chartBasicVisual").append('<li class="ClickNow WidgetVisual" data-visual="2559" style="background-position:-661px ' + yidx + 'px" title="仪表盘"></li>');
            $("#chartBasicVisual").append('<li class="ClickNo WidgetVisual" data-visual="2560" style="background-position:-721px ' + yidx + 'px" title="圆环图"></li>');
            $("#chartBasicVisual").append('<li class="ClickNo WidgetVisual" data-visual="2561" style="background-position:-781px ' + yidx + 'px" title="数字"></li>');
            $(".ClickNo").click(function () {
                ChooseGuage(this);
            })
            $("#wgtSub1BreakCnt").change(function () {
                BreakPointCntChange(1);
            })
            $("#wgtSub2BreakCnt").change(function () {
                BreakPointCntChange(2);
            })
            $("#wgtSub3BreakCnt").change(function () {
                BreakPointCntChange(3);
            })
            $("#wgtSub4BreakCnt").change(function () {
                BreakPointCntChange(4);
            })
            $("#wgtSub5BreakCnt").change(function () {
                BreakPointCntChange(5);
            })
            $("#wgtSub6BreakCnt").change(function () {
                BreakPointCntChange(6);
            })
            requestData("/Tools/DashboardAjax.ashx?act=GetWidgetFilter&id=" + $("#addWidgetEntity").val(), null, function (data) {
                InitWidgetFilter(data, "Sub1");
                InitWidgetFilter(data, "Sub2");
                InitWidgetFilter(data, "Sub3");
                InitWidgetFilter(data, "Sub4");
                InitWidgetFilter(data, "Sub5");
                InitWidgetFilter(data, "Sub6");
            });
            requestData("/Tools/DashboardAjax.ashx?act=GetWidgetReport&id=" + $("#addWidgetEntity").val(), null, function (data) {
                InitWidgetReportonSingle("Sub1", data);
                InitWidgetReportonSingle("Sub2", data);
                InitWidgetReportonSingle("Sub3", data);
                InitWidgetReportonSingle("Sub4", data);
                InitWidgetReportonSingle("Sub5", data);
                InitWidgetReportonSingle("Sub6", data);
            });
            function BreakPointCntChange(sub) {
                var bpCnt = parseInt($("#wgtSub" + sub + "BreakCnt").val());
                if (bpCnt > 1) {
                    $("#wgtSub" + sub + "BP2").show();
                } else {
                    $("#wgtSub" + sub + "BP2").hide();
                }
                if (bpCnt > 2) {
                    $("#wgtSub" + sub + "BP3").show();
                } else {
                    $("#wgtSub" + sub + "BP3").hide();
                }
                if (bpCnt > 3) {
                    $("#wgtSub" + sub + "BP4").show();
                } else {
                    $("#wgtSub" + sub + "BP4").hide();
                }
                if (bpCnt > 4) {
                    $("#wgtSub" + sub + "BP5").show();
                } else {
                    $("#wgtSub" + sub + "BP5").hide();
                }
            }
        }
        ShowLoading();
        setTimeout(function () {
            $(".widgetSizeList").children().click(function () {
                $(this).addClass("widgetSizeListNow").siblings().removeClass("widgetSizeListNow");
                $("#wgtSize").val($(this).data("val"));
            })
            $('#AddWidget').hide();
            $('#AddWidgetBefore').show();
            HideLoading();
        }, 100);
    }
}
function AddWidgetFinish() {
    if ($("#addWidgetName").val() == "") {
        LayerMsg("请输入小窗口标题");
        return;
    }
    var showType = $("#addWidgetTypeSelect").val();
    if (showType == 2581) {
        if ($("#wgtReport1").val() == "") {
            LayerMsg("请选择统计对象");
            return;
        }
        if ($("#wgtGroup1").val() == "") {
            LayerMsg("请选择分组条件");
            return;
        }
    } else if (showType == 2583) {
        var haveSub = false;
        for (var i = 1; i <= 6; i++) {
            if ($("#wgtSub" + i + "Report1").val() != "") {
                var bpCnt = parseInt($("#wgtSub" + i + "BreakCnt").val());
                if ($("#wgtSub" + i + "BP1").val() == "") {
                    LayerMsg("请输入分段数值1");
                    return;
                }
                if (bpCnt > 1 && $("#wgtSub" + i + "BP2").val() == "") {
                    LayerMsg("请输入分段数值2");
                    return;
                }
                if (bpCnt > 2 && $("#wgtSub" + i + "BP3").val() == "") {
                    LayerMsg("请输入分段数值3");
                    return;
                }
                if (bpCnt > 3 && $("#wgtSub" + i + "BP4").val() == "") {
                    LayerMsg("请输入分段数值4");
                    return;
                }
                if (bpCnt > 4 && $("#wgtSub" + i + "BP5").val() == "") {
                    LayerMsg("请输入分段数值5");
                    return;
                }
                haveSub = true;
            }
        }
        if (!haveSub) {
            LayerMsg("请至少选择一个子图表");
            return;
        }
    }
    $("#addWidgetForm").unbind("submit").submit(function () {
        LayerLoad();
        jQuery.ajax({
            url: 'Tools/DashboardAjax.ashx?act=AddWidget&dashboardId=' + CurrentDashboardId(),
            data: $('#addWidgetForm').serialize(),
            type: "POST",
            beforeSend: function () {
            },
            success: function (data) {
                LayerLoadClose();
                if (data != 0) RefreshDashboard();
            }
        });
        return false;
    })
    $("#addWidgetForm").submit();
}
function ChooseGuage(dom) {
    $(".ClickNow").removeClass("ClickNow").addClass("ClickNo").click(function () { ChooseGuage(this); });
    var type = $(dom).addClass("ClickNow").removeClass("ClickNo").unbind("click").data("visual");
    $("#wgtVisualType").val(type);
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
function InitWidgetReportonSingle(sub, data) {
    var str = "<option value=''></option>";
    for (var i = 0; i < data.length; i++) {
        str += "<option value='" + data[i][0].id + "'>" + data[i][0].name + "</option>";
    }
    $("#wgt" + sub + "Report1")[0].innerHTML = str;
    $("#wgt" + sub + "Report1").unbind("change").bind("change", function () {
        ReportChange(sub);
    })
    function ReportChange(sub) {
        var sltValue = $("#wgt" + sub + "Report1").val();
        if (sltValue == "") {
            $("#wgt" + sub + "ReportType1").empty();
            $("#wgt" + sub + "ReportType1").attr("disabled", "disabled");
        } else {
            var strType = '';
            var sltIdx;
            for (var i = 0; i < data.length; i++) {
                for (var j = 0; j < data[i].length; j++) {
                    if (data[i][j].id == sltValue) sltIdx = i;
                }
            }
            for (var j = 0; j < data[sltIdx].length; j++) {
                strType += "<option value='" + data[sltIdx][j].agrId + "'>" + data[sltIdx][j].agrType + "</option>";
            }
            $("#wgt" + sub + "ReportType1").removeAttr("disabled");
            $("#wgt" + sub + "ReportType1")[0].innerHTML = strType;
        }
    }
}
function InitWidgetReporton(data) {
    var str = "<option value=''></option>";
    for (var i = 0; i < data.length; i++) {
        str += "<option value='" + data[i][0].id + "'>" + data[i][0].name + "</option>";
    }
    $("#wgtReport1")[0].innerHTML = str;
    $("#wgtReport2")[0].innerHTML = str;
    $("#wgtReport1").unbind("change").bind("change", function () {
        ReportChange(1);
    })
    $("#wgtReport2").unbind("change").bind("change", function () {
        ReportChange(2);
    })
    function ReportChange(idx) {
        var sltValue = $("#wgtReport" + idx).val();
        var type = $(".ClickNow").data("visual");
        if (sltValue == "") {
            $("#wgtReportType" + idx).empty();
            $("#wgtReportType" + idx).attr("disabled", "disabled");
            if (idx == 2 && (!(type == 2545 || type == 2546 || type == 2547 || type == 2548 || type == 2549 || type == 2556 || type == 2558))) {
                $("#wgtGroup2").removeAttr("disabled");
            }
        } else {
            var strType = '';
            var sltIdx;
            for (var i = 0; i < data.length; i++) {
                for (var j = 0; j < data[i].length; j++) {
                    if (data[i][j].id == sltValue) sltIdx = i;
                }
            }
            for (var j = 0; j < data[sltIdx].length; j++) {
                strType += "<option value='" + data[sltIdx][j].agrId + "'>" + data[sltIdx][j].agrType + "</option>";
            }
            $("#wgtReportType" + idx).removeAttr("disabled");
            $("#wgtReportType" + idx)[0].innerHTML = strType;
            if (idx == 2 && (!(type == 2545 || type == 2546 || type == 2547 || type == 2548 || type == 2549 || type == 2556 || type == 2558))) {
                $("#wgtGroup2").attr("disabled", "disabled");
            }
        }
    }
}
function InitWidgetGroupby(data) {
    var str = "<option value=''></option>";
    for (var i = 0; i < data.length; i++) {
        str += "<option value='" + data[i].val + "'>" + data[i].show + "</option>";
    }
    $("#wgtGroup1")[0].innerHTML = str;
    $("#wgtGroup2")[0].innerHTML = str;
    $("#wgtGroup1").unbind("change").bind("change", function () {
        GroupChange(1);
    })
    $("#wgtGroup2").unbind("change").bind("change", function () {
        GroupChange(2);
    })
    function GroupChange(idx) {
        if (idx == 2) {
            var type = $(".ClickNow").data("visual");
            if (!(type == 2545 || type == 2546 || type == 2556 || type == 2558)) {
                if ($("#wgtGroup2").val() == '') {
                    $("#wgtReport2").removeAttr("disabled");
                } else {
                    $("#wgtReport2").attr("disabled", "disabled");
                }
            }
        }
    }
}
function InitWidgetFilter(data, sub) {
    var str = "<option value=''></option>";
    for (var i = 0; i < data.length; i++) {
        str += "<option value='" + data[i][0].description + "'>" + data[i][0].description + "</option>";
    }
    $(".wgt" + sub + "Filter").each(function () { $(this)[0].innerHTML = str; });
    $(".wgt" + sub + "Filter").unbind("change").bind("change", function () {
        FilterChange(sub, $(this).data("val"));
    })
    $(".wgt" + sub + "Oper").unbind("change").bind("change", function () {
        OperChange(sub, $(this).data("val"));
    })
    function FilterChange(sub, idx) {
        var sltValue = $("#wgt" + sub + "Filter" + idx).val();
        if (sltValue == "") {
            $("#wgt" + sub + "Filter" + idx + "Oper").empty();
            $("#wgt" + sub + "Filter" + idx + "ValDiv").empty();
            //$("#wgtFilter" + idx + "Val1").hide();
            //$("#mlt" + idx).hide();
        } else {
            var str = "";
            for (var i = 0; i < data.length; i++) {
                if (data[i][0].description != sltValue) { continue; }
                for (var j = 0; j < data[i].length; j++) {
                    str += "<option value='" + data[i][j].operator_type_id + "'>" + data[i][j].operatorName + "</option>";
                }
                break;
            }
            $("#wgt" + sub + "Filter" + idx + "Oper")[0].innerHTML = str;
            OperChange(sub, idx);
        }
    }
    function OperChange(sub, idx) {
        if ($("#wgt" + sub + "Filter" + idx + "Oper").val() == "") { return; }
        var proValue = $("#wgt" + sub + "Filter" + idx).val();
        var operValue = $("#wgt" + sub + "Filter" + idx + "Oper").val();
        $("#wgt" + sub + "Filter" + idx + "ValDiv").empty();
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
                $("#wgt" + sub + "Filter" + idx + "ValDiv")[0].innerHTML = '';
                if (cdt.data_type == 820 || cdt.data_type == 804) {
                } else if (cdt.data_type == 809) {
                    $("#wgt" + sub + "Filter" + idx + "ValDiv")[0].innerHTML = '<select id="wgt' + sub + 'Filter' + idx + 'Val1" name="wgt' + sub + 'Filter' + idx + 'Val1" style="width:100%;" class="widgetFilterValue"></select>';
                    $("#wgt" + sub + "Filter" + idx + "Val1")[0].innerHTML = sltVals;
                } else if (cdt.data_type == 805 || cdt.data_type == 816 || cdt.data_type == 818) {
                    $("#wgt" + sub + "Filter" + idx + "ValDiv")[0].innerHTML = '<input id="wgt' + sub + 'Filter' + idx + 'Val1" name="wgt' + sub + 'Filter' + idx + 'Val1" class="widgetFilterValue" />';
                } else if (cdt.data_type == 810) {
                    $("#wgt" + sub + "Filter" + idx + "ValDiv")[0].innerHTML = '<div id="mlt' + sub + idx + '" class="multiplebox widgetFilterValue" style="border:0;"><input type= "hidden" id= "wgt' + sub + 'Filter' + idx + 'Val1" name= "wgt' + sub + 'Filter' + idx + 'Val1" class="sl_cdt" /><select id="mltslt' + sub + idx + '" multiple="multiple" ></select></div >';
                    $("#mltslt" + sub + idx)[0].innerHTML = sltVals;
                    $("#mltslt" + sub + idx).change(function () {
                        $("#wgt" + sub + "Filter" + idx + "Val1").val($(this).val());
                    }).multipleSelect({
                        width: '100%'
                    })
                } else if (cdt.data_type == 812) {

                } else if (cdt.data_type == 803) {

                } else if (cdt.data_type == 807 || cdt.data_type == 817) {
                    var fltHtml = '<input id="wgt' + sub + 'Filter' + idx + 'Val1" name="wgt' + sub + 'Filter' + idx + 'Val1" class="widgetFilterValue Wdate" style="width:80px;" onclick="WdatePicker()" />';
                    fltHtml += '<span style="float:left;margin:0 4px 0 4px">-</span>';
                    fltHtml += '<input id="wgt' + sub + 'Filter' + idx + 'Val2" name="wgt' + sub + 'Filter' + idx + 'Val2" class="widgetFilterValue Wdate" style="width:80px;" onclick="WdatePicker()" />';
                    $("#wgt" + sub + "Filter" + idx + "ValDiv")[0].innerHTML = fltHtml;
                } else if (cdt.data_type == 806) {
                    var fltHtml = '<input id="wgt' + sub + 'Filter' + idx + 'Val1" name="wgt' + sub + 'Filter' + idx + 'Val1" class="widgetFilterValue" style="width:80px;" />';
                    fltHtml += '<span style="float:left;margin:0 4px 0 4px">-</span>';
                    fltHtml += '<input id="wgt' + sub + 'Filter' + idx + 'Val2" name="wgt' + sub + 'Filter' + idx + 'Val2" class="widgetFilterValue" style="width:80px;" />';
                    $("#wgt" + sub + "Filter" + idx + "ValDiv")[0].innerHTML = fltHtml;
                } else if (cdt.data_type == 814) {

                } else if (cdt.data_type == 2807) {
                    $("#wgt" + sub + "Filter" + idx + "ValDiv")[0].innerHTML = '<input id="wgt' + sub + 'Filter' + idx + 'Val1" name="wgt' + sub + 'Filter' + idx + 'Val1" class="widgetFilterValue Wdate" onclick="WdatePicker()" />';
                }
            }
            break;
        }
    }
}



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
        if (data.visualType == 2559)
            CreateWidgetGuageNeedle(data.id, data.guageList[i], i);
        else if (data.visualType == 2560)
            CreateWidgetGuagePie(data.id, data.guageList[i], i);
        else if (data.visualType == 2561)
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
