
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
    else if (data.isx == 1)
        CreateWidgetBar(data.id, data.group1, data.group2, data.report1, 1, data.isStack);
    else if (data.isy == 1)
        CreateWidgetBar(data.id, data.group1, data.group2, data.report1, 0, data.isStack);
}

function CreateWidgetBar(id, group1, group2, data, x, stack) {
    var myChart = echarts.init(document.getElementById('widget' + id + 'container0'));

    var ser = new Array();
    if (group2 == null) {
        ser[0] = {
            data: data,
            type: 'bar',
            itemStyle: {
                normal: {
                    color: function (params) {
                        return SelectTheme[params.dataIndex % SelectTheme.length];
                    },
                },

            },
        };
    } else {
        for (var i = 0; i < data.length; i++) {
            ser[i] = {
                data: data[i],
                name: group2[i],
                type: 'bar',
                stack: stack,
                itemStyle: {
                    normal: {
                        color: SelectTheme[i % SelectTheme.length],
                    },

                },
            };
        }
    }

    var option = {
        yAxis: x == 1 ? {
            type: 'value'
        } : {
                type: 'category',
                data: group1,
            },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            top: '12%',
            containLabel: true
        },
        xAxis: x == 1 ? {
            type: 'category',
            data: group1,
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
        if (group2 == null) {
            WidgetClick(id, params.name, null);
        } else {
            WidgetClick(id, params.name, params.seriesName);
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
            splitNumber: 4,
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
        valIdx = prct.length - 1;

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
            color: '#e6e6e6', //未完成的圆环的颜色
            label: {
                show: false
            },
            labelLine: {
                show: false
            }
        },
        
        emphasis: {
            color: '#e6e6e6' //未完成的圆环的颜色
        }
    };
    //数据填充
    var option = {
        color: [SelectTheme[valIdx % SelectTheme.length], '#e6e6e6'],
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
                        color: SelectTheme[0],
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
            color: '#e6e6e6', //未完成的圆环的颜色
            label: {
                show: false
            },
            labelLine: {
                show: false
            }
        },

        emphasis: {
            color: '#e6e6e6' //未完成的圆环的颜色
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
                color: "#0bb6f0",
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
        str += '</table></div><div class="FooterContainer"><div class="RowStatus">1 - ' + data.gridData.length + ' / ' + data.totalCnt + '</div><div class="ShowAllButtonDiv"><a>显示全部</a></div></div></div>';
    dom[0].innerHTML = str;
}
