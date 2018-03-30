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
    public partial class ManageKnowledgebase :BasePage
    {
        protected  List<sdk_kb_article> artList = null;
        protected List<d_general> pubList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.KB_PUBLISH_TO_TYPE);
        protected List<KnowledgeCateDto> cateList = new KnowledgeBLL().GetKnowledgeCateList(false);
       
        protected void Page_Load(object sender, EventArgs e)
        {
            artList = new KnowledgeBLL().GetArtList();
            if (artList == null)
                artList = new List<sdk_kb_article>();
            
        }
    }
}