using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Peoject
{
    public partial class ProjectAddOrEdit : BasePage
    {
        protected bool isAdd = true;
        protected pro_project thisProject = null;
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                    if (thisProject != null)
                    {
                        isAdd = false;
                    }
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }
        /// <summary>
        /// 页面数据源配置
        /// </summary>
        private void DataBind()
        {

        }

        /// <summary>
        /// 获取相应参数
        /// </summary>
        private void GetParam()
        {

        }

        /// <summary>
        /// 保存操作
        /// </summary>
        /// <returns></returns>
        private bool Save()
        {
            return false;
        }

    }
}