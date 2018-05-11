using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class ExexuteContactDto
    {
        public string ids;

        public bool isHasNote=false;
        public int note_action_type;
        public string note_content;

        public bool isHasTodo=false;
        public int todo_action_type;
        public long assignRes;
        public long startDate;
        public long endDate;
        public string todo_content;

    }
}
