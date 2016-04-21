using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace City_Of_Orlando_Automated_Controller
{
    class LoginResponse
    {
        public LoginResponse(bool result, string token)
        {
            this.result = result;
            this.token = token;
        }

        public LoginResponse()
        {
            //Default
        }

        public bool result { get; set; }
        public string token { get; set; }
    }
}
