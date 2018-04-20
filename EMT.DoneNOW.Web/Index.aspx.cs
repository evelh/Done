using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    public partial class Index : BasePage
    {
        protected bool isFromLogin = false;  // 是否是从登陆页面跳转过来的
        protected List<sys_notice> notList;  // 系统公告类消息
        protected Dictionary<string, int> searchCountDic;
        protected void Page_Load(object sender, EventArgs e)
        {
            searchCountDic = new IndexBLL().GetIndexSearchCount(LoginUserId);
            if (Application["isFromLogin"] != null)
                isFromLogin = Application["isFromLogin"].ToString() == "1";
            Application["isFromLogin"] = "";
            if (isFromLogin)
            {
                notList = new DAL.sys_notice_dal().GetSysNotice(LoginUserId);
                if (notList != null && notList.Count > 0)
                    new IndexBLL().InsertNoticeRes(notList,LoginUserId);
            }
            

        }
    }
}