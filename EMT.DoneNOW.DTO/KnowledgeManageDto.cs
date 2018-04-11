using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class KnowledgeManageDto
    {
        public sdk_kb_article thisArt;
        public List<AddFileDto> filtList;
        public string attIds = "";
        public string ticketId;
    }
}
