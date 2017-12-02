﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectNoteShow : BasePage
    {
        protected pro_project thisProject = null;
        protected List<d_general> actList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var thisId = Request.QueryString["project_id"];
                if(!string.IsNullOrEmpty(thisId))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(thisId));
                }
                if (thisProject != null)
                {
                    ShowNoteList.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_NOTE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_NOTE + "&con1054=" + thisProject.id + "&con1055=";

                    actList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.ACTION_TYPE);
                    if (actList != null && actList.Count > 0)
                    {
                        actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE).ToString()).ToList();
                    }


                }
                else
                {
                    Response.End();
                }

            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}