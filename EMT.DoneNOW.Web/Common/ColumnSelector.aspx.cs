using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    public partial class ColumnSelector : BasePage
    {
        protected string queryPage = "";        // 查询页面名称
        protected List<DTO.DictionaryEntryDto> allPara;     // 可选的所有查询结果列
        protected List<DTO.DictionaryEntryDto> selectedPara;// 已选的查询结果列
        private QueryCommonBLL bll = new QueryCommonBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                queryPage = HttpContext.Current.Request.Form["type"];
                if (string.IsNullOrEmpty(queryPage))
                    Response.Close();
                // 保存选择内容
                SaveSelect();
            }
            queryPage = EMT.Tools.DNRequest.GetQueryString("type");
            if (string.IsNullOrEmpty(queryPage))
                Response.Close();
            GetSelect();
        }

        /// <summary>
        /// 获取所有可选列和已选列
        /// </summary>
        private void GetSelect()
        {
            allPara = bll.GetResultAll(queryPage);
            selectedPara = bll.GetResultSelect(GetLoginUserId(), queryPage);
        }

        /// <summary>
        /// 保存选择列
        /// </summary>
        private void SaveSelect()
        {
            string ids = HttpContext.Current.Request.Form["ids"];
            if (string.IsNullOrEmpty(ids))
            {
                return;
            }
            bll.EditResultSelect(GetLoginUserId(), queryPage, ids);
            Response.Write("<script>window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
            //Response.Close();
        }
    }
}