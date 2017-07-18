using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class DictionaryEntryDto
    {
        public DictionaryEntryDto(string value, string display, int isDefault = 0)
        {
            val = value;
            show = display;
            select = isDefault;
        }
        public string show { get; set; }
        public string val { get; set; }
        public int select { get; set; }
        // public string val;
        // public string show;
        // public int select;
    }
}
