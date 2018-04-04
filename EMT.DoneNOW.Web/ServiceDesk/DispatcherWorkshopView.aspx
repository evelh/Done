<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DispatcherWorkshopView.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.DispatcherWorkshopView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/Dispatch.css" rel="stylesheet" />
    <title></title>
</head>
<body  scroll="NO" style="margin: 0px; padding: 0px; height: 100%; width: 100%; overflow: hidden;">
     <div class="heard-title">
        <span class='TitleContainer'>
            调度工作室
            <a class='SecondaryTitle'>
			 <%=GetDay((int)DateTime.Now.DayOfWeek) %>- <%=DateTime.Now.ToString("yyyy-MM-dd") %>
		   </a>
        </span>
        <div class="UpperPart"></div>
        <div class="help"></div>
    </div>
      <div class="ButtonCollectionBase">
        <div class="Buttonleft">
            <div class="newbtn">
                <img src="../Images/new.png" alt="" />
                <span>新增</span>
                <img src="../Images/down.png" alt="" />
                <div class="SelectBox">
                    <div class="SelectBox-Whiteline"></div>
                    <p onclick="AddAppoint('')">约会</p>
                    <p>快速新增服务预定</p>
                    <p>服务预定</p>
                    <p>待办</p>
                </div>
            </div>
            <div class="btntext">Workload Report</div>
        </div>
        <div class="ButtonRight">
            <div class="vivews">
                <span>显示天数</span>
                <select class="txtBlack8Class" name="" id="SelectView">
                    <option selected="selected" value=""></option>
                    <% if (viewList != null && viewList.Count > 0)
                        {foreach (var view in viewList)
                            {%>
                    <option value="<%=view.id %>" <%if (chooseView != null && chooseView.id == view.id)
                        { %> selected="selected" <%} %> > <%=view.name %></option>
                    <%
                            }
                      } %>
                    <option value="">---------------------------</option>
                    <%if (chooseView != null)
                        { %>
                    <option value="<%=chooseView.id %>"><%=chooseView.name %></option>
                    <%} %>
                    <option value="New">保存为新的视图</option>
                    <option value="Manage">管理已保存的视图</option>
                </select>
            </div>
            <div class="daysElm">
                <ul>
                    <li>1</li>
                    <li>5</li>
                    <li class="ShowdatsElm">7</li>
                    <li>7+</li>
                </ul>
            </div>
            <div class="dateElm">
                 <a class="dateElm-pev"> < </a>
                 <input type="text" class="Wdate" onclick="WdatePicker()" /> 
                 <a class="dateElm-next"> > </a>                 
          </div>
        </div>
    </div>
    <div class="FilterDiv">
        <div id="pnlWorkgroupSelector">
            <span style="font-weight: bold;padding-right: 4px;">工作组</span>
            <select size="4" name="" id="" class="" style="height:34px;width:148px;padding:0px 0px 0px 3px;">
            </select>
            <input type="hidden" id="workIds" value=""/>
            <input type="hidden" id="workIdsHidden" value="<%=chooseView!=null?chooseView.workgroup_ids:"" %>"/>
            <img style="margin-left: 5px;cursor: pointer;" src="../Images/data-selector.png" alt="" onclick="ChooseGroup()"/>
	    </div>

        <div id="pnlResourceSelector">
            <span style="font-weight: bold;padding-right: 4px;">Resources</span>
            <select size="4" name="" id="ResSelect" class="" style="height:34px;width:148px;padding:0px 0px 0px 3px;">
                <option value="29682885">Li,&nbsp;Hong</option>
                <option value="29682887">li,&nbsp;li</option>
            </select>
             <input type="hidden" id="resIds" value=""/>
            <input type="hidden" id="resIdsHidden" value="<%=chooseView!=null?chooseView.resource_ids:"" %>"/>
            <img style="margin-left: 5px;cursor: pointer;" src="../Images/data-selector.png" alt="" onclick="ChooseRes()"/>
	    </div>

        <div id="checkSelector">
            <p>
                <input id="ckNoRes" type="checkbox" name="" /><span>显示无负责人的服务预定</span>
            </p>
			<p>
                <input id="ckShowCancel" type="checkbox" name=""  /><span>显示已取消服务预定</span>
            </p>
        </div>
    </div>
    <div style="margin: 0 10px 10px 10px;">
        <div class="Grid1_Container">
            <div class="ContainerLeft">
                <div class="ContainerDays">
                 
                    <div class="Days-1"></div>
                    <div class="Days-2"></div>
                       <% if (isShowNoRes){ %>
                    <div class="Days-3">Individual</div>
                    <%} %>
                </div>
                 <!--用户列-->                
                <ul class="ContainerUser">
                    <asp:Literal ID="liUser" runat="server"></asp:Literal>
                </ul>
            </div>
            <div class="ContainerRight">
                 <!--时间列-->
                <ul class="R-ContainerDays">
                    <asp:Literal ID="liTime" runat="server"></asp:Literal>
                </ul>
                 <!--任务列-->  
                <asp:Literal ID="liTicket" runat="server"></asp:Literal>
            </div>
        </div>

        <div class="Grid2_Container" style="display: none;">
            <div class="ContainerTop">
                <div class="ContainerTop-One">
                    <div class="ContainerDays">
                        <div class="Days-1">
                        </div>
                        <div class="Days-2">
                        </div>
                        <div class="Days-3">
                        </div>
                        <div class="Days-4"></div>
                    </div>
                </div>
                <div class="ContainerTop-Two">
                    <div class="Days-1">
                        <div class="border"></div>
                        Thursday 08/03/2018
                    </div>
                    <div class="Days-2">
                        <div class="border"></div>                            
                            Individual
                        </div>
                    <ul class="ContainerTop-User">
                        <li>
                            <div class="border"></div>
                            Li, Hong (CST)                            
                        </li>
                         <li>
                            <div class="border"></div>
                            li, li (CST)                           
                        </li>
                    </ul>
                    <div class="ContainerTop-UserLine"></div>
                </div>
            </div>
            <div class="ContainerBottom">
                <div class="ContainerBottom-One">
                    <div class="Hover-t"></div>
                    <ul class="Hover">
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                        <li>
                            <a>12</a>
                            <a>AM</a>
                        </li>
                    </ul>
                </div>
                <div class="ContainerBottom-Two">
                    <div class="Hover-t"></div>
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul>
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul> 
                    <ul class="HouverTask">
                        <li>
                            <div class="border"></div>
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>
                        </li>
                        <li>
                            <div class="border"></div>   
                            <div class="TaskConter">
                                <div class="t1"></div>
                                <div class="t2"></div>
                            </div>                                                     
                        </li>
                    </ul>                    
                </div>
            </div>
        </div>
        
    </div>
    <div id="menu">
        <div class="SelectBox" style="position: none;display: block;">
            <p>新增快速服务预定</p>
            <p>新增服务预定</p>
            <p>新增约会</p>
            <p>新增待办</p>
        </div>
    </div>
    <div id="AppiontMenu" style="position:absolute;">
        <div class="SelectBox" style="position: none;display: block;">
            <p onclick="EditAppoint()">编辑约会</p>
            <p onclick="DeleteAppoint()">删除约会</p>
        </div>
    </div>
    <div class="WzTtDiV"></div>
    <div class="loading">
       <div class="loadimg">
            <img src="../Images/loadingIndicator.gif" alt="" />
            <p>Loading scheduled itenms</p>
       </div>
    </div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/Dispatch.js"></script>
<script>

    function ChooseGroup() {
  
    }

    function ChooseRes() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CALLBACK %>&field=resIds&muilt=1&callBack=GetRes", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetRes() {
        var resIds = $("#resIdsHidden").val();
        var resHtml = "";
        if (resIds != "") {

        }
        $("#ResSelect").html(resHtml);
    }
    function ChangeFilter() {

    }


    $("#SelectView").change(function () {
        var thisValue = $(this).val();
        if (thisValue == "New") {
            var workIds = $("#workIdsHidden").val();
            var resIds = $("#resIdsHidden").val();
            var isNoRes = "";
            if ($("#ckNoRes").is(":checked")) {
                isNoRes = "1";
            }
            var ckShowCancel = "";
            if ($("#ckShowCancel").is(":checked")) {
                ckShowCancel = "1";
            }
            var modeId = $(".ShowdatsElm").eq(0).text();
            if (modeId == "1") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW %>';
            }
            else if (modeId == "5") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW %>';
            }
            else if (modeId == "7") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.FIVE_DAY_WORK_VIEW %>';
            }
            else if (modeId == "7+") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY %>';
            }
            if (modeId == "") {
                return;
            }

            window.open("../ServiceDesk/DispatchViewList.aspx?isAdd=1&workIds=" + workIds + "&resIds=" + resIds + "&isShowNoRes=" + isNoRes + "&isShowCalls=" + ckShowCancel + "&modeId=" + modeId, '_blank', 'left=200,top=200,width=600,height=800', false);
        }
        else if (thisValue == "Manage") {
            window.open("../ServiceDesk/DispatchViewList.aspx",'_blank', 'left=200,top=200,width=600,height=800', false);
        }
        else if (thisValue != "") {
            location.href = "../ServiceDesk/DispatcherWorkshopView.aspx?viewId=" + thisValue;
        } else {
            
        }
    })

    function AddAppoint(chooseDate) {
        window.open("../ServiceDesk/AppointmentsManage.aspx?chooseDate=" + chooseDate, windowObj.appointment + windowType.add, 'left=200,top=200,width=600,height=800', false);
    }
</script>
