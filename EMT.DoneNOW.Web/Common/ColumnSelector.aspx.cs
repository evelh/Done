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
        protected long queryTypeId;
        protected long paraGroupId;
        //protected string queryPage = "";        // 查询页面名称
        protected List<DTO.DictionaryEntryDto> allPara;     // 可选的所有查询结果列
        protected List<DTO.DictionaryEntryDto> selectedPara;// 已选的查询结果列
        private QueryCommonBLL bll = new QueryCommonBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!long.TryParse(Request.QueryString["type"], out queryTypeId))
                queryTypeId = 0;
            if (!long.TryParse(Request.QueryString["group"], out paraGroupId))
                paraGroupId = 0;
            //queryPage = HttpContext.Current.Request.Form["type"];
            if (queryTypeId == 0 || paraGroupId == 0)
            {
                Response.Close();
                return;
            }

            if (IsPostBack)
            {
                // 保存选择内容
                SaveSelect();
                if (queryTypeId == (int)EMT.DoneNOW.DTO.QueryType.MyWorkListTicket)
                {
                    var sendMyWork = !string.IsNullOrEmpty(Request.Form["keep_running"]) && Request.Form["keep_running"].Equals("1");
                    var autoStart = !string.IsNullOrEmpty(Request.Form["auto_start"]) && Request.Form["auto_start"].Equals("1");
                    new IndexBLL().SysWorkSetting(sendMyWork, autoStart,LoginUserId);
                }
            }
            
            GetSelect();
        }

        /// <summary>
        /// 获取所有可选列和已选列
        /// </summary>
        private void GetSelect()
        {
            allPara = bll.GetResultAll(queryTypeId);
            selectedPara = bll.GetResultSelect(GetLoginUserId(), paraGroupId);
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
            bll.EditResultSelect(GetLoginUserId(), queryTypeId, paraGroupId, ids);
            Response.Write("<script>window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
            //Response.Close();
        }
    }
}