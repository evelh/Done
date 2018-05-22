using EMT.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class SearchFrameSet : BasePage
    {
        protected int catId = 0;
        protected long queryTypeId = 0;
        protected long paraGroupId = 0;
        protected int conditionHeight = 0;
        protected string isCheck = "";  // 用于检测是否显示checkBox框
        protected string isShow = "1";
        // 额外的参数(带入页面供js使用)
        protected string param1;
        protected string param2;
        protected string param3;
        protected string param4;
        protected string param5;
        protected string param6;
        protected string param7;
        protected void Page_Load(object sender, EventArgs e)
        {
            var bll = new BLL.QueryCommonBLL();

            catId = DNRequest.GetQueryInt("cat", 0);
            int typeId = DNRequest.GetQueryInt("type", 0);
            int groupId = DNRequest.GetQueryInt("group", 0);
            isCheck = DNRequest.GetStringValue("isCheck","");
            if (catId == 0)
            {
                Response.Close();
                return;
            }

            if (typeId == 0 || groupId == 0)
            {
                var info = bll.GetQueryGroup(catId);
                if (info == null || info.Count == 0)
                {
                    Response.Close();
                    return;
                }
                queryTypeId = info[0].query_type_id;
                paraGroupId = info[0].id;
            }
            else
            {
                queryTypeId = typeId;
                paraGroupId = groupId;
            }
            param1 = string.IsNullOrEmpty(Request.QueryString["param1"]) ? "" : Request.QueryString["param1"];
            param2 = string.IsNullOrEmpty(Request.QueryString["param2"]) ? "" : Request.QueryString["param2"];
            param3 = string.IsNullOrEmpty(Request.QueryString["param3"]) ? "" : Request.QueryString["param3"];
            param4 = string.IsNullOrEmpty(Request.QueryString["param4"]) ? "" : Request.QueryString["param4"];
            param5 = string.IsNullOrEmpty(Request.QueryString["param5"]) ? "" : Request.QueryString["param5"];
            param6 = string.IsNullOrEmpty(Request.QueryString["param6"]) ? "" : Request.QueryString["param6"];
            param7 = string.IsNullOrEmpty(Request.QueryString["param7"]) ? "" : Request.QueryString["param7"];
            if (Request.QueryString["isShow"] == "Search")
                isShow = "";
            var condition = bll.GetConditionParaVisiable(GetLoginUserId(), paraGroupId);
            if (condition.Count == 0)
                conditionHeight = 0;
            else
            {
                int rowCnt = condition.Count / 3;
                if (condition.Count % 3 != 0)
                    rowCnt++;
                conditionHeight = 125 + rowCnt * 35;
                if (conditionHeight < 206)
                    conditionHeight = 206;
                if (conditionHeight > 370)
                    conditionHeight = 370;
                if (catId==(int)DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES|| catId == (int)DTO.DicEnum.QUERY_CATE.APPROVE_EXPENSE|| catId == (int)DTO.DicEnum.QUERY_CATE.APPROVE_LABOUR|| catId == (int)DTO.DicEnum.QUERY_CATE.APPROVE_MILESTONES|| catId == (int)DTO.DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES|| catId == (int)DTO.DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS)
                {
                    conditionHeight += 40;
                }
            }
        }
    }
}