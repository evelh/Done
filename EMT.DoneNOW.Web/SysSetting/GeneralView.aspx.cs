using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class GeneralView : BasePage
    {
        public List<d_general> GeneralList = new List<d_general>();
        public int id;
        public string name;
        protected GeneralBLL gbll = new GeneralBLL();
        protected List<PageContextMenuDto> contextMenu = null;  // 右键菜单信息
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);          
            if (!IsPostBack) {
                if (id > 0) {
                    name = gbll.GetGeneralTableName(id);
                    GeneralList = new GeneralBLL().GetGeneralList(id);
                }
                   
                GetMenus();
            }
        }
        private void GetMenus()
        {
            contextMenu = new List<PageContextMenuDto>();
                    contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
        }
    }
}