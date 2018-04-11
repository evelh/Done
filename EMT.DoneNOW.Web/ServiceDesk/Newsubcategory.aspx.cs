using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class Newsubcategory : BasePage
    {
        protected d_general thisCate = null;
        protected List<KnowledgeCateDto> cateList = new KnowledgeBLL().GetKnowledgeCateList();
        protected long? chooseParentId = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
                thisCate = new DAL.d_general_dal().FindNoDeleteById(long.Parse(id));
            var parentId = Request.QueryString["parentId"];
            if (!string.IsNullOrEmpty(parentId))
                chooseParentId = long.Parse(parentId);
            if (thisCate != null)
                chooseParentId = thisCate.parent_id;
        }
    }
}