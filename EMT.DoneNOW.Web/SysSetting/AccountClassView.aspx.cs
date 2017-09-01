using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class AccountClassView : BasePage
    {
        protected AccountClassBLL acbll = new AccountClassBLL();
        protected List<d_account_classification> aclist = new List<d_account_classification>();
        protected List<PageContextMenuDto> contextMenu = null;  // 右键菜单信息
        protected void Page_Load(object sender, EventArgs e)
        {
            aclist=acbll.GetAll();
            GetMenus();
        }
        private void GetMenus()
        {
            contextMenu = new List<PageContextMenuDto>();
            contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
            contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
            contextMenu.Add(new PageContextMenuDto { text = "失活", click_function = "NoActive()" });
            contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
        }
    }
}