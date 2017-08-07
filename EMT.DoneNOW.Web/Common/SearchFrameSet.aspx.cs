﻿using EMT.Tools;
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
        protected void Page_Load(object sender, EventArgs e)
        {
            var bll = new BLL.QueryCommonBLL();

            catId = DNRequest.GetQueryInt("cat", 0);
            int typeId = DNRequest.GetQueryInt("type", 0);
            int groupId = DNRequest.GetQueryInt("group", 0);

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

            var condition = bll.GetConditionPara(GetLoginUserId(), paraGroupId);
            if (condition.Count == 0)
                conditionHeight = 0;
            else
                conditionHeight = 440;
        }
    }
}