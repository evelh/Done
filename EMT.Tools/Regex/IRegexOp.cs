using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public interface IRegexOp
    {
        bool IsMobilePhone(string phoneNumber);

        bool IsNumeric(string num);
    }
}
