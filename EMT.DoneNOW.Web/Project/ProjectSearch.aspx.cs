using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.Tools;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectSearch : BasePage
    {

        protected int catId = 0;
        protected long queryTypeId = 0;
        protected long paraGroupId = 0;
        protected int conditionHeight = 1;
        protected string isCheck = "";  // 用于检测是否显示checkBox框
        protected void Page_Load(object sender, EventArgs e)

        {
            var bll = new BLL.QueryCommonBLL();

             catId = DNRequest.GetQueryInt("cat", 0);
            // catId = (int)DicEnum.QUERY_CATE.PROJECT_SEARCH;
            int typeId = DNRequest.GetQueryInt("type", 0);
            // typeId = (int)QueryType.PROJECT_SEARCH;
            int groupId = DNRequest.GetQueryInt("group", 0);
            // groupId = 108;
            isCheck = DNRequest.GetStringValue("isCheck", "");
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
            }
        }
    }
}