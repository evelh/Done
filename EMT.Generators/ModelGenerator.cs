
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
	[Table("sdk_kb_article_ticket")]
    [Serializable]
	[DataContract]
    public partial class sdk_kb_article_ticket  
    {

		[Key]
	    [DataMember]
        public Int64 id{ get;set;}
	    [DataMember]
        public Int64 oid{ get;set;}
	    [DataMember]
        public Int64 kb_article_id{ get;set;}
	    [DataMember]
        public Int64 task_id{ get;set;}
	    [DataMember]
        public String task_no{ get;set;}

       
    }
}
/*

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_kb_article_ticket_dal : BaseDAL<sdk_kb_article_ticket>
    {
    }

}

*/
